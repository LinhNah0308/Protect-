local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

pcall(function()
    StarterGui:SetCore("SendNotification",{
        Title = "Protect",
        Text = "Script Protect loaded",
        Duration = 5
    })
end)

local HP_PERCENT = 0.4
local ESCAPE_HEIGHT = 2000
local TWEEN_TIME = 0.2

local escaping = false
local lockedCFrame
local bodyPos
local bodyGyro

hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
hum:SetStateEnabled(Enum.HumanoidStateType.Stunned,false)
hum:SetStateEnabled(Enum.HumanoidStateType.Physics,false)

local function lockInAir()
    bodyPos = Instance.new("BodyPosition")
    bodyPos.MaxForce = Vector3.new(1e9,1e9,1e9)
    bodyPos.P = 1e6
    bodyPos.Position = lockedCFrame.Position
    bodyPos.Parent = root

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
    bodyGyro.P = 1e6
    bodyGyro.CFrame = lockedCFrame
    bodyGyro.Parent = root
end

local function unlock()
    if bodyPos then bodyPos:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    bodyPos = nil
    bodyGyro = nil
end

local function escape()
    if escaping then return end
    escaping = true

    lockedCFrame = root.CFrame + Vector3.new(0,ESCAPE_HEIGHT,0)

    local tween = TweenService:Create(
        root,
        TweenInfo.new(TWEEN_TIME,Enum.EasingStyle.Linear),
        {CFrame = lockedCFrame}
    )

    tween:Play()
    tween.Completed:Wait()

    lockInAir()
end

RunService.Heartbeat:Connect(function()
    if hum.PlatformStand then hum.PlatformStand = false end
    if hum.Sit then hum.Sit = false end
    hum:ChangeState(Enum.HumanoidStateType.Running)

    if hum.Health > 0 then
        if hum.Health / hum.MaxHealth <= HP_PERCENT then
            escape()
        else
            escaping = false
            unlock()
        end
    end
end)
