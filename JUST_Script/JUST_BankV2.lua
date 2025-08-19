--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--// Library & Remotes
local Library = require(ReplicatedStorage:WaitForChild("Library"))
local BankDeposit = ReplicatedStorage:WaitForChild("Bank Deposit")
local BankWithdraw = ReplicatedStorage:WaitForChild("Bank Withdraw")
local GetBank = ReplicatedStorage:WaitForChild("Get Bank")

-- ======================================================
-- INLINE BANK IDs (Name + ID)
-- ======================================================
local MyBankIDs = {
    {"Shion",   "bank-cf202d03df2344dc9772a11912efda67"},
    {"Lyncoln", "bank-9c0176b013034bab8e41f24cd3a58689"},
    {"Lanjo",   "bank-091035b96a61446fbc836b4bd2229321"},
    {"PhJr",    "bank-c28e3f153f4c49e6886f0c1381736f0f"},
    {"MyBank",  "bank-95deacdde0724954aa963c986b8cba85"},
    {"BankDuper16",  "bank-6431d293d7da4f13aea0b00ac24458ae"}
}

-- Helper: Get friendly bank name
local function GetBankName(bankId)
    for _, pair in ipairs(MyBankIDs) do
        if pair[2] == bankId then
            return pair[1]
        end
    end
    return bankId -- fallback
end

-- ======================================================
-- FUNCTIONS
-- ======================================================

-- ✅ DepositAll (simplified, no BuildPetDictionary)
local function DepositAll(bankId, petName)
    petName = petName:lower()
    local save = Library.Save.Get()
    if not save or not save.Pets then return end

    local uids = {}
    for _, pet in ipairs(save.Pets) do
        local petData = Library.Directory.Pets[pet.id]
        local name = petData and petData.name:lower() or pet.id:lower()
        if name == petName then
            table.insert(uids, pet.uid)
        end
    end

    if #uids == 0 then
        return warn("❌ You don’t own any:", petName)
    end

    print("✅ Depositing", #uids, petName, "to", GetBankName(bankId))
    BankDeposit:InvokeServer(bankId, uids)
end

-- ✅ WithdrawAll
local function WithdrawAll(bankId, petName)
    petName = petName:lower()

    -- find petId from Library (case-insensitive)
    local petId = nil
    for id, data in pairs(Library.Directory.Pets) do
        if data.name:lower() == petName then
            petId = id
            break
        end
    end
    if not petId then
        return warn("❌ Pet not found in Library:", petName)
    end

    -- fetch bank data
    local ok, bankData = pcall(function()
        return GetBank:InvokeServer(bankId)
    end)
    if not ok or not bankData or not bankData.Storage or not bankData.Storage.Pets then
        return warn("❌ Failed to fetch bank data for:", GetBankName(bankId))
    end

    -- collect matching uids
    local uids = {}
    for _, pet in ipairs(bankData.Storage.Pets) do
        if tostring(pet.id) == tostring(petId) then
            table.insert(uids, pet.uid)
        end
    end

    if #uids == 0 then
        return warn("❌ No", petName, "found in bank", GetBankName(bankId))
    end

    print("✅ Withdrawing", #uids, petName, "from bank", GetBankName(bankId))
    BankWithdraw:InvokeServer(bankId, uids)
end

-- ======================================================
-- 💀 GUI Setup (BoogyMan Menu)
-- ======================================================

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "PSXO Bank"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 130)
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
title.Text = "💀PSXO Bank"
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

-- TextBoxes
local PetNameBox = Instance.new("TextBox", content)
PetNameBox.Size = UDim2.new(0, 100, 0, 20)
PetNameBox.Position = UDim2.new(0, 10, 0, 20)
PetNameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PetNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PetNameBox.PlaceholderText = "Pet Name"
PetNameBox.Text = "Exclusive Lucky Egg"
PetNameBox.TextSize = 11
PetNameBox.BorderSizePixel = 0

-- Replace BankBox (make it a button, not textbox)
local BankBox = Instance.new("TextButton", content)
BankBox.Size = UDim2.new(0, 100, 0, 20)
BankBox.Position = UDim2.new(0, 10, 0, -5)
BankBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BankBox.TextColor3 = Color3.fromRGB(255, 255, 255)
BankBox.Text = "Choose Bank"
BankBox.TextSize = 11
BankBox.BorderSizePixel = 0
Instance.new("UICorner", BankBox).CornerRadius = UDim.new(0, 8)

-- Dropdown
local dropdown = Instance.new("Frame", content)
dropdown.Size = UDim2.new(0, 100, 0, 0)
dropdown.Position = UDim2.new(0, 120, 0, -5)
dropdown.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
dropdown.BorderSizePixel = 0
dropdown.Visible = false
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", dropdown)
layout.Padding = UDim.new(0, 2)

-- Selected Bank ID variable
local SelectedBankID = nil

-- Build rows from MyBankIDs
for _, entry in ipairs(MyBankIDs) do
    local displayName, bankId = entry[1], entry[2]

    local row = Instance.new("TextButton", dropdown)
    row.Size = UDim2.new(0, 100, 0, 20)
    row.Text = displayName
    row.TextSize = 11
    row.TextColor3 = Color3.fromRGB(255, 255, 255)
    row.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    row.MouseButton1Click:Connect(function()
        BankBox.Text = displayName
        SelectedBankID = bankId
        dropdown.Visible = false
        print("✅ Selected Bank:", displayName, bankId)
    end)
end

BankBox.MouseButton1Click:Connect(function()
    dropdown.Visible = not dropdown.Visible
    if dropdown.Visible then
        dropdown.Size = UDim2.new(0, 100, 0, #MyBankIDs * 22)
    else
        dropdown.Size = UDim2.new(0, 100, 0, 0)
    end
end)

-- ======================================================
-- Buttons
-- ======================================================
local function CreateButton(text, yPos, callback)
    local Btn = Instance.new("TextButton", content)
    Btn.Size = UDim2.new(0, 100, 0, 20)
    Btn.Position = UDim2.new(0, 10, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Text = text
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

CreateButton("Deposit", 45, function()
    if SelectedBankID then
        DepositAll(SelectedBankID, PetNameBox.Text)
    else
        warn("❌ Select a bank first")
    end
end)

CreateButton("Withdraw", 70, function()
    if SelectedBankID then
        WithdrawAll(SelectedBankID, PetNameBox.Text)
    else
        warn("❌ Select a bank first")
    end
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

print("✅ BoogyMan Bank UI Loaded with NEW Withdraw & Simplified Deposit!")
