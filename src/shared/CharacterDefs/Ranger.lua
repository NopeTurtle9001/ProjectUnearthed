-- ReplicatedStorage/CharacterDefs/Ranger.lua
local CharacterRegistry = require(game.ReplicatedStorage.Modules.CharacterRegistry)

local def = {
    Id = "Ranger",
    DisplayName = "Ranger",
    BaseStats = {
        Health = 110, Regen = 1.5, Damage = 12, MoveSpeed = 16, Armor = 0, Jump = 1,
    },
    Skills = {
        Primary = "Ranger_DoubleTap",
        Secondary = "Ranger_PhaseRound",
        Utility = "Ranger_TacticalDive",
        Special = "Ranger_SuppressiveBarrage",
        Variants = {
            DoubleTapPlus = "Ranger_DoubleTapPlus", -- monetized/achievement variant slot
        }
    },
    Skins = { "Ranger_Default", "Ranger_DefaultAlt" },
    Assets = {
        Model = "rbxassetid://<ranger-model>",
        Animations = { Run = "rbxassetid://<anim>", Fire = "rbxassetid://<anim>" },
        Sounds = { Fire = "rbxassetid://<sound>", Roll = "rbxassetid://<sound>" },
        UI = { Portrait = "rbxassetid://<image>" },
    },
}

CharacterRegistry.Register(def)
return def