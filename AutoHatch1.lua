-- =========================
-- 📦 VARIABLES & SERVICES
-- =========================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Modules
local Library = require(ReplicatedStorage:WaitForChild("Library"))
local Eggs = Library.Directory.Eggs
local Save = require(ReplicatedStorage:WaitForChild("Library"):WaitForChild("Client"):WaitForChild("Save"))

-- Remote
local EggRemote = ReplicatedStorage:WaitForChild("Buy Egg")

-- Config
local AutoHatch = false
local EggToHatch = "Fire Dominus Egg"
local TripleHatch = false
local OctupleHatch = false

-- Animation Toggle
local AnimationOn = false
local OriginalOpenEggFunc = nil

-- Internal
local failCount = 0
local maxFails = 5

-- =========================
-- 🖼️ GUI SETUP & EVENTS
-- =========================

-- GUI Frame Setup
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

-- Title
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

-- Auto Hatch Title
local HatchTitle = Instance.new("TextLabel", content)
HatchTitle.Size = UDim2.new(0, 180, 0, 25)
HatchTitle.Position = UDim2.new(0, 10, 0, 10)
HatchTitle.BackgroundTransparency = 1
HatchTitle.Text = "Auto Hatch"
HatchTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HatchTitle.TextSize = 14
HatchTitle.Font = Enum.Font.GothamBold

-- Status Labels
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

-- Toggle Button
local HatchBtn = Instance.new("TextButton", content)
HatchBtn.Size = UDim2.new(0, 180, 0, 25)
HatchBtn.Position = UDim2.new(0, 10, 0, 80)
HatchBtn.Text = "Turn On"
HatchBtn.Font = Enum.Font.SourceSansBold
HatchBtn.TextSize = 15
HatchBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
HatchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Remove Animation Title
local animationTitle = Instance.new("TextLabel", content)
animationTitle.Size = UDim2.new(0, 180, 0, 25)
animationTitle.Position = UDim2.new(0, 5, 0, 110)
animationTitle.BackgroundTransparency = 1
animationTitle.Text = "Remove Animation"
animationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
animationTitle.TextSize = 14
animationTitle.Font = Enum.Font.GothamBold

-- Animation Toggle Button
local animationButton = Instance.new("TextButton", content)
animationButton.Size = UDim2.new(0, 180, 0, 25)
animationButton.Position = UDim2.new(0, 10, 0, 140)
animationButton.Text = "Turn On"
animationButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
animationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
animationButton.Font = Enum.Font.SourceSansBold
animationButton.TextSize = 15

-- Status Toggle
function setStatus(active)
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
setStatus(false)

-- Close & Minimize
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

-- Toggle Hatch
HatchBtn.MouseButton1Click:Connect(function()
    AutoHatch = not AutoHatch
    setStatus(AutoHatch)
    if AutoHatch then
        TeleportToEggOnce()
    end
end)

-- Toggle Animation
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

-- Auto Hatch Loop
task.spawn(function()
    while true do
        if AutoHatch then
            HatchEgg(EggToHatch, TripleHatch, OctupleHatch)
        end
        task.wait(getRandomDelay())
    end
end)

-- =========================
-- 🔧 FUNCTIONS SECTION
-- =========================

function IsEggUnlocked(eggId)
    local eggData = Eggs[eggId]
    if not eggData then return false end
    local save = Save.Get()
    if eggData.UnlockRequirements then
        for _, req in pairs(eggData.UnlockRequirements) do
            if not save.Areas[req] then return false end
        end
    end
    return true
end

function HatchEgg(eggId, triple, octuple)
    if not IsEggUnlocked(eggId) then
        warn("Egg not unlocked:", eggId)
        return
    end

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

function getRandomDelay()
    return math.random(1000, 1000) / 1000 -- Always returns 1s (can be changed)
end

function TeleportToEggOnce()
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

function getOpenEggsEnv()
    local success, result = pcall(function()
        local openEggsScript = LocalPlayer:WaitForChild("PlayerScripts")
            :WaitForChild("Scripts")
            :WaitForChild("Game")
            :WaitForChild("Open Eggs", 10)
        return getsenv(openEggsScript)
    end)
    return success and result or nil
end

-- AntiAfk Title
local AntiAfkTitle = Instance.new("TextLabel", content)
AntiAfkTitle.Size = UDim2.new(0, 180, 0, 25)
AntiAfkTitle.Position = UDim2.new(0, 5, 0, 170)
AntiAfkTitle.BackgroundTransparency = 1
AntiAfkTitle.Text = "Anti-AFK"
AntiAfkTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAfkTitle.TextSize = 14
AntiAfkTitle.Font = Enum.Font.GothamBold

-- AntiAfk Toggle Button
local AntiAfkButton = Instance.new("TextButton", content)
AntiAfkButton.Size = UDim2.new(0, 180, 0, 25)
AntiAfkButton.Position = UDim2.new(0, 10, 0, 200)
AntiAfkButton.Text = "Turn On"
AntiAfkButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
AntiAfkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAfkButton.Font = Enum.Font.SourceSansBold
AntiAfkButton.TextSize = 15

-- Anti-AFK logic
local vu = game:GetService("VirtualUser")
local player = game:GetService("Players").LocalPlayer
local antiAfkEnabled = false
local antiAfkConnection

local function startAntiAfk()
    antiAfkConnection = player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

local function stopAntiAfk()
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
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
