-- ReplicatedStorage/ItemDefs/Items.lua
local ItemRegistry = require(game.ReplicatedStorage.Modules.ItemRegistry)

local function Reg(def) ItemRegistry.Register(def) end

Reg({
    Id = "SoldiersSyringe",
    Tier = "Common",
    Stacks = true,
    OnPickup = function(player, svc) end,
    OnStatCalc = function(player, stacks, stats)
        stats.AttackSpeed = (stats.AttackSpeed or 1) * (1 + 0.15 * stacks)
    end
})

Reg({
    Id = "TougherTimes",
    Tier = "Uncommon",
    Stacks = true,
    OnPickup = function(player, svc) end,
    OnStatCalc = function(player, stacks, stats)
        stats.BlockChance = (stats.BlockChance or 0) + (0.13 / stacks) -- diminishing
    end
})

Reg({
    Id = "Ukelele",
    Tier = "Uncommon",
    Stacks = true,
    OnPickup = function(player, svc) end,
    OnStatCalc = function(player, stacks, stats)
        stats.ChainLightningChance = (stats.ChainLightningChance or 0) + 0.25 + 0.05 * (stacks - 1)
    end
})