-- ReplicatedStorage/CharacterDefs/Constructor.lua
local CharacterRegistry = require(game.ReplicatedStorage.Modules.CharacterRegistry)

local def = {
    Id = "Constructor",
    DisplayName = "Constructor",
    BaseStats = {
        Health = 140, Regen = 1.2, Damage = 11, MoveSpeed = 14, Armor = 10, Jump = 1,
    },
    Skills = {
        Primary = "Constructor_SmartGrenade",
        Secondary = "Constructor_PressureMine",
        Utility = "Constructor_BarrierDrone",
        Special = "Constructor_TwinTurrets",
        Variants = { FortressCore = "Constructor_FortressCore" },
    },
    Skins = { "Constructor_Default", "Constructor_Prototype" },
    Assets = {
        Model = "rbxassetid://<constructor-model>",
        Animations = {},
        Sounds = {},
        UI = { Portrait = "rbxassetid://<image>" },
    },
}

CharacterRegistry.Register(def)
return def