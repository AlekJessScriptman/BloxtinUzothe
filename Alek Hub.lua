-- Alek Paphawin Prajit Hub v2

--[[
📦 Features Added:
✅ Toggle Open/Close Menu
✅GetService GUI
✅ Freeze Trade Button
✅ Auto Farm with target NPC name input
]]

--===[ Utilities ]===--
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

--===[ GUI Setup ]===--
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AlekPaphawinPrajitHub"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 350)
frame.Position = UDim2.new(0, 20, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🔰 Alek Paphawin Prajit Hub v2"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18

-- Resize slider
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
        frame.Size = UDim2.new(0, val, 0, val + 50)
    end
end)

-- Toggle button
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

--===[ Function: Freeze Trade (stub) ]===--
local function FreezeTrade()
    print("[Freeze Trade] Triggered. Replace with actual logic.")
    -- Add your anti-trade-modification logic here
end

--===[ Function: Auto Farm ]===--
local function AutoFarm(targetName)
    print("[AutoFarm] Target NPC:", targetName)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc.Name == targetName and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
            local npcPos = npc.HumanoidRootPart.Position
            local tween = TweenService:Create(hrp, TweenInfo.new(1), {CFrame = CFrame.new(npcPos + Vector3.new(0, 3, 0))})
            tween:Play()
            tween.Completed:Wait()
            wait(0.2)
        end
    end
end

-- Buttons
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

-- AutoFarm input
local npcInput = Instance.new("TextBox", frame)
npcInput.Size = UDim2.new(1, -20, 0, 30)
npcInput.Position = UDim2.new(0, 10, 0, 150)
npcInput.PlaceholderText = "Enter NPC name (case sensitive)"
npcInput.Font = Enum.Font.Gotham
npcInput.TextSize = 14
npcInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
npcInput.TextColor3 = Color3.new(1, 1, 1)

createButton("⚔️ Start Auto Farm", 190, function()
    AutoFarm(npcInput.Text)
end)
