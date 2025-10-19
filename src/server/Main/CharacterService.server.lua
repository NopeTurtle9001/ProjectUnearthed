-- ServerScriptService/Main/CharacterService.server.lua
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local SharedConfig = require(game.ReplicatedStorage.Shared.Modules.SharedConfig)
local CharacterRegistry = require(game.ReplicatedStorage.Shared.Modules.CharacterRegistry)

local purchasesStore = DataStoreService:GetDataStore(SharedConfig.DataStore.Purchases)

local CharacterService = {}

local playerUnlocks = {} -- [userId] = { Characters = {}, Skins = {}, Skills = {} }

local function fetchUnlocks(userId)
    local key = string.format("P_%d", userId)
    local success, result = pcall(function()
        return purchasesStore:GetAsync(key)
    end)
    if success and result then
        return result
    end
    return { Characters = {}, Skins = {}, Skills = {} }
end

function CharacterService.GetUnlocks(userId) return playerUnlocks[userId] or fetchUnlocks(userId) end

Players.PlayerAdded:Connect(function(player)
    playerUnlocks[player.UserId] = fetchUnlocks(player.UserId)
end)
Players.PlayerRemoving:Connect(function(player)
    playerUnlocks[player.UserId] = nil
end)

-- Validate selection server-side
function CharacterService.ValidateSelection(userId: number, charId: string, skinId: string?)
    local def = CharacterRegistry.Get(charId)
    if not def then return false, "InvalidCharacter" end
    local unlocks = CharacterService.GetUnlocks(userId)
    local ownsChar = unlocks.Characters[charId] or charId == "Ranger" -- example: Ranger free
    if not ownsChar then return false, "CharacterLocked" end
    if skinId then
        local ownsSkin = unlocks.Skins[skinId] ~= nil
        if not ownsSkin then return false, "SkinLocked" end
    end
    return true
end

return CharacterService