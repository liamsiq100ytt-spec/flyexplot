-- SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- STATES
local flying = false
local infJump = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MobileFlyGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 140)
frame.Position = UDim2.new(0, 20, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- BUTTON CREATOR
local function createButton(text, posY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 50)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.Text = text
	btn.TextScaled = true
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Parent = frame

	local c = Instance.new("UICorner", btn)
	c.CornerRadius = UDim.new(0, 10)

	return btn
end

local flyButton = createButton("Fly: OFF", 10)
local jumpButton = createButton("Inf Jump: OFF", 70)

-- FLY SETUP
local bodyGyro = Instance.new("BodyGyro")
bodyGyro.P = 9e4
bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)

local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

-- FLY LOOP
RunService.RenderStepped:Connect(function()
	if flying then
		bodyGyro.CFrame = workspace.CurrentCamera.CFrame
		bodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
	end
end)

-- FLY BUTTON
flyButton.MouseButton1Click:Connect(function()
	flying = not flying

	if flying then
		bodyGyro.Parent = root
		bodyVelocity.Parent = root
		humanoid.PlatformStand = true
		flyButton.Text = "Fly: ON"
	else
		bodyGyro.Parent = nil
		bodyVelocity.Parent = nil
		humanoid.PlatformStand = false
		flyButton.Text = "Fly: OFF"
	end
end)

-- INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
	if infJump then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- INF JUMP BUTTON
jumpButton.MouseButton1Click:Connect(function()
	infJump = not infJump
	jumpButton.Text = infJump and "Inf Jump: ON" or "Inf Jump: OFF"
end)
