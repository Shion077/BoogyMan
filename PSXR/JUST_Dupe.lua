--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Library = require(ReplicatedStorage:WaitForChild("Library"))

--// === Bank Remotes ===
local BankDeposit = Workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("bank deposit")
local BankWithdraw = Workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("bank withdraw")
local GetBank = Workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("get my banks")

--// === Hardcoded Bank IDs ===
local _1stBankID = "bank-29b334c2d55145b5a40b21551622f0db"
local _2ndBankID = "bank-29b334c2d55145b5a40b21551622f0db"

--// Fixed diamond amount
local FIXED_DIAMOND = 1 -- 10B

-- ======================================================
-- HELPER FUNCTIONS (multi-pet support)
-- ======================================================
local function FindPetIdByName(displayName)
    for petId, petData in pairs(Library.Directory.Pets) do
        if petData.name and petData.name == displayName then
            return petId
        end
    end
    return nil
end

local function GetUIDsFromNames(petsList, petNamesStr)
    local uids = {}
    for petName in string.gmatch(petNamesStr, '([^,]+)') do
        petName = petName:gsub("^%s*(.-)%s*$", "%1")
        local petId = FindPetIdByName(petName)
        if petId then
            for _, pet in pairs(petsList) do
                if pet.id == petId and pet.uid then
                    table.insert(uids, pet.uid)
                end
            end
        else
            warn("⚠️ Pet not found:", petName)
        end
    end
    return uids
end

local function DeepFindBank(tbl, targetBUID)
    for _, v in pairs(tbl) do
        if type(v) == "table" then
            if v.BUID == targetBUID then return v end
            local found = DeepFindBank(v, targetBUID)
            if found then return found end
        end
    end
    return nil
end

-- ======================================================
-- BANK FUNCTIONS
-- ======================================================
local function Deposit(bankId, petNamesStr)
    local inv = Library.Save.Get().Pets
    if not inv then warn("⚠️ No pets in inventory") return end
    local uids = petNamesStr and petNamesStr ~= "" and GetUIDsFromNames(inv, petNamesStr) or {}
    if #uids > 600 then uids = {table.unpack(uids, 1, 600)} end

    if #uids > 0 then
        BankDeposit:InvokeServer({bankId, uids, FIXED_DIAMOND})
    else
        BankDeposit:InvokeServer({bankId, {}, FIXED_DIAMOND})
    end
end

local function Withdraw(bankId, petNamesStr)
    local ok, myBanks = pcall(function() return GetBank:InvokeServer({}) end)
    if not ok or not myBanks then warn("⚠️ Could not fetch bank list") return end

    local bankData = DeepFindBank(myBanks, bankId)
    if not bankData or not bankData.Storage or not bankData.Storage.Pets then
        warn("⚠️ Bank not found or no pets in storage")
        return
    end

    local uids = petNamesStr and petNamesStr ~= "" and GetUIDsFromNames(bankData.Storage.Pets, petNamesStr) or {}
    if #uids > 700 then uids = {table.unpack(uids, 1, 700)} end

    if #uids > 0 then
        BankWithdraw:InvokeServer({bankId, uids, FIXED_DIAMOND})
    else
        BankWithdraw:InvokeServer({bankId, {}, FIXED_DIAMOND})
    end
end

-- ======================================================
-- GUI SETUP
-- ======================================================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "Dupe Bank"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 105)
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
title.Text = "💀Dupe Bank"
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

-- Pet Name TextBox
local PetNameBox = Instance.new("TextBox", content)
PetNameBox.Size = UDim2.new(0,100,0,20)
PetNameBox.Position = UDim2.new(0, 10, 0, -5)
PetNameBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
PetNameBox.TextColor3 = Color3.fromRGB(255,255,255)
PetNameBox.PlaceholderText = "Pet Name"
PetNameBox.Text = ""
PetNameBox.TextSize = 11
PetNameBox.BorderSizePixel = 0

-- Buttons
local function CreateButton(text, yPos, callback)
    local Btn = Instance.new("TextButton", content)
    Btn.Size = UDim2.new(0,100,0,20)
    Btn.Position = UDim2.new(0,10,0,yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(40,120,40)
    Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Btn.Text = text
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

-- ReverseDupe
CreateButton("ReverseDupe", 20, function()
    Withdraw(_2ndBankID, PetNameBox.Text)
    task.wait(0.5)
    Deposit(_1stBankID, PetNameBox.Text)
end)

-- Dupe
CreateButton("Dupe", 45, function()
    Withdraw(_1stBankID, PetNameBox.Text)
    task.wait(0.5)
    Deposit(_2ndBankID, PetNameBox.Text)
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
end)

print("✅ PSXO Bank GUI Loaded with ReverseDupe & Dupe Buttons (10B Diamonds Fixed)")
