--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--// Library & Remotes
local Library = require(ReplicatedStorage:WaitForChild("Library"))
local BankDeposit = ReplicatedStorage:WaitForChild("Bank Deposit")
local BankWithdraw = ReplicatedStorage:WaitForChild("Bank Withdraw")

--// Save table for deposited pets
local DepositedPets = {}

--// Functions
local function BuildPetDictionary()
    local petsByName = {}
    local save = Library.Save.Get()
    if not save or not save.Pets then return {} end

    for _, pet in ipairs(save.Pets) do
        local petData = Library.Directory.Pets[pet.id]
        local name = petData and petData.name or pet.id
        petsByName[name] = petsByName[name] or {}
        table.insert(petsByName[name], {uid = pet.uid, name = name})
    end
    return petsByName
end

local function DepositByName(bankId, petName)
    local dict = BuildPetDictionary()
    local list = dict[petName]
    if not list or #list == 0 then
        return warn("❌ You don’t own any:", petName)
    end

    local chosen = list[1] -- always pick the first available
    BankDeposit:InvokeServer(bankId, {chosen.uid})
    print("📤 Deposited:", petName, chosen.uid)

    -- save reference
    DepositedPets[petName] = DepositedPets[petName] or {}
    table.insert(DepositedPets[petName], chosen.uid)
end

local function WithdrawByName(bankId, petName)
    local uuids = DepositedPets[petName]
    if not uuids or #uuids == 0 then
        return warn("❌ No deposited:", petName)
    end

    local uid = table.remove(uuids, 1) -- take one back
    BankWithdraw:InvokeServer(bankId, {uid})
    print("📥 Withdrew:", petName, uid)
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
local function CreateBox(placeholder, yPos)
    local Box = Instance.new("TextBox", content)
    Box.Size = UDim2.new(0, 100, 0, 20)
    Box.Position = UDim2.new(0, 10, 0, yPos)
    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.PlaceholderText = placeholder
    Box.BorderSizePixel = 0
    Box.TextSize = 13
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 8)
    return Box
end

local BankBox = CreateBox("Bank ID", -5)
local PetBox = CreateBox("Pet Name", 20)

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
    DepositByName(BankBox.Text, PetBox.Text)
end)

CreateButton("Withdraw", 70, function()
    WithdrawByName(BankBox.Text, PetBox.Text)
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

print("✅ BoogyMan Bank UI Loaded!")
