-- ReplicatedStorage/Shared/Modules/Network.lua
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
    BossAnnounce = Remotes:WaitForChild("BossAnnounce"),
    StageUpdate = Remotes:WaitForChild("StageUpdate"),
    TeleporterState = Remotes:WaitForChild("TeleporterState")
}
Network.Funcs = {
    Ping = Remotes:WaitForChild("Ping"),
}

return Network