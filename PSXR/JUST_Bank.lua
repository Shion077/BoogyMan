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
			if count == index then
				return obj
			end
		end
	end
	return nil
end

local BankDeposit = getRemote(115)
local BankWithdraw = getRemote(116)
local GetBank = getRemote(110)

-- ======================================================
-- INLINE BANK IDs (Name + ID)
-- ======================================================
local MyBankIDs = {
	{"PetStorage", "bank-8cd63833f10b4fde963798a3494bc092"},
	{"Think_About", "bank-2d6afacf3d814071aee6fc59bb22f2fe"}, 
   {"test", "bank-4903404f7f2b4b8e995735043b4c9b5a"}
}

-- ======================================================
-- HELPER: Get UIDs from pet names
-- ======================================================
local function GetUIDsFromNames(petsList, petNamesStr)
	local uids = {}
	for petName in string.gmatch(petNamesStr, '([^,]+)') do
		petName = petName:gsub("^%s*(.-)%s*$", "%1")
		local lowerName = string.lower(petName)

		for uid, pet in pairs(petsList) do
			local realUID = typeof(uid) == "number" and pet.uid or uid
			local petData = Library.Directory.Pets[pet.id]
			local displayName = petData and petData.name
			if displayName and string.lower(displayName) == lowerName then
				table.insert(uids, realUID)
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
	if not inv then return end

	local uids = GetUIDsFromNames(inv, petNamesStr)
	if #uids == 0 then return end
	if #uids > 700 then
		uids = {table.unpack(uids, 1, 700)}
	end

	BankDeposit:InvokeServer(bankId, uids, 0)
end

-- ======================================================
-- WITHDRAW (Pets only, uses GetBank directly)
-- ======================================================
local function Withdraw(bankId, petNamesStr)
	local ok, bankData = pcall(function()
		return GetBank:InvokeServer(bankId)
	end)
	if not ok or not bankData or not bankData.Storage or not bankData.Storage.Pets then return end

	local uids = GetUIDsFromNames(bankData.Storage.Pets, petNamesStr)
	if #uids == 0 then return end
	if #uids > 700 then
		uids = {table.unpack(uids, 1, 700)}
	end

	BankWithdraw:InvokeServer(bankId, uids, 0)
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

local content = Instance.new("Frame", frame)
content.Position = UDim2.new(0, 0, 0, 25)
content.Size = UDim2.new(1, 0, 1, -25)
content.BackgroundTransparency = 1

local PetNameBox = Instance.new("TextBox", content)
PetNameBox.Size = UDim2.new(0, 100, 0, 20)
PetNameBox.Position = UDim2.new(0, 10, 0, 20)
PetNameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PetNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PetNameBox.PlaceholderText = "Pet Name"
PetNameBox.Text = "Exclusive Eyes Egg"
PetNameBox.TextSize = 11
PetNameBox.BorderSizePixel = 0
Instance.new("UICorner", PetNameBox).CornerRadius = UDim.new(0, 8)

local BankBox = Instance.new("TextButton", content)
BankBox.Size = UDim2.new(0, 100, 0, 20)
BankBox.Position = UDim2.new(0, 10, 0, -5)
BankBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BankBox.TextColor3 = Color3.fromRGB(255, 255, 255)
BankBox.Text = "Choose Bank"
BankBox.TextSize = 11
BankBox.BorderSizePixel = 0
Instance.new("UICorner", BankBox).CornerRadius = UDim.new(0, 8)

-- ======================================================
-- 💀 Fixed Dropdown Layout
-- ======================================================
local dropdown = Instance.new("Frame", content)
dropdown.Size = UDim2.new(0, 100, 0, 0)
dropdown.Position = UDim2.new(0, 120, 0, -5) -- appears just under Choose Bank
dropdown.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
dropdown.BorderSizePixel = 0
dropdown.Visible = false
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

-- layout + padding fix
local layout = Instance.new("UIListLayout", dropdown)
layout.Padding = UDim.new(0, 3)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding", dropdown)
padding.PaddingTop = UDim.new(0, 4)
padding.PaddingBottom = UDim.new(0, 4)

local SelectedBankID = nil

for _, entry in ipairs(MyBankIDs) do
	local displayName, bankId = entry[1], entry[2]

	local row = Instance.new("TextButton", dropdown)
	row.Size = UDim2.new(1, -10, 0, 20)
	row.Text = displayName
	row.TextSize = 11
	row.TextColor3 = Color3.fromRGB(255, 255, 255)
	row.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	row.BorderSizePixel = 0
	row.AutoButtonColor = true
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

	-- hover effect (optional)
	row.MouseEnter:Connect(function()
		row.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end)
	row.MouseLeave:Connect(function()
		row.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end)

	row.MouseButton1Click:Connect(function()
		BankBox.Text = displayName
		SelectedBankID = bankId
		dropdown.Visible = false
	end)
end

BankBox.MouseButton1Click:Connect(function()
	dropdown.Visible = not dropdown.Visible
	dropdown.Size = dropdown.Visible and UDim2.new(0, 100, 0, #MyBankIDs * 25) or UDim2.new(0, 100, 0, 0)
end)


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
	end
end)

CreateButton("Withdraw", 70, function()
	if SelectedBankID then
		Withdraw(SelectedBankID, PetNameBox.Text)
	end
end)

-- =========================
-- 🔲 FRAME CONTROL
-- =========================
local isMinimized = false
local originalSize = frame.Size
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    content.Visible = not isMinimized
    frame.Size = isMinimized and UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, header.Size.Y.Offset) or originalSize
    minimizeBtn.Text = isMinimized and "+" or "-"
end)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
