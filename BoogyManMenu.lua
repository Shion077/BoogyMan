local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local saveFile = "BoogeyButtons.json"
local savedButtons = {}

local defaultButtons = {
    {
        name = "Dex Gui",
        code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua"))()'
    },
    {
        name = "Auto Clicker",
        code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Shion077/BoogyMan/refs/heads/main/Autoclicker.lua"))()'
    },
    {
        name = "Auto Redeem",
        code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Shion077/BoogyMan/refs/heads/main/AutoRedeem.lua"))()'
    }
}

-- GUI Setup
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AutoClickerGUI"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 210, 0, 300)
frame.Position = UDim2.new(0.5, -160, 0.5, -140)
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
header.Size = UDim2.new(1, 0, 0, 30)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
header.BorderSizePixel = 0
header.Parent = frame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Title Label
local title = Instance.new("TextLabel")
title.Text = "💀 BoogyMan Menu"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Parent = header

-- Close & Minimize Buttons
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -30, 0.5, -10)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
minimizeBtn.Position = UDim2.new(1, -60, 0.5, -10)
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

-- Scrollable Button List
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ButtonList"
scrollFrame.Parent = content
scrollFrame.Size = UDim2.new(1, -10, 1, -100)
scrollFrame.Position = UDim2.new(0, 5, 0, 5)
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ClipsDescendants = true

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)

-- Input Fields
local nameBox = Instance.new("TextBox")
nameBox.Text = ""
nameBox.PlaceholderText = "Script Name"
nameBox.Size = UDim2.new(1, -10, 0, 25)
nameBox.Position = UDim2.new(0, 5, 1, -90)
nameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.TextSize = 14
nameBox.Font = Enum.Font.Gotham
nameBox.ClearTextOnFocus = false
nameBox.Parent = content

local nameCorner = Instance.new("UICorner")
nameCorner.CornerRadius = UDim.new(0, 6)
nameCorner.Parent = nameBox

local codeBox = Instance.new("TextBox")
codeBox.Text = ""
codeBox.PlaceholderText = "Script Link"
codeBox.Size = UDim2.new(1, -10, 0, 25)
codeBox.Position = UDim2.new(0, 5, 1, -60)
codeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
codeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
codeBox.TextSize = 14
codeBox.Font = Enum.Font.Gotham
codeBox.ClearTextOnFocus = false
codeBox.Parent = content

local codeCorner = Instance.new("UICorner")
codeCorner.CornerRadius = UDim.new(0, 6)
codeCorner.Parent = codeBox

local function saveButtons()
	if isfile(saveFile) then delfile(saveFile) end
	writefile(saveFile, HttpService:JSONEncode(savedButtons))
end

local function addButton(text, callback, originalCode)
	local buttonFrame = Instance.new("Frame")
	buttonFrame.Size = UDim2.new(1, -10, 0, 30)
	buttonFrame.BackgroundTransparency = 1
	buttonFrame.Parent = scrollFrame

	local button = Instance.new("TextButton")
	button.Text = text
	button.Size = UDim2.new(0.65, 0, 1, 0)
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.Gotham
	button.TextSize = 14
	button.Parent = buttonFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = button

	button.MouseButton1Click:Connect(function()
		callback()
	end)

	local editBtn = Instance.new("TextButton")
	editBtn.Text = "📝"
	editBtn.Size = UDim2.new(0, 25, 0, 25)
	editBtn.Position = UDim2.new(0.7, 0, 0.5, -12)
	editBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 40)
	editBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	editBtn.Font = Enum.Font.Gotham
	editBtn.TextSize = 14
	editBtn.Parent = buttonFrame

	local editCorner = Instance.new("UICorner")
	editCorner.CornerRadius = UDim.new(1, 0)
	editCorner.Parent = editBtn

	editBtn.MouseButton1Click:Connect(function()
		nameBox.Text = text
		codeBox.Text = originalCode
		buttonFrame:Destroy()
		for i, btn in ipairs(savedButtons) do
			if btn.name == text and btn.code == originalCode then
				table.remove(savedButtons, i)
				break
			end
		end
		saveButtons()
	end)

	local deleteBtn = Instance.new("TextButton")
	deleteBtn.Text = "❌"
	deleteBtn.Size = UDim2.new(0, 25, 0, 25)
	deleteBtn.Position = UDim2.new(0.85, 0, 0.5, -12)
	deleteBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
	deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	deleteBtn.Font = Enum.Font.Gotham
	deleteBtn.TextSize = 14
	deleteBtn.Parent = buttonFrame

	local deleteCorner = Instance.new("UICorner")
	deleteCorner.CornerRadius = UDim.new(1, 0)
	deleteCorner.Parent = deleteBtn

	deleteBtn.MouseButton1Click:Connect(function()
		buttonFrame:Destroy()
		for i, btn in ipairs(savedButtons) do
			if btn.name == text and btn.code == originalCode then
				table.remove(savedButtons, i)
				break
			end
		end
		saveButtons()
	end)
end

local function loadButtons()
	for _, entry in ipairs(defaultButtons) do
		addButton(entry.name, function()
			local success, err = pcall(function()
				loadstring(entry.code)()
			end)
			if not success then
				warn("Default Button Error:", err)
			end
		end, entry.code)
	end

	if isfile(saveFile) then
		local content = readfile(saveFile)
		local success, data = pcall(function()
			return HttpService:JSONDecode(content)
		end)
		if success then
			for _, entry in ipairs(data) do
				local exists = false
				for _, default in ipairs(defaultButtons) do
					if default.name == entry.name and default.code == entry.code then
						exists = true
						break
					end
				end
				if not exists then
					addButton(entry.name, function()
						local success, err = pcall(function()
							loadstring(entry.code)()
						end)
						if not success then
							warn("Saved Button Error:", err)
						end
					end, entry.code)
				end
				table.insert(savedButtons, entry)
			end
		end
	end

	for _, entry in ipairs(defaultButtons) do
		table.insert(savedButtons, entry)
	end
	saveButtons()
end

local addBtn = Instance.new("TextButton")
addBtn.Text = "+ Add Button"
addBtn.Size = UDim2.new(1, -10, 0, 25)
addBtn.Position = UDim2.new(0, 5, 1, -30)
addBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addBtn.Font = Enum.Font.GothamBold
addBtn.TextSize = 14
addBtn.Parent = content

local addBtnCorner = Instance.new("UICorner")
addBtnCorner.CornerRadius = UDim.new(0, 6)
addBtnCorner.Parent = addBtn

addBtn.MouseButton1Click:Connect(function()
	local btnName = nameBox.Text
	local code = codeBox.Text
	if btnName ~= "" and code ~= "" then
		addButton(btnName, function()
			local success, err = pcall(function()
				loadstring(code)()
			end)
			if not success then
				warn("Error in custom code:", err)
			end
		end, code)
		table.insert(savedButtons, {name = btnName, code = code})
		saveButtons()
		nameBox.Text = ""
		codeBox.Text = ""
	end
end)

loadButtons()

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

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
