-- 💥 Auto-kill old GUI/script
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local oldGUI = Player:WaitForChild("PlayerGui"):FindFirstChild("CodeEditorGUI")
if oldGUI then
	oldGUI:Destroy()
end

-- 📦 Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local redeemRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("REDEEM_CODE")

-- 🧠 Code list
local codeList = {
    "UPDATE18",
    "FREEHUGE",
    "TRADEPLAZA",
    "UPDATE16",
    "UPDATE17",
    "BRAINROT",
    "UPDATE15",
    "X3EVENT",
    "FreeRewards101",
    "FreePotions321",
    "IceRewards221"
}

-- 🧱 GUI setup
local gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
gui.Name = "CodeEditorGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 320)
frame.Position = UDim2.new(0.5, -150, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
frame.Parent = gui

-- 🪟 Header (outside frame, stays visible when minimized)
local header = Instance.new("Frame")
header.Size = UDim2.new(0, 300, 0, 30)
header.Position = frame.Position
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)
header.Parent = gui

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎯 Valex Code Editor"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left

-- ❌ Close Button
local close = Instance.new("TextButton", header)
close.Size = UDim2.new(0, 20, 0, 20)
close.Position = UDim2.new(1, -25, 0.5, -10)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)

-- 🔽 Minimize Button
local minimize = Instance.new("TextButton", header)
minimize.Size = UDim2.new(0, 20, 0, 20)
minimize.Position = UDim2.new(1, -50, 0.5, -10)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Instance.new("UICorner", minimize).CornerRadius = UDim.new(1, 0)

-- 📜 Code List
local scrollingFrame = Instance.new("ScrollingFrame", frame)
scrollingFrame.Position = UDim2.new(0, 10, 0, 40)
scrollingFrame.Size = UDim2.new(1, -20, 0, 180)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollingFrame.BorderSizePixel = 0

local UIListLayout = Instance.new("UIListLayout", scrollingFrame)
UIListLayout.Padding = UDim.new(0, 5)

local function refreshCodeList()
	for _, child in ipairs(scrollingFrame:GetChildren()) do
		if child:IsA("TextLabel") then child:Destroy() end
	end
	for _, code in ipairs(codeList) do
		local label = Instance.new("TextLabel", scrollingFrame)
		label.Size = UDim2.new(1, -10, 0, 25)
		label.Text = "• " .. code
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.new(1, 1, 1)
		label.Font = Enum.Font.Gotham
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
	end
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

-- 🖊 Input box
local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(1, -20, 0, 30)
input.Position = UDim2.new(0, 10, 0, 230)
input.PlaceholderText = "Enter new code here..."
input.Font = Enum.Font.Gotham
input.TextSize = 14
input.TextColor3 = Color3.new(1, 1, 1)
input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
input.BorderSizePixel = 0
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)

-- ➕ Add Code Button
local addButton = Instance.new("TextButton", frame)
addButton.Text = "➕ Add Code"
addButton.Size = UDim2.new(0.45, -5, 0, 30)
addButton.Position = UDim2.new(0.05, 0, 1, -40)
addButton.Font = Enum.Font.Gotham
addButton.TextSize = 14
addButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
addButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", addButton).CornerRadius = UDim.new(0, 6)

-- 📥 Redeem Button
local redeemButton = Instance.new("TextButton", frame)
redeemButton.Text = "📥 Redeem All"
redeemButton.Size = UDim2.new(0.45, -5, 0, 30)
redeemButton.Position = UDim2.new(0.5, 5, 1, -40)
redeemButton.Font = Enum.Font.Gotham
redeemButton.TextSize = 14
redeemButton.BackgroundColor3 = Color3.fromRGB(40, 130, 200)
redeemButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", redeemButton).CornerRadius = UDim.new(0, 6)

-- 🔘 Buttons logic
addButton.MouseButton1Click:Connect(function()
	local code = input.Text:upper()
	if code ~= "" then
		table.insert(codeList, code)
		input.Text = ""
		refreshCodeList()
	end
end)

redeemButton.MouseButton1Click:Connect(function()
	for _, code in ipairs(codeList) do
		redeemRemote:FireServer(code)
		print("✅ Redeemed:", code)
		wait(0.8)
	end
end)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- 🔽 Minimize logic
local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	frame.Visible = not minimized
end)

-- 🖱 Drag header + frame together
local dragging = false
local dragInput, startPos, startInputPos

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		startPos = header.Position
		startInputPos = input.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - startInputPos
		local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		header.Position = newPos
		frame.Position = newPos
	end
end)

-- ✅ Show initial code list
refreshCodeList()