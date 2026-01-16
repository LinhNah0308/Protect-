local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local DISTANCE_X = 10000
local SPEED = 360
local HP_TRIGGER = 4700
local CHECK_DELAY = 0.3

local player = Players.LocalPlayer
local character = nil
local humanoid = nil
local root = nil

local flying = false
local holding = false
local holdPos = nil
local stepConn = nil

local function clearState()
    flying = false
    holding = false
    holdPos = nil
    if stepConn then
        stepConn:Disconnect()
        stepConn = nil
    end
end

local function bindCharacter(char)
    clearState()
    character = char
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")

    stepConn = RunService.Stepped:Connect(function()
        if holding and character and root then
            for _,v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                    v.AssemblyLinearVelocity = Vector3.zero
                end
            end
            root.CFrame = CFrame.new(holdPos)
        end
    end)
end

bindCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(bindCharacter)

StarterGui:SetCore("SendNotification",{
    Title = "-Script Notification-",
    Text = "Script Loaded ✅",
    Duration = 5
})

task.spawn(function()
    while true do
        task.wait(CHECK_DELAY)

        if humanoid and root and humanoid.Health > 0 then
            if humanoid.Health < HP_TRIGGER and not flying then
                flying = true
                holding = false
                holdPos = nil

                local startPos = root.Position
                local targetPos = startPos + Vector3.new(DISTANCE_X,0,0)
                local time = (targetPos - startPos).Magnitude / SPEED

                local tween = TweenService:Create(
                    root,
                    TweenInfo.new(time,Enum.EasingStyle.Linear),
                    {CFrame = CFrame.new(targetPos)}
                )

                tween:Play()
                tween.Completed:Wait()

                if root and humanoid.Health > 0 then
                    holdPos = root.Position
                    holding = true
                end
            end
        end
    end
end)
