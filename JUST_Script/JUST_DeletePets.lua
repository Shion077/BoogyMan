local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local deletePetsRemote = ReplicatedStorage:WaitForChild("Delete Several Pets")
local Library = require(ReplicatedStorage:WaitForChild("Library"))

-- Function to delete pets by name (case-insensitive)
local function DeletePetsByName(petName)
    local save = Library.Save.Get()
    if not save or not save.Pets then return end

    local uids = {}
    for _, pet in ipairs(save.Pets) do
        local petData = Library.Directory.Pets[pet.id]
        local name = petData and petData.name:lower() or pet.id:lower()
        if name == petName:lower() then
            table.insert(uids, pet.uid)
        end
    end

    if #uids > 0 then
        deletePetsRemote:InvokeServer(uids)
        print("Deleted pets:", table.concat(uids, ", "))
    else
        warn("No pets found with name:", petName)
    end
end

-- GUI Setup
local boostRemote = ReplicatedStorage:WaitForChild("Activate Server Boost")
local gui = Instance.new("ScreenGui")
gui.Name = "PSXO Boost"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 80)
frame.Position = UDim2.new(0.5, -160, 0.5, -135)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 20)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
header.BorderSizePixel = 0
header.Parent = frame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Title Label
local title = Instance.new("TextLabel")
title.Text = "💀PSXO Boost"
title.Font = Enum.Font.GothamBold
title.TextSize = 10
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Parent = header

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Size = UDim2.new(0, 15, 0, 15)
closeBtn.Position = UDim2.new(0, 100, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Size = UDim2.new(0, 15, 0, 15)
minimizeBtn.Position = UDim2.new(0, 82, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Parent = header

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(1, 0)
minimizeCorner.Parent = minimizeBtn

-- Content Frame
local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.new(0, 0, 0, 30)
content.Size = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = 1
content.Parent = frame

-- UI setup
local PetNameBox = Instance.new("TextBox", content)
PetNameBox.Size = UDim2.new(0, 100, 0, 20)
PetNameBox.Position = UDim2.new(0, 10, 0, -5)
PetNameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PetNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PetNameBox.PlaceholderText = "Pet Name"
PetNameBox.Text = "Exclusive Lucky Egg"
PetNameBox.TextSize = 11
PetNameBox.BorderSizePixel = 0

local DeletePets = Instance.new("TextButton", content)
DeletePets.Size = UDim2.new(0, 100, 0, 20)
DeletePets.Position = UDim2.new(0, 10, 0, 20)
DeletePets.Text = "Delete Pets"
DeletePets.TextSize = 11
DeletePets.TextColor3 = Color3.fromRGB(255, 255, 255)
DeletePets.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
DeletePets.BorderSizePixel = 0
Instance.new("UICorner", DeletePets).CornerRadius = UDim.new(0, 6)

DeletePets.MouseButton1Click:Connect(function()
    local petName = PetNameBox.Text
    if petName and petName ~= "" then
        DeletePetsByName(petName) -- deletes ALL with matching name (case-insensitive)
    else
        warn("Please enter a pet name first.")
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



