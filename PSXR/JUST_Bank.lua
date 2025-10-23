--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

--// Library & Remotes
local Library = require(ReplicatedStorage:WaitForChild("Library"))


-- ======================================================
-- 🎯 Remote Grabber
-- ======================================================
local function getRemote(index)
    local count = 0
    for _, obj in ipairs(ReplicatedStorage:GetChildren()) do
        if obj:IsA("RemoteFunction") then
            count += 1
            if count == index then -- change index here if needed
                return obj
            end
        end
    end
    return nil
end

local BankDepositRemote = getRemote(11)
local BankWithdrawRemote = getRemote(2)
local GetBankRemote = getRemote(3)

-- ======================================================
-- INLINE BANK IDs (Name + ID)
-- ======================================================
local MyBankIDs = {
    {"PetStorage",        "bank-8cd63833f10b4fde963798a3494bc092"},
    {"Think_About",   "bank-2d6afacf3d814071aee6fc59bb22f2fe"}
}

-- ======================================================
-- HELPER: Get UIDs from pet names
-- ======================================================
local function GetUIDsFromNames(petsList, petNamesStr)
    local uids = {}
    for petName in string.gmatch(petNamesStr, '([^,]+)') do
        petName = petName:gsub("^%s*(.-)%s*$", "%1") -- trim spaces
        local lowerName = string.lower(petName)

        for uid, pet in pairs(petsList) do
            local realUID = typeof(uid) == "number" and pet.uid or uid
            local petData = Library.Directory.Pets[pet.id]
            local displayName = petData and petData.name
            if displayName and string.lower(displayName) == lowerName then
                table.insert(uids, realUID)
                print("✅ Matched:", displayName, "→ UID:", realUID)
            end
        end
    end
    return uids
end

-- ======================================================
-- DEPOSIT (Pets only)
-- ======================================================
local function Deposit(bankId, petNamesStr)
    local inv = Library.Save.Get().Pets
    if not inv then
        warn("⚠️ No pets found in inventory")
        return
    end

    local uids = GetUIDsFromNames(inv, petNamesStr)
    if #uids == 0 then
        warn("❌ No matching pets found to deposit")
        return
    end

    if #uids > 700 then
        uids = {table.unpack(uids, 1, 700)}
    end

    print("✅ Depositing Pets Only")
    BankDeposit:InvokeServer({bankId, uids, 0})
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
-- WITHDRAW (Pets only)
-- ======================================================
local function Withdraw(bankId, petNamesStr)
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

    print("🔎 Bank Pets:")
    for k,v in pairs(bankData.Storage.Pets) do
        local petName = (Library.Directory.Pets[v.id] and Library.Directory.Pets[v.id].name) or "Unknown"
        print("  UID:", k, " → ID:", v.id, " Name:", petName)
    end

    local uids = GetUIDsFromNames(bankData.Storage.Pets, petNamesStr)
    if #uids == 0 then
        warn("❌ No matching pets found to withdraw")
        return
    end

    if #uids > 700 then
        uids = {table.unpack(uids, 1, 700)}
    end

    print("✅ Withdrawing Pets Only")
    BankWithdraw:InvokeServer({bankId, uids, 0})
end

-- ======================================================
-- 💀 GUI Setup (Pet-Only Menu)
-- ======================================================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "Bank"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 130)
frame.Position = UDim2.new(0.5, -160, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 20)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Text = "💀Pet Bank"
title.Font = Enum.Font.GothamBold
title.TextSize = 10
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1

local closeBtn = Instance.new("TextButton", header)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Size = UDim2.new(0, 15, 0, 15)
closeBtn.Position = UDim2.new(0, 100, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

local content = Instance.new("Frame", frame)
content.Position = UDim2.new(0, 0, 0, 25)
content.Size = UDim2.new(1, 0, 1, -25)
content.BackgroundTransparency = 1

local PetNameBox = Instance.new("TextBox", content)
PetNameBox.Size = UDim2.new(0, 100, 0, 20)
PetNameBox.Position = UDim2.new(0, 10, 0, 15)
PetNameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PetNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PetNameBox.PlaceholderText = "Pet Name"
PetNameBox.Text = ""
PetNameBox.TextSize = 11
PetNameBox.BorderSizePixel = 0

-- Bank dropdown
local BankBox = Instance.new("TextButton", content)
BankBox.Size = UDim2.new(0, 100, 0, 20)
BankBox.Position = UDim2.new(0, 10, 0, -5)
BankBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BankBox.TextColor3 = Color3.fromRGB(255, 255, 255)
BankBox.Text = "Choose Bank"
BankBox.TextSize = 11
BankBox.BorderSizePixel = 0
Instance.new("UICorner", BankBox).CornerRadius = UDim.new(0, 8)

local dropdown = Instance.new("Frame", content)
dropdown.Size = UDim2.new(0, 100, 0, 0)
dropdown.Position = UDim2.new(0, 120, 0, -5)
dropdown.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
dropdown.BorderSizePixel = 0
dropdown.Visible = false
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", dropdown)
layout.Padding = UDim.new(0, 2)

local SelectedBankID = nil
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
    dropdown.Size = dropdown.Visible and UDim2.new(0, 100, 0, #MyBankIDs * 22) or UDim2.new(0, 100, 0, 0)
end)

-- Buttons
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
        Deposit(SelectedBankID, PetNameBox.Text)
    else
        warn("❌ Select a bank first")
    end
end)

CreateButton("Withdraw", 70, function()
    if SelectedBankID then
        Withdraw(SelectedBankID, PetNameBox.Text)
    else
        warn("❌ Select a bank first")
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("✅ BoogyMan Pet-Only Bank UI Loaded")
