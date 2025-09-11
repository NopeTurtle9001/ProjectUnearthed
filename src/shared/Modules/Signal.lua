-- ReplicatedStorage/Modules/Signal.lua
-- Lightweight typed signal for Luau
local Signal = {}
Signal.__index = Signal

function Signal.new()
    local self = setmetatable({}, Signal)
    self._binds = {}
    return self
end

function Signal:Connect(fn)
    local conn = { _fn = fn, _d = false }
    self._binds[conn] = true
    return {
        Disconnect = function()
            if not conn._d then
                conn._d = true
                self._binds[conn] = nil
            end
        end
    }
end

function Signal:Fire(...)
    for conn in pairs(self._binds) do
        task.spawn(conn._fn, ...)
    end
end

return Signal