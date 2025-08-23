--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--// Library & Remotes
local Library = require(ReplicatedStorage:WaitForChild("Library"))
local BankDeposit = Workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("bank deposit")
local BankWithdraw = Workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("bank withdraw")

-- ======================================================
-- FIXED BANK ID
-- ======================================================
local 1stBankID = "bank-fb2ed956005b49ab8799f4187fc7515c"
local 2ndBankID = "bank-fb2ed956005b49ab8799f4187fc7515c"


-- ======================================================
-- FUNCTION: Dupe (Withdraw → 1s → Deposit)
-- ======================================================
local function DupeDiamonds()
    local amount = 10000000000

    -- Withdraw first
    print(":money_with_wings: Withdrawing", amount, "diamonds...")
    BankWithdraw:InvokeServer({1stBankID, {}, amount})

    -- Deposit back after 1 sec
    task.delay(0.5, function()
        print(":money_with_wings: Depositing back", amount, "diamonds...")
        BankDeposit:InvokeServer({2ndBankID, {}, amount})
    end)
end

-- ======================================================
-- GUI (One Button Only)
-- ======================================================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "DupeUI"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 120, 0, 50)
frame.Position = UDim2.new(0.5, -60, 0.5, -25)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, -20, 1, -10)
button.Position = UDim2.new(0, 10, 0, 5)
button.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "Dupe"
button.Font = Enum.Font.GothamBold
button.TextSize = 14
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

-- Connect Dupe function
button.MouseButton1Click:Connect(DupeDiamonds)

print(":white_check_mark: Dupe button loaded (Withdraw + Deposit after 1 sec)")
