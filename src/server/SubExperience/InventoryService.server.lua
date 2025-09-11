-- ServerScriptService/SubExperience/InventoryService.server.lua
local Players = game:GetService("Players")

local Network = require(game.ReplicatedStorage.Modules.Network)
local ItemRegistry = require(game.ReplicatedStorage.Modules.ItemRegistry)
local SharedConfig = require(game.ReplicatedStorage.Modules.SharedConfig)

local InventoryService = {}
local inv = {} -- [userId] = { [itemId] = stacks }

function InventoryService.Get(userId) inv[userId] = inv[userId] or {}; return inv[userId] end

function InventoryService.Add(userId, itemId)
    local def = ItemRegistry.Get(itemId); if not def then return end
    local t = InventoryService.Get(userId)
    t[itemId] = (t[itemId] or 0) + 1
end

-- Item pickup (from world) -> server decides who gets it or starts share flow
Network.Events.ItemPickup.OnServerEvent:Connect(function(player, itemId, worldId)
    local teamPlayers = Players:GetPlayers()
    if SharedConfig.Coop.LootShareMode == "PartyShare" and #teamPlayers > 1 then
        -- announce share; simple equal round-robin by total pickups count
        local totals = {}
        for _, p in ipairs(teamPlayers) do
            local t = InventoryService.Get(p.UserId)
            local c = 0; for _, s in pairs(t) do c += s end
            table.insert(totals, { p = p, c = c })
        end
        table.sort(totals, function(a,b) return a.c < b.c end)
        InventoryService.Add(totals[1].p.UserId, itemId)
        -- Destroy world item here; notify UI of recipient
    else
        InventoryService.Add(player.UserId, itemId)
    end
end)

-- Player-initiated sharing
Network.Events.ItemShareRequest.OnServerEvent:Connect(function(player, targetUserId, itemId)
    if not ItemRegistry.Get(itemId) then return end
    local src = InventoryService.Get(player.UserId)
    if (src[itemId] or 0) > 0 then
        src[itemId] -= 1
        InventoryService.Add(targetUserId, itemId)
        -- notify clients
    end
end)

return InventoryService