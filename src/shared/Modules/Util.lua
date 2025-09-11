-- ReplicatedStorage/Modules/Util.lua
local Util = {}

function Util.RateLimiter(maxPerSec)
    local allowance = maxPerSec
    local last = os.clock()
    return function(n)
        n = n or 1
        local now = os.clock()
        local elapsed = now - last
        last = now
        allowance = math.min(maxPerSec, allowance + elapsed * maxPerSec)
        if allowance >= n then
            allowance -= n
            return true
        end
        return false
    end
end

function Util.SafePlayerFromId(userId: number): Player?
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr.UserId == userId then return plr end
    end
    return nil
end

function Util.DeepFreeze(tbl)
    table.freeze(tbl)
    for _, v in pairs(tbl) do
        if type(v) == "table" and not table.isfrozen(v) then
            Util.DeepFreeze(v)
        end
    end
    return tbl
end

return Util