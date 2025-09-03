--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

--// Library & Remotes
local Library = require(ReplicatedStorage:WaitForChild("Library"))
local BankDeposit = Workspace.__THINGS.__REMOTES["bank deposit"]
local BankWithdraw = Workspace.__THINGS.__REMOTES["bank withdraw"]
local GetBank = Workspace.__THINGS.__REMOTES["get my banks"]

-- ======================================================
-- INLINE BANK IDs (Name + ID)
-- ======================================================
local MyBankIDs = {
    {"Shion",   "bank-e83fd3510c004c81a7c81adeafc396f3"},
    {"Dm_Machine",   "bank-fb2ed956005b49ab8799f4187fc7515c"},
    {"Think",   "bank-2d6afacf3d814071aee6fc59bb22f2few"}

}

-- ======================================================
-- HELPER: Map Display Name → Directory Pet ID (Case sensitive)
-- ======================================================
local function FindPetIdByName(displayName)
    for petId, petData in pairs(Library.Directory.Pets) do
        if petData.name and petData.name == displayName then
            return petId
        end
    end
    return nil
end

-- ======================================================
-- HELPER: Get UIDs from multiple pet names
-- ======================================================
local function GetUIDsFromNames(petsList, petNamesStr)
    local uids = {}
    for petName in string.gmatch(petNamesStr, '([^,]+)') do
        petName = petName:gsub("^%s*(.-)%s*$", "%1") -- trim spaces
        local petId = FindPetIdByName(petName)
        if petId then
            for _, pet in pairs(petsList) do
                if pet.id == petId and pet.uid then
                    table.insert(uids, pet.uid)
                end
            end
        else
            warn("⚠️ Pet not found in directory:", petName)
        end
    end
    return uids
end

-- ======================================================
-- DEPOSIT (Pets+Diamonds / Pets only / Diamonds only)
-- ======================================================
local function Deposit(bankId, petNamesStr, diamondAmount)
    local inv = Library.Save.Get().Pets
    if not inv then
        warn("⚠️ No pets found in inventory")
        return
    end

    -- collect UIDs
    local uids = petNamesStr and petNamesStr ~= "" and GetUIDsFromNames(inv, petNamesStr) or {}

    -- cap 600
    if #uids > 600 then
        uids = {table.unpack(uids, 1, 700)}
    end

    -- decide mode
    if #uids > 0 and diamondAmount > 0 then
        print("✅ Depositing Pets + Diamonds")
        BankDeposit:InvokeServer({bankId, uids, diamondAmount})

    elseif #uids > 0 and diamondAmount == 0 then
        print("✅ Depositing Pets Only")
        BankDeposit:InvokeServer({bankId, uids, 0})

    elseif #uids == 0 and diamondAmount > 0 then
        print("✅ Depositing Diamonds Only")
        BankDeposit:InvokeServer({bankId, {}, diamondAmount})

    else
        warn("❌ Nothing valid to deposit")
    end
end

-- ======================================================
-- Deep search for bank by BUID
-- ======================================================
local function DeepFindBank(tbl, targetBUID)
    for _, v in pairs(tbl) do
        if type(v) == "table" then
            if v.BUID == targetBUID then
                return v
            end
            local found = DeepFindBank(v, targetBUID)
            if found then return found end
        end
    end
    return nil
end

-- ======================================================
-- WITHDRAW (Pets+Diamonds / Pets only / Diamonds only)
-- ======================================================
local function Withdraw(bankId, petNamesStr, diamondAmount)
    local ok, myBanks = pcall(function()
        return GetBank:InvokeServer({})
    end)
    if not ok or not myBanks then
        warn("⚠️ Could not fetch bank list")
        return
    end

    local bankData = DeepFindBank(myBanks, bankId)
    if not bankData or not bankData.Storage or not bankData.Storage.Pets then
        warn("⚠️ Bank not found or no pets in storage")
        return
    end

    -- collect UIDs
    local uids = petNamesStr and petNamesStr ~= "" and GetUIDsFromNames(bankData.Storage.Pets, petNamesStr) or {}

    -- cap 700
    if #uids > 700 then
        uids = {table.unpack(uids, 1, 700)}
    end

    -- decide mode
    if #uids > 0 and diamondAmount > 0 then
        print("✅ Withdrawing Pets + Diamonds")
        BankWithdraw:InvokeServer({bankId, uids, diamondAmount})

    elseif #uids > 0 and diamondAmount == 0 then
        print("✅ Withdrawing Pets Only")
        BankWithdraw:InvokeServer({bankId, uids, 0})

    elseif #uids == 0 and diamondAmount > 0 then
        print("✅ Withdrawing Diamonds Only")
        BankWithdraw:InvokeServer({bankId, {}, diamondAmount})

    else
        warn("❌ Nothing valid to withdraw")
    end
end

-- ======================================================
-- 💀 GUI Setup (BoogyMan Menu)
-- ======================================================

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "Bank"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 155)
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
title.Text = "💀Bank"
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
PetNameBox.Text = "Exclusive Pixel Egg"
PetNameBox.TextSize = 11
PetNameBox.BorderSizePixel = 0

local DiamondBox = Instance.new("TextBox", content)
DiamondBox.Size = UDim2.new(0, 100, 0, 20)
DiamondBox.Position = UDim2.new(0, 10, 0, 45)
DiamondBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DiamondBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DiamondBox.PlaceholderText = "Diamond"
DiamondBox.Text = "20000000000"
DiamondBox.TextSize = 11
DiamondBox.BorderSizePixel = 0

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

CreateButton("Deposit", 70, function()
    if SelectedBankID then
        local diamonds = tonumber(DiamondBox.Text) or 0
        Deposit(SelectedBankID, PetNameBox.Text, diamonds)
    else
        warn("❌ Select a bank first")
    end
end)

CreateButton("Withdraw", 95, function()
    if SelectedBankID then
        local diamonds = tonumber(DiamondBox.Text) or 0
        Withdraw(SelectedBankID, PetNameBox.Text, diamonds)
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

print("✅ BoogyMan Bank UI Loaded with Multi-Pet Support & Case-Sensitive 3-Mode Deposit & Withdraw")

