-- ReplicatedStorage/Modules/SkillSystem/SkillBase.lua
-- Base class providing cooldown state and validation
local Signal = require(game.ReplicatedStorage.Modules.Signal)

local SkillBase = {}
SkillBase.__index = SkillBase

function SkillBase.new(def)
    local self = setmetatable({}, SkillBase)
    self.Id = def.Id
    self.Name = def.Name
    self.Cooldown = def.Cooldown or 1
    self.ExecuteServer = def.ExecuteServer
    self.ExecuteClient = def.ExecuteClient
    self.Description = def.Description
    self.Icon = def.Icon
    self._cooldowns = {} -- [userId] = time when usable
    self.Activated = Signal.new()
    return self
end

function SkillBase:IsReady(userId: number)
    local now = os.clock()
    return (self._cooldowns[userId] or 0) <= now
end

function SkillBase:Consume(userId: number)
    self._cooldowns[userId] = os.clock() + self.Cooldown
end

return SkillBase