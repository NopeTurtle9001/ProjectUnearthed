-- StarterPlayerScripts/Client/TeleporterUI.client.lua
local Players = game:GetService("Players")
local Network = require(game.ReplicatedStorage.Modules.Network)

-- Assume a ScreenGui named RunHUD with:
-- - TextLabel StageLabel
-- - TextLabel DifficultyLabel
-- - Frame TeleporterBar with a UIGradient or Size.X scale
-- - TextLabel TeleporterStateLabel
local gui = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("RunHUD")
local stageLabel = gui:WaitForChild("StageLabel")
local diffLabel = gui:WaitForChild("DifficultyLabel")
local tpBar = gui:WaitForChild("TeleporterBar")
local tpState = gui:WaitForChild("TeleporterStateLabel")

Network.Events.StageUpdate.OnClientEvent:Connect(function(stageIndex, difficultyCoeff)
    stageLabel.Text = ("Stage %d"):format(stageIndex)
    diffLabel.Text = ("Difficulty x%.2f"):format(difficultyCoeff)
end)

Network.Events.TeleporterState.OnClientEvent:Connect(function(state, charge)
    tpState.Text = state
    if tpBar:IsA("Frame") then
        tpBar.Size = UDim2.new(math.clamp(charge/100, 0, 1), 0, tpBar.Size.Y.Scale, tpBar.Size.Y.Offset)
    end
end)

Network.Events.BossAnnounce.OnClientEvent:Connect(function(name)
    -- Flash banner or play a sound
end)