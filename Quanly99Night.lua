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
   _G.AutoChopTP = false
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
        _G.AutoMorsel = Value
        if not Value then return end

        task.spawn(function()
            local player = game.Players.LocalPlayer
            local cookPos = CFrame.new(0.5406733,12.499372,-0.7186632)
            local originalPos = nil

            while _G.AutoMorsel do
                task.wait(0.1)

                local characterNow = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPartNow = nil
                if characterNow then
                    humanoidRootPartNow = characterNow:FindFirstChild("HumanoidRootPart")
                end
                if humanoidRootPartNow and not originalPos then
                    originalPos = humanoidRootPartNow.CFrame
                end
                if not humanoidRootPartNow then
                    continue
                end

                local nearestMorsel = nil
                local nearestDistance = nil
                for _, possibleMorsel in pairs(workspace:GetDescendants()) do
                    if possibleMorsel:IsA("Model") and possibleMorsel.Name == "Morsel" and possibleMorsel.PrimaryPart then
                        local dist = (possibleMorsel.PrimaryPart.Position - humanoidRootPartNow.Position).Magnitude
                        if nearestDistance == nil or dist < nearestDistance then
                            nearestDistance = dist
                            nearestMorsel = possibleMorsel
                        end
                    end
                end

                if nearestMorsel then
                    humanoidRootPartNow.CFrame = nearestMorsel.PrimaryPart.CFrame
                    nearestMorsel:SetPrimaryPartCFrame(cookPos)
                    task.wait(1)
                end
            end

            local finalCharacter = player.Character
            if finalCharacter then
                local finalHRP = finalCharacter:FindFirstChild("HumanoidRootPart")
                if finalHRP and originalPos then
                    finalHRP.CFrame = originalPos
                end
            end
        end)
    end
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
        _G.AutoLog = Value
        if not Value then return end

        task.spawn(function()
            local player = game.Players.LocalPlayer
            local cookPos = CFrame.new(0.5406733,12.499372,-0.7186632)
            local originalPos = nil

            while _G.AutoLog do
                task.wait(0.1)

                local characterNow = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPartNow = nil
                if characterNow then
                    humanoidRootPartNow = characterNow:FindFirstChild("HumanoidRootPart")
                end
                if humanoidRootPartNow and not originalPos then
                    originalPos = humanoidRootPartNow.CFrame
                end
                if not humanoidRootPartNow then
                    continue
                end

                local nearestLog = nil
                local nearestDistance = nil
                for _, possibleLog in pairs(workspace:GetDescendants()) do
                    if possibleLog:IsA("Model") and possibleLog.Name == "Log" and possibleLog.PrimaryPart then
                        local dist = (possibleLog.PrimaryPart.Position - humanoidRootPartNow.Position).Magnitude
                        if nearestDistance == nil or dist < nearestDistance then
                            nearestDistance = dist
                            nearestLog = possibleLog
                        end
                    end
                end

                if nearestLog then
                    humanoidRootPartNow.CFrame = nearestLog.PrimaryPart.CFrame
                    nearestLog:SetPrimaryPartCFrame(cookPos)
                    task.wait(0.15)
                end
            end

            local finalCharacter = player.Character
            if finalCharacter then
                local finalHRP = finalCharacter:FindFirstChild("HumanoidRootPart")
                if finalHRP and originalPos then
                    finalHRP.CFrame = originalPos
                end
            end
        end)
    end
})
Camp:AddToggle({
    Name = "Auto Fire (Bring)",
    Flag = "AutoLogBring",
    Default = false,
    Callback = function(Value)
        _G.AutoLogBring = Value
        if not _G.broughtModelsPermanent then _G.broughtModelsPermanent = {} end
        if not Value then return end

        task.spawn(function()
            local player = game.Players.LocalPlayer
            local modelNames = {"Log","Fuel","Small Tree", "Mousel", "Coal"}

            while _G.AutoLogBring do
                task.wait(0.1)

                local characterNow = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPartNow = characterNow and characterNow:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPartNow then continue end

                local nearestModel = nil
                local nearestDistance = nil
                for _, possibleModel in pairs(workspace:GetDescendants()) do
                    if possibleModel:IsA("Model") and possibleModel.PrimaryPart and table.find(modelNames, possibleModel.Name) then
                        if not _G.broughtModelsPermanent[possibleModel] then
                            local dist = (possibleModel.PrimaryPart.Position - humanoidRootPartNow.Position).Magnitude
                            if nearestDistance == nil or dist < nearestDistance then
                                nearestDistance = dist
                                nearestModel = possibleModel
                            end
                        end
                    end
                end

                if nearestModel then
                    nearestModel:SetPrimaryPartCFrame(humanoidRootPartNow.CFrame + Vector3.new(0,0,5))
                    _G.broughtModelsPermanent[nearestModel] = true
                    task.wait(0.15)
                end
            end
        end)
    end
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
Player:AddParagraph({
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
	Flag = "Toggle",
	Default = false,
	Callback = function(Value)
   end,
})
KillAura:AddToggle({
	Name = "Kill Aura (All)",
	Flag = "Toggle",
	Default = false,
	Callback = function(Value)
   end,
})

--[[ Class Auto Buy ]]--
Class:AddDropdown({
	Name = "Select Class",
	Default = "",
	Values = {"All"},
	Callback = print
})
Class:AddToggle({
	Name = "Auto Buy",
	Flag = "Toggle",
	Default = false,
	Callback = function(Value)
   end,
})

--[[ Tree ]]--

spawn(function()
	while true do
		task.wait(0.1)
		_G.AutoChopTP = Section.Flags.AutoChopTree

		if _G.AutoChopTP then
			local player = game.Players.LocalPlayer
			local UIS = game:GetService("UserInputService")
			local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			local originalPos = hrp and hrp.CFrame

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

			if hrp and originalPos then
				hrp.CFrame = originalPos
			end
		end
	end
end)
