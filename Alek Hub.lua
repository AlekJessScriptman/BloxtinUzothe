-- Alek Paphawin Prajit Hub v1 (Full Jes Creator, Saksit)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- GUI Setup
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AlekPaphawinPrajitHub"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 680)
frame.Position = UDim2.new(0, 20, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0
frame.Visible = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🔰 Alek Paphawin Prajit Hub v4"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18

-- Resize Menu Size Input
local sizeSlider = Instance.new("TextBox", frame)
sizeSlider.Size = UDim2.new(1, -20, 0, 30)
sizeSlider.Position = UDim2.new(0, 10, 0, 50)
sizeSlider.PlaceholderText = "Menu Size (e.g. 300)"
sizeSlider.Font = Enum.Font.Gotham
sizeSlider.TextSize = 14
sizeSlider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
sizeSlider.TextColor3 = Color3.new(1, 1, 1)

sizeSlider.FocusLost:Connect(function()
    local val = tonumber(sizeSlider.Text)
    if val then
        frame.Size = UDim2.new(0, val, 0, val + 380)
    end
end)

-- Toggle Button
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 140, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 10)
toggle.Text = "🔃 Toggle Menu"
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 16
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

local isOpen = true
toggle.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    frame.Visible = isOpen
end)

-- Freeze Trade Placeholder
local function FreezeTrade()
    print("[Freeze Trade] Activated - Replace with actual logic")
end

-- Auto Farm
local autoFarmRunning = false
local function AutoFarm(targetName)
    if autoFarmRunning then
        warn("[AutoFarm] Already running")
        return
    end
    autoFarmRunning = true
    spawn(function()
        while autoFarmRunning do
            local character = LocalPlayer.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then
                wait(1)
                continue
            end
            local hrp = character.HumanoidRootPart
            local targetNPC = nil
            for _, npc in pairs(workspace:GetDescendants()) do
                if npc:IsA("Model") and npc.Name == targetName and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                    targetNPC = npc
                    break
                end
            end
            if targetNPC then
                local npcPos = targetNPC.HumanoidRootPart.Position
                local tween = TweenService:Create(hrp, TweenInfo.new(0.5), {CFrame = CFrame.new(npcPos + Vector3.new(0, 3, 0))})
                tween:Play()
                tween.Completed:Wait()
                wait(0.3)
            else
                warn("[AutoFarm] NPC not found:", targetName)
                autoFarmRunning = false
            end
            wait(0.1)
        end
    end)
end

local function StopAutoFarm()
    autoFarmRunning = false
end

-- Aimbot (basic)
local aimbotEnabled = false
local aimbotTargetName = nil

local function getClosestNPCToMouse(name)
    local mouse = LocalPlayer:GetMouse()
    local closestDist = math.huge
    local closestNPC = nil
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc.Name == name and npc:FindFirstChild("HumanoidRootPart") then
            local npcPos = npc.HumanoidRootPart.Position
            local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(npcPos)
            if onScreen then
                local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closestNPC = npc
                end
            end
        end
    end
    return closestNPC
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and aimbotTargetName then
        local npc = getClosestNPCToMouse(aimbotTargetName)
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(hrp.Position, npc.HumanoidRootPart.Position)
            end
        end
    end
end)

-- Auto Tween Fruits
local autoTweenFruitsRunning = false
local tweenSpeed = 50 -- default speed

local function isFruit(obj)
    if obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("Part") then
        local keywords = {"fruit", "bloxfruit", "dragon", "bomb", "magma"}
        for _, word in pairs(keywords) do
            if string.find(obj.Name:lower(), word) then
                return true
            end
        end
    end
    return false
end

local function TweenTo(pos)
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dist = (hrp.Position - pos).Magnitude
    local time = math.clamp(dist / tweenSpeed, 0.5, 5)
    local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
    tween:Play()
    tween.Completed:Wait()
end

local function AutoTweenFruits()
    if autoTweenFruitsRunning then
        warn("[AutoTweenFruits] Already running")
        return
    end
    autoTweenFruitsRunning = true
    spawn(function()
        while autoTweenFruitsRunning do
            for _, obj in pairs(workspace:GetDescendants()) do
                if isFruit(obj) then
                    local pos = nil
                    if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                        pos = obj.Handle.Position
                    elseif obj:IsA("Model") and obj.PrimaryPart then
                        pos = obj.PrimaryPart.Position
                    elseif obj:IsA("Part") then
                        pos = obj.Position
                    end
                    if pos then
                        TweenTo(pos + Vector3.new(0, 3, 0))
                        wait(0.3)
                    end
                end
            end
            wait(1)
        end
    end)
end

local function StopAutoTweenFruits()
    autoTweenFruitsRunning = false
end

-- Fruit Equip Changer
local fruitInput = Instance.new("TextBox", frame)
fruitInput.Size = UDim2.new(1, -20, 0, 30)
fruitInput.Position = UDim2.new(0, 10, 0, 520)
fruitInput.PlaceholderText = "Enter Fruit Name to Equip"
fruitInput.Font = Enum.Font.Gotham
fruitInput.TextSize = 14
fruitInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
fruitInput.TextColor3 = Color3.new(1, 1, 1)

local function EquipFruit(fruitName)
    print("[EquipFruit] Trying to equip:", fruitName)
    local backpack = LocalPlayer:WaitForChild("Backpack")
    local character = LocalPlayer.Character
    local fruitTool = backpack:FindFirstChild(fruitName) or (character and character:FindFirstChild(fruitName))
    if fruitTool and fruitTool:IsA("Tool") then
        LocalPlayer.Character.Humanoid:EquipTool(fruitTool)
        print("[EquipFruit] Equipped:", fruitName)
    else
        warn("[EquipFruit] Fruit not found in Backpack or Character")
    end
end

local function createButton(text, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.MouseButton1Click:Connect(callback)
end

createButton("❄️ Freeze Trade", 100, FreezeTrade)

local npcInput = Instance.new("TextBox", frame)
npcInput.Size = UDim2.new(1, -20, 0, 30)
npcInput.Position = UDim2.new(0, 10, 0, 150)
npcInput.PlaceholderText = "Enter NPC name (case sensitive)"
npcInput.Font = Enum.Font.Gotham
npcInput.TextSize = 14
npcInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
npcInput.TextColor3 = Color3.new(1, 1, 1)

createButton("⚔️ Start Auto Farm", 190, function()
    if npcInput.Text ~= "" then
        AutoFarm(npcInput.Text)
    else
        warn("Please enter a valid NPC name.")
    end
end)

createButton("🛑 Stop Auto Farm", 240, StopAutoFarm)

local aimbotToggle = Instance.new("TextButton", frame)
aimbotToggle.Size = UDim2.new(1, -20, 0, 40)
aimbotToggle.Position = UDim2.new(0, 10, 0, 290)
aimbotToggle.Text = "🎯 Toggle Aimbot"
aimbotToggle.Font = Enum.Font.Gotham
aimbotToggle.TextSize = 16
aimbotToggle.TextColor3 = Color3.new(1, 1, 1)
aimbotToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
aimbotToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotTargetName = npcInput.Text ~= "" and npcInput.Text or nil
    print("Aimbot enabled:", aimbotEnabled)
end)

local speedInput = Instance.new("TextBox", frame)
speedInput.Size = UDim2.new(1, -20, 0, 30)
speedInput.Position = UDim2.new(0, 10, 0, 370)
speedInput.PlaceholderText = "Tween Speed (e.g. 50)"
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 14
speedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
speedInput.TextColor3 = Color3.new(1, 1, 1)

speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val and val > 0 then
        tweenSpeed = val
        print("Tween speed set to:", tweenSpeed)
    else
        warn("Invalid tween speed value")
    end
end)

createButton("🍍 Start Auto Tween Fruits", 410, AutoTweenFruits)
createButton("⏹ Stop Auto Tween Fruits", 450, StopAutoTweenFruits)

createButton("🥭 Equip Fruit", 560, function()
    if fruitInput.Text ~= "" then
        EquipFruit(fruitInput.Text)
    else
        warn("Please enter a fruit name")
    end
end)

-- Follow Player System

local targetPlayerInput = Instance.new("TextBox", frame)
targetPlayerInput.Size = UDim2.new(1, -20, 0, 30)
targetPlayerInput.Position = UDim2.new(0, 10, 0, 600)
targetPlayerInput.PlaceholderText = "Enter Player Name to Follow"
targetPlayerInput.Font = Enum.Font.Gotham
targetPlayerInput.TextSize = 14
targetPlayerInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
targetPlayerInput.TextColor3 = Color3.new(1, 1, 1)

local followRunning = false

local function FollowPlayer(targetName)
    if followRunning then
        warn("[FollowPlayer] Already following a player")
        return
    end
    followRunning = true
    spawn(function()
        while followRunning do
            local targetPlayer = Players:FindFirstChild(targetName)
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and hrp then
                local targetPos = targetPlayer.Character.HumanoidRootPart.Position
                local tween = TweenService:Create(hrp, TweenInfo.new(0.5), {CFrame = CFrame.new(targetPos + Vector3.new(0,3,0))})
                tween:Play()
                tween.Completed:Wait()
            else
                warn("[FollowPlayer] Target player or parts not found")
                wait(1)
            end
            wait(0.2)
        end
    end)
end

local function StopFollowPlayer()
    followRunning = false
end

createButton("🏃 Start Follow Player", 640, function()
    local name = targetPlayerInput.Text
    if name ~= "" then
        FollowPlayer(name)
    else
        warn("Please enter a player name to follow")
    end
end)

createButton("🛑 Stop Follow Player", 680, StopFollowPlayer)
