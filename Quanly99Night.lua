game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Success Loading",
    Icon = "rbxthumb://type=Asset&id=131484641795167&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Keybind: LeftControl",
    Icon = "rbxthumb://type=Asset&id=131484641795167&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Image = "rbxthumb://type=Asset&id=106019376492019&w=420&h=420"
getgenv().ToggleUI = "LeftControl"

task.spawn(function()
    if not getgenv().LoadedMobileUI then
        getgenv().LoadedMobileUI = true
        local OpenUI = Instance.new("ScreenGui")
        local ImageButton = Instance.new("ImageButton")
        local UICorner = Instance.new("UICorner")
        OpenUI.Name = "OpenUI"
        OpenUI.Parent = game:GetService("CoreGui")
        OpenUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ImageButton.Parent = OpenUI
        ImageButton.BackgroundColor3 = Color3.fromRGB(105, 105, 105)
        ImageButton.BackgroundTransparency = 0.8
        ImageButton.Position = UDim2.new(0, 20, 0, 25)
        ImageButton.Size = UDim2.new(0, 50, 0, 50)
        ImageButton.Image = getgenv().Image
        ImageButton.Draggable = true
        ImageButton.Transparency = 1
        UICorner.CornerRadius = UDim.new(0,13)
        UICorner.Parent = ImageButton
        ImageButton.MouseButton1Click:Connect(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, getgenv().ToggleUI, false, game)
        end)
    end
end)
local NothingLibrary = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/3345-c-a-t-s-u-s/NOTHING/main/source.lua'))();
local Windows = NothingLibrary.new({
	Title = "Aura Hub Beta",
	Description = "[Premium]",
	Keybind = Enum.KeyCode.LeftControl,
	Logo = 'rbxthumb://type=Asset&id=131484641795167&w=420&h=420'
})
local Webhook = Windows:NewTab({
	Title = "Webhook",
	Description = "Webhook Discord",
	Icon = "rbxassetid://7733960981"
})
local TabFrame = Windows:NewTab({
	Title = "Main",
	Description = "Main Play",
	Icon = "rbxassetid://7733960981"
})
--[[ Webhook ]]--
local StartWebhook = Webhook:NewSection({
	Title = "Webhook",
	Icon = "rbxassetid://7743869054",
	Position = "Left"
})
local SettingsWebhook = Webhook:NewSection({
	Title = "Settings",
	Icon = "rbxassetid://7743869054",
	Position = "Left"
})

--[[ Main Play ]]--
local Main = TabFrame:NewSection({
	Title = "Main",
	Icon = "rbxassetid://7743869054",
	Position = "Left"
})
local Cooked = TabFrame:NewSection({
	Title = "Cooked",
	Icon = "rbxassetid://7743869054",
	Position = "Right"
})
local Fire = TabFrame:NewSection({
	Title = "Camp",
	Icon = "rbxassetid://7743869054",
	Position = "Left"
})
local Visual = TabFrame:NewSection({
	Title = "Visual",
	Icon = "rbxassetid://7743869054",
	Position = "Right"
})
local Esp = TabFrame:NewSection({
	Title = "Esp",
	Icon = "rbxassetid://7743869054",
	Position = "Left"
})
local Section = TabFrame:NewSection({
	Title = "Kill",
	Icon = "rbxassetid://7743869054",
	Position = "Right"
})
Main:NewTitle('Tree')
Main:NewToggle({
    Title = "Auto Cut Tree",
    Default = false,
    Callback = function(v)
        _G.AutoChopTP = v
        if v then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local originalPos = hrp and hrp.CFrame
            task.spawn(function()
                while _G.AutoChopTP do
                    task.wait(0.3)
                    local trees = {}
                    for _, tree in pairs(workspace:GetDescendants()) do
                        if tree:IsA("Model") and tree.Name == "Small Tree" and tree.PrimaryPart then
                            table.insert(trees, tree)
                        end
                    end
                    for _, tree in ipairs(trees) do
                        if not _G.AutoChopTP then break end
                        if hrp and tree.PrimaryPart then
                            hrp.CFrame = tree.PrimaryPart.CFrame + Vector3.new(0,0,-3)
                            UIS.InputBegan:Fire({UserInputType=Enum.UserInputType.MouseButton1, Position=tree.PrimaryPart.Position}, false)
                            task.wait(0.1)
                            UIS.InputEnded:Fire({UserInputType=Enum.UserInputType.MouseButton1, Position=tree.PrimaryPart.Position}, false)
                            task.wait(0.5)
                        end
                    end
                end
                if hrp and originalPos then
                    hrp.CFrame = originalPos
                end
            end)
        else
            _G.AutoChopTP = false
        end
    end,
})
Main:NewTitle('Chest')
Main:NewToggle({
    Title = "Auto Open Chest",
    Default = false,
    Callback = function(value)
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        if not _G.AutoChestNearby then
            _G.AutoChestNearby = {running = false}
        end

        local function getPromptsInRange(range)
            local prompts = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and string.find(obj.Name, "Item Chest") then
                    local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local dist = (humanoidRootPart.Position - part.Position).Magnitude
                        if dist <= range then
                            for _, p in ipairs(obj:GetDescendants()) do
                                if p:IsA("ProximityPrompt") then
                                    table.insert(prompts, p)
                                end
                            end
                        end
                    end
                end
            end
            return prompts
        end

        if value then
            if _G.AutoChestNearby.running then return end
            _G.AutoChestNearby.running = true
            task.spawn(function()
                while _G.AutoChestNearby.running do
                    local prompts = getPromptsInRange(chestRange)
                    for _, prompt in ipairs(prompts) do
                        fireproximityprompt(prompt, math.huge)
                    end
                    task.wait(0.5)
                end
            end)
        else
            _G.AutoChestNearby.running = false
        end
    end,
})

Cooked:NewToggle({
    Title = "Auto Cooked (Teleport)",
    Default = false,
    Callback = function(value)
        if value then
            _G.AutoMorsel = true
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local originalPos = hrp and hrp.CFrame
            task.spawn(function()
                while _G.AutoMorsel do
                    task.wait()
                    for _, m in pairs(workspace:GetDescendants()) do
                        if not _G.AutoMorsel then break end
                        if m:IsA("Model") and m.Name == "Morsel" and m.PrimaryPart then
                            if hrp then
                                hrp.CFrame = m.PrimaryPart.CFrame
                                m:SetPrimaryPartCFrame(CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207))
                                task.wait(0.2)
                            end
                        end
                    end
                end
                if hrp and originalPos then
                    hrp.CFrame = originalPos
                end
            end)
        else
            _G.AutoMorsel = false
        end
    end,
})

Cooked:NewToggle({
    Title = "Auto Cooked (Bring)",
    Default = false,
    Callback = function(value)
        if value then
            _G.BringMorsels = true
            task.spawn(function()
                while _G.BringMorsels do
                    task.wait()
                    for _, m in pairs(workspace:GetDescendants()) do
                        if not _G.BringMorsels then break end
                        if m:IsA("Model") and m.Name == "Morsel" and m.PrimaryPart then
                            m:SetPrimaryPartCFrame(CFrame.new(-0.5468149185180664, 7.632332801818848, 0.11174965649843216))
                            task.wait(0.2)
                        end
                    end
                end
            end)
        else
            _G.BringMorsels = false
        end
    end,
})

Fire:NewToggle({
    Title = "Auto Fire (Teleport)",
    Default = false,
    Callback = function(value)
        if value then
            _G.AutoLog = true
            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local originalPos = hrp and hrp.CFrame
            task.spawn(function()
                while _G.AutoLog do
                    task.wait()
                    for _, m in pairs(workspace:GetDescendants()) do
                        if not _G.AutoLog then break end
                        if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then
                            if hrp then
                                hrp.CFrame = m.PrimaryPart.CFrame
                                m:SetPrimaryPartCFrame(CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207))
                                task.wait(0.2)
                            end
                        end
                    end
                end
                if hrp and originalPos then
                    hrp.CFrame = originalPos
                end
            end)
        else
            _G.AutoLog = false
        end
    end,
})

Fire:NewToggle({
    Title = "Auto Fire (Teleport - Coal)",
    Default = false,
    Callback = function(value)
        if value then
            _G.AutoCoal = true
            local player = game.Players.LocalPlayer
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local originalPos = hrp and hrp.CFrame
            task.spawn(function()
                while _G.AutoCoal do
                    task.wait()
                    for _, m in pairs(workspace:GetDescendants()) do
                        if not _G.AutoCoal then break end
                        if m:IsA("Model") and m.Name == "Coal" and m.PrimaryPart then
                            if hrp then
                                hrp.CFrame = m.PrimaryPart.CFrame
                                m:SetPrimaryPartCFrame(CFrame.new(0.5406733155250549, 12.499372482299805, -0.718663215637207))
                                task.wait(0.2)
                            end
                        end
                    end
                end
                if hrp and originalPos then
                    hrp.CFrame = originalPos
                end
            end)
        else
            _G.AutoCoal = false
        end
    end,
})

Fire:NewToggle({
    Title = "Auto Fire (Bring)",
    Default = false,
    Callback = function(value)
        if value then
            _G.BringLogs = true
            task.spawn(function()
                while _G.BringLogs do
                    task.wait()
                    for _, m in pairs(workspace:GetDescendants()) do
                        if not _G.BringLogs then break end
                        if m:IsA("Model") and m.Name == "Log" and m.PrimaryPart then
                            m:SetPrimaryPartCFrame(CFrame.new(-0.5468149185180664, 7.632332801818848, 0.11174965649843216))
                            task.wait(0.2)
                        end
                    end
                end
            end)
        else
            _G.BringLogs = false
        end
    end,
})

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = game.Players.LocalPlayer

local flyUpLoop = false
local flyUpNightLoop = false
local connAllTime
local connNightOnly

Visual:NewToggle({
    Title = "Fly Up (All Time)",
    Default = false,
    Callback = function(value)
        local character = player.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end

        flyUpLoop = value
        humanoid.PlatformStand = value

        if value then
            local ray = Ray.new(hrp.Position, Vector3.new(0, -1000, 0))
            local part, pos = workspace:FindPartOnRay(ray, hrp.Parent)
            local targetY = (part and pos.Y or hrp.Position.Y) + 30
            connAllTime = RunService.Heartbeat:Connect(function()
                if not flyUpLoop or not hrp.Parent then return end
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)
            end)
        else
            if connAllTime then connAllTime:Disconnect() end
        end
    end,
})

Visual:NewToggle({
    Title = "Fly Up (Night Only)",
    Default = false,
    Callback = function(value)
        local character = player.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end

        flyUpNightLoop = value

        if value then
            local currentTime = Lighting.ClockTime
            if currentTime >= 18 or currentTime < 6 then
                humanoid.PlatformStand = true
                local ray = Ray.new(hrp.Position, Vector3.new(0, -1000, 0))
                local part, pos = workspace:FindPartOnRay(ray, hrp.Parent)
                local targetY = (part and pos.Y or hrp.Position.Y) + 30
                connNightOnly = RunService.Heartbeat:Connect(function()
                    if not flyUpNightLoop or not hrp.Parent then return end
                    local t = Lighting.ClockTime
                    if t >= 18 or t < 6 then
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)
                    end
                end)
            else
                -- tắt toggle nếu bật ngoài giờ đêm
                value = false
                flyUpNightLoop = false
                if connNightOnly then connNightOnly:Disconnect() end
                humanoid.PlatformStand = false
            end
        else
            if connNightOnly then connNightOnly:Disconnect() end
            humanoid.PlatformStand = false
        end
    end,
})

Visual:NewButton({
	Title = "Through Wall ",
	Callback = function()
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")
        local RunService = game:GetService("RunService")

        local LocalPlayer = Players.LocalPlayer
        if not LocalPlayer then return end

        local Character = LocalPlayer.Character
        if not Character then
            Character = LocalPlayer.CharacterAdded:Wait()
        end

        local RootPart = Character:FindFirstChild("HumanoidRootPart")
        if not RootPart then return end

        local CurrentPosition = RootPart.Position
        local CurrentCFrame = RootPart.CFrame
        local FacingDirection = CurrentCFrame.LookVector

        local DashMagnitude = 30
        local DashOffset = Vector3.new(0, 1.25, 0)
        local DashVector = FacingDirection * DashMagnitude
        local Destination = CurrentPosition + DashVector + DashOffset

        local BodyPosition = Instance.new("BodyPosition")
        BodyPosition.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        BodyPosition.P = 1e5
        BodyPosition.D = 2000
        BodyPosition.Position = Destination
        BodyPosition.Parent = RootPart

        local DashDuration = 0.2
        local Connection = nil
        local StartTime = tick()

        Connection = RunService.RenderStepped:Connect(function()
            if tick() - StartTime >= DashDuration then
                BodyPosition:Destroy()
                if Connection then
                    Connection:Disconnect()
                end
            end
        end)
	end,
})
Visual:NewToggle({
    Title = "Speed Boost",
    Default = false,
    Callback = function(Value)
        _G.Speed100 = Value

        local player = game:GetService("Players").LocalPlayer
        if not player then return end

        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        if _G.Speed100 then
            humanoid.WalkSpeed = 100
        else
            humanoid.WalkSpeed = 16
        end
    end,
})

Esp:NewToggle({
    Title = "ESP Player",
    Default = false,
    Callback = function(Value)
        if Value then
            for i, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if head and humanoid then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Adornee = head
                        billboard.AlwaysOnTop = true
                        billboard.Size = UDim2.new(0,120,0,50)
                        billboard.MaxDistance = math.huge
                        billboard.StudsOffset = Vector3.new(0,2,0)
                        billboard.Parent = game.CoreGui

                        local frame = Instance.new("Frame")
                        frame.Size = UDim2.new(1,0,0,5)
                        frame.Position = UDim2.new(0,0,1,0)
                        frame.BackgroundColor3 = Color3.new(0,1,0)
                        frame.BorderSizePixel = 0
                        frame.Parent = billboard

                        local textLabel = Instance.new("TextLabel")
                        textLabel.Text = player.Name
                        textLabel.Size = UDim2.new(1,0,1,0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.TextColor3 = Color3.new(1,0,0)
                        textLabel.TextScaled = true
                        textLabel.Parent = billboard

                        game:GetService("RunService").RenderStepped:Connect(function()
                            if humanoid.Health > 0 then
                                frame.Size = UDim2.new(humanoid.Health/humanoid.MaxHealth,0,0,5)
                            else
                                billboard:Destroy()
                            end
                        end)
                    end
                end
            end
        else
            for _, gui in pairs(game.CoreGui:GetChildren()) do
                if gui:IsA("BillboardGui") then
                    gui:Destroy()
                end
            end
        end
    end,
})

Esp:NewToggle({
    Title = "ESP Mob",
    Default = false,
    Callback = function(Value)
        if Value then
            for i, mob in pairs(workspace:GetDescendants()) do
                if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                    local hrp = mob.HumanoidRootPart
                    local humanoid = mob.Humanoid

                    local billboard = Instance.new("BillboardGui")
                    billboard.Adornee = hrp
                    billboard.AlwaysOnTop = true
                    billboard.Size = UDim2.new(0,120,0,50)
                    billboard.MaxDistance = math.huge
                    billboard.StudsOffset = Vector3.new(0,2,0)
                    billboard.Parent = game.CoreGui

                    local frame = Instance.new("Frame")
                    frame.Size = UDim2.new(1,0,0,5)
                    frame.Position = UDim2.new(0,0,1,0)
                    frame.BackgroundColor3 = Color3.new(0,1,0)
                    frame.BorderSizePixel = 0
                    frame.Parent = billboard

                    local textLabel = Instance.new("TextLabel")
                    textLabel.Text = mob.Name
                    textLabel.Size = UDim2.new(1,0,1,0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextColor3 = Color3.new(1,0,0)
                    textLabel.TextScaled = true
                    textLabel.Parent = billboard

                    game:GetService("RunService").RenderStepped:Connect(function()
                        if humanoid.Health > 0 then
                            frame.Size = UDim2.new(humanoid.Health/humanoid.MaxHealth,0,0,5)
                        else
                            billboard:Destroy()
                        end
                    end)
                end
            end
        else
            for _, gui in pairs(game.CoreGui:GetChildren()) do
                if gui:IsA("BillboardGui") then
                    gui:Destroy()
                end
            end
        end
    end,
})

Section:NewToggle({
    Title = "Kill Aura",
    Default = false,
    Callback = function(state)
        if state then
            getgenv().KillAura = true
            task.spawn(function()
                while getgenv().KillAura do
                    task.wait(1)
                    for _, mob in pairs(workspace:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                            local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if hrp and (mob.HumanoidRootPart.Position - hrp.Position).Magnitude < 10 then
                                mob.Humanoid:TakeDamage(20)
                            end
                        end
                    end
                end
            end)
        else
            getgenv().KillAura = false
        end
    end,
})
Section:NewToggle({
    Title = "Kill Aura (Testing)",
    Default = false,
    Callback = function(state)
        if state then
            getgenv().KillAuraTest = true
            local player = game.Players.LocalPlayer
            task.spawn(function()
                while getgenv().KillAuraTest do
                    task.wait(0.05)
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not hrp then continue end
                    for _, mob in pairs(workspace:GetChildren()) do
                        if not getgenv().KillAura then break end
                        local humanoid = mob:FindFirstChildWhichIsA("Humanoid")
                        local mhrp = mob:FindFirstChild("HumanoidRootPart")
                        if humanoid and mhrp and (mhrp.Position - hrp.Position).Magnitude <= 12 then
                            pcall(function() humanoid.Health = 0 end)
                            pcall(function() humanoid:Destroy() end)
                            pcall(function() mob:Destroy() end)
                            pcall(function() for _, v in pairs(mob:GetDescendants()) do if v:IsA("BasePart") then v:BreakJoints() end end end)
                        end
                    end
                end
            end)
        else
            getgenv().KillAuraTest = false
        end
    end,
})



--[[ Webhook ]]--
StartWebhook:NewTextbox({
	Title = "Url",
	Default = "",
	Callback = function(tr)
	end,
})
StartWebhook:NewToggle({
	Title = "Start Webhook",
	Default = false,
	Callback = function(tr)
	end,
})
SettingsWebhook:NewToggle({
	Title = "When 100 Night",
	Default = false,
	Callback = function(tr)
	end,
})
SettingsWebhook:NewToggle({
	Title = "When Your Die",
	Default = false,
	Callback = function(tr)
	end,
})
SettingsWebhook:NewToggle({
	Title = "Send Webhook For All",
	Default = true,
	Callback = function(tr)
	end,
})

