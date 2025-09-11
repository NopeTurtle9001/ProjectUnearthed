-- ReplicatedStorage/Modules/ItemRegistry.lua
local Util = require(game.ReplicatedStorage.Modules.Util)

local ItemRegistry = { _defs = {} }

function ItemRegistry.Register(def)
    ItemRegistry._defs[def.Id] = Util.DeepFreeze(def)
end

function ItemRegistry.Get(id) return ItemRegistry._defs[id] end
function ItemRegistry.All() return ItemRegistry._defs end

return ItemRegistry