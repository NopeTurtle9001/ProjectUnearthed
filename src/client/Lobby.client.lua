-- StarterPlayerScripts/Client/Lobby.client.lua
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")

local Network = require(game.ReplicatedStorage.Shared.Modules.Network)

-- Simple party UI bindings
-- Example: buttons call:
-- Network.Events.MatchQueue:FireServer("CreateParty")
-- Network.Events.MatchQueue:FireServer("JoinParty", partyId)
-- Network.Events.MatchQueue:FireServer("StartRun", partyId)

Network.Events.LobbyParty.OnClientEvent:Connect(function(kind, payload)
    -- Update UI accordingly
end)