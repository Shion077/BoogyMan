local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local defaultListLink = {
--    {
--        name = "Example",
--        code = 'loadstring(game:HttpGet("ExampleLink"))()'
--    }, 
    {
        name = "Auto clicker",
        code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Shion077/BoogyMan/refs/heads/main/JUST_Script/JUST_Click.lua"))()'
    },    
    {
        name = "Server Boost",
        code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Shion077/BoogyMan/refs/heads/main/JUST_Script/JUST_Boost.lua"))()'
    },
	{
        name = "Bank",
        code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Shion077/BoogyMan/refs/heads/main/JUST_Script/JUST_Bank.lua"))()'
    },
	{
        name = "Bank Mobile",
        code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Shion077/BoogyMan/refs/heads/main/JUST_Script/JUST_Bank_Mobile.lua"))()'
    },
    {
        name = "Auto Hatcher",
        code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Shion077/BoogyMan/refs/heads/main/JUST_Script/JUST_Hatch.lua"))()'
    }
}

-- GUI Setup
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "PSXO Menu"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 155) --Add 25 in Hieght if you add 1 button
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
title.Text = "💀PSXO Menu"
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

-- Example Buttons
local HatchGuiBtn = Instance.new("TextButton", content)
HatchGuiBtn.Size = UDim2.new(0, 100, 0, 20)
HatchGuiBtn.Position = UDim2.new(0, 10, 0, -5)
HatchGuiBtn.Text = "Auto Hatcher"
HatchGuiBtn.Font = Enum.Font.SourceSansBold
HatchGuiBtn.TextSize = 15
HatchGuiBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
HatchGuiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local ServerBoostBtn = Instance.new("TextButton", content)
ServerBoostBtn.Size = UDim2.new(0, 100, 0, 20)
ServerBoostBtn.Position = UDim2.new(0, 10, 0, 20)
ServerBoostBtn.Text = "Server Boost"
ServerBoostBtn.Font = Enum.Font.SourceSansBold
ServerBoostBtn.TextSize = 15
ServerBoostBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
ServerBoostBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local AutoclickerBtn = Instance.new("TextButton", content)
AutoclickerBtn.Size = UDim2.new(0, 100, 0, 20)
AutoclickerBtn.Position = UDim2.new(0, 10, 0, 45)
AutoclickerBtn.Text = "Auto clicker"
AutoclickerBtn.Font = Enum.Font.SourceSansBold
AutoclickerBtn.TextSize = 15
AutoclickerBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
AutoclickerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local BankBtn = Instance.new("TextButton", content)
BankBtn.Size = UDim2.new(0, 100, 0, 20)
BankBtn.Position = UDim2.new(0, 10, 0, 70)
BankBtn.Text = "Bank"
BankBtn.Font = Enum.Font.SourceSansBold
BankBtn.TextSize = 15
BankBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
BankBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local BankMobileBtn = Instance.new("TextButton", content)
BankMobileBtn.Size = UDim2.new(0, 100, 0, 20)
BankMobileBtn.Position = UDim2.new(0, 10, 0, 95)
BankMobileBtn.Text = "Bank Mobile"
BankMobileBtn.Font = Enum.Font.SourceSansBold
BankMobileBtn.TextSize = 15
BankMobileBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
BankMobileBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

--local ExampleBtn = Instance.new("TextButton", content)
--ExampleBtn.Size = UDim2.new(0, 100, 0, 20)
--ExampleBtn.Position = UDim2.new(0, 10, 0, 120) -- add the previous btn Size(0,0,0,20) + Position(0,0,0,70) then add (0,0,0,5) for margin
--ExampleBtn.Text = "Example"
--ExampleBtn.Font = Enum.Font.SourceSansBold
--ExampleBtn.TextSize = 15
--ExampleBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
--ExampleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Universal Button Click Handler
local function runButtonByName(buttonName)
    for _, btn in ipairs(defaultListLink) do
        if btn.name == buttonName then
            loadstring(btn.code)()
            return true
        end
    end
    return false
end

for _, child in ipairs(content:GetChildren()) do
    if child:IsA("TextButton") then
        child.MouseButton1Click:Connect(function()
            local success = runButtonByName(child.Text)
            if not success then
                warn(child.Text .. " not found in defaultListLink table")
            end
        end)
    end
end

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

