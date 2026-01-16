local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local DISTANCE_X = 10000
local SPEED = 370
local HP_TRIGGER = 4700
local CHECK_DELAY = 0.3

local player = Players.LocalPlayer
local character
local humanoid
local root
local flying = false
local holdPos

local function setup(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    flying = false
    holdPos = nil
end

setup(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(setup)

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
                v.AssemblyLinearVelocity = Vector3.zero
            end
        end
        if holdPos then
            root.CFrame = CFrame.new(holdPos)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(CHECK_DELAY)

        if humanoid and root and humanoid.Health > 0 then
            if humanoid.Health < HP_TRIGGER and not flying then
                flying = true

                local startPos = root.Position
                local targetPos = startPos + Vector3.new(DISTANCE_X,0,0)
                local distance = (targetPos - startPos).Magnitude
                local tweenTime = distance / SPEED

                local tween = TweenService:Create(
                    root,
                    TweenInfo.new(tweenTime,Enum.EasingStyle.Linear),
                    {CFrame = CFrame.new(targetPos)}
                )

                tween:Play()
                tween.Completed:Wait()

                holdPos = root.Position
            end
        end
    end
end)
