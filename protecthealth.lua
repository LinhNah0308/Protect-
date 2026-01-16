local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

pcall(function()
    StarterGui:SetCore("SendNotification",{
        Title = "Info",
        Text = "Script Loaded ✅",
        Duration = 4
    })
end)

local player = Players.LocalPlayer
local HP_TRIGGER = 4500
local DIST_X = 10000
local SPEED = 150

local char, hum, root
local active = false
local targetX

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

    if hum.Health < HP_TRIGGER and not active then
        active = true
        root.Anchored = true
        targetX = root.Position.X + DIST_X
    end

    if active then
        for _,v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end

        local p = root.Position
        local nextX = math.min(p.X + SPEED, targetX)
        root.CFrame = CFrame.new(nextX, p.Y, p.Z)
    end
end)
