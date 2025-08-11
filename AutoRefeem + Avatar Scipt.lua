-- 🔄 Auto Redeem All Codes Instantly
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local redeemRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("REDEEM_CODE")

-- 🧠 List of codes to redeem
local codeList = {
    "UPDATE18",
    "FREEHUGE",
    "TRADEPLAZA",
    "UPDATE16",
    "UPDATE17",
    "BRAINROT",
    "UPDATE15",
    "X3EVENT",
    "FreeRewards101",
    "FreePotions321",
    "IceRewards221"
}

-- 🔁 Redeem all codes
for _, code in ipairs(codeList) do
    pcall(function()
        redeemRemote:FireServer(code)
        print("✅ Redeemed:", code)
        wait(0.5)
    end)
end

print("🎉 All codes attempted.")

loadstring(game:HttpGet("https://raw.githubusercontent.com/IdiotHub/Scripts/refs/heads/main/Avatar%20Fighting%20Simulator/main.lua"))()
