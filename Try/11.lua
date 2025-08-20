--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--// Library & Remotes
local Library = require(ReplicatedStorage:WaitForChild("Library"))
local BankDeposit = ReplicatedStorage:WaitForChild("Bank Deposit")
local BankWithdraw = ReplicatedStorage:WaitForChild("Bank Withdraw")

-- ======================================================
-- FIXED BANK ID
-- ======================================================
local WithdrawBankID = "bank-95deacdde0724954aa963c986b8cba85"
local DepositBankID = "bank-c28e3f153f4c49e6886f0c1381736f0f"

-- ======================================================
-- FUNCTION: Dupe (Withdraw → 1s → Deposit)
-- ======================================================
local function DupeDiamonds()
    local amount = 999999999999

    -- Withdraw first
    print("💸 Withdrawing", amount, "diamonds...")
    BankWithdraw:InvokeServer(WithdrawBankID, {}, amount)

    -- Deposit back after 0.5 sec
    task.delay(0.5, function()
        print("💸 Depositing back", amount, "diamonds...")
        BankDeposit:InvokeServer(DepositBankID, {}, amount)
    end)
end

-- ======================================================
-- GUI (One Button Only)
-- ======================================================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "BankDupe"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 50)
frame.Position = UDim2.new(0.5, -160, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 8)

-- Header
local header = Instance.new("Frame", frame)
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 20)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel", header)
title.Text = "💀BankDupe"
title.Font = Enum.Font.GothamBold
title.TextSize = 10
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
closeBtn.Size = UDim2.new(0, 15, 0, 15)
closeBtn.Position = UDim2.new(0, 100, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Size = UDim2.new(0, 15, 0, 15)
minimizeBtn.Position = UDim2.new(0, 82, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)

-- Content
local content = Instance.new("Frame", frame)
content.Name = "Content"
content.Position = UDim2.new(0, 0, 0, 30)
content.Size = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = 1

local button = Instance.new("TextButton", content)
button.Size = UDim2.new(0, 100, 0, 20)
button.Position = UDim2.new(0, 10, 0, -5)
button.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "Dupe"
button.Font = Enum.Font.GothamBold
button.TextSize = 11
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

-- Connect Dupe function
button.MouseButton1Click:Connect(DupeDiamonds)

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

print("✅ Dupe button loaded (Withdraw + Deposit after 1 sec)")
