local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AutoClickerGUI"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 215)
frame.Position = UDim2.new(0.5, -160, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
header.BorderSizePixel = 0
header.Parent = frame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Text = "💀 BoogyMan AutoClicker"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)

-- Close
local closeBtn = Instance.new("TextButton", header)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -30, 0.5, -10)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- Minimize
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Text = "-"
minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
minimizeBtn.Position = UDim2.new(1, -60, 0.5, -10)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)

-- Content
local content = Instance.new("Frame", frame)
content.Name = "Content"
content.Position = UDim2.new(0, 0, 0, 30)
content.Size = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = 1

-- Variables
local IsClicking = false
local Interval = 0.2
local ClickPosition = nil
local ToggleKey = Enum.KeyCode.F
local HotkeyChanging = false
local isMinimized = false
local originalSize = frame.Size

-- Utility
local function formatInterval(value)
	return string.format("%.1f", value)
end

-- GUI Setup
local statusLabel = Instance.new("TextLabel", content)
statusLabel.Size = UDim2.new(0, 85, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 10)
statusLabel.Text = "📟 STATUS :"
statusLabel.TextSize = 15
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local statusValue = Instance.new("TextLabel", content)
statusValue.Size = UDim2.new(0, 80, 0, 25)
statusValue.Position = UDim2.new(0, 100, 0, 10)
statusValue.Text = "Inactive"
statusValue.TextSize = 15
statusValue.Font = Enum.Font.SourceSansBold
statusValue.TextColor3 = Color3.new(1, 1, 1)
statusValue.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local statusCircle = Instance.new("Frame", content)
statusCircle.Size = UDim2.new(0, 60, 0, 60)
statusCircle.Position = UDim2.new(0, 200, 0, 10)
statusCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", statusCircle).CornerRadius = UDim.new(1, 0)

local toggleLabel = Instance.new("TextLabel", content)
toggleLabel.Size = UDim2.new(0, 85, 0, 25)
toggleLabel.Position = UDim2.new(0, 10, 0, 45)
toggleLabel.Text = "🎮 TOGGLE :"
toggleLabel.TextSize = 15
toggleLabel.Font = Enum.Font.SourceSansBold
toggleLabel.TextColor3 = Color3.new(1, 1, 1)
toggleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local toggleValue = Instance.new("TextButton", content)
toggleValue.Size = UDim2.new(0, 80, 0, 25)
toggleValue.Position = UDim2.new(0, 100, 0, 45)
toggleValue.Text = ToggleKey.Name
toggleValue.TextSize = 15
toggleValue.Font = Enum.Font.SourceSansBold
toggleValue.TextColor3 = Color3.new(1, 1, 1)
toggleValue.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local plusButton = Instance.new("TextButton", content)
plusButton.Size = UDim2.new(0, 58, 0, 25)
plusButton.Position = UDim2.new(0, 10, 0, 80)
plusButton.Text = "+"
plusButton.TextSize = 25
plusButton.Font = Enum.Font.SourceSansBold
plusButton.TextColor3 = Color3.new(1, 1, 1)
plusButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local intervalLabel = Instance.new("TextLabel", content)
intervalLabel.Size = UDim2.new(0, 121, 0, 25)
intervalLabel.Position = UDim2.new(0, 80, 0, 80)
intervalLabel.Text = "⏱ Interval : " .. formatInterval(Interval)
intervalLabel.TextSize = 15
intervalLabel.Font = Enum.Font.SourceSansBold
intervalLabel.TextColor3 = Color3.new(1, 1, 1)
intervalLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local minusButton = Instance.new("TextButton", content)
minusButton.Size = UDim2.new(0, 58, 0, 25)
minusButton.Position = UDim2.new(0, 211, 0, 80)
minusButton.Text = "-"
minusButton.TextSize = 25
minusButton.Font = Enum.Font.SourceSansBold
minusButton.TextColor3 = Color3.new(1, 1, 1)
minusButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local selectPositionButton = Instance.new("TextButton", content)
selectPositionButton.Size = UDim2.new(0, 125, 0, 25)
selectPositionButton.Position = UDim2.new(0, 10, 0, 115)
selectPositionButton.Text = "🎯 Select Position"
selectPositionButton.TextSize = 15
selectPositionButton.Font = Enum.Font.SourceSansBold
selectPositionButton.TextColor3 = Color3.new(1, 1, 1)
selectPositionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local resetPositionButton = Instance.new("TextButton", content)
resetPositionButton.Size = UDim2.new(0, 125, 0, 25)
resetPositionButton.Position = UDim2.new(0, 145, 0, 115)
resetPositionButton.Text = "♻️ Reset Position"
resetPositionButton.TextSize = 15
resetPositionButton.Font = Enum.Font.SourceSansBold
resetPositionButton.TextColor3 = Color3.new(1, 1, 1)
resetPositionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local positionLabel = Instance.new("TextLabel", content)
positionLabel.Size = UDim2.new(1, -20, 0, 25)
positionLabel.Position = UDim2.new(0, 10, 0, 150)
positionLabel.Text = "🧭 X : 0, Y : 0"
positionLabel.TextSize = 15
positionLabel.Font = Enum.Font.SourceSansBold
positionLabel.TextColor3 = Color3.new(1, 1, 1)
positionLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Logic
local function toggleClicking()
	IsClicking = not IsClicking
	statusValue.Text = IsClicking and "Active" or "Inactive"
	statusCircle.BackgroundColor3 = IsClicking and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

	if IsClicking then
		task.wait(1)
		spawn(function()
			while IsClicking do
				local pos = ClickPosition or UserInputService:GetMouseLocation()
				VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
				VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
				task.wait(Interval)
			end
		end)
	end
end

statusCircle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		toggleClicking()
	end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == ToggleKey then
		toggleClicking()
	end
end)

toggleValue.MouseButton1Click:Connect(function()
	if HotkeyChanging then return end
	HotkeyChanging = true
	toggleValue.Text = "..."
	toggleValue.TextColor3 = Color3.fromRGB(200, 200, 0)

	local conn
	conn = UserInputService.InputBegan:Connect(function(input, gpe)
		if not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
			ToggleKey = input.KeyCode
			toggleValue.Text = ToggleKey.Name
			toggleValue.TextColor3 = Color3.new(1, 1, 1)
			HotkeyChanging = false
			conn:Disconnect()
		end
	end)
end)

local function round(num, decimals)
	return tonumber(string.format("%." .. (decimals or 1) .. "f", num))
end

-- Interval formatter (decimal only for < 1)
local function formatInterval(value)
	if value < 1 then
		return string.format("%.1f", value)
	else
		return tostring(math.floor(value))
	end
end

-- Increase logic
local function increaseInterval()
	if Interval >= 0.1 and Interval < 0.9 then
		Interval = round(Interval + 0.1, 1)
	elseif Interval >= 0.9 and Interval < 1 then
		Interval = 1.1
	elseif Interval >= 1.1 and Interval < 10 then
		Interval = Interval + 1
	elseif Interval >= 10.1 and Interval < 30 then
		Interval = Interval + 5
	elseif Interval >= 30.1 and Interval < 50.1 then
		Interval = Interval + 10
	elseif Interval == 50.1 then
		Interval = 60
	end
end

-- Decrease logic
function decreaseInterval()
	Interval = round(Interval, 1) -- round before comparing

	if Interval == 60 then
		Interval = 50.1
	elseif Interval <= 60 and Interval > 40 then
		Interval = Interval - 10
	elseif Interval <= 40 and Interval > 30.1 then
		Interval = Interval - 9.9
	elseif Interval <= 30.1 and Interval >= 15.1 then
		Interval = Interval - 5
	elseif Interval < 15.1 and Interval >= 2.1 then
		Interval = Interval - 1
	elseif Interval == 1.1 then
		Interval = 0.9
	elseif Interval < 1 and Interval > 0.1 then
		Interval = round(Interval - 0.1, 1)
	end
end

-- Button bindings
plusButton.MouseButton1Click:Connect(function()
	increaseInterval()
	intervalLabel.Text = "⏱ Interval : " .. formatInterval(Interval)
end)

minusButton.MouseButton1Click:Connect(function()
	decreaseInterval()
	intervalLabel.Text = "⏱ Interval : " .. formatInterval(Interval)
end)

selectPositionButton.MouseButton1Click:Connect(function()
	selectPositionButton.Text = "Click anywhere..."
	local conn
	conn = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			ClickPosition = input.Position
			positionLabel.Text = "🧭 X : " .. ClickPosition.X .. ", Y : " .. ClickPosition.Y
			selectPositionButton.Text = "🎯 Select Position"
			conn:Disconnect()
		end
	end)
end)

resetPositionButton.MouseButton1Click:Connect(function()
	ClickPosition = nil
	positionLabel.Text = "🧭 X : 0, Y : 0"
end)

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

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
