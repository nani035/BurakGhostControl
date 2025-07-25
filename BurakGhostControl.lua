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
