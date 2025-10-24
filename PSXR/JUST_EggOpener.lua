--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Library = require(ReplicatedStorage:WaitForChild("Library"))

--// Remote
-- ======================================================
-- 🎯 Remote Grabber
-- ======================================================
local function getRemote(int)
    local count = 0
    for _, obj in ipairs(ReplicatedStorage:GetChildren()) do
        if obj:IsA("RemoteFunction") then
            count += 1
            if count == int then -- change index here if needed
                return obj
            end
        end
    end
    return nil
end

local openEgg = getRemote(30)

--// Auto Open Egg Function
local function AutoOpenEgg(name, amount)
    name = name:lower()
    local save = Library.Save.Get()
    if not save or not save.Pets then return warn("❌ No pets found!") end

    local uids = {}
    for _, pet in ipairs(save.Pets) do
        local petData = Library.Directory.Pets[pet.id]
        local pname = petData and petData.name:lower() or pet.id:lower()
        if pname == name then
            table.insert(uids, pet.uid)
        end
    end

    if #uids == 0 then
        return warn("❌ You don’t own any egg named:", name)
    end

    -- choose only `amount` worth of uids
    local selected = {}
    for i = 1, math.min(amount, #uids) do
        table.insert(selected, uids[i])
    end

    local result = openEgg:InvokeServer(selected[1],#selected) 
    print("✅ Egg Open Result:", result)
end

--// === GUI Setup ===
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup (already premade)
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "EGG OPENER"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 130)
frame.Position = UDim2.new(0.5, -160, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 20)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
header.BorderSizePixel = 0
header.Parent = frame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Title Label
local title = Instance.new("TextLabel")
title.Text = "💀Egg Opener"
title.Font = Enum.Font.GothamBold
title.TextSize = 10
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Parent = header

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Size = UDim2.new(0, 15, 0, 15)
closeBtn.Position = UDim2.new(0, 100, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Size = UDim2.new(0, 15, 0, 15)
minimizeBtn.Position = UDim2.new(0, 82, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Parent = header

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(1, 0)
minimizeCorner.Parent = minimizeBtn

-- Content Frame
local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0, 0, 0, 30)
content.Size = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = 1
content.Parent = frame

--// === Egg Opener UI inside your premade content ===

-- Egg Name TextBox
local eggNameBox = Instance.new("TextBox", content)
eggNameBox.Size = UDim2.new(0, 100, 0, 20)
eggNameBox.Position = UDim2.new(0, 10, 0, -5)
eggNameBox.PlaceholderText = "Enter Egg Name"
eggNameBox.Text = "Exclusive Axolotl Egg"
eggNameBox.TextColor3 = Color3.new(1,1,1)
eggNameBox.BackgroundColor3 = Color3.fromRGB(50,50,50)

local eggCorner = Instance.new("UICorner")
eggCorner.CornerRadius = UDim.new(0,6)
eggCorner.Parent = eggNameBox

-- Amount TextBox
local amountBox = Instance.new("TextBox", content)
amountBox.Size = UDim2.new(0, 100, 0, 20)
amountBox.Position = UDim2.new(0, 10, 0, 20)
amountBox.PlaceholderText = "Enter Amount"
amountBox.Text = "8"
amountBox.TextColor3 = Color3.new(1,1,1)
amountBox.BackgroundColor3 = Color3.fromRGB(50,50,50)

local amountCorner = Instance.new("UICorner")
amountCorner.CornerRadius = UDim.new(0,6)
amountCorner.Parent = amountBox

-- Status Label
local statusLabel = Instance.new("TextLabel", content)
statusLabel.Size = UDim2.new(0, 100, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 45)
statusLabel.Text = "STATUS : OFF"
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Switch Button (replaces Open Egg Button)
local SwitchBtn = Instance.new("TextButton", content)
SwitchBtn.Size = UDim2.new(0, 100, 0, 20)
SwitchBtn.Position = UDim2.new(0, 10, 0, 70)
SwitchBtn.Font = Enum.Font.GothamBold
SwitchBtn.TextSize = 14
SwitchBtn.TextColor3 = Color3.fromRGB(255,255,255)

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0,6)
buttonCorner.Parent = SwitchBtn

-- Auto toggle logic
local autoRunning = false

local function updateButtonUI()
    if autoRunning then
        SwitchBtn.Text = "Stop"
        statusLabel.Text = "STATUS : ON"
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    else
        SwitchBtn.Text = "Start"
        statusLabel.Text = "STATUS : OFF"
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
    end
end
updateButtonUI()

-- Switch functionality
SwitchBtn.MouseButton1Click:Connect(function()
    autoRunning = not autoRunning
    updateButtonUI()
    if autoRunning then
        task.spawn(function()
            while autoRunning do
                local eggName = eggNameBox.Text
                local amount = tonumber(amountBox.Text)
                if eggName ~= "" and amount and amount > 0 then
                    AutoOpenEgg(eggName, amount)
                end
                task.wait(0.1) -- adjust delay between openings
            end
        end)
    end
end)


-- Minimize Function
local isMinimized = false
local originalSize = frame.Size

minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		content.Visible = false
		frame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, header.Size.Y.Offset)
		minimizeBtn.Text = "+"
	else
		content.Visible = true
		frame.Size = originalSize
		minimizeBtn.Text = "-"
	end
end)

-- Close Function
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "EGG OPENER"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 130)
frame.Position = UDim2.new(0.5, -160, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 20)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
header.BorderSizePixel = 0
header.Parent = frame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Title Label
local title = Instance.new("TextLabel")
title.Text = "💀Egg Opener"
title.Font = Enum.Font.GothamBold
title.TextSize = 10
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Parent = header

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Size = UDim2.new(0, 15, 0, 15)
closeBtn.Position = UDim2.new(0, 100, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Size = UDim2.new(0, 15, 0, 15)
minimizeBtn.Position = UDim2.new(0, 82, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Parent = header

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(1, 0)
minimizeCorner.Parent = minimizeBtn

-- Content Frame
local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0, 0, 0, 30)
content.Size = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = 1
content.Parent = frame

--// === Egg Opener UI inside your premade content ===

-- Egg Name TextBox
local eggNameBox = Instance.new("TextBox", content)
eggNameBox.Size = UDim2.new(0, 100, 0, 20)
eggNameBox.Position = UDim2.new(0, 10, 0, -5)
eggNameBox.PlaceholderText = "Enter Egg Name"
eggNameBox.Text = "Exclusive Axolotl Egg"
eggNameBox.TextColor3 = Color3.new(1,1,1)
eggNameBox.BackgroundColor3 = Color3.fromRGB(50,50,50)

local eggCorner = Instance.new("UICorner")
eggCorner.CornerRadius = UDim.new(0,6)
eggCorner.Parent = eggNameBox

-- Amount TextBox
local amountBox = Instance.new("TextBox", content)
amountBox.Size = UDim2.new(0, 100, 0, 20)
amountBox.Position = UDim2.new(0, 10, 0, 20)
amountBox.PlaceholderText = "Enter Amount"
amountBox.Text = "8"
amountBox.TextColor3 = Color3.new(1,1,1)
amountBox.BackgroundColor3 = Color3.fromRGB(50,50,50)

local amountCorner = Instance.new("UICorner")
amountCorner.CornerRadius = UDim.new(0,6)
amountCorner.Parent = amountBox

-- Status Label
local statusLabel = Instance.new("TextLabel", content)
statusLabel.Size = UDim2.new(0, 100, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 45)
statusLabel.Text = "STATUS : OFF"
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Switch Button (replaces Open Egg Button)
local SwitchBtn = Instance.new("TextButton", content)
SwitchBtn.Size = UDim2.new(0, 100, 0, 20)
SwitchBtn.Position = UDim2.new(0, 10, 0, 70)
SwitchBtn.Font = Enum.Font.GothamBold
SwitchBtn.TextSize = 14
SwitchBtn.TextColor3 = Color3.fromRGB(255,255,255)

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0,6)
buttonCorner.Parent = SwitchBtn

-- Auto toggle logic
local autoRunning = false

local function updateButtonUI()
    if autoRunning then
        SwitchBtn.Text = "Stop"
        statusLabel.Text = "STATUS : ON"
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    else
        SwitchBtn.Text = "Start"
        statusLabel.Text = "STATUS : OFF"
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
    end
end
updateButtonUI()

-- Switch functionality
SwitchBtn.MouseButton1Click:Connect(function()
    autoRunning = not autoRunning
    updateButtonUI()
    if autoRunning then
        task.spawn(function()
            while autoRunning do
                local eggName = eggNameBox.Text
                local amount = tonumber(amountBox.Text)
                if eggName ~= "" and amount and amount > 0 then
                    AutoOpenEgg(eggName, amount)
                end
                task.wait(0.1) -- adjust delay between openings
            end
        end)
    end
end)


-- Minimize Function
local isMinimized = false
local originalSize = frame.Size

minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		content.Visible = false
		frame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, header.Size.Y.Offset)
		minimizeBtn.Text = "+"
	else
		content.Visible = true
		frame.Size = originalSize
		minimizeBtn.Text = "-"
	end
end)

-- Close Function
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

