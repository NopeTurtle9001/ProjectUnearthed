-- ReplicatedStorage/Modules/SkillSystem/SkillLibrary.lua
local SkillBase = require(script.Parent.SkillBase)

local function mk(def) return SkillBase.new(def) end

-- Example implementations are server-authoritative. Client echoes VFX only.
local SkillLibrary = {
    -- Ranger-like Double Tap (primary, rapid fire hitscan)
    Ranger_DoubleTap = mk({
        Id = "Ranger_DoubleTap",
        Name = "Double Tap",
        Cooldown = 0.15,
        Description = "Fire a quick burst for moderate damage.",
        ExecuteServer = function(ctx)
            -- ctx: {player, character, originCFrame, direction, stats}
            -- Server raycast and apply damage based on ctx.stats.Damage
            -- Emit hit VFX via RemoteEvent to nearby clients
        end,
        ExecuteClient = function(ctx)
            -- play muzzle flash, camera recoil, sound
        end,
    }),

    -- Ranger Secondary: Phase Round (piercing shot)
    Ranger_PhaseRound = mk({
        Id = "Ranger_PhaseRound",
        Name = "Phase Round",
        Cooldown = 5,
        ExecuteServer = function(ctx)
            -- Multi-pierce ray with damage falloff
        end,
        ExecuteClient = function(ctx)
            -- charge sound + tracer
        end,
    }),

    -- Ranger Utility: Tactical Dive (short dash + i-frames)
    Ranger_TacticalDive = mk({
        Id = "Ranger_TacticalDive",
        Name = "Tactical Dive",
        Cooldown = 7,
        ExecuteServer = function(ctx)
            -- server-set velocity/position with state lock for brief i-frames
        end,
        ExecuteClient = function(ctx)
            -- roll animation, motion blur
        end,
    }),

    -- Ranger Special: Suppressive Barrage (cone multi-hit)
    Ranger_SuppressiveBarrage = mk({
        Id = "Ranger_SuppressiveBarrage",
        Name = "Suppressive Barrage",
        Cooldown = 12,
        ExecuteServer = function(ctx)
            -- spawn timed hits in a cone; apply stun on last ticks
        end,
        ExecuteClient = function(ctx)
            -- screen shake, particle cone
        end,
    }),

    -- Warden (Summoner) Primary: Spirit Darts (tag enemies for minions)
    Warden_SpiritDarts = mk({
        Id = "Warden_SpiritDarts",
        Name = "Spirit Darts",
        Cooldown = 0.25,
        ExecuteServer = function(ctx)
            -- apply "Marked" status; minions prioritize marked targets
        end,
        ExecuteClient = function(ctx) end,
    }),

    -- Warden Secondary: Bind Totem (root field)
    Warden_BindTotem = mk({
        Id = "Warden_BindTotem",
        Name = "Bind Totem",
        Cooldown = 10,
        ExecuteServer = function(ctx)
            -- place totem instance; AoE slow/root pulses
        end,
        ExecuteClient = function(ctx) end,
    }),

    -- Warden Utility: Rally (summon quick wisp ally)
    Warden_RallyWisp = mk({
        Id = "Warden_RallyWisp",
        Name = "Rally Wisp",
        Cooldown = 14,
        ExecuteServer = function(ctx)
            -- spawn a short-lived minion allied to player
        end,
        ExecuteClient = function(ctx) end,
    }),

    -- Warden Special: Swarm (call several minions temporarily)
    Warden_Swarm = mk({
        Id = "Warden_Swarm",
        Name = "Swarm",
        Cooldown = 30,
        ExecuteServer = function(ctx)
            -- spawn a burst of minions with limited lifetime
        end,
        ExecuteClient = function(ctx) end,
    }),

    -- Constructor (Engineer-like) Primary: Smart Grenade
    Constructor_SmartGrenade = mk({
        Id = "Constructor_SmartGrenade",
        Name = "Smart Grenade",
        Cooldown = 0.7,
        ExecuteServer = function(ctx)
            -- create projectile with slight seek near end of arc
        end,
        ExecuteClient = function(ctx) end,
    }),

    -- Constructor Secondary: Pressure Mine (placeable)
    Constructor_PressureMine = mk({
        Id = "Constructor_PressureMine",
        Name = "Pressure Mine",
        Cooldown = 6,
        ExecuteServer = function(ctx)
            -- place mine entity; arms after delay; AoE when triggered
        end,
        ExecuteClient = function(ctx) end,
    }),

    -- Constructor Utility: Barrier Drone (deployable cover)
    Constructor_BarrierDrone = mk({
        Id = "Constructor_BarrierDrone",
        Name = "Barrier Drone",
        Cooldown = 14,
        ExecuteServer = function(ctx)
            -- spawn stationary drone projecting frontal shield
        end,
        ExecuteClient = function(ctx) end,
    }),

    -- Constructor Special: Twin Turrets (scales with items)
    Constructor_TwinTurrets = mk({
        Id = "Constructor_TwinTurrets",
        Name = "Twin Turrets",
        Cooldown = 25,
        ExecuteServer = function(ctx)
            -- spawn two turrets that mirror player on-kill/on-hit effects
        end,
        ExecuteClient = function(ctx) end,
    }),
}

return SkillLibrary