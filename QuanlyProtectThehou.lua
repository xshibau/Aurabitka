local PremiumKeys = {  
"RH7CX-XMNS7-YTXEE-D16PO-HFU9O", -- 30/9 hết hạn
"76UPD-M3FOC-NP1KN-3ULEN-0ZZ2T", -- 30/9 hết hạn
"LGZWR-U6HTL-6Q08K-AI766-8U2W7", -- 30/9 hết hạn
"QC2V6-BKOYC-VH1M4-F1EWJ-7KNRI", -- 30/9 hết hạn
"6VQAR-H3PQT-HZK1H-HC59H-RBX3W", -- 30/9 hết hạn
}  
  
local BlacklistKeys = {  
    ["abc123"] = "Hành vi gian lận bị phát hiện",  
    ["badkey456"] = "Vi phạm điều khoản sử dụng",  
    ["xyz789"] = "Key đã bị thu hồi do lạm dụng"  
}  
  
local function isPremiumKey(key)  
    for _, v in ipairs(PremiumKeys) do  
        if v == key then  
            return true  
        end  
    end  
    return false  
end  
  
local function getBlacklistReason(key)  
    return BlacklistKeys[key]  
end  
  
if not script_key or getBlacklistReason(script_key) then  
    local reason = getBlacklistReason(script_key) or "Key bị chặn"  
    game:GetService("Players").LocalPlayer:Kick(reason)  
    return  
end  
  
if isPremiumKey(script_key) then  
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KaitunUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 99
ScreenGui.Parent = PlayerGui

local FullBlack = Instance.new("Frame")
FullBlack.Size = UDim2.new(1, 0, 1, 36)
FullBlack.Position = UDim2.new(0, 0, -0.03, 0)
FullBlack.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
FullBlack.BorderSizePixel = 0
FullBlack.ZIndex = 19999999
FullBlack.BackgroundTransparency = 1
FullBlack.Parent = ScreenGui

local Image = Instance.new("ImageLabel")
Image.Size = UDim2.new(0, 100, 0, 100)
Image.Position = UDim2.new(0.5, -50, 0.5, -90)
Image.BackgroundTransparency = 1
Image.Image = "rbxthumb://type=Asset&id=131484641795167&w=420&h=420"
Image.ZIndex = 29999999
Image.Parent = ScreenGui

local Version = Instance.new("TextLabel")
Version.AnchorPoint = Vector2.new(0.5, 0.5)
Version.Position = UDim2.new(0.5, 0, 0.5, 40)
Version.Size = UDim2.new(0, 600, 0, 50)
Version.BackgroundTransparency = 1
Version.Text = "Aura Hub"
Version.Font = Enum.Font.PermanentMarker
Version.TextSize = 55
Version.TextColor3 = Color3.fromRGB(255, 255, 255)
Version.ZIndex = 39999999
Version.Parent = ScreenGui

task.spawn(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

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

local currentMob = nil

RunService.RenderStepped:Connect(function()
    if hrp then
        if not currentMob or currentMob.Humanoid.Health <= 0 or not currentMob.Parent then
            local mobs = getAliveMobs()
            if #mobs > 0 then
                -- chọn Mob gần nhất
                local closest = mobs[1]
                local minDist = (hrp.Position - closest.PrimaryPart.Position).Magnitude
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
end)
task.spawn(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local function getAliveMobs()
    local mobs = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
            table.insert(mobs, obj)
        end
    end
    return mobs
end

local function aimAtHead(mob)
    local head = mob:FindFirstChild("Head")
    if head then
        local direction = (head.Position - camera.CFrame.Position).Unit
        camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
    end
end

RunService.RenderStepped:Connect(function()
    local mobs = getAliveMobs()
    if #mobs > 0 then
        local closest = mobs[1]
        local minDist = (camera.CFrame.Position - closest.PrimaryPart.Position).Magnitude
        for _, mob in ipairs(mobs) do
            if mob.PrimaryPart then
                local dist = (camera.CFrame.Position - mob.PrimaryPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = mob
                end
            end
        end
        aimAtHead(closest)
    end
end)
    end)
task.spawn(function()
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function equipFirstTool(character)
    local backpack = player:WaitForChild("Backpack")
    local function equip()
        local tool = nil
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                tool = item
                break
            end
        end
        if tool then
            tool.Parent = character
        end
    end
    backpack.ChildAdded:Connect(equip)
    backpack.ChildRemoved:Connect(equip)
    while character.Parent do
        equip()
        wait(0.1)
    end
end

if player.Character then
    equipFirstTool(player.Character)
end
player.CharacterAdded:Connect(equipFirstTool)
    end)
else  
    game:GetService("Players").LocalPlayer:Kick("Invalid Key")  
end
