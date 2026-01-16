local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local DISTANCE_X = 10000
local HP_TRIGGER = 4700
local CHECK_DELAY = 0.3
local TWEEN_TIME = 4

local player = Players.LocalPlayer
local character
local humanoid
local root
local flying = false

local function setupChar(char)
    character = char
    humanoid = char:WaitForChild("Humanoid",5)
    root = char:WaitForChild("HumanoidRootPart",5)
    flying = false
end

setupChar(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(setupChar)

StarterGui:SetCore("SendNotification",{
    Title = "-Script Notification-",
    Text = "Script Loaded ✅",
    Duration = 5
})

RunService.Stepped:Connect(function()
    if flying and character then
        for _,v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(CHECK_DELAY)

        if humanoid and root and humanoid.Health > 0 then
            if humanoid.Health < HP_TRIGGER and flying == false then
                flying = true

                local goal = {}
                goal.CFrame = root.CFrame + Vector3.new(DISTANCE_X,0,0)

                local tween = TweenService:Create(
                    root,
                    TweenInfo.new(TWEEN_TIME,Enum.EasingStyle.Linear),
                    goal
                )

                tween:Play()
            end
        end
    end
end)
