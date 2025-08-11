-- Auto-skip egg animation on script execution

-- Wait for game to load
repeat wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Wait for the "Open Eggs" script to be present
local OpenEggsScriptEnv
local function getOpenEggsEnv()
	local success, result = pcall(function()
		local openEggsScript = LocalPlayer:WaitForChild("PlayerScripts")
			:WaitForChild("Scripts")
			:WaitForChild("Game")
			:WaitForChild("Open Eggs", 10)
		return getsenv(openEggsScript)
	end)
	return success and result or nil
end

-- Keep trying until it's hooked
while not OpenEggsScriptEnv do
	OpenEggsScriptEnv = getOpenEggsEnv()
	wait(0.1)
end

-- Overwrite the OpenEgg function to disable animation
if OpenEggsScriptEnv and OpenEggsScriptEnv.OpenEgg then
	OpenEggsScriptEnv.OpenEgg = function(...)
		return true -- Skip animation
	end
end
