local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local STEP_DISTANCE = 250
local TOTAL_DISTANCE = 10000
local SPEED = 370
local HP_TRIGGER = 4700
local CHECK_DELAY = 0.3
local FORCE_TIME = 180

local player = Players.LocalPlayer
local char, hum, root
local moving = false
local forcedUsed = false
local lockY = false
local fixedY = 0

local function bind(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
    moving = false
    lockY = false
end

bind(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(bind)

StarterGui:SetCore("SendNotification",{
    Title="-Script Notification-",
    Text="Script Loaded ✅",
    Duration=5
})

RunService.Stepped:Connect(function()
    if lockY and root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.CFrame = CFrame.new(root.Position.X, fixedY, root.Position.Z)
    end
end)

local function escape()
    if moving or not hum or hum.Health <= 0 then return end
    moving = true

    fixedY = root.Position.Y
    lockY = true

    local moved = 0
    while hum and hum.Health > 0 and moved < TOTAL_DISTANCE do
        local step = math.min(STEP_DISTANCE, TOTAL_DISTANCE - moved)
        local targetPos = Vector3.new(
            root.Position.X + step,
            fixedY,
            root.Position.Z
        )

        local t = step / SPEED
        local tween = TweenService:Create(
            root,
            TweenInfo.new(t, Enum.EasingStyle.Linear),
            {CFrame = CFrame.new(targetPos)}
        )

        tween:Play()
        tween.Completed:Wait()

        moved += step
        task.wait(0.05)
    end

    lockY = false
    moving = false
end

task.spawn(function()
    while true do
        task.wait(CHECK_DELAY)
        if hum and hum.Health > 0 and hum.Health < HP_TRIGGER then
            escape()
        end
    end
end)

task.spawn(function()
    local remain = FORCE_TIME
    while remain > 0 and not forcedUsed do
        StarterGui:SetCore("SendNotification",{
            Title="-Script Notification-",
            Text="Teleport sau "..remain.."s",
            Duration=3
        })
        task.wait(10)
        remain -= 10
    end
    if not forcedUsed then
        forcedUsed = true
        escape()
    end
end)
