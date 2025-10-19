-- ServerScriptService/SubExperience/EnemyController.server.lua
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local SharedConfig = require(game.ReplicatedStorage.Shared.Modules.SharedConfig)
local RunState = require(game.ReplicatedStorage.Shared.Modules.RunState)

-- Tag enemies with "Enemy" and optional "Boss" for special handling.
-- Enemy model requirements:
-- - PrimaryPart set
-- - Attributes: BaseHealth, BaseDamage, MoveSpeed (optional)
-- - Attributes: Health (runtime), Damage (runtime), IsBoss (bool optional)
-- - Child: Humanoid (recommended) or we handle manual movement

local ACTIVE = {}

local function scaleEnemy(model: Model)
    local pc = #Players:GetPlayers()
    local healthBase = model:GetAttribute("BaseHealth") or 100
    local dmgBase = model:GetAttribute("BaseDamage") or 10
    local mv = model:GetAttribute("MoveSpeed") or 12

    local coopHealth = 1 + (pc - 1) * SharedConfig.Coop.HealthMultiplierPerPlayer
    local coopDamage = 1 + (pc - 1) * SharedConfig.Coop.DamageMultiplierPerPlayer

    local diff = RunState.DifficultyCoeff
    model:SetAttribute("Health", math.floor(healthBase * coopHealth * (0.8 + 0.2 * diff)))
    model:SetAttribute("Damage", math.floor(dmgBase * coopDamage * (0.8 + 0.2 * diff)))
    model:SetAttribute("MoveSpeed", mv)
end

local function pickTarget()
    local tg, d2
    for _, p in ipairs(Players:GetPlayers()) do
        local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 then
            return p, hrp
        end
    end
    return nil, nil
end

local function steerTo(model: Model, targetPos: Vector3)
    local hum = model:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:MoveTo(targetPos)
        return
    end
    -- Fallback: simple velocity
    local pp = model.PrimaryPart
    if not pp then return end
    local dir = (targetPos - pp.Position)
    local speed = model:GetAttribute("MoveSpeed") or 12
    local vel = dir.Magnitude > 1 and dir.Unit * speed or Vector3.zero
    pp.AssemblyLinearVelocity = Vector3.new(vel.X, pp.AssemblyLinearVelocity.Y, vel.Z)
end

local function attackIfInRange(model: Model, targetPart: BasePart)
    local pp = model.PrimaryPart
    if not pp then return end
    local dist = (targetPart.Position - pp.Position).Magnitude
    local range = model:GetAttribute("AttackRange") or 4
    if dist <= range then
        local dmg = model:GetAttribute("Damage") or 10
        local hum = targetPart.Parent and targetPart.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            hum:TakeDamage(dmg)
            model:SetAttribute("LastAttack", os.clock())
        end
    end
end

local function stepEnemy(model: Model, dt: number)
    if not model.Parent then return end
    local pc = #Players:GetPlayers()
    RunState.UpdateDifficulty(pc)

    local targetPlayer, targetPart = pickTarget()
    local pp = model.PrimaryPart
    if not targetPlayer or not targetPart or not pp then return end

    scaleEnemy(model)

    -- Simple state: chase -> attack
    steerTo(model, targetPart.Position)
    attackIfInRange(model, targetPart)

    -- Death handling
    local hp = model:GetAttribute("Health")
    if hp and hp <= 0 then
        model:Destroy()
    end
end

-- Track enemies by tag
local function track(model)
    if ACTIVE[model] then return end
    ACTIVE[model] = true
    model.AncestryChanged:Connect(function(_, parent)
        if not parent then ACTIVE[model] = nil end
    end)
end

for _, inst in ipairs(CollectionService:GetTagged("Enemy")) do
    if inst:IsA("Model") then track(inst) end
end
CollectionService:GetInstanceAddedSignal("Enemy"):Connect(function(inst)
    if inst:IsA("Model") then track(inst) end
end)

RunService.Heartbeat:Connect(function(dt)
    for model in pairs(ACTIVE) do
        task.spawn(stepEnemy, model, dt)
    end
end)