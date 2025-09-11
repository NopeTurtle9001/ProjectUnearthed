-- ReplicatedStorage/Modules/Network.lua
local Network = {}

local Remotes = game.ReplicatedStorage:WaitForChild("Remotes")

Network.Events = {
    SkillRequest = Remotes:WaitForChild("SkillRequest"),
    ItemPickup = Remotes:WaitForChild("ItemPickup"),
    ItemShareRequest = Remotes:WaitForChild("ItemShareRequest"),
    ShopPrompt = Remotes:WaitForChild("ShopPrompt"),
    ShopGrant = Remotes:WaitForChild("ShopGrant"),
    LobbyParty = Remotes:WaitForChild("LobbyParty"),
    MatchQueue = Remotes:WaitForChild("MatchQueue"),
}
Network.Funcs = {
    Ping = Remotes:WaitForChild("Ping"),
}

return Network