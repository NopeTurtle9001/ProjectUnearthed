-- ReplicatedStorage/Modules/SharedConfig.lua
local SharedConfig = {
    MainPlaceId = 0000000000, -- your main place id
    SubExperiencePlaceId = 0000000000, -- your sub-experience place id

    -- Developer products for Robux purchases
    Products = {
        -- grant specific character unlock
        CharacterUnlocks = {
            Ranger = 1111111111,
            Warden = 1111111112,
            Constructor = 1111111113,
        },
        -- grant skin unlocks
        SkinUnlocks = {
            Ranger_DefaultAlt = 1111111121,
            Warden_Obsidian = 1111111122,
            Constructor_Prototype = 1111111123,
        },
        -- grant skill variants
        SkillUnlocks = {
            Ranger_DoubleTapPlus = 1111111131,
            Warden_SwarmLord = 1111111132,
            Constructor_FortressCore = 1111111133,
        },
    },

    -- DataStore keys
    DataStore = {
        Profile = "RoR_Profile_v1",
        Purchases = "RoR_Purchases_v1",
        Achievements = "RoR_Achievements_v1",
    },

    -- Co-op scaling
    Coop = {
        HealthMultiplierPerPlayer = 0.7, -- additive per extra player
        DamageMultiplierPerPlayer = 0.3,
        LootShareMode = "PartyShare", -- "PartyShare" or "FreeForAll"
    },

    -- Network throttles
    Net = {
        SkillRequestRate = 8, -- per second per player
        ItemShareRate = 4,
        PingTimeoutSec = 20,
    },

    -- Run flow
    Run = {
        StageTimeSeconds = 300,
        MaxPlayersPerRun = 4,
    },
}

return SharedConfig