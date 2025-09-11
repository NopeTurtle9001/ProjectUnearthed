-- ServerScriptService/Main/ShopService.server.lua
local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")

local SharedConfig = require(game.ReplicatedStorage.Modules.SharedConfig)
local Network = require(game.ReplicatedStorage.Modules.Network)

local purchasesStore = DataStoreService:GetDataStore(SharedConfig.DataStore.Purchases)

local function grantPurchase(userId: number, grantType: string, id: string)
    local key = string.format("P_%d", userId)
    local success, result = pcall(function()
        return purchasesStore:UpdateAsync(key, function(old)
            old = old or { Characters = {}, Skins = {}, Skills = {} }
            local bucket = old[grantType]; if not bucket then old[grantType] = {}; bucket = old[grantType] end
            bucket[id] = true
            return old
        end)
    end)
    return success
end

MarketplaceService.ProcessReceipt = function(info)
    local userId = info.PlayerId
    -- Determine what to grant based on product id
    for charId, prodId in pairs(SharedConfig.Products.CharacterUnlocks) do
        if prodId == info.ProductId then
            if grantPurchase(userId, "Characters", charId) then
                local plr = game.Players:GetPlayerByUserId(userId)
                if plr then Network.Events.ShopGrant:FireClient(plr, "Character", charId) end
                return Enum.ProductPurchaseDecision.PurchaseGranted
            end
        end
    end
    for skinId, prodId in pairs(SharedConfig.Products.SkinUnlocks) do
        if prodId == info.ProductId then
            if grantPurchase(userId, "Skins", skinId) then
                local plr = game.Players:GetPlayerByUserId(userId)
                if plr then Network.Events.ShopGrant:FireClient(plr, "Skin", skinId) end
                return Enum.ProductPurchaseDecision.PurchaseGranted
            end
        end
    end
    for skillId, prodId in pairs(SharedConfig.Products.SkillUnlocks) do
        if prodId == info.ProductId then
            if grantPurchase(userId, "Skills", skillId) then
                local plr = game.Players:GetPlayerByUserId(userId)
                if plr then Network.Events.ShopGrant:FireClient(plr, "Skill", skillId) end
                return Enum.ProductPurchaseDecision.PurchaseGranted
            end
        end
    end
    return Enum.ProductPurchaseDecision.NotProcessedYet
end

Network.Events.ShopPrompt.OnServerEvent:Connect(function(player, kind, id)
    -- kind: "Character" | "Skin" | "Skill" ; id must exist in SharedConfig.Products
    local mapping = (kind == "Character" and SharedConfig.Products.CharacterUnlocks)
        or (kind == "Skin" and SharedConfig.Products.SkinUnlocks)
        or (kind == "Skill" and SharedConfig.Products.SkillUnlocks)
    if mapping and mapping[id] then
        game:GetService("MarketplaceService"):PromptProductPurchase(player, mapping[id])
    end
end)