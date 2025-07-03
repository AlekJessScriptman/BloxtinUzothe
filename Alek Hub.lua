-- Alek Paphawin Prajit Hub v2 - Scrollable Fixed Edition (All Features Combined)

-- Services local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local TweenService = game:GetService("TweenService") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local TeleportService = game:GetService("TeleportService")

-- GUI Setup local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")) gui.Name = "AlekPaphawinPrajitHub" gui.ResetOnSpawn = false

-- Scrollable Frame local scrollFrame = Instance.new("ScrollingFrame", gui) scrollFrame.Size = UDim2.new(0, 300, 0, 500) scrollFrame.Position = UDim2.new(0, 20, 0.3, 0) scrollFrame.CanvasSize = UDim2.new(0, 0, 5, 0) scrollFrame.ScrollBarThickness = 8 scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) scrollFrame.Active = true scrollFrame.BorderSizePixel = 0 scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y scrollFrame.CanvasPosition = Vector2.new(0, 0) scrollFrame.ClipsDescendants = true scrollFrame.ZIndex = 1

-- Dragging support local dragging, dragInput, dragStart, startPos = false, nil, nil, nil scrollFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = scrollFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end) scrollFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end) UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart scrollFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

-- UI Container local container = Instance.new("Frame", scrollFrame) container.Size = UDim2.new(1, 0, 0, 2000) container.BackgroundTransparency = 1 container.Name = "Container"

local layout = Instance.new("UIListLayout", container) layout.Padding = UDim.new(0, 5) layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Create Functions local function createLabel(text) local label = Instance.new("TextLabel", container) label.Size = UDim2.new(1, -20, 0, 30) label.Text = text label.Font = Enum.Font.GothamBold label.TextSize = 16 label.TextColor3 = Color3.new(1, 1, 1) label.BackgroundTransparency = 1 end

local function createTextBox(placeholder) local box = Instance.new("TextBox", container) box.Size = UDim2.new(1, -20, 0, 30) box.PlaceholderText = placeholder box.Font = Enum.Font.Gotham box.TextSize = 14 box.BackgroundColor3 = Color3.fromRGB(45, 45, 45) box.TextColor3 = Color3.new(1, 1, 1) return box end

local function createToggleButton(text, callback) local on = false local btn = Instance.new("TextButton", container) btn.Size = UDim2.new(1, -20, 0, 35) btn.Text = "[OFF] " .. text btn.Font = Enum.Font.Gotham btn.TextSize = 14 btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) btn.TextColor3 = Color3.new(1, 1, 1) btn.MouseButton1Click:Connect(function() on = not on btn.Text = (on and "[ON] " or "[OFF] ") .. text callback(on) end) end

-- New Feature: Auto Collect Chest createLabel("💰 Auto Collect Chest") createToggleButton("Auto Chest", function(active) if active then RunService.Heartbeat:Connect(function() for _, chest in pairs(workspace:GetDescendants()) do if chest.Name:lower():find("chest") and chest:IsA("Part") then local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if hrp then TweenService:Create(hrp, TweenInfo.new(0.5), {CFrame = CFrame.new(chest.Position + Vector3.new(0, 3, 0))}):Play() end end end end) end end)

-- New Feature: Auto Accept Trade createLabel("🤝 Auto Accept Trade") createToggleButton("Accept Trades", function(active) if active then local success, err = pcall(function() local function acceptTrade() for _, gui in pairs(game:GetService("CoreGui"):GetDescendants()) do if gui:IsA("TextButton") and gui.Text:lower():find("accept") then gui:Activate() end end end RunService.RenderStepped:Connect(acceptTrade) end) if not success then warn("[Auto Accept Trade] Error:", err) end end end)

-- New Feature: Join Player by Name createLabel("🌍 Join Player by Name") local joinBox = createTextBox("Player username") createToggleButton("Join", function(active) if active then local username = joinBox.Text if username ~= "" then print("[Join Player] Attempting to join user:", username) -- In real case, use third-party API or TeleportService if server ID known end end end)

-- Keep other features unchanged below this point

print("✅ Alek Paphawin Prajit Hub v2 Loaded - All Systems Online")
