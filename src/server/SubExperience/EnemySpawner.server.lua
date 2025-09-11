-- ServerScriptService/SubExperience/EnemySpawner.server.lua
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

local SharedConfig = require(game.ReplicatedStorage.Modules.SharedConfig)
local RunState = require(game.ReplicatedStorage.Modules.RunState)

local spawnPoints = workspace:WaitForChild("EnemySpawnPoints"):GetChildren()
local enemyTemplates = ServerStorage:WaitForChild("EnemyTemplates"):GetChildren()

local baseInterval = 9
local maxEnemiesBase = 20
local active = {}

local function scaleAndTrack(enemy)
    CollectionService:AddTag(enemy, "Enemy")
    table.insert(active, enemy)
    enemy.Destroying:Connect(function()
        local i = table.find(active, enemy)
        if i then table.remove(active, i) end
    end)
    -- Apply baseline attributes; EnemyController rescales per heartbeat as needed
    local pc = #Players:GetPlayers()
    RunState.UpdateDifficulty(pc)
    local baseH = enemy:GetAttribute("BaseHealth") or 100
    local baseD = enemy:GetAttribute("BaseDamage") or 10
    local diff = RunState.DifficultyCoeff
    enemy:SetAttribute("Health", math.floor(baseH * (0.8 + 0.2 * diff)))
    enemy:SetAttribute("Damage", math.floor(baseD * (0.8 + 0.2 * diff)))
end

local function spawnOne()
    if #Players:GetPlayers() == 0 then return end
    local cap = math.floor(maxEnemiesBase * math.min(2.5, RunState.DifficultyCoeff))
    if #active >= cap then return end
    local sp = spawnPoints[math.random(1, #spawnPoints)]
    local tpl = enemyTemplates[math.random(1, #enemyTemplates)]
    local m = tpl:Clone()
    m.Parent = workspace.Enemies
    m:PivotTo(sp.CFrame)
    scaleAndTrack(m)
end

task.spawn(function()
    while true do
        local interval = baseInterval / math.clamp(RunState.DifficultyCoeff, 1, 3)
        task.wait(interval)
        spawnOne()
    end
end)