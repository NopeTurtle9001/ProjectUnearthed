-- ReplicatedStorage/Modules/EnemyAI.lua
-- Stateless helpers to drive enemy behavior via a controller
local EnemyAI = {}

function EnemyAI.PickTarget(players)
    -- Prefer closest living player
    local best, bestDist = nil, math.huge
    for _, p in ipairs(players) do
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local dist = (hrp.Position)
            if dist then
                -- We'll compute distance in the controller with positions; leave placeholder
            end
        end
    end
    return nil
end

function EnemyAI.CanSee(origin: Vector3, targetPart: BasePart): boolean
    local dir = (targetPart.Position - origin)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Whitelist
    params.FilterDescendantsInstances = { targetPart.Parent }
    local result = workspace:Raycast(origin, dir, params)
    return result ~= nil and result.Instance ~= nil
end

return EnemyAI