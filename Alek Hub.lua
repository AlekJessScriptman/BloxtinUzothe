-- Alek Paphawin Hub: Mod Menu + Functions

--===[🛡️ Function #2: Ploy And Jes - Anti-Ban]===--
function PloyAndJes()
    print("🛡️ Anti-Ban Activated")
    local function safeRun(callback)
        local success, err = pcall(callback)
        if not success then warn("[AntiBan]", err) end
    end

    safeRun(function()
        local mt = getrawmetatable(game)
        if setreadonly then setreadonly(mt, false) end
        local old = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            if getnamecallmethod() == "Kick" then
                warn("[AntiBan] Kick blocked")
                return nil
            end
            return old(self, ...)
        end)
    end)

    safeRun(function()
        game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then
                hum.BreakJoints = function()
                    warn("[AntiBan] BreakJoints blocked!")
                end
            end
        end)
    end)
end

--===[🍍 Function #3: Saksit Tween to Fruits]===--
function SaksitTweenToFruits()
    print("🍍 Auto Fruit Collector Running...")
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local ts = game:GetService("TweenService")

    local keywords = {"Fruit", "BloxFruit", "Dragon", "Bomb", "Magma"}
    local function isFruit(obj)
        if obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("Part") then
            for _, word in pairs(keywords) do
                if string.find(obj.Name:lower(), word:lower()) then return true end
            end
        end
        return false
    end

    local function tweenTo(pos)
        local d = (hrp.Position - pos).Magnitude
        local t = math.clamp(d / 100, 0.5, 5)
        local tween = ts:Create(hrp, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
        tween:Play()
        tween.Completed:Wait()
    end

    for _, obj in pairs(workspace:GetDescendants()) do
        if isFruit(obj) then
            local pos = (obj:IsA("Tool") and obj:FindFirstChild("Handle")) and obj.Handle.Position or
                        (obj:IsA("Part") and obj.Position) or
                        (obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position)
            if pos then
                tweenTo(pos + Vector3.new(0, 3, 0))
                wait(0.5)
            end
        end
    end
    print("✅ Fruits collected.")
end

--===[🍎 Function #1: Busoshoki Alex - Drop Fruit]===--
function BusoshokiAlex(commandTable)
    local action, target, category, fruitName = unpack(commandTable)
    if action == "drop" and target == "item" and category == "bloxfruits" and fruitName then
        print("Attempting to drop fruit:", fruitName)
        -- Simulated inventory
        local inventory = {
            ["Dragon-Dragon"] = true,
            ["Magma-Magma"] = true
        }
        if inventory[fruitName] then
            print("✅ Dropped:", fruitName)
        else
            warn("❌ You don’t own:", fruitName)
        end
    else
        warn("Invalid drop command")
    end
end

--===[🖥️ GUI: Alek Paphawin Hub]===--
local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AlekPaphawinHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 300)
frame.Position = UDim2.new(0, 20, 0.4, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🔥 Alek Paphawin Hub 🔥"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18

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

-- Buttons
createButton("🛡️ Ploy and Jes (Anti-Ban)", 50, function()
    PloyAndJes()
end)

createButton("🍍 Saksit: Auto Collect Fruits", 100, function()
    SaksitTweenToFruits()
end)

createButton("🍎 Busoshoki: Drop Fruit", 150, function()
    local input = tostring(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChildWhichIsA("ScreenGui"):FindFirstChildWhichIsA("Frame") or "Dragon-Dragon")
    BusoshokiAlex({"drop", "item", "bloxfruits", input})
end)
