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
-- Darkrai UI chỉnh sửa theo yêu cầu của Kiệt (UI 500x400, tab 200)
local PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)

if not game:IsLoaded() then repeat game.Loaded:Wait() until game:IsLoaded() end
repeat wait() until game:GetService("Players")
if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then repeat wait() until game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
wait(1)

do local GUI = game.CoreGui:FindFirstChild("Darkrai");if GUI then GUI:Destroy();end;if _G.Color == nil then
   _G.Color = Color3.fromRGB(255, 0, 0)
end end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		local Tween = TweenService:Create(object, TweenInfo.new(0.15), {Position = pos})
		Tween:Play()
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

local DarkraiX = {}

function DarkraiX:ToggleUi()
	local gui = game.CoreGui:FindFirstChild("Darkrai")
	if gui then
		gui.Enabled = not gui.Enabled
	end
end

function DarkraiX:Window(text,gamenme,logo,keybind)
	local hubname = text
	local gamename = gamenme
	local uihide = false
	local abc = false
	local logo = logo or 0
	local currentpage = ""
	local keybind = keybind or Enum.KeyCode.RightControl
	local yoo = string.gsub(tostring(keybind),"Enum.KeyCode.","")
	if gamename == "" then gamename = "" end

	local Darkrai = Instance.new("ScreenGui")
	Darkrai.Name = "Darkrai"
	Darkrai.Parent = game.CoreGui
	Darkrai.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Parent = Darkrai
	Main.ClipsDescendants = true
	Main.AnchorPoint = Vector2.new(0.5,0.5)
	Main.BackgroundColor3 = Color3.fromRGB(45,45,45)
	Main.Position = UDim2.new(0.5,0,0.5,0)
	Main.Size = UDim2.new(0,0,0,0)
	Main:TweenSize(UDim2.new(0,500,0,400),"Out","Quad",0.4,true)

	local MCNR = Instance.new("UICorner", Main)

	local Top = Instance.new("Frame", Main)
	Top.Name = "Top"
	Top.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Top.Size = UDim2.new(0,500,0,27)

	local TCNR = Instance.new("UICorner", Top)

	local Logo = Instance.new("ImageLabel", Top)
	Logo.BackgroundTransparency = 1
	Logo.Position = UDim2.new(0,10,0,1)
	Logo.Size = UDim2.new(0,25,0,25)
	Logo.Image = ""

	local Name = Instance.new("TextLabel", Top)
	Name.BackgroundTransparency = 1
	Name.Position = UDim2.new(0.06,0,0,0)
	Name.Size = UDim2.new(0,61,0,27)
	Name.Font = Enum.Font.GothamSemibold
	Name.Text = hubname
	Name.TextColor3 = Color3.fromRGB(147,112,219)
	Name.TextSize = 17
	
    local Tab = Instance.new("Frame", Main)
	Tab.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Tab.Position = UDim2.new(0,5,0,130)
	Tab.Size = UDim2.new(0,200,0,265)

	
	local ScrollTab = Instance.new("ScrollingFrame", Tab)
	ScrollTab.Active = true
	ScrollTab.BackgroundTransparency = 1
	ScrollTab.Size = UDim2.new(0,200,0,265)
	ScrollTab.ScrollBarThickness = 0

	local PLL = Instance.new("UIListLayout", ScrollTab)
	PLL.SortOrder = Enum.SortOrder.LayoutOrder
	PLL.Padding = UDim.new(0,15)
	local PPD = Instance.new("UIPadding", ScrollTab)
	PPD.PaddingLeft = UDim.new(0,10)
	PPD.PaddingTop = UDim.new(0,10)

	local Page = Instance.new("Frame", Main)
	Page.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Page.Position = UDim2.new(0,210,0,30)
	Page.Size = UDim2.new(0,285,0,360)

	local PCNR = Instance.new("UICorner", Page)
	local MainPage = Instance.new("Frame", Page)
	MainPage.BackgroundTransparency = 1
	MainPage.Size = UDim2.new(0,285,0,360)

	local PageList = Instance.new("Folder", MainPage)
	local UIPageLayout = Instance.new("UIPageLayout", PageList)
	UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIPageLayout.EasingStyle = Enum.EasingStyle.Quad
	UIPageLayout.TweenTime = 0.4

	MakeDraggable(Top,Main)

	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode[yoo] then
			uihide = not uihide
			if uihide then
				Main:TweenSize(UDim2.new(0,0,0,0),"In","Quad",0.4,true)
			else
				Main:TweenSize(UDim2.new(0,500,0,400),"Out","Quad",0.4,true)
			end
		end
	end)
end

return DarkraiX
