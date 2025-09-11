-- ReplicatedStorage/Modules/RunState.lua
local SharedConfig = require(game.ReplicatedStorage.Modules.SharedConfig)

local RunState = {
    Seed = math.random(1, 10^9),
    StageIndex = 1,
    StageStartTime = os.clock(),
    DifficultyCoeff = 1.0,
    BossAlive = false,
    Teleporter = {
        State = "Dormant", -- Dormant, Activated, Charging, Charged, PortalOpen
        Charge = 0, -- 0..100
    },
}

function RunState.ResetForNewStage()
    RunState.StageIndex += 1
    RunState.StageStartTime = os.clock()
    RunState.BossAlive = false
    RunState.Teleporter = { State = "Dormant", Charge = 0 }
end

function RunState.UpdateDifficulty(playersCount: number)
    -- Time-based scaling similar in spirit to RoR: grows with time and stage
    local elapsed = os.clock() - RunState.StageStartTime
    local timeFactor = 1 + elapsed / SharedConfig.Run.StageTimeSeconds
    local stageFactor = 1 + 0.35 * (RunState.StageIndex - 1)
    local playerFactor = 1 + (playersCount - 1) * 0.3
    RunState.DifficultyCoeff = timeFactor * stageFactor * playerFactor
end

return RunState