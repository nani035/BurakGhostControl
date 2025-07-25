-- BurakGhostControl | Zysumi-style Floating Menu 👻
-- Author: Burak

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Remote References
local spawnPetRemote = ReplicatedStorage:FindFirstChild("SpawnPet")
local spawnSeedRemote = ReplicatedStorage:FindFirstChild("SpawnSeed")
local eggInfoRemote = ReplicatedStorage:FindFirstChild("EggInfo")
local changeEggPetRemote = ReplicatedStorage:FindFirstChild("ChangeEggPet")

-- Pet and Seed Lists
local petOptions = {"Bee", "Butterfly", "Snail", "Dragon Fly"}
local seedOptions = {"Sunflower Seed", "Pumpkin Seed", "Magic Bean"}

-- Setup UI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "BurakGhostUI"
ScreenGui.ResetOnSpawn = false

local ghostBtn = Instance.new("TextButton", ScreenGui)
ghostBtn.Size = UDim2.new(0, 50, 0, 50)
ghostBtn.Position = UDim2.new(0.015, 0, 0.4, 0)
ghostBtn.Text = "👻"
ghostBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ghostBtn.TextScaled = true
ghostBtn.TextColor3 = Color3.new(1, 1, 1)
ghostBtn.BackgroundTransparency = 0.3
ghostBtn.BorderSizePixel = 0
ghostBtn.Draggable = true

-- Create Command Button
local function makeButton(name, offsetY, callback)
	local btn = Instance.new("TextButton", ScreenGui)
	btn.Size = UDim2.new(0, 180, 0, 35)
	btn.Position = UDim2.new(0.015, 60, 0.4 + offsetY, 0)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextScaled = true
	btn.BorderSizePixel = 0
	btn.Visible = false
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Functionality
local speedOn, jumpOn = false, false
local function toggleSpeed()
	speedOn = not speedOn
	humanoid.WalkSpeed = speedOn and 50 or 16
end

local function toggleJump()
	jumpOn = not jumpOn
	humanoid.JumpPower = jumpOn and 120 or 50
end

local function spawnChosenPet()
	local petName = petOptions[math.random(1, #petOptions)]
	local age = math.random(1, 80)
	local weight = math.random(1, 20)
	if spawnPetRemote then
		spawnPetRemote:FireServer(petName, age, weight)
	end
end

local function spawnChosenSeed()
	local seedName = seedOptions[math.random(1, #seedOptions)]
	if spawnSeedRemote then
		spawnSeedRemote:FireServer(seedName)
	end
end

local function showEggInfo()
	if eggInfoRemote then
		local result = eggInfoRemote:InvokeServer()
		game.StarterGui:SetCore("SendNotification", {
			Title = "🥚 Egg Info",
			Text = "Type: " .. result.Type .. "\nReady: " .. tostring(result.Ready),
			Duration = 4
		})
	end
end

local function changeEgg()
	local newPet = petOptions[math.random(1, #petOptions)]
	if changeEggPetRemote then
		changeEggPetRemote:FireServer(newPet)
	end
end

-- Buttons
local btnSpeed = makeButton("⚡ Toggle Speed", 0.00, toggleSpeed)
local btnJump = makeButton("🦘 Toggle Jump", 0.07, toggleJump)
local btnPet = makeButton("🐾 Spawn Pet (Pick)", 0.14, spawnChosenPet)
local btnSeed = makeButton("🌱 Spawn Seed (Pick)", 0.21, spawnChosenSeed)
local btnEgg = makeButton("🥚 Egg Info", 0.28, showEggInfo)
local btnChange = makeButton("🧬 Change Hatch", 0.35, changeEgg)

-- Toggle visibility
local toggled = false
ghostBtn.MouseButton1Click:Connect(function()
	toggled = not toggled
	btnSpeed.Visible = toggled
	btnJump.Visible = toggled
	btnPet.Visible = toggled
	btnSeed.Visible = toggled
	btnEgg.Visible = toggled
	btnChange.Visible = toggled
end)

-- Reapply after respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
	char = newChar
	humanoid = char:WaitForChild("Humanoid")
	if speedOn then humanoid.WalkSpeed = 50 end
	if jumpOn then humanoid.JumpPower = 120 end
end)-- BurakGhostControl.lua | Zysumi-style Floating UI by Burak

local Players = game:GetService("Players") local ReplicatedStorage = game:GetService("ReplicatedStorage") local LocalPlayer = Players.LocalPlayer local StarterGui = game:GetService("StarterGui")

local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = "BurakGhostUI" ScreenGui.ResetOnSpawn = false ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local ghostIcon = Instance.new("ImageButton") ghostIcon.Size = UDim2.new(0, 50, 0, 50) ghostIcon.Position = UDim2.new(0, 10, 0.5, -25) ghostIcon.BackgroundTransparency = 1 ghostIcon.Image = "rbxassetid://15750610296" -- 👻 ghost icon ghostIcon.Parent = ScreenGui

local frame = Instance.new("Frame") frame.Size = UDim2.new(0, 250, 0, 300) frame.Position = UDim2.new(0, 70, 0.5, -150) frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) frame.Visible = false frame.Parent = ScreenGui

local uicorner = Instance.new("UICorner", frame) uicorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel") title.Size = UDim2.new(1, 0, 0, 30) title.BackgroundTransparency = 1 title.Text = "Burak Ghost Menu 👻" title.Font = Enum.Font.GothamBold title.TextColor3 = Color3.fromRGB(255, 255, 255) title.TextScaled = true title.Parent = frame

-- Toggle UI local open = false ghostIcon.MouseButton1Click:Connect(function() open = not open frame.Visible = open end)

-- Buttons local function makeButton(text, order, callback) local button = Instance.new("TextButton") button.Size = UDim2.new(1, -20, 0, 30) button.Position = UDim2.new(0, 10, 0, 35 + (order * 35)) button.BackgroundColor3 = Color3.fromRGB(45, 45, 45) button.Text = text button.Font = Enum.Font.Gotham button.TextColor3 = Color3.fromRGB(255, 255, 255) button.TextScaled = true button.Parent = frame

Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

button.MouseButton1Click:Connect(callback)

end

-- Speed makeButton("Toggle Speed (50)", 0, function() local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() local hum = char:FindFirstChildOfClass("Humanoid") if hum then hum.WalkSpeed = hum.WalkSpeed == 16 and 50 or 16 end end)

-- Jump makeButton("Toggle Jump (120)", 1, function() local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() local hum = char:FindFirstChildOfClass("Humanoid") if hum then hum.JumpPower = hum.JumpPower == 50 and 120 or 50 end end)

-- Seed picker placeholder makeButton("Spawn Selected Seed", 2, function() print("[BurakSpawner] Seed spawn requested") end)

-- Pet picker placeholder makeButton("Spawn Pet (Pick, Age, Weight)", 3, function() print("[BurakSpawner] Pet spawn requested") end)

-- Egg info placeholder makeButton("Show Egg Info", 4, function() print("[BurakSpawner] Egg Info displayed") end)

-- Change hatching egg placeholder makeButton("Change Hatching Egg", 5, function() print("[BurakSpawner] Hatching egg changed") end)

print("[BurakGhostControl] Loaded!")

-- BurakGhostControl.lua | 👻 Floating Manual Pet & Seed Controller

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--⚙️ SETTINGS:
local ghostLogo = "👻" -- You can change this to 🐱, 🐉, 🧠 etc.
local petOptions = {"Bee", "Butterfly", "Snail", "Dragon Fly"}
local seedOptions = {"Sunflower Seed", "Pumpkin Seed", "Magic Bean"}
local hatchChangeOptions = {"Bee", "Butterfly", "Snail"}

--🧠 UI SETUP (Floating ghost logo):
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "BurakGhostControlUI"
local ghostButton = Instance.new("TextButton", screenGui)
ghostButton.Size = UDim2.new(0, 50, 0, 50)
ghostButton.Position = UDim2.new(0.9, 0, 0.4, 0)
ghostButton.Text = ghostLogo
ghostButton.BackgroundTransparency = 0.3
ghostButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ghostButton.TextColor3 = Color3.new(1, 1, 1)
ghostButton.TextScaled = true
ghostButton.Draggable = true

--📦 Remotes (Adjust these if needed):
local spawnPetRemote = ReplicatedStorage:WaitForChild("SpawnPet")
local spawnSeedRemote = ReplicatedStorage:WaitForChild("SpawnSeed")
local eggInfoRemote = ReplicatedStorage:WaitForChild("EggInfo")
local changeEggPetRemote = ReplicatedStorage:WaitForChild("ChangeEggPet")

--⚡️ Speed & Jump toggle:
local function applyStats()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")
	hum.WalkSpeed = 50
	hum.JumpPower = 120
end
LocalPlayer.CharacterAdded:Connect(function() task.wait(1) applyStats() end)
if LocalPlayer.Character then applyStats() end

--📍 Popup UI function:
local function notify(title, content)
	game.StarterGui:SetCore("SendNotification", {
		Title = title,
		Text = content,
		Duration = 4
	})
end

--🎯 Select and spawn ONE pet:
local function choosePet()
	local petName = petOptions[math.random(1, #petOptions)]
	local age = math.random(1, 100)
	local weight = math.random(1, 20)
	spawnPetRemote:FireServer(petName, age, weight)
	notify("Pet Spawned", petName .. " | Age: " .. age .. ", Weight: " .. weight)
end

--🌱 Spawn ONE seed:
local function chooseSeed()
	local seedName = seedOptions[math.random(1, #seedOptions)]
	spawnSeedRemote:FireServer(seedName)
	notify("Seed Spawned", seedName)
end

--🥚 Egg info display:
local function showEggInfo()
	local result = eggInfoRemote:InvokeServer()
	notify("Egg Info", "Type: " .. result.Type .. "\nReady: " .. tostring(result.Ready))
end

--🧬 Change the pet from hatching egg:
local function changeHatchResult()
	local newPet = hatchChangeOptions[math.random(1, #hatchChangeOptions)]
	changeEggPetRemote:FireServer(newPet)
	notify("Egg Changed", "New Hatch: " .. newPet)
end

--🎮 Manual ghost button logic:
local lastClick = 0
ghostButton.MouseButton1Click:Connect(function()
	if tick() - lastClick < 1 then return end
	lastClick = tick()

	local action = math.random(1, 5)
	if action == 1 then
		choosePet()
	elseif action == 2 then
		chooseSeed()
	elseif action == 3 then
		showEggInfo()
	elseif action == 4 then
		changeHatchResult()
	else
		applyStats()
		notify("Boost Applied", "Speed & Jump boosted!")
	end
end)-- BurakGhostUI.lua | Floating 👻 Control | Made by Burak

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

--🐾 Pet list
local petList = {
    "Dragon Fly", "Caterpillar", "Butterfly", "Bee",
    "Snail", "Fire Fly", "Lady Bug"
}

--🌱 Seed remote (adjust if your game uses a different one)
local spawnSeedRemote = ReplicatedStorage:FindFirstChild("SpawnSeed")
--🐾 Pet remote
local spawnPetRemote = ReplicatedStorage:FindFirstChild("SpawnPet")

--📦 UI Setup
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "BurakGhostUI"
ScreenGui.ResetOnSpawn = false

--👻 Floating Ghost Button
local ghostBtn = Instance.new("TextButton", ScreenGui)
ghostBtn.Size = UDim2.new(0, 50, 0, 50)
ghostBtn.Position = UDim2.new(0.02, 0, 0.3, 0)
ghostBtn.Text = "👻"
ghostBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ghostBtn.TextScaled = true
ghostBtn.TextColor3 = Color3.new(1, 1, 1)
ghostBtn.BackgroundTransparency = 0.3
ghostBtn.BorderSizePixel = 0
ghostBtn.Draggable = true

--⚙️ Floating command buttons
local function makeButton(name, offsetY, callback)
    local btn = Instance.new("TextButton", ScreenGui)
    btn.Size = UDim2.new(0, 130, 0, 35)
    btn.Position = UDim2.new(0.02, 60, 0.3 + offsetY, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.BorderSizePixel = 0
    btn.Visible = false
    btn.MouseButton1Click:Connect(callback)
    return btn
end

--📌 Toggles
local speedEnabled = false
local jumpEnabled = false

local function toggleSpeed()
    speedEnabled = not speedEnabled
    humanoid.WalkSpeed = speedEnabled and 60 or 16
end

local function toggleJump()
    jumpEnabled = not jumpEnabled
    humanoid.JumpPower = jumpEnabled and 120 or 50
end

local function spawnAllPets()
    for _, petName in ipairs(petList) do
        if spawnPetRemote then
            spawnPetRemote:FireServer(petName)
            task.wait(0.2)
        end
    end
end

local function spawnSeed()
    if spawnSeedRemote then
        spawnSeedRemote:FireServer()
    end
end

--🔘 Buttons
local btnSpeed = makeButton("⚡ Speed Run", 0, toggleSpeed)
local btnJump = makeButton("🦘 High Jump", 0.08, toggleJump)
local btnPets = makeButton("🐾 Spawn All Pets", 0.16, spawnAllPets)
local btnSeeds = makeButton("🌱 Spawn Seeds", 0.24, spawnSeed)

--👻 Toggle display on ghost click
local toggled = false
ghostBtn.MouseButton1Click:Connect(function()
    toggled = not toggled
    btnSpeed.Visible = toggled
    btnJump.Visible = toggled
    btnPets.Visible = toggled
    btnSeeds.Visible = toggled
end)

--✅ Auto re-apply on respawn
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = char:WaitForChild("Humanoid")
    if speedEnabled then humanoid.WalkSpeed = 60 end
    if jumpEnabled then humanoid.JumpPower = 120 end
end)-- BurakGhostControl.lua | Made by Burak
-- 👻 Manual Speed, Jump, Seed, and Pet Spawner (Non-Visual)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Control Flags
local toggleSpeed = false
local toggleJump = false

-- Spawn Remotes (placeholders, will adjust based on Grow a Garden setup)
local spawnPetRemote = ReplicatedStorage:FindFirstChild("SpawnPet")
local spawnSeedRemote = ReplicatedStorage:FindFirstChild("SpawnSeed")

-- Manual Command Setup via Ghost Emoji 👻
local ghostGui = Instance.new("BillboardGui", LocalPlayer:WaitForChild("PlayerGui"))
ghostGui.Size = UDim2.new(0, 100, 0, 50)
ghostGui.StudsOffset = Vector3.new(0, 3, 0)
ghostGui.AlwaysOnTop = true

local ghostLabel = Instance.new("TextButton", ghostGui)
ghostLabel.Size = UDim2.new(1, 0, 1, 0)
ghostLabel.BackgroundTransparency = 1
ghostLabel.Text = "👻"
ghostLabel.TextScaled = true
ghostLabel.TextColor3 = Color3.new(1, 1, 1)

-- Toggle control on click
ghostLabel.MouseButton1Click:Connect(function()
	toggleSpeed = not toggleSpeed
	toggleJump = not toggleJump
	humanoid.WalkSpeed = toggleSpeed and 50 or 16
	humanoid.JumpPower = toggleJump and 120 or 50
end)

-- Chat Command Controls
LocalPlayer.Chatted:Connect(function(msg)
	msg = msg:lower()
	if msg == "/spawnseeds" and spawnSeedRemote then
		for _ = 1, 10 do
			spawnSeedRemote:FireServer()
			wait(0.1)
		end
	elseif msg == "/spawnpets" and spawnPetRemote then
		local petList = {"Dragon Fly", "Caterpillar", "Butterfly", "Bee", "Snail", "Fire Fly", "Lady Bug"}
		for _, petName in ipairs(petList) do
			spawnPetRemote:FireServer(petName)
			wait(0.2)
		end
	end
end)
