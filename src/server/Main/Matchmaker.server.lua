-- ServerScriptService/Main/Matchmaker.server.lua
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local SharedConfig = require(game.ReplicatedStorage.Shared.Modules.SharedConfig)
local Network = require(game.ReplicatedStorage.Shared.Modules.Network)

local queues = {} -- [partyId] = { leaderUserId, members = {userId...}, artifacts = {...} }

Network.Events.MatchQueue.OnServerEvent:Connect(function(player, action, payload)
    if action == "CreateParty" then
        local partyId = tostring(player.UserId) .. "_" .. tostring(os.time())
        queues[partyId] = { leaderUserId = player.UserId, members = { player.UserId }, artifacts = {} }
        Network.Events.LobbyParty:FireClient(player, "PartyCreated", partyId)
    elseif action == "JoinParty" then
        local partyId = payload
        local q = queues[partyId]
        if q and #q.members < SharedConfig.Run.MaxPlayersPerRun then
            table.insert(q.members, player.UserId)
            for _, uid in ipairs(q.members) do
                local p = Players:GetPlayerByUserId(uid)
                if p then Network.Events.LobbyParty:FireClient(p, "MemberJoined", player.UserId) end
            end
        end
    elseif action == "StartRun" then
        local partyId = payload
        local q = queues[partyId]
        if q and q.leaderUserId == player.UserId then
            local playersToTeleport = {}
            for _, uid in ipairs(q.members) do
                local p = Players:GetPlayerByUserId(uid)
                if p then table.insert(playersToTeleport, p) end
            end
            if #playersToTeleport > 0 then
                TeleportService:TeleportPartyAsync(SharedConfig.SubExperiencePlaceId, playersToTeleport, {
                    reservedServerAccessCode = nil, -- TeleportService decides
                    serverInstanceId = nil,
                    data = { artifacts = q.artifacts },
                })
            end
            queues[partyId] = nil
        end
    end
    elseif action == "SelectCharacter" then
    local ok, reason = require(script.Parent.CharacterService).ValidateSelection(player.UserId, payload.charId, payload.skinId)
    if ok then
        -- Store selection in party data
        -- e.g., queues[partyId].selections[player.UserId] = { charId = payload.charId, skinId = payload.skinId }
    else
        Network.Events.LobbyParty:FireClient(player, "SelectionFailed", reason)
    end
end
end)