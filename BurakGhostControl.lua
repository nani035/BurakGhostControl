-- BurakGhostUI.lua | Floating 👻 Control | Made by Burak

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
