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
local ESCAPE_HEIGHT = 10000
local RISE_SPEED = 30

local char, hum, root
local activated = false
local targetY

local function bind(c)
    char = c
    hum = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
end

bind(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(bind)

RunService.Heartbeat:Connect(function()
    if not hum or not root then return end
    if hum.Health <= 0 then return end

    if hum.Health < HP_TRIGGER and not activated then
        activated = true
        root.Anchored = true
        targetY = root.Position.Y + ESCAPE_HEIGHT
    end

    if activated then
        local pos = root.Position
        if pos.Y < targetY then
            root.CFrame = CFrame.new(pos.X, math.min(pos.Y + RISE_SPEED, targetY), pos.Z)
        else
            root.CFrame = CFrame.new(pos.X, targetY, pos.Z)
        end
    end
end)
