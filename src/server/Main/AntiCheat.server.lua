-- ServerScriptService/Main/AntiCheat.server.lua
local Network = require(game.ReplicatedStorage.Shared.Modules.Network)
local SharedConfig = require(game.ReplicatedStorage.Shared.Modules.SharedConfig)
local Util = require(game.ReplicatedStorage.Shared.Modules.Util)

local rate = {} -- [userId] = { skill = limiter, share = limiter }

game.Players.PlayerAdded:Connect(function(plr)
    rate[plr.UserId] = {
        skill = Util.RateLimiter(SharedConfig.Net.SkillRequestRate),
        share = Util.RateLimiter(SharedConfig.Net.ItemShareRate),
    }
end)
game.Players.PlayerRemoving:Connect(function(plr)
    rate[plr.UserId] = nil
end)

Network.Events.SkillRequest.OnServerEvent:Connect(function(plr, payload)
    if not rate[plr.UserId] or not rate[plr.UserId].skill() then return end
    -- Additional validation is in GameLoop and skill server execute
end)

Network.Events.ItemShareRequest.OnServerEvent:Connect(function(plr, payload)
    if not rate[plr.UserId] or not rate[plr.UserId].share() then return end
end)