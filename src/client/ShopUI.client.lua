-- StarterPlayerScripts/Client/ShopUI.client.lua
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local Network = require(game.ReplicatedStorage.Modules.Network)

-- When user clicks buy button:
-- Network.Events.ShopPrompt:FireServer("Character", "Warden")
-- Network.Events.ShopPrompt:FireServer("Skin", "Ranger_DefaultAlt")
-- Network.Events.ShopPrompt:FireServer("Skill", "Constructor_FortressCore")

Network.Events.ShopGrant.OnClientEvent:Connect(function(kind, id)
    -- Show toast: granted purchase
end)