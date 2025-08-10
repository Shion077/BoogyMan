local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AutoClickerGUI"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 160) -- Increased height for toggle button
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
title.Text = "💀 BoogyMan"
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
closeBtn.Size = UDim2.new(0, 15, 0, 15)
closeBtn.Position = UDim2.new(1, -20, 0.55, -10)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- Minimize
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Text = "-"
minimizeBtn.Size = UDim2.new(0, 15, 0, 15)
minimizeBtn.Position = UDim2.new(1, -40, 0.5, -10)
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
local isMinimized = false
local originalSize = frame.Size

-- Utility: Round function for 1 decimal place
local function round(num, decimals)
	return tonumber(string.format("%." .. (decimals or 1) .. "f", num))
end

local function formatInterval(value)
	return string.format("%.1f", value)
end

-- GUI Setup
local statusLabel = Instance.new("TextLabel", content)
statusLabel.Size = UDim2.new(0, 52, 0, 15)
statusLabel.Position = UDim2.new(0, 5, 0, 5)
statusLabel.Text = "STATUS :"
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local statusValue = Instance.new("TextLabel", content)
statusValue.Size = UDim2.new(0, 53, 0, 15)
statusValue.Position = UDim2.new(0, 57, 0, 5)
statusValue.Text = "Inactive"
statusValue.TextSize = 10
statusValue.Font = Enum.Font.SourceSansBold
statusValue.TextColor3 = Color3.new(1, 1, 1)
statusValue.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local statusCircle = Instance.new("Frame", content)
statusCircle.Size = UDim2.new(0, 30, 0, 30)
statusCircle.Position = UDim2.new(0, 115, 0, 5)
statusCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", statusCircle).CornerRadius = UDim.new(1, 0)

local plusButton = Instance.new("TextButton", content)
plusButton.Size = UDim2.new(0, 20, 0, 15)
plusButton.Position = UDim2.new(0, 5, 0, 25)
plusButton.Text = "+"
plusButton.TextSize = 10
plusButton.Font = Enum.Font.SourceSansBold
plusButton.TextColor3 = Color3.new(1, 1, 1)
plusButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local intervalLabel = Instance.new("TextLabel", content)
intervalLabel.Size = UDim2.new(0, 56, 0, 15)
intervalLabel.Position = UDim2.new(0, 30, 0, 25)
intervalLabel.Text = "Interval : " .. formatInterval(Interval)
intervalLabel.TextSize = 10
intervalLabel.Font = Enum.Font.SourceSansBold
intervalLabel.TextColor3 = Color3.new(1, 1, 1)
intervalLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local minusButton = Instance.new("TextButton", content)
minusButton.Size = UDim2.new(0, 20, 0, 15)
minusButton.Position = UDim2.new(0, 90, 0, 25)
minusButton.Text = "-"
minusButton.TextSize = 10
minusButton.Font = Enum.Font.SourceSansBold
minusButton.TextColor3 = Color3.new(1, 1, 1)
minusButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local selectPositionButton = Instance.new("TextButton", content)
selectPositionButton.Size = UDim2.new(0, 68, 0, 15)
selectPositionButton.Position = UDim2.new(0, 5, 0, 45)
selectPositionButton.Text = "Select Position"
selectPositionButton.TextSize = 10
selectPositionButton.Font = Enum.Font.SourceSansBold
selectPositionButton.TextColor3 = Color3.new(1, 1, 1)
selectPositionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local resetPositionButton = Instance.new("TextButton", content)
resetPositionButton.Size = UDim2.new(0, 68, 0, 15)
resetPositionButton.Position = UDim2.new(0, 77, 0, 45)
resetPositionButton.Text = "Reset Position"
resetPositionButton.TextSize = 10
resetPositionButton.Font = Enum.Font.SourceSansBold
resetPositionButton.TextColor3 = Color3.new(1, 1, 1)
resetPositionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local positionLabel = Instance.new("TextLabel", content)
positionLabel.Size = UDim2.new(1, -10, 0, 25)
positionLabel.Position = UDim2.new(0, 5, 0, 65)
positionLabel.Text = "X : 0.0, Y : 0.0"
positionLabel.TextSize = 10
positionLabel.Font = Enum.Font.SourceSansBold
positionLabel.TextColor3 = Color3.new(1, 1, 1)
positionLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- New Toggle Button below positionLabel
local toggleButton = Instance.new("TextButton", content)
toggleButton.Size = UDim2.new(0, 140, 0, 25)
toggleButton.Position = UDim2.new(0, 5, 0, 95)
toggleButton.Text = "Toggle Clicking"
toggleButton.TextSize = 12
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 6)

-- Logic
local function toggleClicking()
	IsClicking = not IsClicking
	statusValue.Text = IsClicking and "Active" or "Inactive"
	statusCircle.BackgroundColor3 = IsClicking and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	
	-- Update toggle button text accordingly
	toggleButton.Text = IsClicking and "Stop Clicking" or "Start Clicking"

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

-- Optional debounce to prevent rapid toggling
local toggleDebounce = false
statusCircle.TouchTap:Connect(function()
	if toggleDebounce then return end
	toggleDebounce = true
	toggleClicking()
	task.delay(0.3, function()
		toggleDebounce = false
	end)
end)

toggleButton.TouchTap:Connect(function()
	if toggleDebounce then return end
	toggleDebounce = true
	toggleClicking()
	task.delay(0.3, function()
		toggleDebounce = false
	end)
end)

-- Increase interval logic
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

-- Decrease interval logic
local function decreaseInterval()
	Interval = round(Interval, 1)

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
plusButton.TouchTap:Connect(function()
	increaseInterval()
	intervalLabel.Text = "Interval : " .. formatInterval(Interval)
end)

minusButton.TouchTap:Connect(function()
	decreaseInterval()
	intervalLabel.Text = "Interval : " .. formatInterval(Interval)
end)

selectPositionButton.TouchTap:Connect(function()
	selectPositionButton.Text = "Click anywhere..."
	local conn
	conn = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			ClickPosition = input.Position
			positionLabel.Text = "X : " .. round(ClickPosition.X, 1) .. ", Y : " .. round(ClickPosition.Y, 1)
			selectPositionButton.Text = "Select Position"
			conn:Disconnect()
		end
	end)
end)

resetPositionButton.TouchTap:Connect(function()
	ClickPosition = nil
	positionLabel.Text = "X : 0.0, Y : 0.0"
end)

minimizeBtn.TouchTap:Connect(function()
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

closeBtn.TouchTap:Connect(function()
	gui:Destroy()
end)
