-- ServerScriptService/SubExperience/Teleporter.server.lua
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local SharedConfig = require(game.ReplicatedStorage.Shared.Modules.SharedConfig)
local Network = require(game.ReplicatedStorage.Shared.Modules.Network)
local RunState = require(game.ReplicatedStorage.Shared.Modules.RunState)

-- Requirements in Workspace:
-- - A Teleporter model with PrimaryPart and a Zone Part named "ActivationZone" (Touched region)
-- - An Enemies folder (for organization)
-- - Boss templates in ServerStorage/BossTemplates (Models tagged "Enemy" and "Boss" optional attribute IsBoss=true)

local Teleporter = workspace:WaitForChild("Teleporter")
local Zone = Teleporter:WaitForChild("ActivationZone")

local playersInZone: {[number]: boolean} = {}
local bossModel: Model? = nil

local function playersCountInZone()
    local n = 0
    for _, _ in pairs(playersInZone) do n += 1 end
    return n
end

local function broadcastTeleporter()
    Network.Events.TeleporterState:FireAllClients(RunState.Teleporter.State, RunState.Teleporter.Charge)
end

local function broadcastStage()
    Network.Events.StageUpdate:FireAllClients(RunState.StageIndex, RunState.DifficultyCoeff)
end

local function applyBossScaling(model: Model)
    CollectionService:AddTag(model, "Enemy")
    model:SetAttribute("IsBoss", true)
    -- Stronger multipliers
    local pc = #Players:GetPlayers()
    RunState.UpdateDifficulty(pc)
    local baseH = model:GetAttribute("BaseHealth") or 2000
    local baseD = model:GetAttribute("BaseDamage") or 30
    local diff = RunState.DifficultyCoeff
    local coopH = 1 + (pc - 1) * SharedConfig.Coop.HealthMultiplierPerPlayer
    local coopD = 1 + (pc - 1) * SharedConfig.Coop.DamageMultiplierPerPlayer
    model:SetAttribute("Health", math.floor(baseH * coopH * (0.9 + 0.3 * diff)))
    model:SetAttribute("Damage", math.floor(baseD * coopD * (0.9 + 0.3 * diff)))
end

local function spawnBoss()
    if bossModel then return end
    local folder = ServerStorage:WaitForChild("BossTemplates")
    local choices = folder:GetChildren()
    if #choices == 0 then return end
    local template = choices[math.random(1, #choices)]
    bossModel = template:Clone()
    bossModel.Parent = workspace.Enemies
    bossModel:PivotTo(Teleporter:GetPivot() * CFrame.new(0, 0, -30))
    applyBossScaling(bossModel)
    RunState.BossAlive = true
    Network.Events.BossAnnounce:FireAllClients(bossModel.Name)
    bossModel.Destroying:Connect(function()
        RunState.BossAlive = false
        bossModel = nil
    end)
end

-- Zone tracking
Zone.Touched:Connect(function(hit)
    local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
    if plr then
        playersInZone[plr.UserId] = true
    end
end)
Zone.TouchEnded:Connect(function(hit)
    local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
    if plr then
        playersInZone[plr.UserId] = nil
    end
end)

-- Flow loop
task.spawn(function()
    RunState.Teleporter.State = "Dormant"
    broadcastTeleporter()
    broadcastStage()

    while true do
        task.wait(0.25)
        RunState.UpdateDifficulty(#Players:GetPlayers())

        if RunState.Teleporter.State == "Dormant" then
            -- Activated by first touch
            if playersCountInZone() > 0 then
                RunState.Teleporter.State = "Activated"
                spawnBoss()
                broadcastTeleporter()
            end

        elseif RunState.Teleporter.State == "Activated" then
            -- Boss must die before charging can start
            if not RunState.BossAlive then
                RunState.Teleporter.State = "Charging"
                RunState.Teleporter.Charge = 0
                broadcastTeleporter()
            end

        elseif RunState.Teleporter.State == "Charging" then
            local pct = playersCountInZone() / math.max(1, #Players:GetPlayers())
            local rate = 12 -- percent per second at full occupancy
            RunState.Teleporter.Charge = math.clamp(RunState.Teleporter.Charge + pct * rate * 0.25, 0, 100)
            broadcastTeleporter()
            if RunState.Teleporter.Charge >= 100 then
                RunState.Teleporter.State = "Charged"
                broadcastTeleporter()
            end

        elseif RunState.Teleporter.State == "Charged" then
            -- Open portal and allow stage advance
            RunState.Teleporter.State = "PortalOpen"
            broadcastTeleporter()

        elseif RunState.Teleporter.State == "PortalOpen" then
            -- If all players touch zone again, advance stage
            if playersCountInZone() == #Players:GetPlayers() and #Players:GetPlayers() > 0 then
                -- Reset for next stage
                RunState.ResetForNewStage()
                broadcastStage()
                -- Reset teleporter visuals (charge to 0, close portal)
                broadcastTeleporter()
            end
        end
    end
end)