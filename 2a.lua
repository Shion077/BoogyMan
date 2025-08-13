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
local OctupleHatch = false

-- States
local AutoHatch = false
local AnimationOn = false
local antiAfkEnabled = false
local failCount = 0
local maxFails = 5

-- Animation
local OriginalOpenEggFunc = nil

-- Anti AFK
local antiAfkConnection

-- =========================
-- 🖼 GUI SETUP
-- =========================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AutoClickerGUI"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 270)
frame.Position = UDim2.new(0.5, -160, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Header
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Text = "💀 BoogyMan Hatcher"
title.Font = Enum.Font.GothamBold
title.TextSize = 13
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
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -30, 0.5, -10)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
minimizeBtn.Position = UDim2.new(1, -60, 0.5, -10)
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
HatchTitle.Size = UDim2.new(0, 180, 0, 25)
HatchTitle.Position = UDim2.new(0, 10, 0, 10)
HatchTitle.BackgroundTransparency = 1
HatchTitle.Text = "Auto Hatch"
HatchTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HatchTitle.TextSize = 14
HatchTitle.Font = Enum.Font.GothamBold

local HatchstatusLabel = Instance.new("TextLabel", content)
HatchstatusLabel.Size = UDim2.new(0, 85, 0, 25)
HatchstatusLabel.Position = UDim2.new(0, 10, 0, 45)
HatchstatusLabel.Text = "📟 STATUS :"
HatchstatusLabel.TextSize = 15
HatchstatusLabel.Font = Enum.Font.SourceSansBold
HatchstatusLabel.TextColor3 = Color3.new(1, 1, 1)
HatchstatusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local HatchstatusValue = Instance.new("TextLabel", content)
HatchstatusValue.Size = UDim2.new(0, 85, 0, 25)
HatchstatusValue.Position = UDim2.new(0, 105, 0, 45)
HatchstatusValue.Text = "Inactive"
HatchstatusValue.TextSize = 15
HatchstatusValue.Font = Enum.Font.SourceSansBold
HatchstatusValue.TextColor3 = Color3.fromRGB(255, 50, 50)
HatchstatusValue.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local HatchBtn = Instance.new("TextButton", content)
HatchBtn.Size = UDim2.new(0, 180, 0, 25)
HatchBtn.Position = UDim2.new(0, 10, 0, 80)
HatchBtn.Text = "Turn On"
HatchBtn.Font = Enum.Font.SourceSansBold
HatchBtn.TextSize = 15
HatchBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
HatchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- =========================
-- 2️⃣ REMOVE ANIMATION UI
-- =========================
local animationTitle = Instance.new("TextLabel", content)
animationTitle.Size = UDim2.new(0, 180, 0, 25)
animationTitle.Position = UDim2.new(0, 5, 0, 110)
animationTitle.BackgroundTransparency = 1
animationTitle.Text = "Remove Animation"
animationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
animationTitle.TextSize = 14
animationTitle.Font = Enum.Font.GothamBold

local animationButton = Instance.new("TextButton", content)
animationButton.Size = UDim2.new(0, 180, 0, 25)
animationButton.Position = UDim2.new(0, 10, 0, 140)
animationButton.Text = "Turn On"
animationButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
animationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
animationButton.Font = Enum.Font.SourceSansBold
animationButton.TextSize = 15

-- =========================
-- 3️⃣ ANTI-AFK UI
-- =========================
local AntiAfkTitle = Instance.new("TextLabel", content)
AntiAfkTitle.Size = UDim2.new(0, 180, 0, 25)
AntiAfkTitle.Position = UDim2.new(0, 5, 0, 170)
AntiAfkTitle.BackgroundTransparency = 1
AntiAfkTitle.Text = "Anti-AFK"
AntiAfkTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAfkTitle.TextSize = 14
AntiAfkTitle.Font = Enum.Font.GothamBold

local AntiAfkButton = Instance.new("TextButton", content)
AntiAfkButton.Size = UDim2.new(0, 180, 0, 25)
AntiAfkButton.Position = UDim2.new(0, 10, 0, 200)
AntiAfkButton.Text = "Turn On"
AntiAfkButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
AntiAfkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAfkButton.Font = Enum.Font.SourceSansBold
AntiAfkButton.TextSize = 15

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

-- === Your existing GUI elements ===
-- AntiAfk Title
local AntiAfkTitle = Instance.new("TextLabel", content)
AntiAfkTitle.Size = UDim2.new(0, 180, 0, 25)
AntiAfkTitle.Position = UDim2.new(0, 5, 0, 110)
AntiAfkTitle.BackgroundTransparency = 1
AntiAfkTitle.Text = "Anti-AFK (Jump)"
AntiAfkTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAfkTitle.TextSize = 14
AntiAfkTitle.Font = Enum.Font.GothamBold

-- AntiAfk Toggle Button
local AntiAfkButton = Instance.new("TextButton", content)
AntiAfkButton.Size = UDim2.new(0, 180, 0, 25)
AntiAfkButton.Position = UDim2.new(0, 10, 0, 140)
AntiAfkButton.Text = "Turn On"
AntiAfkButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
AntiAfkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAfkButton.Font = Enum.Font.SourceSansBold
AntiAfkButton.TextSize = 15

-- === Jump-based Anti-AFK ===
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local antiAfkEnabled = false
local idleConn -- fires when Roblox thinks you're idle
local loopToken = 0 -- cancels the running loop when toggled off

local function getHumanoid()
    local character = player.Character or player.CharacterAdded:Wait()
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then hum = character:WaitForChild("Humanoid") end
    return hum
end

local function doJump()
    local hum = getHumanoid()
    if hum and not hum.Sit and hum.FloorMaterial ~= Enum.Material.Air then
        hum.Jump = true
    end
end

local function startAntiAfk()
    -- periodic jump every 4–5 minutes so it never reaches AFK
    loopToken += 1
    local myToken = loopToken
    task.spawn(function()
        while antiAfkEnabled and myToken == loopToken do
            doJump()
            task.wait(math.random(240, 300)) -- 240–300s
        end
    end)

    -- also jump immediately if Roblox flags idle sooner
    idleConn = player.Idled:Connect(function()
        doJump()
    end)
end

local function stopAntiAfk()
    loopToken += 1 -- cancels the running loop
    if idleConn then idleConn:Disconnect(); idleConn = nil end
end

AntiAfkButton.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    if antiAfkEnabled then
        startAntiAfk()
        AntiAfkButton.Text = "Turn Off"
        AntiAfkButton.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
    else
        stopAntiAfk()
        AntiAfkButton.Text = "Turn On"
        AntiAfkButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
    end
end)
