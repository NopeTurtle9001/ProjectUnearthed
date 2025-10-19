-- ServerScriptService/SubExperience/GameLoop.server.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local SharedConfig = require(game.ReplicatedStorage.Shared.Modules.SharedConfig)
local Network = require(game.ReplicatedStorage.Shared.Modules.Network)
local SkillLibrary = require(game.ReplicatedStorage.Shared.Modules.SkillSystem.SkillLibrary)
local CharacterRegistry = require(game.ReplicatedStorage.Shared.Modules.CharacterRegistry)
local InventoryService = require(script.Parent.InventoryService)

local playerState = {} -- [userId] = { character = "Ranger", stats = {}, cooldowns = {} }

local function calcStats(userId)
    local base = CharacterRegistry.Get(playerState[userId].character).BaseStats
    local stats = {
        Health = base.Health,
        Regen = base.Regen,
        Damage = base.Damage,
        MoveSpeed = base.MoveSpeed,
        Armor = base.Armor,
        Jump = base.Jump,
        AttackSpeed = 1,
    }
    -- Apply items
    local inv = InventoryService.Get(userId)
    for itemId, stacks in pairs(inv) do
        local def = require(game.ReplicatedStorage.Modules.ItemRegistry).Get(itemId)
        if def then def.OnStatCalc(Players:GetPlayerByUserId(userId), stacks, stats) end
    end
    return stats
end

local function onPlayerAdded(plr)
    -- default character (could come from CharacterService via TeleportData)
    playerState[plr.UserId] = { character = "Ranger", stats = {} }
    playerState[plr.UserId].stats = calcStats(plr.UserId)
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, p in ipairs(Players:GetPlayers()) do onPlayerAdded(p) end

Network.Events.SkillRequest.OnServerEvent:Connect(function(player, payload)
    -- payload = { skillId, originCFrame, direction }
    local u = playerState[player.UserId]; if not u then return end
    local skill = SkillLibrary[payload.skillId]; if not skill then return end

    -- server validates cooldown and character owns it
    local char = CharacterRegistry.Get(u.character)
    local allowed = {
        [char.Skills.Primary] = true,
        [char.Skills.Secondary] = true,
        [char.Skills.Utility] = true,
        [char.Skills.Special] = true,
    }
    if not allowed[payload.skillId] then return end
    if not skill:IsReady(player.UserId) then return end

    local ctx = {
        player = player,
        character = u.character,
        originCFrame = payload.originCFrame,
        direction = payload.direction,
        stats = u.stats,
        inventory = InventoryService.Get(player.UserId),
        playersInRun = #Players:GetPlayers(),
    }

    skill:Consume(player.UserId)
    skill.ExecuteServer(ctx)
    -- Optionally broadcast to others for VFX
end)

-- Stage timer and scaling
task.spawn(function()
    local start = os.clock()
    while true do
        task.wait(1)
        local elapsed = os.clock() - start
        local playersCount = #Players:GetPlayers()
        local healthScale = 1 + (playersCount - 1) * SharedConfig.Coop.HealthMultiplierPerPlayer
        local damageScale = 1 + (playersCount - 1) * SharedConfig.Coop.DamageMultiplierPerPlayer
        -- apply to spawn tables and enemies here
        if elapsed >= SharedConfig.Run.StageTimeSeconds then
            -- advance stage or trigger teleporter event
            start = os.clock()
        end
        -- recalc stats occasionally in case of pickups
        for _, plr in ipairs(Players:GetPlayers()) do
            playerState[plr.UserId].stats = calcStats(plr.UserId)
        end
    end
end)