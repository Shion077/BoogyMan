-- AntiAfk Title
local AntiAfkTitle = Instance.new("TextLabel", content)
AntiAfkTitle.Size = UDim2.new(0, 180, 0, 25)
AntiAfkTitle.Position = UDim2.new(0, 5, 0, 110)
AntiAfkTitle.BackgroundTransparency = 1
AntiAfkTitle.Text = "Anti-AFK"
AntiAfkTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAfkTitle.TextSize = 14
AntiAfkTitle.Font = Enum.Font.GothamBold

-- AntiAfk Toggle Button
local AntiAfkButton = Instance.new("TextButton", content)
AntiAfkButton.Size = UDim2.new(0, 180, 0, 25)
AntiAfkButton.Position = UDim2.new(0, 10, 0, 140)
AntiAfkButton.Text = "Turn On"
AntiAfkButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
AntiAfkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAfkButton.Font = Enum.Font.SourceSansBold
AntiAfkButton.TextSize = 15

-- Anti-AFK logic
local vu = game:GetService("VirtualUser")
local player = game:GetService("Players").LocalPlayer
local antiAfkEnabled = false
local antiAfkConnection

local function startAntiAfk()
    antiAfkConnection = player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

local function stopAntiAfk()
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
end

AntiAfkButton.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    if antiAfkEnabled then
        startAntiAfk()
        AntiAfkButton.Text = "Turn Off"
        AntiAfkButton.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
    else
        stopAntiAfk()
        AntiAfkButton.Text = "Turn On"
        AntiAfkButton.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
    end
end)
