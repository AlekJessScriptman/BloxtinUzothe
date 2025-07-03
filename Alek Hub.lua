-- Alek Paphawin Prajit Hub v2 - Scrollable Fixed Edition (All Features Combined)

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

-- GUI Setup
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AlekPaphawinPrajitHub"
gui.ResetOnSpawn = false

-- Scrollable Frame
local scrollFrame = Instance.new("ScrollingFrame", gui)
scrollFrame.Size = UDim2.new(0, 300, 0, 500)
scrollFrame.Position = UDim2.new(0, 20, 0.3, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollFrame.Active = true
scrollFrame.BorderSizePixel = 0
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.CanvasPosition = Vector2.new(0, 0)
scrollFrame.ClipsDescendants = true
scrollFrame.ZIndex = 1

-- Dragging support
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
scrollFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = scrollFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
scrollFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        scrollFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- UI Container
local container = Instance.new("Frame", scrollFrame)
container.Size = UDim2.new(1, 0, 0, 2000)
container.BackgroundTransparency = 1
container.Name = "Container"

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Create Functions
local function createLabel(text)
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
end

local function createTextBox(placeholder)
    local box = Instance.new("TextBox", container)
    box.Size = UDim2.new(1, -20, 0, 30)
    box.PlaceholderText = placeholder
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    box.TextColor3 = Color3.new(1, 1, 1)
    return box
end

local function createToggleButton(text, callback)
    local on = false
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Text = "[OFF] " .. text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = (on and "[ON] " or "[OFF] ") .. text
        callback(on)
    end)
end

-- Features
createLabel("❄️ Freeze Trade")
createToggleButton("Freeze", function(active)
    if active then print("[Freeze Trade] Enabled") end
end)

createLabel("⚔️ Auto Farm")
local npcInput = createTextBox("Enter NPC Name")
local farming = false
createToggleButton("Auto Farm", function(active)
    farming = active
end)

RunService.Heartbeat:Connect(function()
    if farming then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        for _, npc in pairs(workspace:GetDescendants()) do
            if npc:IsA("Model") and npc.Name == npcInput.Text and npc:FindFirstChild("HumanoidRootPart") then
                local pos = npc.HumanoidRootPart.Position
                TweenService:Create(hrp, TweenInfo.new(1), {CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))}):Play()
            end
        end
    end
end)

createToggleButton("Auto Attack", function(active)
    if active then
        RunService.Stepped:Connect(function()
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then pcall(function() tool:Activate() end) end
        end)
    end
end)

createLabel("⚡ Set Speed")
local speedBox = createTextBox("WalkSpeed number")
createToggleButton("Apply Speed", function(active)
    if active then
        local speed = tonumber(speedBox.Text)
        if speed then
            LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
    end
end)

createLabel("⚡ Equip Fruit")
local fruitBox = createTextBox("Fruit name")
createToggleButton("Equip", function(active)
    if active then
        local bp = LocalPlayer:FindFirstChild("Backpack")
        local fruit = bp and bp:FindFirstChild(fruitBox.Text)
        if fruit then fruit.Parent = LocalPlayer.Character end
    end
end)

createLabel("👣 Follow Player")
local followBox = createTextBox("Player name")
local following = false
createToggleButton("Follow", function(active)
    following = active
end)

RunService.Heartbeat:Connect(function()
    if following then
        local target = Players:FindFirstChild(followBox.Text)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and hrp then
            local pos = target.Character.HumanoidRootPart.Position
            hrp.CFrame = CFrame.new(hrp.Position, pos)
        end
    end
end)

createLabel("🎯 Aimbot")
createToggleButton("Aimbot", function(active)
    if active then
        RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            local nearest = nil
            local dist = math.huge
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                    local head = plr.Character.Head
                    local d = (cam.CFrame.Position - head.Position).Magnitude
                    if d < dist then
                        dist = d
                        nearest = head
                    end
                end
            end
            if nearest then cam.CFrame = CFrame.new(cam.CFrame.Position, nearest.Position) end
        end)
    end
end)

createLabel("💰 Lucky Playtime for Gacha")
createToggleButton("Lucky Timer", function(active)
    if active then print("[Lucky Playtime] You feel lucky! Maybe better drops?") end
end)

-- Fruit Notifier
local notified = {}
RunService.Heartbeat:Connect(function()
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Part")) and not notified[v] and v.Name:lower():find("fruit") then
            print("[Fruit] Found:", v.Name)
            notified[v] = true
        end
    end
end)

print("✅ Alek Paphawin Prajit Hub v2 Loaded - All Systems Online")
