getgenv().Settings = {
     CollectRemotes = nil,
     FlySpeed = nil,
     TeleportAndFire = nil,
     InstantFly = nil,
     FlyMode = nil,
     SpeedToggle = nil,
     InfJump = nil,
     InstantTP = nil,
     AntiServer = nil,
     MyHitbox = nil,
     hitboxsize = nil,
     ShowHitbox = nil,
}
local FileName = tostring(game.Players.LocalPlayer.UserId).."_Settings.json"
local BaseFolder = "AuraHub"
local SubFolder = "AuraHubSave"

function SaveSetting() 
    local json
    local HttpService = game:GetService("HttpService")
    
    if writefile then
        json = HttpService:JSONEncode(getgenv().Settings)

        if not isfolder(BaseFolder) then
            makefolder(BaseFolder)
        end
        if not isfolder(BaseFolder.."/"..SubFolder) then
            makefolder(BaseFolder.."/"..SubFolder)
        end
        
        writefile(BaseFolder.."/"..SubFolder.."/"..FileName, json)
    else
        error("ERROR: Can't save your settings")
    end
end

function LoadSetting()
    local HttpService = game:GetService("HttpService")
    if readfile and isfile and isfile(BaseFolder.."/"..SubFolder.."/"..FileName) then
        getgenv().Settings = HttpService:JSONDecode(readfile(BaseFolder.."/"..SubFolder.."/"..FileName))
    end
end

LoadSetting()

game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Success Loading",
    Icon = "rbxthumb://type=Asset&id=131484641795167&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Aura Hub - Build a Zoo [Premium]" ,
    SubTitle = "Ziugpro",
    TabWidth = 130,
    Size = UDim2.fromOffset(505, 345),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})
local Tabs = {
    Player = Window:AddTab({ Title = "Tab Players", Icon = "" }),
    Main = Window:AddTab({ Title = "Tab Famring", Icon = "" }),
    Anti = Window:AddTab({ Title = "Tab Anti", Icon = "" }),
}

local Main = Tabs.Main:AddSection("Coins")
local CollectRemotes = Tabs.Main:AddToggle("CollectRemotes", {
    Title = "Auto Collect Coins",
    Description = "สะสมเหรียญอัตโนมัติ",
    Default = getgenv().Settings.CollectRemotes or false,
    Callback = function(Value)
        getgenv().Settings.CollectRemotes = Value
        SaveSetting()
        if Value then
            spawn(function()
                while getgenv().Settings.CollectRemotes do
                    for _, obj in pairs(game:GetDescendants()) do
                        if obj:IsA("RemoteEvent") and string.lower(obj.Name) == "collecthl" then
                            pcall(function() obj:FireServer() end)
                            pcall(function() obj:FireServer(true) end)
                            pcall(function() obj:FireServer(game.Players.LocalPlayer) end)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})
local InstantTP = Tabs.Main:AddToggle("InstantTP", {
    Title = "Auto Collect Coins (Test)",
    Description = "การสะสมเหรียญอัตโนมัติ (ทดสอบ)",
    Default = getgenv().Settings.InstantTP or false,
    Callback = function(Value)
        getgenv().Settings.InstantTP = Value
        SaveSetting()
        if Value then
            spawn(function()
                while getgenv().Settings.InstantTP do
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, model in pairs(workspace:GetDescendants()) do
                            if model:IsA("Model") and string.match(model.Name, "^[a-f0-9]+$") and #model.Name >= 30 then
                                local targetPos
                                if model.PrimaryPart then
                                    targetPos = model.PrimaryPart.Position
                                else
                                    local total = Vector3.new(0,0,0)
                                    local count = 0
                                    for _, part in pairs(model:GetDescendants()) do
                                        if part:IsA("BasePart") then
                                            total += part.Position
                                            count += 1
                                        end
                                    end
                                    if count > 0 then
                                        targetPos = total / count
                                    end
                                end
                                if targetPos then
                                    hrp.CFrame = CFrame.new(targetPos)
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

local Main = Tabs.Main:AddSection("Egg Shop")
local Input = Tabs.Main:AddInput("FlySpeed", {
    Title = "Speed Buy",
    Default = getgenv().Settings.FlySpeed or "50",
    Placeholder = "",
    Description = "ซื้อเร็ว",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            getgenv().Settings.FlySpeed = num
            SaveSetting()
        end
    end
})
local TweenService = game:GetService("TweenService")
local InstantFly = Tabs.Main:AddToggle("InstantFly", {
    Title = "Auto Buy Egg",
    Description = "ซื้อไข่อัตโนมัติ",
    Default = getgenv().Settings.InstantFly or false,
    Callback = function(Value)
        getgenv().Settings.InstantFly = Value
        SaveSetting()
        if Value then
            spawn(function()
                while getgenv().Settings.InstantFly do
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, obj in pairs(game:GetDescendants()) do
                            if obj:IsA("BasePart") and string.lower(obj.Name) == "belt" then
                                local targetPosition = obj.Position
                                local distance = (targetPosition - hrp.Position).Magnitude
                                local speed = getgenv().Settings.FlySpeed or 50
                                local time = distance / speed
                                local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                                local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPosition)})
                                tween:Play()
                                tween.Completed:Wait()

                                for _, prompt in pairs(workspace:GetDescendants()) do
                                    if prompt:IsA("ProximityPrompt") and (prompt.Parent:IsA("BasePart") and (prompt.Parent.Position - hrp.Position).Magnitude <= prompt.MaxActivationDistance) then
                                        pcall(function()
                                            fireproximityprompt(prompt)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})
local Main = Tabs.Main:AddSection("Shop")
local TeleportAndFire = Tabs.Main:AddToggle("TeleportAndFire", {
    Title = "Auto Buy Food (Good)",
    Description = "ซื้ออาหารอัตโนมัติ (ดี)",
    Default = getgenv().Settings.TeleportAndFire or false,
    Callback = function(Value)
        getgenv().Settings.TeleportAndFire = Value
        SaveSetting()

        if Value then
            spawn(function()
                while getgenv().Settings.TeleportAndFire do
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local targetCFrame = CFrame.new(-634.693115234375, 20.385948181152344, 99.90825653076172)
                        character.HumanoidRootPart.CFrame = targetCFrame

                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("Model") then
                                local modelPos = (obj:GetModelCFrame().Position - character.HumanoidRootPart.Position).Magnitude
                                if modelPos <= 20 then
                                    for _, re in pairs(obj:GetDescendants()) do
                                        if re:IsA("RemoteEvent") then
                                            pcall(function()
                                                re:FireServer()
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    wait(0.1)
                end
            end)
        end
    end
})
local Main = Tabs.Anti:AddSection("Anti")
local AntiServer = Tabs.Anti:AddToggle("AntiServer", {
    Title = "Anti Server - แอนตี้เซิร์ฟเวอร์",
    Description = "Kick if server has more than 1 person - เตะออกหากเซิร์ฟเวอร์มีมากกว่า 1 คน",
    Default = getgenv().Settings.AntiServer or false,
    Callback = function(Value)
        getgenv().Settings.AntiServer = Value
        SaveSetting()

        if Value then
            spawn(function()
                while getgenv().Settings.AntiServer do
                    local players = game.Players:GetPlayers()
                    if #players > 1 then
                        game.Players.LocalPlayer:Kick("Anti Server Active: Too many players")
                        break
                    end
                    wait()
                end
            end)
        end
    end
})

local SpeedToggle = Tabs.Player:AddToggle("SpeedToggle", {
    Title = "Speed Boost",
    Description = "เพิ่มความเร็ว",
    Default = getgenv().Settings.SpeedToggle or false,
    Callback = function(Value)
        getgenv().Settings.SpeedToggle = Value
        SaveSetting()

        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        if Value then
            humanoid.WalkSpeed = 500
        else
            humanoid.WalkSpeed = 16
        end
    end
})
local UserInputService = game:GetService("UserInputService")

local InfJump = Tabs.Player:AddToggle("InfJump", {
    Title = "Infinite Jump",
    Description = "กระโดดไม่สิ้นสุด",
    Default = getgenv().Settings.InfJump or false,
    Callback = function(Value)
        getgenv().Settings.InfJump = Value
        SaveSetting()

        if Value then
            getgenv().InfJumpConnection = UserInputService.JumpRequest:Connect(function()
                local player = game.Players.LocalPlayer
                local character = player.Character
                if character and character:FindFirstChildOfClass("Humanoid") then
                    character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end)
        else
            if getgenv().InfJumpConnection then
                getgenv().InfJumpConnection:Disconnect()
                getgenv().InfJumpConnection = nil
            end
        end
    end
})
local HitboxToggles = {}
local ShowHitbox = Tabs.Player:AddToggle("ShowHitbox", {
    Title = "Show Hitbox",
    Default = getgenv().Settings.ShowHitbox or false,
    Callback = function(Value)
        getgenv().Settings.ShowHitbox = Value
        SaveSetting()
        if Value then
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Adornee = part
                    box.Size = part.Size
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Color3 = Color3.fromRGB(255, 0, 0)
                    box.Transparency = 0.6
                    box.Parent = game.CoreGui
                    HitboxToggles[part] = box
                end
            end
        else
            for _, adorn in pairs(HitboxToggles) do
                if adorn and adorn.Parent then
                    adorn:Destroy()
                end
            end
            table.clear(HitboxToggles)
        end
    end
})
local hitboxsize = Tabs.Player:AddSlider("hitboxsize", {
    Title = "Hitbox Size",
    Default = getgenv().Settings.hitboxsize or 15,
    Min = 15,
    Max = 500,
    Rounding = 1,
    Callback = function(Value)
        getgenv().Settings.Slider = Value
        SaveSetting()
        if getgenv().Settings.MyHitbox then
            hrp.Size = Vector3.new(Value, Value, Value)
        end
    end
})
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local MyHitbox = Tabs.Player:AddToggle("MyHitbox", {
    Title = "Hitbox Increase",
    Default = getgenv().Settings.MyHitbox or false,
    Callback = function(Value)
        getgenv().Settings.MyHitbox = Value
        SaveSetting()
        if Value then
            hrp.Size = Vector3.new(getgenv().Settings.Slider, getgenv().Settings.Slider, getgenv().Settings.Slider)
            hrp.Transparency = 0.6
            hrp.Material = Enum.Material.Neon
            hrp.Color = Color3.fromRGB(0, 255, 0)
        else
            hrp.Size = Vector3.new(2, 2, 1)
            hrp.Transparency = 0
            hrp.Material = Enum.Material.Plastic
        end
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
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:SetFolder("AuraHub")
InterfaceManager:SetFolder("AuraHubSave")

SaveManager:BuildConfigSection(Tabs.Sv)
InterfaceManager:BuildInterfaceSection(Tabs.Sv)
