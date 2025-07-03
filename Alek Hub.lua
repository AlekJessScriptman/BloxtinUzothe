-- Alek Paphawin Prajit Hub v5 (Stable Edition for Blox Fruits)

-- Services local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local TweenService = game:GetService("TweenService") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local ReplicatedStorage = game:GetService("ReplicatedStorage") local Workspace = game:GetService("Workspace") local StarterGui = game:GetService("StarterGui")

-- Remotes local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents") or Instance.new("Folder", ReplicatedStorage) local BuyFruitEvent = RemoteEvents:FindFirstChild("BuyFruit") local TradeEvent = RemoteEvents:FindFirstChild("TradeEvent") local SummonFruitEvent = RemoteEvents:FindFirstChild("SummonFruit")

-- Rare Fruit List local rareFruits = { "Dragon", "Kitsune", "Yeti", "Leopard", "Spirit", "Gas", "Control", "Venom", "Shadow", "Dough", "T-rex", "Mammoth", "Gravity", "Blizzard", "Pain", "Rumble", "Portal", "Phoenix", "Sound", "Spider", "Creation", "Love", "Buddha", "Quake", "Magma", "Rubber", "Light", "Eagle", "Dark", "Sand" }

-- UI Setup local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")) gui.Name = "AlekPaphawinPrajitHub" gui.ResetOnSpawn = false

local scrollFrame = Instance.new("ScrollingFrame", gui) scrollFrame.Size = UDim2.new(0, 350, 0, 550) scrollFrame.Position = UDim2.new(0, 20, 0.2, 0) scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) scrollFrame.BorderSizePixel = 0 scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y scrollFrame.CanvasSize = UDim2.new(0, 0, 5, 0) scrollFrame.ScrollBarThickness = 8 scrollFrame.ClipsDescendants = true

-- Drag support local dragging, dragStart, startPos scrollFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = scrollFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end) UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart scrollFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

-- Container local container = Instance.new("Frame", scrollFrame) container.Size = UDim2.new(1, 0, 0, 3000) container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container) layout.Padding = UDim.new(0, 5) layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Helper UI local function createLabel(text) local lbl = Instance.new("TextLabel", container) lbl.Size = UDim2.new(1, -20, 0, 25) lbl.Text = text lbl.Font = Enum.Font.GothamBold lbl.TextSize = 16 lbl.TextColor3 = Color3.new(1,1,1) lbl.BackgroundTransparency = 1 end

local function createTextBox(placeholder) local tb = Instance.new("TextBox", container) tb.Size = UDim2.new(1, -20, 0, 30) tb.PlaceholderText = placeholder tb.Font = Enum.Font.Gotham tb.TextSize = 14 tb.BackgroundColor3 = Color3.fromRGB(50, 50, 50) tb.TextColor3 = Color3.new(1,1,1) tb.ClearTextOnFocus = false return tb end

local function createToggleButton(name, callback) local toggled = false local btn = Instance.new("TextButton", container) btn.Size = UDim2.new(1, -20, 0, 35) btn.Text = "[OFF] " .. name btn.Font = Enum.Font.Gotham btn.TextSize = 14 btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) btn.TextColor3 = Color3.new(1,1,1) btn.MouseButton1Click:Connect(function() toggled = not toggled btn.Text = (toggled and "[ON] " or "[OFF] ") .. name pcall(callback, toggled) end) end

-- Toggle GUI local toggleBtn = Instance.new("TextButton", gui) toggleBtn.Size = UDim2.new(0, 120, 0, 30) toggleBtn.Position = UDim2.new(0, 20, 0.05, 0) toggleBtn.Text = "Hide Menu" toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40) toggleBtn.TextColor3 = Color3.new(1,1,1) toggleBtn.Font = Enum.Font.Gotham

toggleBtn.MouseButton1Click:Connect(function() scrollFrame.Visible = not scrollFrame.Visible toggleBtn.Text = scrollFrame.Visible and "Hide Menu" or "Show Menu" end)

-- States local states = { farming = false, autoAttack = false, follow = false, aimbot = false, autoTradeAccept = false, autoFruitTrade = false, autoCollectChest = false, equipFruit = false, freeShop = false }

-- Inputs local npcBox = createTextBox("Enter NPC name") local speedBox = createTextBox("Tween speed (max 250)") speedBox.Text = "150" local fruitBox = createTextBox("Fruit name") local followBox = createTextBox("Player name")

-- Toggles createLabel("⚔️ Auto Farm") createToggleButton("Auto Farm", function(on) states.farming = on end) createToggleButton("Auto Attack", function(on) states.autoAttack = on end)

createLabel("🍉 Equip Fruit") createToggleButton("Equip Fruit", function(on) states.equipFruit = on end)

createLabel("👣 Follow Player") createToggleButton("Follow", function(on) states.follow = on end)

createLabel("🎯 Aimbot") createToggleButton("Aimbot", function(on) states.aimbot = on end)

createLabel("💰 Auto Trade") createToggleButton("Auto Add Fruits", function(on) states.autoFruitTrade = on end) createToggleButton("Auto Accept Trade", function(on) states.autoTradeAccept = on end)

createLabel("📦 Collect Chest") createToggleButton("Auto Collect Chest", function(on) states.autoCollectChest = on end)

createLabel("🛍️ Free Shopping") createToggleButton("Free Shop", function(on) states.freeShop = on end)

-- Utility local lastEquip = 0 local notified = {} local function getCharacter() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end

-- Main Loop RunService.Heartbeat:Connect(function() local char = getCharacter() local hrp = char and char:FindFirstChild("HumanoidRootPart")

if states.farming and npcBox.Text ~= "" and hrp then
    for _, npc in pairs(Workspace:GetChildren()) do
        if npc:IsA("Model") and npc.Name == npcBox.Text and npc:FindFirstChild("HumanoidRootPart") then
            local targetPos = npc.HumanoidRootPart.Position
            local speed = math.clamp(tonumber(speedBox.Text) or 100, 10, 250)
            local dist = (hrp.Position - targetPos).Magnitude
            local time = dist / speed
            TweenService:Create(hrp, TweenInfo.new(time), {CFrame = CFrame.new(targetPos + Vector3.new(0,3,0))}):Play()
            break
        end
    end
end

if states.autoAttack then
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then pcall(function() tool:Activate() end) end
end

if states.follow and followBox.Text ~= "" then
    local plr = Players:FindFirstChild(followBox.Text)
    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and hrp then
        hrp.CFrame = CFrame.new(hrp.Position, plr.Character.HumanoidRootPart.Position)
    end
end

if states.aimbot then
    local cam = Workspace.CurrentCamera
    local nearest, minDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local d = (cam.CFrame.Position - p.Character.Head.Position).Magnitude
            if d < minDist then
                nearest = p.Character.Head
                minDist = d
            end
        end
    end
    if nearest then
        cam.CFrame = CFrame.new(cam.CFrame.Position, nearest.Position)
    end
end

if states.equipFruit and tick() - lastEquip > 2 then
    lastEquip = tick()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local fruit = backpack and backpack:FindFirstChild(fruitBox.Text)
    if fruit and not char:FindFirstChild(fruit.Name) then
        fruit.Parent = char
    end
end

if states.autoCollectChest then
    for _, model in pairs(Workspace:GetChildren()) do
        if model:IsA("Model") and model.Name:lower():find("chest") then
            local cd = model:FindFirstChildWhichIsA("ClickDetector")
            if cd then pcall(fireclickdetector, cd) end
        end
    end
end

if states.freeShop then
    local gui = LocalPlayer.PlayerGui:FindFirstChild("ShopGui")
    if gui then
        for _, label in pairs(gui:GetDescendants()) do
            if label:IsA("TextLabel") and label.Name:lower():find("price") then
                label.Text = "0 Robux"
            end
        end
    end
end

-- Rare Fruit ESP / Notifier
for _, item in pairs(Workspace:GetDescendants()) do
    if (item:IsA("Tool") or item:IsA("Part")) and not notified[item] then
        for _, name in pairs(rareFruits) do
            if item.Name:lower():find(name:lower()) then
                print("[ESP] Found rare fruit:", item.Name)
                notified[item] = true
                break
            end
        end
    end
end

end)

print("✅ Alek Paphawin Prajit Hub v5 Loaded - Stable Edition")
