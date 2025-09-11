-- StarterPlayerScripts/Client/HUD.client.lua
local Players = game:GetService("Players")
local Network = require(game.ReplicatedStorage.Modules.Network)

-- Display cooldowns, items, stage timer
-- You can listen for server updates (notified through custom events you add)