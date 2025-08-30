local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local BankDeposit = Workspace.__THINGS.__REMOTES["bank deposit"]
local BankWithdraw = Workspace.__THINGS.__REMOTES["bank withdraw"]

--Funtion Line
local bankId = "bank-2d6afacf3d814071aee6fc59bb22f2fe"

-- Table of pet UUIDs
local baseUids = {
    "ide375407c2396416f9f1c8e59805f829e",
    "idb4e647aeeb354e8fab49d4bc5c278811",
    "id3bdfe01ff03c43f594f9355945a59b00",
    "ide853015f69cb452fb4a3185b291b13d3",
    "id5bd980944b234867b5ff3c3cedd13787",
    "id7790b01be6744035a6691212b1a365b8",
    "id30a956d446d34f4584452801027fa115",
    "idbcd9d8d467704f6e9f85beedc0da2ddb",
    "id76a36ecc9f2643c78eb32584e658980c",
    "id174eb06459ee49bd8117064cf697c7a4"
}

-- Final list of 100 UUIDs
local uids = {}

-- Repeat the set 10 times
for i = 1, 10 do
    for _, uid in ipairs(baseUids) do
        table.insert(uids, uid)
    end
end

local diamondAmount = 0

-- GUI Setup
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "Menu"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 80) --Add 25 in Hieght if you add 1 button
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
title.Text = "💀Menu"
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


local Bank_Withdraw = Instance.new("TextButton", content)
Bank_Withdraw.Size = UDim2.new(0, 100, 0, 20)
Bank_Withdraw.Position = UDim2.new(0, 10, 0, -5)
Bank_Withdraw.Text = "Bank Withdraw"
Bank_Withdraw.Font = Enum.Font.SourceSansBold
Bank_Withdraw.TextSize = 15
Bank_Withdraw.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
Bank_Withdraw.TextColor3 = Color3.fromRGB(255, 255, 255)

Bank_Withdraw.MouseButton1Click:Connect(function()
    BankWithdraw:InvokeServer({ bankId, uids, diamondAmount })
end)

local Bank_Deposit = Instance.new("TextButton", content)
Bank_Deposit.Size = UDim2.new(0, 100, 0, 20)
Bank_Deposit.Position = UDim2.new(0, 10, 0, 20)
Bank_Deposit.Text = "Bank Deposit"
Bank_Deposit.Font = Enum.Font.SourceSansBold
Bank_Deposit.TextSize = 15
Bank_Deposit.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
Bank_Deposit.TextColor3 = Color3.fromRGB(255, 255, 255)

Bank_Deposit.MouseButton1Click:Connect(function()
    BankDeposit:InvokeServer({ bankId, uids, diamondAmount })
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
