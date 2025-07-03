-- Alek Paphawin Prajit Hub v2 - Scrollable Edition (Fixed & Optimized)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- GUI Setup
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AlekPaphawinPrajitHub"
gui.ResetOnSpawn = false

-- Scrollable Frame (no dragging of the entire frame)
local scrollFrame = Instance.new("ScrollingFrame", gui)
scrollFrame.Size = UDim2.new(0, 300, 0, 500)
scrollFrame.Position = UDim2.new(0, 20, 0.3, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 5, 0) -- tall content
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollFrame.Active = true
scrollFrame.BorderSizePixel = 0
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ClipsDescendants = true
scrollFrame.ZIndex = 1

-- Container for UI elements inside scrolling frame
local container = Instance.new("Frame", scrollFrame)
container.Size = UDim2.new(1, 0, 0, 2000)
container.BackgroundTransparency = 1
container.Name = "Container"

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Helper functions for UI elements
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
    
    local connection = nil

    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = (on and "[ON] " or "[OFF] ") .. text
        callback(on, connection)
    end)
end

-- Variables for connections to disconnect on toggle off
local autoFarmConn, autoAttackConn, followConn, aimbotConn

-- Freeze Trade (Stub)
createLabel("❄️ Freeze Trade")
createToggleButton("Freeze", function(active)
    if active then
        print("[Freeze Trade] Enabled (stub)")
        -- Add your freeze trade logic here
    else
        print("[Freeze Trade] Disabled")
    end
end)

-- Auto Farm
createLabel("⚔️ Auto Farm")
local npcInput = createTextBox("Enter NPC Name")

createToggleButton("Auto Farm", function(active)
    if active then
        autoFarmConn = RunService.Heartbeat:Connect(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, npc in pairs(workspace:GetDescendants()) do
                if npc:IsA("Model") and npc.Name == npcInput.Text and npc:FindFirstChild("HumanoidRootPart") then
                    local pos = npc.HumanoidRootPart.Position
                    local tween = TweenService:Create(hrp, TweenInfo.new(1), {CFrame = CFrame.new(pos + Vector3.new(0,3,0))})
                    tween:Play()
                end
            end
        end)
    else
        if autoFarmConn then
            autoFarmConn:Disconnect()
            autoFarmConn = nil
        end
    end
end)

-- Auto Attack
createToggleButton("Auto Attack", function(active)
    if active then
        autoAttackConn = RunService.Stepped:Connect(function()
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function()
                    tool:Activate()
                end)
            end
        end)
    else
        if autoAttackConn then
            autoAttackConn:Disconnect()
            autoAttackConn = nil
        end
    end
end)

-- Speed Setting
createLabel("⚡ Set Speed")
local speedBox = createTextBox("WalkSpeed number")
createToggleButton("Apply Speed", function(active)
    if active then
        local speed = tonumber(speedBox.Text)
        if speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = speed
        else
            warn("[Speed] Invalid input or Humanoid not found")
        end
    else
        -- Reset speed to default when toggled off (optional)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- Equip Fruit
createLabel("⚡ Equip Fruit")
local fruitBox = createTextBox("Fruit name")
createToggleButton("Equip", function(active)
    if active then
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if not bp then return warn("[Equip Fruit] Backpack not found") end
        local fruit = bp:FindFirstChild(fruitBox.Text) or LocalPlayer.Character:FindFirstChild(fruitBox.Text)
        if fruit then
            fruit.Parent = LocalPlayer.Character
            print("[Equip Fruit] Equipped: ".. fruitBox.Text)
        else
            warn("[Equip Fruit] Fruit not found in Backpack or Character")
        end
    else
        print("[Equip Fruit] Disabled")
    end
end)

-- Follow Player
createLabel("👣 Follow Player")
local followBox = createTextBox("Player name")
local following = false

createToggleButton("Follow", function(active)
    following = active
    if active then
        followConn = RunService.Heartbeat:Connect(function()
            if not following then return end
            local target = Players:FindFirstChild(followBox.Text)
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and hrp then
                local targetPos = target.Character.HumanoidRootPart.Position
                hrp.CFrame = CFrame.new(hrp.Position, targetPos)
                hrp.CFrame = hrp.CFrame + (targetPos - hrp.Position).Unit * 3
            end
        end)
    else
        if followConn then
            followConn:Disconnect()
            followConn = nil
        end
    end
end)

-- Aimbot
createLabel("🎯 Aimbot")
createToggleButton("Aimbot", function(active)
    if active then
        aimbotConn = RunService.RenderStepped:Connect(function()
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
            if nearest then
                cam.CFrame = CFrame.new(cam.CFrame.Position, nearest.Position)
            end
        end)
    else
        if aimbotConn then
            aimbotConn:Disconnect()
            aimbotConn = nil
        end
    end
end)

-- Join Player (Stub)
createLabel("🌍 Join Player")
local joinBox = createTextBox("Player username")
createToggleButton("Join (Not functional)", function(active)
    if active then
        print("[Join Player] Feature not implemented yet.")
    end
end)

-- Fruit Notifier (prints fruit found once)
local notified = {}
RunService.Heartbeat:Connect(function()
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Part")) and not notified[v] and v.Name:lower():find("fruit") then
            print("[Fruit] Found:", v.Name)
            notified[v] = true
        end
    end
end)

print("✅ Alek Paphawin Prajit Hub Loaded")
