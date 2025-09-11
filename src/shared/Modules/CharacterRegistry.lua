-- ReplicatedStorage/Modules/CharacterRegistry.lua
local Util = require(game.ReplicatedStorage.Modules.Util)

local CharacterRegistry = {
    _defs = {},
}

function CharacterRegistry.Register(def)
    CharacterRegistry._defs[def.Id] = Util.DeepFreeze(def)
end

function CharacterRegistry.Get(id)
    return CharacterRegistry._defs[id]
end

function CharacterRegistry.All()
    return CharacterRegistry._defs
end

return CharacterRegistry