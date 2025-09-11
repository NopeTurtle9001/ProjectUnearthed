-- ReplicatedStorage/CharacterDefs/Warden.lua
local CharacterRegistry = require(game.ReplicatedStorage.Modules.CharacterRegistry)

local def = {
    Id = "Warden",
    DisplayName = "Warden",
    BaseStats = {
        Health = 100, Regen = 2.0, Damage = 10, MoveSpeed = 15, Armor = 0, Jump = 1,
    },
    Skills = {
        Primary = "Warden_SpiritDarts",
        Secondary = "Warden_BindTotem",
        Utility = "Warden_RallyWisp",
        Special = "Warden_Swarm",
        Variants = { SwarmLord = "Warden_SwarmLord" },
    },
    Skins = { "Warden_Default", "Warden_Obsidian" },
    Assets = {
        Model = "rbxassetid://<warden-model>",
        Animations = {},
        Sounds = {},
        UI = { Portrait = "rbxassetid://<image>" },
    },
}

CharacterRegistry.Register(def)
return def