-- ReplicatedStorage/ArtifactDefs/Artifacts.lua
local ArtifactRegistry = require(game.ReplicatedStorage.Modules.ArtifactRegistry)

local function Reg(def) ArtifactRegistry.Register(def) end

Reg({
    Id = "ArtifactOfHonor",
    Name = "Artifact of Honor",
    Description = "Enemies only drop items of Uncommon tier or higher.",
    ApplyRunModifiers = function(run)
        run.DropTable.FilterMinTier = "Uncommon"
    end,
})

Reg({
    Id = "ArtifactOfKin",
    Name = "Artifact of Kin",
    Description = "Monsters come in only one type.",
    ApplyRunModifiers = function(run)
        run.SpawnRules.SingleFamily = true
    end,
})