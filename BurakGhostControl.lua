-- BurakGhostControl.lua | Made by Burak
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
