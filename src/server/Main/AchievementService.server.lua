-- ServerScriptService/Main/AchievementService.server.lua
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local SharedConfig = require(game.ReplicatedStorage.Shared.Modules.SharedConfig)

local achieveStore = DataStoreService:GetDataStore(SharedConfig.DataStore.Achievements)
local cache = {} -- [userId] = { [achId] = true }

local function save(userId, achId)
    local key = string.format("A_%d", userId)
    pcall(function()
        achieveStore:UpdateAsync(key, function(old)
            old = old or {}
            old[achId] = true
            return old
        end)
    end)
end

local AchievementService = {}

function AchievementService.Grant(player: Player, achId: string)
    cache[player.UserId] = cache[player.UserId] or {}
    cache[player.UserId][achId] = true
    save(player.UserId, achId)
end

function AchievementService.Has(player: Player, achId: string)
    local t = cache[player.UserId]
    if t then return t[achId] == true end
    local key = string.format("A_%d", player.UserId)
    local ok, res = pcall(function() return achieveStore:GetAsync(key) end)
    cache[player.UserId] = ok and (res or {}) or {}
    return cache[player.UserId][achId] == true
end

Players.PlayerRemoving:Connect(function(plr) cache[plr.UserId] = nil end)

return AchievementService