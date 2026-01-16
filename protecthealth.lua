local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

pcall(function()
    StarterGui:SetCore("SendNotification",{
        Title = "Protect",
        Text = "Script Protect loaded",
        Duration = 5
    })
end)

local HP_TRIGGER = 4500
local ESCAPE_HEIGHT = 2000
local RISE_SPEED = 25

local char, hum, root
local escaping = false
local startY, targetY

local function bind(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
end

bind(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(bind)

RunService.Heartbeat:Connect(function(dt)
    if not hum or not root then return end
    if hum.Health <= 0 then return end

    if hum.Health < HP_TRIGGER then
        if not escaping then
            escaping = true
            root.Anchored = true
            startY = root.Position.Y
            targetY = startY + ESCAPE_HEIGHT
        end

        local current = root.Position
        local nextY = math.min(current.Y + RISE_SPEED, targetY)
        root.CFrame = CFrame.new(current.X, nextY, current.Z)

    else
        escaping = false
        if root.Anchored then
            root.Anchored = false
        end
    end
end)
