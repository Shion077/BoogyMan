--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

--// Library & Remotes
local Library = require(ReplicatedStorage:WaitForChild("Library"))
local DeletePetsRemote = Workspace.__THINGS.__REMOTES["delete several pets"]

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
-- DELETE PETS
-- ======================================================
local function DeletePetsByName(petNamesStr)
    local save = Library.Save.Get()
    if not save or not save.Pets then
        warn("⚠️ No save data or Pets found")
        return
    end

    local pets = save.Pets
    if typeof(pets) == "string" then
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(pets)
        end)
        if success and decoded then
            pets = decoded
        else
            warn("⚠️ Failed to decode Pets data")
            return
        end
    end

    local uids = GetUIDsFromNames(pets, petNamesStr)

    if #uids > 0 then
        DeletePetsRemote:InvokeServer({uids})
        print("✅ Deleted pets:", table.concat(uids, ", "))
    else
        warn("❌ No pets matched the names:", petNamesStr)
    end
end

-- ======================================================
-- 💀 GUI Setup (BoogyMan Pet Delete)
-- ======================================================

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "PetDelete"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 120, 0, 80)
frame.Position = UDim2.new(0.5, -160, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Header
local header = Instance.new("Frame", frame)
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 20)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel", header)
title.Text = "💀Pet Delete"
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

-- PetName Box
local PetNameBox = Instance.new("TextBox", content)
PetNameBox.Size = UDim2.new(0, 100, 0, 20)
PetNameBox.Position = UDim2.new(0, 10, 0, -5)
PetNameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PetNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PetNameBox.PlaceholderText = "Pet Name(s)"
PetNameBox.Text = "Dog, Cat"
PetNameBox.TextSize = 11
PetNameBox.BorderSizePixel = 0

-- Delete Button
local DeleteBtn = Instance.new("TextButton", content)
DeleteBtn.Size = UDim2.new(0, 100, 0, 20)
DeleteBtn.Position = UDim2.new(0, 10, 0, 20)
DeleteBtn.Text = "Delete Pets"
DeleteBtn.TextSize = 11
DeleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DeleteBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
DeleteBtn.BorderSizePixel = 0
Instance.new("UICorner", DeleteBtn).CornerRadius = UDim.new(0, 6)

DeleteBtn.MouseButton1Click:Connect(function()
    local petNames = PetNameBox.Text
    if petNames and petNames ~= "" then
        DeletePetsByName(petNames)
    else
        warn("❌ Enter at least one pet name")
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

print("✅ BoogyMan Pet Delete UI Loaded with Multi-Pet Support")
