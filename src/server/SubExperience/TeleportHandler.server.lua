-- ServerScriptService/SubExperience/TeleportHandler.server.lua
local Players = game:GetService("Players")

local artifactPayloadByUser = {}

game:GetService("TeleportService").LocalPlayerArrivedFromTeleport:Connect(function(player, data)
    if data and data.artifacts then
        artifactPayloadByUser[player.UserId] = data.artifacts
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    artifactPayloadByUser[plr.UserId] = nil
end)

return {
    GetArtifactsFor = function(userId)
        return artifactPayloadByUser[userId]
    end
}