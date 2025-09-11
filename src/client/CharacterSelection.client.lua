local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require(ReplicatedStorage.Modules.Network)
local CharacterRegistry = require(ReplicatedStorage.Modules.CharacterRegistry)

local player = Players.LocalPlayer

-- Assume you have a ScreenGui named CharacterSelectGui in StarterGui
local gui = player:WaitForChild("PlayerGui"):WaitForChild("CharacterSelectGui")
local charListFrame = gui:WaitForChild("CharacterList")
local skinListFrame = gui:WaitForChild("SkinList")
local confirmButton = gui:WaitForChild("ConfirmButton")

local selectedChar, selectedSkin

-- Populate character buttons
for id, def in pairs(CharacterRegistry.All()) do
    local btn = Instance.new("TextButton")
    btn.Text = def.DisplayName
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.Parent = charListFrame
    btn.MouseButton1Click:Connect(function()
        selectedChar = id
        -- Populate skins
        for _, child in ipairs(skinListFrame:GetChildren()) do
            if child:IsA("GuiButton") then child:Destroy() end
        end
        for _, skinId in ipairs(def.Skins) do
            local skinBtn = Instance.new("TextButton")
            skinBtn.Text = skinId
            skinBtn.Size = UDim2.new(1, 0, 0, 40)
            skinBtn.Parent = skinListFrame
            skinBtn.MouseButton1Click:Connect(function()
                selectedSkin = skinId
            end)
        end
    end)
end

confirmButton.MouseButton1Click:Connect(function()
    if selectedChar then
        Network.Events.MatchQueue:FireServer("SelectCharacter", { charId = selectedChar, skinId = selectedSkin })
    end
end)