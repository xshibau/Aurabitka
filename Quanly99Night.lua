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
getgenv().ToggleUI = "RightControl"

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
local Compkiller = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/CompKiller/refs/heads/main/src/source.luau"))();

local Notifier = Compkiller.newNotify();

Compkiller:Loader("rbxthumb://type=Asset&id=131484641795167&w=420&h=420", 2.5).yield();

local Window = Compkiller.new({
	Name = "Aura Hub [Beta]",
	Keybind = "RightControl",
	Logo = "rbxthumb://type=Asset&id=131484641795167&w=420&h=420",
	Scale = Compkiller.Scale.Mobile,
	TextSize = 15,
});

local Main = Window:DrawTab({
	Name = "Main",
	Icon = "house",
	EnableScrolling = true
})

local Section = Main:DrawSection({
	Name = "Main",
	Position = 'left'	
})
local Player = Main:DrawSection({
	Name = "Esp & Player",
	Position = 'Left'	
})
local Class = Main:DrawSection({
	Name = "Class",
	Position = 'Left'	
})

local Camp = Main:DrawSection({
	Name = "Camp",
	Position = 'Right'	
})
local FlyUp = Main:DrawSection({
	Name = "Enabled",
	Position = 'Right'	
})
local KillAura = Main:DrawSection({
	Name = "Kill Aura",
	Position = 'Right'	
})




Section:AddToggle({
	Name = "Auto Chop Tree",
	Flag = "AutoChopTree",
	Default = false,
	Callback = function(Value)
   end,
})
Section:AddParagraph({
	Title = "Chest",
	Content = "หน้าอก"
})
Section:AddToggle({
	Name = "Auto Open Chest",
	Flag = "AutoChestNearby",
	Default = false,
	Callback = function(Value)
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

        if Value then
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


--[[ Camp ]]--
Camp:AddParagraph({
	Title = "Cooked",
	Content = "ปรุงสุกแล้ว"
})
Camp:AddToggle({
	Name = "Auto Cooked",
	Flag = "AutoMorsel",
	Default = false,
	Callback = function(Value)
        if Value then
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
Camp:AddParagraph({
	Title = "Fire",
	Content = "กองไฟ"
})
Camp:AddToggle({
	Name = "Auto Fire",
	Flag = "AutoLog",
	Default = false,
	Callback = function(Value)
       if Value then
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
Camp:AddToggle({
	Name = "Auto Fire (Coal)",
	Flag = "AutoCoal",
	Default = false,
	Callback = function(Value)
        if Value then
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

--[[ Night ]]--
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = game.Players.LocalPlayer

local flyUpLoop = false
local flyUpNightLoop = false
local connAllTime
local connNightOnly
FlyUp:AddToggle({
	Name = "Fly Up All Time",
	Flag = "FlyUpAllTime",
	Default = false,
	Callback = function(Value)
        local character = player.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end

        flyUpLoop = Value
        humanoid.PlatformStand = Value

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
FlyUp:AddToggle({
	Name = "Fly Up Only Night",
	Flag = "FlyUpOnlyNight",
	Default = false,
	Callback = function(Value)
        local character = player.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end

        flyUpNightLoop = Value

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
--[[ Players ]]--
Player:AddToggle({
	Name = "Speed Boost",
	Flag = "SpeedBoost",
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
Players:AddParagraph({
	Title = "Esp",
	Content = "เอสพี"
})
Player:AddToggle({
	Name = "Esp Mob",
	Flag = "EspMob",
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
Player:AddToggle({
	Name = "Esp Player",
	Flag = "EspPlayer",
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
--[[ Kill Aura ]]--
KillAura:AddParagraph({
	Title = "Kill",
	Content = "ฆ่าออร่า"
})
KillAura:AddToggle({
	Name = "Kill Aura (Mob)",
	Flag = "KillMob",
	Default = false,
	Callback = function(Value)
   end,
})
KillAura:AddToggle({
	Name = "Kill Aura (All)",
	Flag = "KillAll",
	Default = false,
	Callback = function(Value)
   end,
})

--[[ Class Auto Buy ]]--
Class:AddDropdown({
	Name = "Select Class",
	Default = "",
	Values = {"All"},
	Callback = function(Value)
		end,
})
Class:AddToggle({
	Name = "Auto Buy",
	Flag = "AutoBuy",
	Default = false,
	Callback = function(Value)
   end,
})

--[[ Tree ]]--
