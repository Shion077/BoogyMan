--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local Buy100Egg = Workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("purchase exclusive egg 2")
local openEgg = Workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("exclusive eggs: open")

local BankDeposit = Workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("bank deposit")
local BankWithdraw = Workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("bank withdraw")

local DeletePetsRemote = Workspace:WaitForChild("__THINGS"):WaitForChild("__REMOTES"):WaitForChild("delete several pets") 

--// Library
local Library = require(ReplicatedStorage:WaitForChild("Library"))

--// CONFIG
local eggName = "Exclusive Cat Egg"
local NoOfToOpen = 8
local TARGET_NAMES = { "DarkLord Ghoul Horse", "Evil Ghoul Horse" }
local GEMSBANK_ID = "bank-fb2ed956005b49ab8799f4187fc7515c"
local STOREBANK_ID = "bank-9f6802eb4b0c4cba929e9cc7e9b871d3"
local FIXED_DIAMOND = 9750000000
local positions = {
    Vector3.new(-8, 90, 246),
    Vector3.new(-14, 90, 237),
    Vector3.new(-10, 90, 258),
    Vector3.new(-25, 90, 234),
    Vector3.new(-20, 90, 264),
    Vector3.new(-35, 90, 240),
    Vector3.new(-31, 90, 261),
    Vector3.new(-37, 90, 251),
}

-- ======================================================
-- GUI SETUP
-- ======================================================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "Afk Hatch"
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
title.Text = "💀Afk Hatch"
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

-- Helper: Get pet by UID
local function GetPetByUID(uid)
    local pets = Library.Save.Get().Pets
    for _, pet in ipairs(pets) do
        if pet.uid == uid then
            return pet
        end
    end
    return nil
end

-- Helper: Check if a pet name is a target
local function IsTargetPet(name)
    for _, target in ipairs(TARGET_NAMES) do
        if name == target then
            return true
        end
    end
    return false
end

-- Collect only target pets
local function CollectTargetPets()
    local save = Library.Save.Get()
    if not save or not save.Pets then return {} end

    local petsByName = {}
    for _, pet in ipairs(save.Pets) do
        local petData = Library.Directory.Pets[pet.id]
        if petData and IsTargetPet(petData.name) then
            if not petsByName[petData.name] then
                petsByName[petData.name] = {}
            end
            table.insert(petsByName[petData.name], pet.uid)
        end
    end
    return petsByName
end

-- Optimized DeletePipeline for target pets only
local function DeletePipeline()
    while autoRunning do
        

-- Bank
local function WithdrawDiamonds(bankId)
    BankWithdraw:InvokeServer({ bankId, {}, FIXED_DIAMOND })
end

local function DepositDarkMatter(bankId)
    local inv = Library.Save.Get().Pets
    if not inv then return end
    local uids = {}
    for _, pet in pairs(inv) do
        if pet.dm == true and pet.uid then
            table.insert(uids, pet.uid)
        end
    end
    if #uids > 0 then
        BankDeposit:InvokeServer({ bankId, uids, 0 })
    end
end

-- Egg Pipeline
local function Buy400Eggs()
    for i = 1, 4 do
        Buy100Egg:InvokeServer({100})
        task.wait(0.3)
    end
end

local function AutoOpenEgg()
    local save = Library.Save.Get()
    if not save or not save.Pets then return end
    local uids = {}
    for _, pet in ipairs(save.Pets) do
        local petData = Library.Directory.Pets[pet.id]
        local pname = petData and petData.name:lower() or pet.id:lower()
        if pname == eggName:lower() then
            table.insert(uids, pet.uid)
        end
    end
    for i = 1, #uids, NoOfToOpen do
        local batch = {}
        for j = i, math.min(i+NoOfToOpen-1, #uids) do
            table.insert(batch, uids[j])
        end
        if #batch > 0 then
            openEgg:InvokeServer({batch[1], #batch, positions})
            task.wait(0.1)
        end
    end
end

-- ======================================================
-- Threads
-- ======================================================
local function EggPipeline()
    while autoRunning do
        WithdrawDiamonds(GEMSBANK_ID)
        task.wait(0.5)
        Buy400Eggs()
        AutoOpenEgg()
        DepositDarkMatter(STOREBANK_ID)
        task.wait(0.5)
    end
end

-- Button
SwitchFuseBtn.MouseButton1Click:Connect(function()
    autoRunning = not autoRunning
    updateButtonUI()
    if autoRunning then
        task.spawn(EggPipeline)
        task.spawn(DeletePipeline)
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
