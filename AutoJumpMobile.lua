local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AutoClickerGUI"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 95) -- Increased height for toggle button
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

-- Close Button
local closeBtn = Instance.new("TextButton", header)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 15, 0, 15)
closeBtn.Position = UDim2.new(1, -20, 0.5, -10)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Text = "-"
minimizeBtn.Size = UDim2.new(0, 15, 0, 15)
minimizeBtn.Position = UDim2.new(1, -40, 0.5, -10)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)

-- Content Frame
local content = Instance.new("Frame", frame)
content.Name = "Content"
content.Position = UDim2.new(0, 0, 0, 30)
content.Size = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = 1

-- STATUS Label
local statusLabel = Instance.new("TextLabel", content)
statusLabel.Size = UDim2.new(0, 68, 0, 25)
statusLabel.Position = UDim2.new(0, 5, 0, 5)
statusLabel.Text = "STATUS :"
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", statusLabel).CornerRadius = UDim.new(0, 6)

-- STATUS Value
local statusValue = Instance.new("TextLabel", content)
statusValue.Size = UDim2.new(0, 68, 0, 25)
statusValue.Position = UDim2.new(0, 77, 0, 5)
statusValue.Text = "Inactive"
statusValue.TextSize = 12
statusValue.Font = Enum.Font.SourceSansBold
statusValue.TextColor3 = Color3.new(1, 1, 1)
statusValue.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", statusValue).CornerRadius = UDim.new(0, 6)

-- Toggle Button
local toggleButton = Instance.new("TextButton", content)
toggleButton.Size = UDim2.new(0, 140, 0, 25)
toggleButton.Position = UDim2.new(0, 5, 0, 35)
toggleButton.Text = "Toggle Clicking"
toggleButton.TextSize = 12
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 6)

-- Minimize functionality
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

-- Close functionality
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
