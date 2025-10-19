-- ServerScriptService/SubExperience/DropService.server.lua
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

local Network = require(game.ReplicatedStorage.Shared.Modules.Network)
local ItemRegistry = require(game.ReplicatedStorage.Shared.Modules.ItemRegistry)
local InventoryService = require(script.Parent.InventoryService)
local SharedConfig = require(game.ReplicatedStorage.Shared.Modules.SharedConfig)

-- Requirements:
-- - ServerStorage/ItemPickups contains simple pickup models named by ItemId with PrimaryPart and ProximityPrompt

local function spawnDrop(itemId: string, position: Vector3)
    local folder = ServerStorage:FindFirstChild("ItemPickups")
    if not folder then return end
    local template = folder:FindFirstChild(itemId)
    if not template then return end
    local m = template:Clone()
    m.Parent = workspace:FindFirstChild("Pickups") or workspace
    m:MoveTo(position + Vector3.new(0, 2, 0))
    -- Bind prompt
    local prompt = m:FindFirstChildOfClass("ProximityPrompt") or Instance.new("ProximityPrompt", m.PrimaryPart)
    prompt.ActionText = "Pick up"
    prompt.ObjectText = itemId
    prompt.MaxActivationDistance = 12
    prompt.Triggered:Connect(function(player)
        if ItemRegistry.Get(itemId) then
            InventoryService.Add(player.UserId, itemId)
            Network.Events.ItemPickup:FireClient(player, itemId) -- optional UI toast
            m:Destroy()
        end
    end)
end

-- Simple drop table
local COMMON = { "SoldiersSyringe" }
local UNCOMMON = { "Ukelele" }
local function pickRandom(t) return t[math.random(1, #t)] end

-- Hook enemy deaths by watching for Destroying and KilledBy attribute
game.DescendantRemoving:Connect(function(inst)
    if inst:IsA("Model") and CollectionService:HasTag(inst, "Enemy") then
        local killedBy = inst:GetAttribute("KilledBy")
        local pp = inst.PrimaryPart
        local pos = pp and pp.Position or (inst:GetPivot().Position)
        -- Drop chance scaled a bit by difficulty
        if math.random() < 0.6 then
            local itemId = math.random() < 0.8 and pickRandom(COMMON) or pickRandom(UNCOMMON)
            spawnDrop(itemId, pos)
        end
    end
end)

return {}