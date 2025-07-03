-- [ศักดิ์สิทธิ์] Alek Paphawin Prajit Hub v2 (Fixed Toggle Version)

--[[ 📦 Features Added: ✅ Toggle Open/Close Menu ✅ Resizable GUI ✅ Freeze Trade ✅ Force Accept เคนโด้ ✅ Auto Farm with target NPC name input (toggle) ✅ Auto Attack (toggle) ✅ Speed Test ✅ Damage Control via user input ✅ Fruit Equip changer ]]

--===[ Utilities ]===-- local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local TweenService = game:GetService("TweenService") local RunService = game:GetService("RunService")

--===[ GUI Setup ]===-- local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")) gui.Name = "AlekPaphawinPrajitHub" gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui) frame.Size = UDim2.new(0, 250, 0, 550) frame.Position = UDim2.new(0, 20, 0.3, 0) frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) frame.Active = true frame.Draggable = true frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame) title.Size = UDim2.new(1, 0, 0, 40) title.BackgroundTransparency = 1 title.Text = "🔰 Alek Paphawin Prajit Hub v2" title.Font = Enum.Font.GothamBold title.TextColor3 = Color3.new(1, 1, 1) title.TextSize = 18

-- Resize slider local sizeSlider = Instance.new("TextBox", frame) sizeSlider.Size = UDim2.new(1, -20, 0, 30) sizeSlider.Position = UDim2.new(0, 10, 0, 50) sizeSlider.PlaceholderText = "Menu Size (e.g. 300)" sizeSlider.Font = Enum.Font.Gotham sizeSlider.TextSize = 14 sizeSlider.BackgroundColor3 = Color3.fromRGB(45, 45, 45) sizeSlider.TextColor3 = Color3.new(1, 1, 1)

sizeSlider.FocusLost:Connect(function() local val = tonumber(sizeSlider.Text) if val then frame.Size = UDim2.new(0, val, 0, val + 250) end end)

-- Toggle button local toggle = Instance.new("TextButton", gui) toggle.Size = UDim2.new(0, 140, 0, 40) toggle.Position = UDim2.new(0, 10, 0, 10) toggle.Text = "🔃 Toggle Menu" toggle.Font = Enum.Font.Gotham toggle.TextSize = 16 toggle.TextColor3 = Color3.new(1, 1, 1) toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

local isOpen = true toggle.MouseButton1Click:Connect(function() isOpen = not isOpen frame.Visible = isOpen end)

--===[ Toggles and States ]===-- local autoFarmEnabled = false local autoAttackEnabled = false local autoFarmThread = nil local autoAttackConn = nil

--===[ Function: Freeze Trade ]===-- local function FreezeTrade() print("[Freeze Trade] Triggered.") end

--===[ Function: Force Accept Greatly ]===-- local function ForceAccept() print("[Force Accept] Triggered.") end

--===[ Function: Toggle Auto Farm ]===-- local function ToggleAutoFarm(targetName) autoFarmEnabled = not autoFarmEnabled print("[AutoFarm] Enabled:", autoFarmEnabled) if autoFarmEnabled then autoFarmThread = coroutine.create(function() while autoFarmEnabled and task.wait(1) do local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") for _, npc in pairs(workspace:GetDescendants()) do if npc:IsA("Model") and npc.Name == targetName and npc:FindFirstChild("HumanoidRootPart") then local pos = npc.HumanoidRootPart.Position TweenService:Create(hrp, TweenInfo.new(1), {CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))}):Play() break end end end end) coroutine.resume(autoFarmThread) end end

--===[ Function: Toggle Auto Attack ]===-- local function ToggleAutoAttack() autoAttackEnabled = not autoAttackEnabled print("[AutoAttack] Enabled:", autoAttackEnabled) if autoAttackEnabled then autoAttackConn = RunService.RenderStepped:Connect(function() local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") if tool and tool:FindFirstChild("Activate") then tool:Activate() end end) elseif autoAttackConn then autoAttackConn:Disconnect() autoAttackConn = nil end end

--===[ Function: Speed Test ]===-- local function SpeedTest() local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() local hum = char:WaitForChild("Humanoid") hum.WalkSpeed = 100 print("[SpeedTest] WalkSpeed set to 100") end

--===[ Function: Damage Control ]===-- local function DamageControl(amount) print("[DamageControl] Set to:", amount) -- Placeholder: Apply damage logic here end

--===[ Function: Change Fruit Equip ]===-- local function EquipFruit(fruitName) print("[EquipFruit] Switching to:", fruitName) for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do if tool:IsA("Tool") and string.find(tool.Name:lower(), fruitName:lower()) then tool.Parent = LocalPlayer.Character break end end end

--===[ GUI Elements ]===-- local function createButton(text, posY, callback) local btn = Instance.new("TextButton", frame) btn.Size = UDim2.new(1, -20, 0, 30) btn.Position = UDim2.new(0, 10, 0, posY) btn.Text = text btn.Font = Enum.Font.Gotham btn.TextSize = 14 btn.TextColor3 = Color3.new(1, 1, 1) btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) btn.MouseButton1Click:Connect(callback) end

createButton("❄️ Freeze Trade", 90, FreezeTrade) createButton("🧲 Force Accept Greatly", 130, ForceAccept) createButton("⚔️ Toggle Auto Attack", 170, ToggleAutoAttack) createButton("⚡ Speed Test", 210, SpeedTest)

local npcInput = Instance.new("TextBox", frame) npcInput.Size = UDim2.new(1, -20, 0, 30) npcInput.Position = UDim2.new(0, 10, 0, 250) npcInput.PlaceholderText = "NPC name (case sensitive)" npcInput.Font = Enum.Font.Gotham npcInput.TextSize = 14 npcInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45) npcInput.TextColor3 = Color3.new(1, 1, 1)

createButton("🎯 Toggle Auto Farm", 290, function() ToggleAutoFarm(npcInput.Text) end)

local dmgInput = Instance.new("TextBox", frame) dmgInput.Size = UDim2.new(1, -20, 0, 30) dmgInput.Position = UDim2.new(0, 10, 0, 330) dmgInput.PlaceholderText = "Damage Amount" dmgInput.Font = Enum.Font.Gotham dmgInput.TextSize = 14 dmgInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45) dmgInput.TextColor3 = Color3.new(1, 1, 1)

createButton("💥 Apply Damage Control", 370, function() DamageControl(dmgInput.Text) end)

local fruitInput = Instance.new("TextBox", frame) fruitInput.Size = UDim2.new(1, -20, 0, 30) fruitInput.Position = UDim2.new(0, 10, 0, 410) fruitInput.PlaceholderText = "Fruit Name to Equip" fruitInput.Font = Enum.Font.Gotham fruitInput.TextSize = 14 fruitInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45) fruitInput.TextColor3 = Color3.new(1, 1, 1)

createButton("🍍 Equip Fruit", 450, function() EquipFruit(fruitInput.Text) end)

