-- =========================
-- 📦 Wait until game and player are ready
-- =========================
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

-- =========================
-- 📦 VARIABLES & SERVICES
-- =========================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- Modules
local Library = require(ReplicatedStorage:WaitForChild("Library"))
local Save = require(ReplicatedStorage:WaitForChild("Library"):WaitForChild("Client"):WaitForChild("Save"))

-- =========================
-- ⚙️ CONFIG
-- =========================
local Eggname = "Pog Egg"
local NoOfEgg = 21

-- States
local AutoHatch = false
local antiAfkEnabled = false
local failCount = 0
local maxFails = 5

-- Anti AFK Timer
local seconds, minutes, hours = 0, 0, 0
local timerRunning = false

-- =========================
-- 🎬 REMOVE ANIMATION (destroy script immediately)
-- =========================
task.spawn(function()
    local openEggsScript = LocalPlayer:WaitForChild("PlayerScripts")
        :WaitForChild("Scripts")
        :WaitForChild("Game")
        :WaitForChild("Open Eggs")

    if openEggsScript then
        openEggsScript:Destroy()
        warn("✅ Egg opening animation script destroyed.")
    else
        warn("⚠️ Could not find Open Eggs script.")
    end
end)

-- =========================
-- 🖼 GUI SETUP
-- =========================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "PSXO Hatch"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 105)
frame.Position = UDim2.new(0.5, -160, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Header
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 20)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Text = "💀PSXO Hatch"
title.Font = Enum.Font.GothamBold
title.TextSize = 10
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1

-- Close Button
local closeBtn = Instance.new("TextButton", header)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Size = UDim2.new(0, 15, 0, 15)
closeBtn.Position = UDim2.new(0, 100, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Size = UDim2.new(0, 15, 0, 15)
minimizeBtn.Position = UDim2.new(0, 82, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)

-- Content Frame
local content = Instance.new("Frame", frame)
content.Position = UDim2.new(0, 0, 0, 30)
content.Size = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = 1

-- =========================
-- UI Elements
-- =========================
local HatchstatusLabel = Instance.new("TextLabel", content)
HatchstatusLabel.Size = UDim2.new(0, 52.5, 0, 20)
HatchstatusLabel.Position = UDim2.new(0, 5, 0, -5)
HatchstatusLabel.Text = "STATUS :"
HatchstatusLabel.TextSize = 12
HatchstatusLabel.Font = Enum.Font.SourceSansBold
HatchstatusLabel.TextColor3 = Color3.new(1, 1, 1)
HatchstatusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local HatchstatusValue = Instance.new("TextLabel", content)
HatchstatusValue.Size = UDim2.new(0, 52.5, 0, 20)
HatchstatusValue.Position = UDim2.new(0, 62, 0, -5)
HatchstatusValue.Text = "Inactive"
HatchstatusValue.TextSize = 12
HatchstatusValue.Font = Enum.Font.SourceSansBold
HatchstatusValue.TextColor3 = Color3.fromRGB(255, 50, 50)
HatchstatusValue.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local AntiAfkButton = Instance.new("TextLabel", content)
AntiAfkButton.Size = UDim2.new(0, 52.5, 0, 20)
AntiAfkButton.Position = UDim2.new(0, 5, 0, 20)
AntiAfkButton.Text = "AFK:Time"
AntiAfkButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AntiAfkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAfkButton.Font = Enum.Font.SourceSansBold
AntiAfkButton.TextSize = 12

local AfkTimeLabel = Instance.new("TextLabel", content)
AfkTimeLabel.Size = UDim2.new(0, 52.5, 0, 20)
AfkTimeLabel.Position = UDim2.new(0, 62, 0, 20)
AfkTimeLabel.Text = "0:0:0"
AfkTimeLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AfkTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AfkTimeLabel.Font = Enum.Font.SourceSansBold
AfkTimeLabel.TextSize = 12

local SwitchBtn = Instance.new("TextButton", content)
SwitchBtn.Size = UDim2.new(0, 110, 0, 20)
SwitchBtn.Position = UDim2.new(0, 5, 0, 45)
SwitchBtn.Text = "Turn On"
SwitchBtn.Font = Enum.Font.SourceSansBold
SwitchBtn.TextSize = 12
SwitchBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
SwitchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- =========================
-- 🎯 AUTO HATCH LOGIC
-- =========================

local function HatchEgg()
    local OpenEgg = ReplicatedStorage:GetChildren()[20]

    if not OpenEgg then
        warn("❌ HatchEgg failed: RemoteFunction[14] not found.")
        return
    end

    local success, result = pcall(function()
        return OpenEgg:InvokeServer(Eggname, NoOfEgg)
    end)

    if not success then
        warn("Failed to hatch egg:", result)
        failCount += 1
        if failCount >= maxFails then
            warn("Too many failures, stopping AutoHatch.")
            AutoHatch = false
            setStatus(false)
        end
    else
        failCount = 0
    end
end

-- =========================
-- 🔘 STATUS & MASTER SWITCH
-- =========================
local function setStatus(active)
    if active then
        HatchstatusValue.Text = "Active"
        HatchstatusValue.TextColor3 = Color3.fromRGB(50, 255, 50)
        SwitchBtn.Text = "Turn Off"
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    else
        HatchstatusValue.Text = "Inactive"
        HatchstatusValue.TextColor3 = Color3.fromRGB(255, 50, 50)
        SwitchBtn.Text = "Turn On"
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
    end
end

local function toggleAll(state)
    AutoHatch = state
    antiAfkEnabled = state
    timerRunning = state

    if not state then
        seconds, minutes, hours = 0, 0, 0
        AfkTimeLabel.Text = "0:0:0"
    end

    setStatus(state)
end

SwitchBtn.MouseButton1Click:Connect(function()
    toggleAll(not AutoHatch)
end)

-- =========================
-- ⏳ AUTO HATCH LOOP
-- =========================
task.spawn(function()
    while true do
        if AutoHatch then
            HatchEgg()
        end
        task.wait(0.1)
    end
end)

-- =========================
-- 💤 ANTI-AFK LOGIC
-- =========================
LocalPlayer.Idled:Connect(function()
    if antiAfkEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Timer
task.spawn(function()
    while true do
        task.wait(1)
        if timerRunning then
            seconds += 1
            if seconds >= 60 then
                seconds = 0
                minutes += 1
            end
            if minutes >= 60 then
                minutes = 0
                hours += 1
            end
            AfkTimeLabel.Text = string.format("%d:%d:%d", hours, minutes, seconds)
        end
    end
end)

-- =========================
-- 🔲 FRAME CONTROL
-- =========================
local isMinimized = false
local originalSize = frame.Size
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    content.Visible = not isMinimized
    frame.Size = isMinimized and UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, header.Size.Y.Offset) or originalSize
    minimizeBtn.Text = isMinimized and "+" or "-"
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
