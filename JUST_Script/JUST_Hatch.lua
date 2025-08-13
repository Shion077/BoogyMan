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
local Eggs = Library.Directory.Eggs
local Save = require(ReplicatedStorage:WaitForChild("Library"):WaitForChild("Client"):WaitForChild("Save"))

-- Remote
local EggRemote = ReplicatedStorage:WaitForChild("Buy Egg")

-- Config
local EggToHatch = "Fire Dominus Egg"
local TripleHatch = false
local OctupleHatch = true

-- States
local AutoHatch = false
local AnimationOn = false
local antiAfkEnabled = false
local failCount = 0
local maxFails = 5

-- Animation
local OriginalOpenEggFunc = nil

-- Anti AFK
local antiAfkEnabled = false
local seconds, minutes, hours = 0, 0, 0
local timerRunning = false

-- =========================
-- 🖼 GUI SETUP
-- =========================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "PSXO Hatch"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 205)
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
-- 1️⃣ AUTO HATCH UI
-- =========================
local HatchTitle = Instance.new("TextLabel", content)
HatchTitle.Size = UDim2.new(0, 110, 0, 20)
HatchTitle.Position = UDim2.new(0, 5, 0, -5)
HatchTitle.BackgroundTransparency = 1
HatchTitle.Text = "Auto Hatch"
HatchTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HatchTitle.TextSize = 12
HatchTitle.Font = Enum.Font.GothamBold

local HatchstatusLabel = Instance.new("TextLabel", content)
HatchstatusLabel.Size = UDim2.new(0, 52.5, 0, 20)
HatchstatusLabel.Position = UDim2.new(0, 5, 0, 20)
HatchstatusLabel.Text = "STATUS :"
HatchstatusLabel.TextSize = 12
HatchstatusLabel.Font = Enum.Font.SourceSansBold
HatchstatusLabel.TextColor3 = Color3.new(1, 1, 1)
HatchstatusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local HatchstatusValue = Instance.new("TextLabel", content)
HatchstatusValue.Size = UDim2.new(0, 52.5, 0, 20)
HatchstatusValue.Position = UDim2.new(0, 62, 0, 20)
HatchstatusValue.Text = "Inactive"
HatchstatusValue.TextSize = 12
HatchstatusValue.Font = Enum.Font.SourceSansBold
HatchstatusValue.TextColor3 = Color3.fromRGB(255, 50, 50)
HatchstatusValue.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local HatchBtn = Instance.new("TextButton", content)
HatchBtn.Size = UDim2.new(0, 110, 0, 20)
HatchBtn.Position = UDim2.new(0, 5, 0, 45)
HatchBtn.Text = "Turn On"
HatchBtn.Font = Enum.Font.SourceSansBold
HatchBtn.TextSize = 12
HatchBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
HatchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- =========================
-- 2️⃣ REMOVE ANIMATION UI
-- =========================
local animationTitle = Instance.new("TextLabel", content)
animationTitle.Size = UDim2.new(0, 110, 0, 20)
animationTitle.Position = UDim2.new(0, 5, 0, 70)
animationTitle.BackgroundTransparency = 1
animationTitle.Text = "Remove Animation"
animationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
animationTitle.TextSize = 12
animationTitle.Font = Enum.Font.GothamBold

local animationButton = Instance.new("TextButton", content)
animationButton.Size = UDim2.new(0, 110, 0, 20)
animationButton.Position = UDim2.new(0, 5, 0, 95)
animationButton.Text = "Turn On"
animationButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
animationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
animationButton.Font = Enum.Font.SourceSansBold
animationButton.TextSize = 12

-- =========================
-- 3️⃣ ANTI-AFK UI
-- =========================
local AntiAfkTitle = Instance.new("TextLabel", content)
AntiAfkTitle.Size = UDim2.new(0, 110, 0, 20)
AntiAfkTitle.Position = UDim2.new(0, 5, 0, 120)
AntiAfkTitle.BackgroundTransparency = 1
AntiAfkTitle.Text = "Anti-AFK"
AntiAfkTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAfkTitle.TextSize = 12
AntiAfkTitle.Font = Enum.Font.GothamBold

local AntiAfkButton = Instance.new("TextButton", content)
AntiAfkButton.Size = UDim2.new(0, 52.5, 0, 20)
AntiAfkButton.Position = UDim2.new(0, 5, 0, 145)
AntiAfkButton.Text = "AFK: On"
AntiAfkButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
AntiAfkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAfkButton.Font = Enum.Font.SourceSansBold
AntiAfkButton.TextSize = 12

local AfkTimeLabel = Instance.new("TextLabel", content)
AfkTimeLabel.Size = UDim2.new(0, 52.5, 0, 20)
AfkTimeLabel.Position = UDim2.new(0, 62, 0, 145)
AfkTimeLabel.Text = "0:0:0"
AfkTimeLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AfkTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AfkTimeLabel.Font = Enum.Font.SourceSansBold
AfkTimeLabel.TextSize = 12

-- =========================
-- 🎯 AUTO HATCH LOGIC
-- =========================
local function setStatus(active)
    if active then
        HatchstatusValue.Text = "Active"
        HatchstatusValue.TextColor3 = Color3.fromRGB(50, 255, 50)
        HatchBtn.Text = "Turn Off"
        HatchBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    else
        HatchstatusValue.Text = "Inactive"
        HatchstatusValue.TextColor3 = Color3.fromRGB(255, 50, 50)
        HatchBtn.Text = "Turn On"
        HatchBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
    end
end

local function TeleportToEggOnce()
    local ok, err = pcall(function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local root = character:WaitForChild("HumanoidRootPart")
        local destination = workspace:WaitForChild("__MAP")
            :WaitForChild("Eggs")
            :WaitForChild(EggToHatch)
            :WaitForChild("PLATFORM")
            :WaitForChild("SectionName")
        root.CFrame = destination.CFrame * CFrame.new(0, 5, 0)
    end)
    if not ok then
        warn("Teleport failed:", err)
    end
end

local function HatchEgg(eggId, triple, octuple)
    local success, result = pcall(function()
        return EggRemote:InvokeServer(eggId, triple or false, octuple or false)
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

HatchBtn.MouseButton1Click:Connect(function()
    AutoHatch = not AutoHatch
    setStatus(AutoHatch)
    if AutoHatch then
        TeleportToEggOnce()

        -- Mobile tap simulation
        local prompt = workspace:WaitForChild("__MAP")
            :WaitForChild("Eggs")
            :WaitForChild(EggToHatch)
            :FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt then
            fireproximityprompt(prompt)
        end
    end
end)

task.spawn(function()
    while true do
        if AutoHatch then
            HatchEgg(EggToHatch, TripleHatch, OctupleHatch)
        end
        task.wait(1)
    end
end)

-- =========================
-- 🎬 REMOVE ANIMATION LOGIC
-- =========================
local function getOpenEggsEnv()
    local success, result = pcall(function()
        local openEggsScript = LocalPlayer:WaitForChild("PlayerScripts")
            :WaitForChild("Scripts")
            :WaitForChild("Game")
            :WaitForChild("Open Eggs", 10)
        return getsenv(openEggsScript)
    end)
    return success and result or nil
end

animationButton.MouseButton1Click:Connect(function()
    local env = getOpenEggsEnv()
    if not env or not env.OpenEgg then
        warn("OpenEggs script not found.")
        return
    end

    if not AnimationOn then
        if not OriginalOpenEggFunc then
            OriginalOpenEggFunc = env.OpenEgg
        end
        env.OpenEgg = function(...) return true end
        animationButton.Text = "Turn Off"
        animationButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        AnimationOn = true
    else
        if OriginalOpenEggFunc then
            env.OpenEgg = OriginalOpenEggFunc
        end
        animationButton.Text = "Turn On"
        animationButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
        AnimationOn = false
    end
end)

-- =========================
-- 💤 ANTI-AFK LOGIC
-- =========================
game.Players.LocalPlayer.Idled:Connect(function()
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

AntiAfkButton.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    if antiAfkEnabled then
        AntiAfkButton.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
		AntiAfkButton.Text = "AFK: On"
        seconds, minutes, hours = 0, 0, 0
        timerRunning = true
    else
        AntiAfkButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
		AntiAfkButton.Text = "AFK: Off"
        seconds, minutes, hours = 0, 0, 0
        AfkTimeLabel.Text = "0:0:0"
        timerRunning = false
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