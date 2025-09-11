-- StarterPlayerScripts/Client/Input.client.lua
local UserInputService = game:GetService("UserInputService")
local Network = require(game.ReplicatedStorage.Modules.Network)

local function sendSkill(skillId)
    local char = workspace:FindFirstChild(game.Players.LocalPlayer.Name)
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local cf = hrp.CFrame
    local dir = (cf.LookVector).Unit
    Network.Events.SkillRequest:FireServer({
        skillId = skillId,
        originCFrame = cf,
        direction = dir,
    })
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Q then sendSkill("Ranger_DoubleTap") end
    if input.KeyCode == Enum.KeyCode.E then sendSkill("Ranger_PhaseRound") end
    if input.KeyCode == Enum.KeyCode.LeftShift then sendSkill("Ranger_TacticalDive") end
    if input.KeyCode == Enum.KeyCode.R then sendSkill("Ranger_SuppressiveBarrage") end
end)