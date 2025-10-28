getgenv().Settings = {
     ToggleInfJump = nil,
     ToggleAimbot = nil,
     ToggleTargetAimbot = nil,
     AimbotTarget = nil,
     ToggleESPBox = nil,
     ToggleESPHuman = nil,
     ToggleESPLine = nil,
     ToggleSpeed = nil,
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
    Title = "Aura Hub - [Premium]" ,
    SubTitle = "Ziugpro",
    TabWidth = 160,
    Size = UDim2.fromOffset(490, 385),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})
local Tabs = {
    Sv = Window:AddTab({ Title = "Setting GUI", Icon = "settings" }),
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    
}
local Dropdown = Tabs.Main:AddDropdown("AimbotTarget", {
    Title = "Aimbot Target",
    Values = {},
    Multi = false,
    Default = nil,
    Callback = function(Value)
        getgenv().Settings.AimbotTarget = Value
        SaveSetting()
    end
})

Tabs.Main:AddButton({
    Title = "Reset List",
    Description = "",
    Callback = function()
        local players = {}
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                table.insert(players, plr.Name)
            end
        end
        Dropdown:SetValues(players)
    end
})

local Toggle = Tabs.Main:AddToggle("ToggleTargetAimbot", {
    Title = "Aimbot (Selected Target)",
    Default = getgenv().Settings.ToggleTargetAimbot or false,
    Callback = function(Value)
        getgenv().Settings.ToggleTargetAimbot = Value
        local player = game.Players.LocalPlayer
        local camera = workspace.CurrentCamera
        local RunService = game:GetService("RunService")

        if Value then
            getgenv().TargetAimbotConnection = RunService.RenderStepped:Connect(function()
                local targetName = getgenv().Settings.AimbotTarget
                local target = targetName and game.Players:FindFirstChild(targetName)
                if target and target.Character and target.Character:FindFirstChild("Head") then
                    local head = target.Character.Head
                    local ray = Ray.new(camera.CFrame.Position, (head.Position - camera.CFrame.Position).Unit * 9999)
                    local hit = workspace:FindPartOnRay(ray, player.Character)
                    if hit and hit:IsDescendantOf(target.Character) then
                        camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
                    end
                end
            end)
        else
            if getgenv().TargetAimbotConnection then
                getgenv().TargetAimbotConnection:Disconnect()
                getgenv().TargetAimbotConnection = nil
            end
        end

        SaveSetting()
    end
})
local Toggle = Tabs.Main:AddToggle("ToggleAimbot", {
    Title = "Aimbot (Head, Visible Only)",
    Default = getgenv().Settings.ToggleAimbot or false,
    Callback = function(Value)
        getgenv().Settings.ToggleAimbot = Value
        local player = game.Players.LocalPlayer
        local camera = workspace.CurrentCamera
        local RunService = game:GetService("RunService")
        local Mouse = player:GetMouse()

        if Value then
            getgenv().AimbotConnection = RunService.RenderStepped:Connect(function()
                local closestPlayer, shortestDistance = nil, math.huge
                for _, target in pairs(game.Players:GetPlayers()) do
                    if target ~= player and target.Character and target.Character:FindFirstChild("Head") then
                        local head = target.Character.Head
                        local headPos, onScreen = camera:WorldToViewportPoint(head.Position)
                        if onScreen then
                            local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(headPos.X, headPos.Y)).Magnitude
                            if dist < shortestDistance and dist < 300 then -- 300 = độ nhạy aimbot
                                local ray = Ray.new(camera.CFrame.Position, (head.Position - camera.CFrame.Position).Unit * 9999)
                                local hit = workspace:FindPartOnRay(ray, player.Character)
                                if hit and hit:IsDescendantOf(target.Character) then
                                    closestPlayer = target
                                    shortestDistance = dist
                                end
                            end
                        end
                    end
                end

                if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
                    camera.CFrame = CFrame.new(camera.CFrame.Position, closestPlayer.Character.Head.Position)
                end
            end)
        else
            if getgenv().AimbotConnection then
                getgenv().AimbotConnection:Disconnect()
                getgenv().AimbotConnection = nil
            end
        end

        SaveSetting()
    end
})

local Main = Tabs.Main:AddSection("ESP")
local Toggle = Tabs.Main:AddToggle("ToggleESPBox", {
    Title = "ESP Box",
    Default = getgenv().Settings.ToggleESPBox or false,
    Callback = function(Value)
        getgenv().Settings.ToggleESPBox = Value
        SaveSetting()

        local RunService = game:GetService("RunService")
        local PlayersService = game:GetService("Players")
        local Camera = workspace.CurrentCamera
        local Lines, Quads = {}, {}

        local function HasCharacter(Player)
            return Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        end

        local function DrawQuad(PosA, PosB, PosC, PosD)
            local PosAScreen, PosAVisible = Camera:WorldToViewportPoint(PosA)
            local PosBScreen, PosBVisible = Camera:WorldToViewportPoint(PosB)
            local PosCScreen, PosCVisible = Camera:WorldToViewportPoint(PosC)
            local PosDScreen, PosDVisible = Camera:WorldToViewportPoint(PosD)
            if not (PosAVisible or PosBVisible or PosCVisible or PosDVisible) then return end
            local Quad = Drawing.new("Quad")
            Quad.Thickness = 0.5
            Quad.Color = Color3.fromRGB(255, 255, 255)
            Quad.Transparency = 0.25
            Quad.ZIndex = 1
            Quad.Filled = true
            Quad.Visible = true
            Quad.PointA = Vector2.new(PosAScreen.X, PosAScreen.Y)
            Quad.PointB = Vector2.new(PosBScreen.X, PosBScreen.Y)
            Quad.PointC = Vector2.new(PosCScreen.X, PosCScreen.Y)
            Quad.PointD = Vector2.new(PosDScreen.X, PosDScreen.Y)
            table.insert(Quads, Quad)
        end

        local function DrawLine(From, To)
            local FromScreen, FromVisible = Camera:WorldToViewportPoint(From)
            local ToScreen, ToVisible = Camera:WorldToViewportPoint(To)
            if not (FromVisible or ToVisible) then return end
            local Line = Drawing.new("Line")
            Line.Thickness = 1
            Line.From = Vector2.new(FromScreen.X, FromScreen.Y)
            Line.To = Vector2.new(ToScreen.X, ToScreen.Y)
            Line.Color = Color3.fromRGB(255, 255, 255)
            Line.Transparency = 1
            Line.ZIndex = 1
            Line.Visible = true
            table.insert(Lines, Line)
        end

        local function GetCorners(Part)
            local CF, Size, Corners = Part.CFrame, Part.Size / 2, {}
            for X = -1, 1, 2 do
                for Y = -1, 1, 2 do
                    for Z = -1, 1, 2 do
                        Corners[#Corners+1] = (CF * CFrame.new(Size * Vector3.new(X, Y, Z))).Position
                    end
                end
            end
            return Corners
        end

        local function DrawEsp(Player)
            local HRP = Player.Character.HumanoidRootPart
            local CubeVertices = GetCorners({CFrame = HRP.CFrame * CFrame.new(0, -0.5, 0), Size = Vector3.new(3, 5, 3)})
            DrawLine(CubeVertices[1], CubeVertices[2])
            DrawLine(CubeVertices[2], CubeVertices[6])
            DrawLine(CubeVertices[6], CubeVertices[5])
            DrawLine(CubeVertices[5], CubeVertices[1])
            DrawQuad(CubeVertices[1], CubeVertices[2], CubeVertices[6], CubeVertices[5])
            DrawLine(CubeVertices[1], CubeVertices[3])
            DrawLine(CubeVertices[2], CubeVertices[4])
            DrawLine(CubeVertices[6], CubeVertices[8])
            DrawLine(CubeVertices[5], CubeVertices[7])
            DrawQuad(CubeVertices[2], CubeVertices[4], CubeVertices[8], CubeVertices[6])
            DrawQuad(CubeVertices[1], CubeVertices[2], CubeVertices[4], CubeVertices[3])
            DrawQuad(CubeVertices[1], CubeVertices[5], CubeVertices[7], CubeVertices[3])
            DrawQuad(CubeVertices[5], CubeVertices[7], CubeVertices[8], CubeVertices[6])
            DrawLine(CubeVertices[3], CubeVertices[4])
            DrawLine(CubeVertices[4], CubeVertices[8])
            DrawLine(CubeVertices[8], CubeVertices[7])
            DrawLine(CubeVertices[7], CubeVertices[3])
            DrawQuad(CubeVertices[3], CubeVertices[4], CubeVertices[8], CubeVertices[7])
        end

        local function BoxEsp()
            local Players = PlayersService:GetPlayers()
            for _, Line in pairs(Lines) do Line:Remove() end
            Lines = {}
            for _, Quad in pairs(Quads) do Quad:Remove() end
            Quads = {}
            for _, Player in pairs(Players) do
                if Player ~= game.Players.LocalPlayer and HasCharacter(Player) then
                    DrawEsp(Player)
                end
            end
        end

        if Value then
            getgenv().ESPConnection = RunService.RenderStepped:Connect(BoxEsp)
        else
            if getgenv().ESPConnection then
                getgenv().ESPConnection:Disconnect()
                getgenv().ESPConnection = nil
            end
            for _, Line in pairs(Lines) do Line:Remove() end
            for _, Quad in pairs(Quads) do Quad:Remove() end
        end
    end
})
local Toggle = Tabs.Main:AddToggle("ToggleESPHuman", {
    Title = "ESP Human",
    Default = false,
    Callback = function(Value)
        if Value then
            getgenv().Settings.ToggleESPHuman = true

            -- ▼▼▼ TOÀN BỘ CODE GỐC CỦA MÀY ▼▼▼
            local Settings = {
                TeamCheck = true, -- Overules Color
                Red = Color3.fromRGB(255, 0, 0),
                Green = Color3.fromRGB(0, 255, 0),
                Color = Color3.fromRGB(255, 0, 0),
                TeamColor = false
            }

            local player = game:GetService("Players").LocalPlayer
            local camera = game:GetService("Workspace").CurrentCamera
            local mouse = player:GetMouse()
            getgenv().ESPHumanDrawings = {}
            getgenv().ESPHumanConnections = {}

            local function NewQuad(color)
                local quad = Drawing.new("Quad")
                quad.Visible = false
                quad.PointA = Vector2.new(0,0)
                quad.PointB = Vector2.new(0,0)
                quad.PointC = Vector2.new(0,0)
                quad.PointD = Vector2.new(0,0)
                quad.Color = color
                quad.Filled = true
                quad.Thickness = 1
                quad.Transparency = 0.25
                table.insert(getgenv().ESPHumanDrawings, quad)
                return quad
            end

            local function Colorize(color, lib)
                for i, v in pairs(lib) do
                    v.Color = color
                end
            end

            local function ESP(object, plr)
                local part = object
                local quads = {
                    quad1 = NewQuad(Settings.Color),
                    quad2 = NewQuad(Settings.Color),
                    quad3 = NewQuad(Settings.Color),
                    quad4 = NewQuad(Settings.Color),
                    quad5 = NewQuad(Settings.Color),
                    quad6 = NewQuad(Settings.Color)
                }

                local function Updater()
                    local connection
                    connection = game:GetService("RunService").RenderStepped:Connect(function()
                        if getgenv().Settings.ToggleESPHuman == false then
                            connection:Disconnect()
                            return
                        end
                        if plr.Character ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild(object.Name) ~= nil then
                            local partpos, onscreen = camera:WorldToViewportPoint(part.Position)
                            if onscreen then
                                local size_X = part.Size.X/2
                                local size_Y = part.Size.Y/2
                                local size_Z = part.Size.Z/2

                                local Top1 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(-size_X, size_Y, -size_Z)).p)
                                local Top2 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(-size_X, size_Y, size_Z)).p)
                                local Top3 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(size_X, size_Y, size_Z)).p)
                                local Top4 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(size_X, size_Y, -size_Z)).p)

                                local Bottom1 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(-size_X, -size_Y, -size_Z)).p)
                                local Bottom2 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(-size_X, -size_Y, size_Z)).p)
                                local Bottom3 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(size_X, -size_Y, size_Z)).p)
                                local Bottom4 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(size_X, -size_Y, -size_Z)).p)

                                quads.quad1.PointA = Vector2.new(Top1.X, Top1.Y)
                                quads.quad1.PointB = Vector2.new(Top2.X, Top2.Y)
                                quads.quad1.PointC = Vector2.new(Top3.X, Top3.Y)
                                quads.quad1.PointD = Vector2.new(Top4.X, Top4.Y)

                                quads.quad2.PointA = Vector2.new(Bottom1.X, Bottom1.Y)
                                quads.quad2.PointB = Vector2.new(Bottom2.X, Bottom2.Y)
                                quads.quad2.PointC = Vector2.new(Bottom3.X, Bottom3.Y)
                                quads.quad2.PointD = Vector2.new(Bottom4.X, Bottom4.Y)

                                quads.quad3.PointA = Vector2.new(Top1.X, Top1.Y)
                                quads.quad3.PointB = Vector2.new(Top2.X, Top2.Y)
                                quads.quad3.PointC = Vector2.new(Bottom2.X, Bottom2.Y)
                                quads.quad3.PointD = Vector2.new(Bottom1.X, Bottom1.Y)

                                quads.quad4.PointA = Vector2.new(Top2.X, Top2.Y)
                                quads.quad4.PointB = Vector2.new(Top3.X, Top3.Y)
                                quads.quad4.PointC = Vector2.new(Bottom3.X, Bottom3.Y)
                                quads.quad4.PointD = Vector2.new(Bottom2.X, Bottom2.Y)

                                quads.quad5.PointA = Vector2.new(Top3.X, Top3.Y)
                                quads.quad5.PointB = Vector2.new(Top4.X, Top4.Y)
                                quads.quad5.PointC = Vector2.new(Bottom4.X, Bottom4.Y)
                                quads.quad5.PointD = Vector2.new(Bottom3.X, Bottom3.Y)

                                quads.quad6.PointA = Vector2.new(Top4.X, Top4.Y)
                                quads.quad6.PointB = Vector2.new(Top1.X, Top1.Y)
                                quads.quad6.PointC = Vector2.new(Bottom1.X, Bottom1.Y)
                                quads.quad6.PointD = Vector2.new(Bottom4.X, Bottom4.Y)

                                if Settings.Team_Check then
                                    if plr.TeamColor == player.TeamColor then
                                        local group_color = Settings.Green
                                        Colorize(group_color, quads)
                                    else 
                                        local group_color = Settings.Red
                                        Colorize(group_color, quads)
                                    end
                                else 
                                    local group_color = Settings.Color
                                    Colorize(group_color, quads)
                                end

                                if Settings.TeamColor then
                                    Colorize(plr.TeamColor.Color, quads)
                                end

                                for u, x in pairs(quads) do
                                    x.Visible = true
                                end
                            else 
                                for u, x in pairs(quads) do
                                    x.Visible = false
                                end
                            end
                        else 
                            for u, x in pairs(quads) do
                                x.Visible = false
                            end
                            if game.Players:FindFirstChild(plr.Name) == nil then
                                connection:Disconnect()
                            end
                        end
                    end)
                    table.insert(getgenv().ESPHumanConnections, connection)
                end
                coroutine.wrap(Updater)()
            end

            for i, v in pairs(game:GetService("Players"):GetPlayers()) do
                spawn(function()
                    if v.Name ~= player.Name then
                        repeat wait() until v.Character ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("Head") ~= nil
                        for u, x in pairs(v.Character:GetChildren()) do
                            if x:IsA("MeshPart") or x.Name == "Head" or x.Name == "Left Arm" or x.Name == "Right Arm" or x.Name == "Right Leg" or x.Name == "Left Leg" or x.Name == "Torso" then
                                coroutine.wrap(ESP)(x, v)
                            end
                        end
                    end
                end)
            end

            game.Players.PlayerAdded:Connect(function(newplr)
                spawn(function()
                    if newplr.Name ~= player.Name then
                        repeat wait() until newplr.Character ~= nil and newplr.Character:FindFirstChild("Humanoid") ~= nil and newplr.Character:FindFirstChild("HumanoidRootPart") ~= nil and newplr.Character.Humanoid.Health > 0 and newplr.Character:FindFirstChild("Head") ~= nil
                        for u, x in pairs(newplr.Character:GetChildren()) do
                            if x:IsA("MeshPart") or x.Name == "Head" or x.Name == "Left Arm" or x.Name == "Right Arm" or x.Name == "Right Leg" or x.Name == "Left Leg" or x.Name == "Torso" then
                                coroutine.wrap(ESP)(x, newplr)
                            end
                        end
                    end
                end)
            end)
            -- ▲▲▲ CODE GỐC CỦA MÀY GIỮ NGUYÊN ▲▲▲

        else
            getgenv().Settings.ToggleESPHuman = false
            if getgenv().ESPHumanConnections then
                for _, conn in pairs(getgenv().ESPHumanConnections) do
                    conn:Disconnect()
                end
            end
            if getgenv().ESPHumanDrawings then
                for _, draw in pairs(getgenv().ESPHumanDrawings) do
                    draw:Remove()
                end
            end
            getgenv().ESPHumanDrawings = {}
            getgenv().ESPHumanConnections = {}
        end
    end
})
local Toggle = Tabs.Main:AddToggle("ToggleESPLine", {
    Title = "ESP Line",
    Default = false,
    Callback = function(Value)
        if Value then
            getgenv().Settings.ToggleESPLine = true
            getgenv().ESPLineDrawings = {}
            getgenv().ESPLineConnections = {}

            local camera = workspace.CurrentCamera
            local player = game.Players.LocalPlayer
            local RunService = game:GetService("RunService")

            local function CreateLine()
                local line = Drawing.new("Line")
                line.Visible = false
                line.Thickness = 1.5
                line.Transparency = 1
                line.Color = Color3.fromRGB(255, 255, 255)
                table.insert(getgenv().ESPLineDrawings, line)
                return line
            end

            local function DrawLineToHead(target)
                local line = CreateLine()
                local connection
                connection = RunService.RenderStepped:Connect(function()
                    if not getgenv().Settings.ToggleESPLine then
                        line:Remove()
                        connection:Disconnect()
                        return
                    end

                    if target.Character and target.Character:FindFirstChild("Head") then
                        local head = target.Character.Head
                        local headPos, onScreen = camera:WorldToViewportPoint(head.Position)

                        if onScreen then
                            local screenCenter = Vector2.new(camera.ViewportSize.X / 2, 0)
                            line.From = screenCenter
                            line.To = Vector2.new(headPos.X, headPos.Y)
                            line.Visible = true
                        else
                            line.Visible = false
                        end
                    else
                        line.Visible = false
                    end
                end)
                table.insert(getgenv().ESPLineConnections, connection)
            end

            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= player then
                    DrawLineToHead(plr)
                end
            end

            game.Players.PlayerAdded:Connect(function(newplr)
                if newplr ~= player then
                    DrawLineToHead(newplr)
                end
            end)

        else
            getgenv().Settings.ToggleESPLine = false
            if getgenv().ESPLineConnections then
                for _, conn in pairs(getgenv().ESPLineConnections) do
                    conn:Disconnect()
                end
            end
            if getgenv().ESPLineDrawings then
                for _, line in pairs(getgenv().ESPLineDrawings) do
                    line:Remove()
                end
            end
            getgenv().ESPLineConnections = {}
            getgenv().ESPLineDrawings = {}
        end
    end
})
local Main = Tabs.Main:AddSection("Local")
local Toggle = Tabs.Main:AddToggle("ToggleSpeed", {
    Title = "Speed Boost", 
    Default = getgenv().Settings.ToggleSpeed or false,
    Callback = function(Value)
        getgenv().Settings.ToggleSpeed = Value
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            if Value then
                humanoid.WalkSpeed = 100
            else
                humanoid.WalkSpeed = 16
            end
        end

        SaveSetting()
    end
})
local Toggle = Tabs.Main:AddToggle("ToggleInfJump", {
    Title = "Infinite Jump", 
    Default = getgenv().Settings.ToggleInfJump or false,
    Callback = function(Value)
        getgenv().Settings.ToggleInfJump = Value
        local player = game.Players.LocalPlayer
        local userInput = game:GetService("UserInputService")

        if Value then
            getgenv().InfJumpConnection = userInput.JumpRequest:Connect(function()
                local character = player.Character
                if character and character:FindFirstChildOfClass("Humanoid") then
                    character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if getgenv().InfJumpConnection then
                getgenv().InfJumpConnection:Disconnect()
                getgenv().InfJumpConnection = nil
            end
        end

        SaveSetting()
    end
})
local Toggle = Tabs.Main:AddToggle("ToggleNoclip", {
    Title = "Noclip",
    Default = getgenv().Settings.ToggleNoclip or false,
    Callback = function(Value)
        getgenv().Settings.ToggleNoclip = Value
        local player = game.Players.LocalPlayer
        local RunService = game:GetService("RunService")

        if Value then
            getgenv().NoclipConnection = RunService.Stepped:Connect(function()
                local character = player.Character
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if getgenv().NoclipConnection then
                getgenv().NoclipConnection:Disconnect()
                getgenv().NoclipConnection = nil
            end

            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end

        SaveSetting()
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

