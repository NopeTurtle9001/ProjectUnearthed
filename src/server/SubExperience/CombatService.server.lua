-- ServerScriptService/SubExperience/CombatService.server.lua
local Debris = game:GetService("Debris")
local CollectionService = game:GetService("CollectionService")

local CombatService = {}

local function findEnemyModel(instance: Instance): Model?
    local m = instance:FindFirstAncestorOfClass("Model")
    if not m then return nil end
    return CollectionService:HasTag(m, "Enemy") and m or nil
end

function CombatService.Hitscan(originCFrame, direction, range, damage, sourcePlayer)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = { sourcePlayer.Character }

    local result = workspace:Raycast(originCFrame.Position, direction * range, params)
    if result and result.Instance then
        local enemy = findEnemyModel(result.Instance)
        if enemy then
            local hp = enemy:GetAttribute("Health")
            if hp then
                hp -= damage
                enemy:SetAttribute("Health", math.max(0, hp))
                if hp <= 0 then
                    enemy:SetAttribute("KilledBy", sourcePlayer.UserId)
                    enemy:Destroy()
                end
            end
        end
    end
end

return CombatService