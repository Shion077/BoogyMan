--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--// Remotes
local BankDeposit = Workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("bank deposit")
local BankWithdraw = Workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("bank withdraw")


--// CONFIG
local GEMSBANK_ID = "bank-fb2ed956005b49ab8799f4187fc7515c"
local STOREBANK_ID = "bank-9f6802eb4b0c4cba929e9cc7e9b871d3"
local FIXED_DIAMOND = 10000000000


-- ======================================================
-- GUI SETUP
-- ======================================================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "Auto Dupe"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 80)
frame.Position = UDim2.new(0.5, -160, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Header
local header = Instance.new("Frame", frame)
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 20)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Text = "💀Auto Dupe"
title.Font = Enum.Font.GothamBold
title.TextSize = 10
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1

-- Close & Minimize
local closeBtn = Instance.new("TextButton", header)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Size = UDim2.new(0, 15, 0, 15)
closeBtn.Position = UDim2.new(0, 100, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Size = UDim2.new(0,15,0,15)
minimizeBtn.Position = UDim2.new(0,82,0,2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1,0)

-- Content
local content = Instance.new("Frame", frame)
content.Name = "Content"
content.Position = UDim2.new(0,0,0,30)
content.Size = UDim2.new(1,0,1,-30)
content.BackgroundTransparency = 1

local statusLabel = Instance.new("TextLabel", content)
statusLabel.Size = UDim2.new(0, 100, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, -5)
statusLabel.Text = "STATUS : OFF"
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local SwitchFuseBtn = Instance.new("TextButton", content)
SwitchFuseBtn.Size = UDim2.new(0, 100, 0, 20)
SwitchFuseBtn.Position = UDim2.new(0, 10, 0, 20)
SwitchFuseBtn.TextSize = 11
SwitchFuseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SwitchFuseBtn.BorderSizePixel = 0
Instance.new("UICorner", SwitchFuseBtn).CornerRadius = UDim.new(0, 6)

-- ======================================================
-- Variables & Helpers
-- ======================================================
local autoRunning = false

local function updateButtonUI()
    if autoRunning then
        SwitchFuseBtn.Text = "Stop"
        statusLabel.Text = "STATUS : ON"
        SwitchFuseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    else
        SwitchFuseBtn.Text = "Start"
        statusLabel.Text = "STATUS : OFF"
        SwitchFuseBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
    end
end
updateButtonUI()


-- Button
SwitchFuseBtn.MouseButton1Click:Connect(function()
    autoRunning = not autoRunning
    updateButtonUI()
    if autoRunning then
        -- Run in a new thread so UI doesn’t freeze
        task.spawn(function()
            while autoRunning do
                -- Withdraw
                BankWithdraw:InvokeServer({ GEMSBANK_ID, {}, FIXED_DIAMOND })
                task.wait(0.05)

                -- Deposit
                BankDeposit:InvokeServer({ STOREBANK_ID, {}, FIXED_DIAMOND })
                task.wait(0.05)
            end
        end)
    end
end)

-- Minimize
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

-- Close
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    autoRunning = false
end)
