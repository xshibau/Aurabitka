local HttpService = game:GetService("HttpService")
local SaveFileName = "UISettings.json"

local function ReadFileSafe(path)
    local success, content = pcall(function() return readfile(path) end)
    return success and content or nil
end

local function WriteFileSafe(path, content)
    pcall(function() writefile(path, content) end)
end

local function DecodeJSONSafe(jsonStr)
    local success, data = pcall(function() return HttpService:JSONDecode(jsonStr) end)
    return success and type(data) == "table" and data or {}
end

local function EncodeJSONSafe(data)
    local success, jsonStr = pcall(function() return HttpService:JSONEncode(data) end)
    return success and jsonStr or ""
end

local SettingsData = DecodeJSONSafe(ReadFileSafe(SaveFileName))

local function LoadSetting(key, default)
    return SettingsData[key] ~= nil and SettingsData[key] or default
end

local function SaveSetting(key, value)
    SettingsData[key] = value
    WriteFileSafe(SaveFileName, EncodeJSONSafe(SettingsData))
end

local SkUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/xshibau/Aurabitka/refs/heads/main/SkUI_v1.72.lua"))()

local UI = SkUI:CreateWindow("SkUI V1.72 - By Ziugpro")

local Tab = UI:Create(110, "General")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local selectedToolName = LoadSetting("Selected_Tool", nil)

Tab:AddDropdown("Left", "Select Tool", (function()
    local backpack = player:WaitForChild("Backpack")
    local tools = {}
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            table.insert(tools, item.Name)
        end
    end
    return tools
end)(), selectedToolName, function(toolName)
    SaveSetting("Selected_Tool", toolName)
    selectedToolName = toolName
end)

local current = LoadSetting("AutoFarm", false)

local hrp
local currentMob = nil
local AutoFarmConnection1, AutoFarmConnection2, AutoFarmConnection3

local function setupCharacter(character)
    hrp = character:WaitForChild("HumanoidRootPart")
end

if player.Character then
    setupCharacter(player.Character)
end
player.CharacterAdded:Connect(setupCharacter)

local function getAliveMobs()
    local mobs = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 and obj.Parent and not Players:GetPlayerFromCharacter(obj) then
            table.insert(mobs, obj)
        end
    end
    return mobs
end

local function aimAtHead(mob)
    local camera = workspace.CurrentCamera
    local head = mob:FindFirstChild("Head")
    if head then
        camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
    end
end

Tab:AddToggle("Left", "Auto Farm", current, function(v)
    SaveSetting("AutoFarm", v)

    if v then
        AutoFarmConnection1 = RunService.RenderStepped:Connect(function()
            if hrp then
                if not currentMob or currentMob.Humanoid.Health <= 0 or not currentMob.Parent then
                    local mobs = getAliveMobs()
                    if #mobs > 0 then
                        local closest = mobs[1]
                        local minDist = (hrp.Position - (closest.PrimaryPart and closest.PrimaryPart.Position or closest.Head.Position)).Magnitude
                        for _, mob in ipairs(mobs) do
                            if mob.PrimaryPart then
                                local dist = (hrp.Position - mob.PrimaryPart.Position).Magnitude
                                if dist < minDist then
                                    minDist = dist
                                    closest = mob
                                end
                            end
                        end
                        currentMob = closest
                    else
                        currentMob = nil
                    end
                end

                if currentMob and currentMob:FindFirstChild("Head") and currentMob.Humanoid.Health > 0 then
                    hrp.CFrame = CFrame.new(currentMob.Head.Position + Vector3.new(0,4,0))
                end
            end
        end)

        AutoFarmConnection2 = RunService.RenderStepped:Connect(function()
            local mobs = getAliveMobs()
            if #mobs > 0 then
                local closest = mobs[1]
                local minDist = (workspace.CurrentCamera.CFrame.Position - (closest.PrimaryPart and closest.PrimaryPart.Position or closest.Head.Position)).Magnitude
                for _, mob in ipairs(mobs) do
                    if mob.PrimaryPart then
                        local dist = (workspace.CurrentCamera.CFrame.Position - mob.PrimaryPart.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closest = mob
                        end
                    end
                end
                aimAtHead(closest)
            end
        end)

        AutoFarmConnection3 = RunService.RenderStepped:Connect(function()
            if selectedToolName and player.Character and player.Character.Parent then
                local backpack = player:WaitForChild("Backpack")
                local tool = backpack:FindFirstChild(selectedToolName)
                if tool then
                    tool.Parent = player.Character
                end
            end
        end)
    else
        if AutoFarmConnection1 then AutoFarmConnection1:Disconnect() AutoFarmConnection1 = nil end
        if AutoFarmConnection2 then AutoFarmConnection2:Disconnect() AutoFarmConnection2 = nil end
        if AutoFarmConnection3 then AutoFarmConnection3:Disconnect() AutoFarmConnection3 = nil end
        currentMob = nil
    end
end)


Tab:AddTextLabel("Left", "Misc Farm")
local current = LoadSetting("AutoFarmFast", false)
local AutoFarmConnection1, AutoFarmConnection2, AutoFarmConnection3
local BackpackConnection1, BackpackConnection2
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local hrp

local function setupCharacter(character)
    hrp = character:WaitForChild("HumanoidRootPart")
end

if player.Character then
    setupCharacter(player.Character)
end
player.CharacterAdded:Connect(setupCharacter)

local function getAliveMobs()
    local mobs = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 and obj.Parent and not Players:GetPlayerFromCharacter(obj) then
            table.insert(mobs, obj)
        end
    end
    return mobs
end

local function aimAtHead(mob)
    local camera = workspace.CurrentCamera
    local head = mob:FindFirstChild("Head")
    if head then
        camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
    end
end

local currentMob = nil

Tab:AddToggle("Left", "Auto Farm Fast", current, function(v)
    SaveSetting("AutoFarmFast", v)

    if v then
        AutoFarmConnection1 = RunService.RenderStepped:Connect(function()
            if hrp then
                if not currentMob or currentMob.Humanoid.Health <= 0 or not currentMob.Parent then
                    local mobs = getAliveMobs()
                    if #mobs > 0 then
                        local closest = mobs[1]
                        local minDist = (hrp.Position - (closest.PrimaryPart and closest.PrimaryPart.Position or closest.Head.Position)).Magnitude
                        for _, mob in ipairs(mobs) do
                            if mob.PrimaryPart then
                                local dist = (hrp.Position - mob.PrimaryPart.Position).Magnitude
                                if dist < minDist then
                                    minDist = dist
                                    closest = mob
                                end
                            end
                        end
                        currentMob = closest
                    else
                        currentMob = nil
                    end
                end

                if currentMob and currentMob:FindFirstChild("Head") and currentMob.Humanoid.Health > 0 then
                    hrp.CFrame = CFrame.new(currentMob.Head.Position + Vector3.new(0,4,0))
                end
            end
        end)

        AutoFarmConnection2 = RunService.RenderStepped:Connect(function()
            local mobs = getAliveMobs()
            if #mobs > 0 then
                local closest = mobs[1]
                local minDist = (workspace.CurrentCamera.CFrame.Position - (closest.PrimaryPart and closest.PrimaryPart.Position or closest.Head.Position)).Magnitude
                for _, mob in ipairs(mobs) do
                    if mob.PrimaryPart then
                        local dist = (workspace.CurrentCamera.CFrame.Position - mob.PrimaryPart.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closest = mob
                        end
                    end
                end
                aimAtHead(closest)
            end
        end)

        AutoFarmConnection3 = RunService.RenderStepped:Connect(function()
            if player.Character and player.Character.Parent then
                local backpack = player:WaitForChild("Backpack")
                local tool = backpack:FindFirstChildWhichIsA("Tool")
                if tool then
                    tool.Parent = player.Character
                end
            end
        end)
    else
        if AutoFarmConnection1 then AutoFarmConnection1:Disconnect() AutoFarmConnection1 = nil end
        if AutoFarmConnection2 then AutoFarmConnection2:Disconnect() AutoFarmConnection2 = nil end
        if AutoFarmConnection3 then AutoFarmConnection3:Disconnect() AutoFarmConnection3 = nil end
        currentMob = nil
    end
end)

Tab:RealLine("Left")

Tab:AddTextLabel("Left", "Local")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")

local current = LoadSetting("SpeedHack", false)

if current and Humanoid then
    Humanoid.WalkSpeed = 100
end

Tab:AddToggle("Left", "Speed Hack", current, function(v)
    SaveSetting("SpeedHack", v)
    if v then
        if Humanoid then
            Humanoid.WalkSpeed = 100
        end
    else
        if Humanoid then
            Humanoid.WalkSpeed = 16
        end
    end
end)
local UserInputService = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer

local current = LoadSetting("InfiniteJump", false)

if current then
    UserInputService.JumpRequest:Connect(function()
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end

Tab:AddToggle("Left", "Infinite Jump", current, function(v)
    SaveSetting("InfiniteJump", v)
    if v then
        UserInputService.JumpRequest:Connect(function()
            if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
                Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    else
    end
end)
Tab:RealLine("Left")



--{ Right }--
Tab:AddTextLabel("Right", "Esp")
local current = LoadSetting("ESPPlayer", false)

if current then
    for i, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "PlayerBillboard"
            billboard.Adornee = player.Character.Head
            billboard.Size = UDim2.new(0, 100, 0, 30)
            billboard.AlwaysOnTop = true
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            local text = Instance.new("TextLabel", billboard)
            text.Size = UDim2.new(1,0,1,0)
            text.Text = player.Name
            text.BackgroundTransparency = 1
            text.TextColor3 = Color3.fromRGB(255,0,0)
            text.Font = Enum.Font.SourceSansBold
            text.TextSize = 14
            text.TextScaled = false
            billboard.Parent = player.Character
        end
    end
end

Tab:AddToggle("Right", "ESP Player", current, function(v)
    SaveSetting("ESPPlayer", v)
    for i, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if v then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "PlayerBillboard"
                billboard.Adornee = player.Character.Head
                billboard.Size = UDim2.new(0, 100, 0, 30)
                billboard.AlwaysOnTop = true
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                local text = Instance.new("TextLabel", billboard)
                text.Size = UDim2.new(1,0,1,0)
                text.Text = player.Name
                text.BackgroundTransparency = 1
                text.TextColor3 = Color3.fromRGB(255,0,0)
                text.Font = Enum.Font.SourceSansBold
                text.TextSize = 14
                text.TextScaled = false
                billboard.Parent = player.Character
            else
                local b = player.Character:FindFirstChild("PlayerBillboard")
                if b then b:Destroy() end
            end
        end
    end
end)
local current = LoadSetting("ESPMob", false)

if current then
    for i, mob in pairs(workspace:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("Head") then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "MobBillboard"
            billboard.Adornee = mob.Head
            billboard.Size = UDim2.new(0, 100, 0, 30)
            billboard.AlwaysOnTop = true
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            local text = Instance.new("TextLabel", billboard)
            text.Size = UDim2.new(1,0,1,0)
            text.Text = mob.Name
            text.BackgroundTransparency = 1
            text.TextColor3 = Color3.fromRGB(0,255,0)
            text.Font = Enum.Font.SourceSansBold
            text.TextSize = 14
            text.TextScaled = false
            billboard.Parent = mob
        end
    end
end

Tab:AddToggle("Right", "ESP Mob", current, function(v)
    SaveSetting("ESPMob", v)
    for i, mob in pairs(workspace:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("Head") then
            if v then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "MobBillboard"
                billboard.Adornee = mob.Head
                billboard.Size = UDim2.new(0, 100, 0, 30)
                billboard.AlwaysOnTop = true
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                local text = Instance.new("TextLabel", billboard)
                text.Size = UDim2.new(1,0,1,0)
                text.Text = mob.Name
                text.BackgroundTransparency = 1
                text.TextColor3 = Color3.fromRGB(0,255,0)
                text.Font = Enum.Font.SourceSansBold
                text.TextSize = 14
                text.TextScaled = false
                billboard.Parent = mob
            else
                local b = mob:FindFirstChild("MobBillboard")
                if b then b:Destroy() end
            end
        end
    end
end)

local current = LoadSetting("ESPGoldcoin", false)

local function createBillboard(obj)
    if obj:FindFirstChild("Head") or obj:IsA("BasePart") then
        local adornee = obj:IsA("BasePart") and obj or obj:FindFirstChild("Head")
        if adornee then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "GoldcoinBillboard"
            billboard.Adornee = adornee
            billboard.Size = UDim2.new(0,100,0,30)
            billboard.AlwaysOnTop = true
            billboard.StudsOffset = Vector3.new(0,2,0)
            local text = Instance.new("TextLabel", billboard)
            text.Size = UDim2.new(1,0,1,0)
            text.Text = obj.Name
            text.BackgroundTransparency = 1
            text.TextColor3 = Color3.fromRGB(255, 215, 0)
            text.Font = Enum.Font.SourceSansBold
            text.TextSize = 14
            text.TextScaled = false
            billboard.Parent = obj
        end
    end
end

if current then
    for i, obj in pairs(workspace:GetDescendants()) do
        if string.find(string.lower(obj.Name), "goldcoin") then
            createBillboard(obj)
        end
    end
end

Tab:AddToggle("Right", "ESP Goldcoin", current, function(v)
    SaveSetting("ESPGoldcoin", v)
    for i, obj in pairs(workspace:GetDescendants()) do
        if string.find(string.lower(obj.Name), "goldcoin") then
            if v then
                createBillboard(obj)
            else
                local b = obj:FindFirstChild("GoldcoinBillboard")
                if b then b:Destroy() end
            end
        end
    end
end)
Tab:RealLine("Right")
