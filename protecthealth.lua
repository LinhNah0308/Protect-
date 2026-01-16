local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local STEP_DISTANCE = 250
local TOTAL_DISTANCE = 10000
local SPEED = 370
local HP_TRIGGER = 4700
local CHECK_DELAY = 0.3
local FORCE_TIME = 180

local player = Players.LocalPlayer
local char, hum, root
local moving = false
local startTime = os.clock()
local forcedUsed = false

local function bind(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
    moving = false
end

bind(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(bind)

StarterGui:SetCore("SendNotification",{
    Title="-Script Notification-",
    Text="Script Loaded ✅",
    Duration=5
})

local function escape()
    if moving then return end
    moving = true
    local moved = 0

    while hum and hum.Health > 0 and moved < TOTAL_DISTANCE do
        local startPos = root.Position
        local step = math.min(STEP_DISTANCE, TOTAL_DISTANCE - moved)
        local targetPos = startPos + Vector3.new(step,0,0)
        local t = step / SPEED

        local tween = TweenService:Create(
            root,
            TweenInfo.new(t,Enum.EasingStyle.Linear),
            {CFrame = CFrame.new(targetPos)}
        )

        tween:Play()
        tween.Completed:Wait()
        moved += step
        task.wait(0.05)
    end

    moving = false
end

task.spawn(function()
    while true do
        task.wait(CHECK_DELAY)

        if hum and hum.Health > 0 then
            if hum.Health < HP_TRIGGER then
                escape()
            elseif not forcedUsed and os.clock() - startTime >= FORCE_TIME then
                forcedUsed = true
                escape()
            end
        end
    end
end)
