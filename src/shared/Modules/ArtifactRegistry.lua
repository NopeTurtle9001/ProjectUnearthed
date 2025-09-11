-- ReplicatedStorage/Modules/ArtifactRegistry.lua
local Util = require(game.ReplicatedStorage.Modules.Util)

local ArtifactRegistry = { _defs = {} }

function ArtifactRegistry.Register(def)
    ArtifactRegistry._defs[def.Id] = Util.DeepFreeze(def)
end

function ArtifactRegistry.Get(id) return ArtifactRegistry._defs[id] end
function ArtifactRegistry.All() return ArtifactRegistry._defs end

return ArtifactRegistry