-- BurakGhostControl.lua | 👻 Floating UI for Manual Control | By Burak

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Remotes (Adjust names if different in your game)
local spawnPetRemote = ReplicatedStorage:FindFirstChild("SpawnPet")
local spawnSeedRemote = ReplicatedStorage:FindFirstChild("SpawnSeed")
local eggInfoRemote = ReplicatedStorage:FindFirstChild("EggInfo")
local changeEggPetRemote = ReplicatedStorage:FindFirstChild("ChangeEggPet")

-- Data Options
local petOptions = {"Bee", "Butterfly", "Snail", "Dragon Fly"}
local seedOptions = {"Sunflower Seed", "Pumpkin Seed", "Magic Bean"}
local hatchChangeOptions = {"Bee", "Butterfly", "Snail"}

-- Create UI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "BurakGhostControlUI"

-- Ghost Icon Button
local ghostBtn = Instance.new("TextButton", ScreenGui)
ghostBtn.Size = UDim2.new(0, 50, 0, 50)
ghostBtn.Position = UDim2.new(0.015, 0, 0.3, 0)
ghostBtn.Text = "👻"
ghostBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ghostBtn.TextColor3 = Color3.new(1, 1, 1)
ghostBtn.TextScaled = true
ghostBtn.Draggable = true
ghostBtn.BackgroundTransparency = 0.3
ghostBtn.BorderSizePixel = 0

-- Function to create buttons
local function makeButton(name, offsetY, callback)
	local btn = Instance.new("TextButton", ScreenGui)
	btn.Size = UDim2.new(0, 180, 0, 30)
	btn.Position = UDim2.new(0.015, 60, 0.3 + offsetY, 0)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextScaled = true
	btn.BorderSizePixel = 0
	btn.Visible = false
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Toggle visibility
local buttons = {}
local toggled = false
local function toggleUI()
	toggled = not toggled
	for _, btn in ipairs(buttons) do
		btn.Visible = toggled
	end
end
ghostBtn.MouseButton1Click:Connect(toggleUI)

-- Controls
local speedOn = false
local jumpOn = false

table.insert(buttons, makeButton("⚡ Toggle Speed", 0, function()
	speedOn = not speedOn
	Humanoid.WalkSpeed = speedOn and 50 or 16
end))

table.insert(buttons, makeButton("🦘 Toggle Jump", 0.07, function()
	jumpOn = not jumpOn
	Humanoid.JumpPower = jumpOn and 120 or 50
end))

table.insert(buttons, makeButton("🐾 Spawn One Pet", 0.14, function()
	local pet = petOptions[math.random(1, #petOptions)]
	local age = math.random(1, 100)
	local weight = math.random(1, 20)
	if spawnPetRemote then
		spawnPetRemote:FireServer(pet, age, weight)
		StarterGui:SetCore("SendNotification", {
			Title = "Pet Spawned",
			Text = pet .. " (Age: " .. age .. ", Weight: " .. weight .. ")",
			Duration = 4
		})
	end
end))

table.insert(buttons, makeButton("🌱 Spawn One Seed", 0.21, function()
	local seed = seedOptions[math.random(1, #seedOptions)]
	if spawnSeedRemote then
		spawnSeedRemote:FireServer(seed)
		StarterGui:SetCore("SendNotification", {
			Title = "Seed Spawned",
			Text = seed,
			Duration = 4
		})
	end
end))

table.insert(buttons, makeButton("🥚 Show Egg Info", 0.28, function()
	if eggInfoRemote then
		local result = eggInfoRemote:InvokeServer()
		StarterGui:SetCore("SendNotification", {
			Title = "Egg Info",
			Text = "Type: " .. result.Type .. "\nReady: " .. tostring(result.Ready),
			Duration = 4
		})
	end
end))

table.insert(buttons, makeButton("🔁 Change Hatch Egg", 0.35, function()
	if changeEggPetRemote then
		local pet = hatchChangeOptions[math.random(1, #hatchChangeOptions)]
		changeEggPetRemote:FireServer(pet)
		StarterGui:SetCore("SendNotification", {
			Title = "Hatch Changed",
			Text = "New: " .. pet,
			Duration = 4
		})
	end
end))

-- Auto reapply stats
LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(1)
	local hum = char:WaitForChild("Humanoid")
	if speedOn then hum.WalkSpeed = 50 end
	if jumpOn then hum.JumpPower = 120 end
end)
