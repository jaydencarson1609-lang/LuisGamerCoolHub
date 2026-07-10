-- LuisGamerCoolHub | Press K to toggle

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "LuisGamerCoolHub"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- MainFrame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 677, 0, 406)
MainFrame.Position = UDim2.new(0.312, 0, 0.1696, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(52, 183, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = gui

-- Tab Holder
local TabHolder = Instance.new("Frame")
TabHolder.Name = "TabHolder"
TabHolder.Size = UDim2.new(0, 171, 0, 406)
TabHolder.BackgroundTransparency = 1
TabHolder.Parent = MainFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(0, 160, 0, 406)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.Parent = TabHolder

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = ScrollingFrame

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(0, 517, 0, 406)
ContentFrame.Position = UDim2.new(0.236, 0, 0, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Visible = false
ContentFrame.Parent = MainFrame

local ContentHolder = Instance.new("Frame")
ContentHolder.Name = "ContentHolder"
ContentHolder.Size = UDim2.new(0, 477, 0, 333)
ContentHolder.Position = UDim2.new(0.075, 0, 0.18, 0)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Parent = ContentFrame

local ContentList = Instance.new("UIListLayout")
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Padding = UDim.new(0, 8)
ContentList.Parent = ContentHolder

-- ==================== ELEMENTS ====================
local Elements = {}

-- Tab Button
function Elements:AddTab(name)
	local tab = ScrollingFrame:FindFirstChild("TabButtonTemplate"):Clone()
	tab.Name = name .. "Tab"
	tab.Text = name
	tab.Visible = true
	tab.Parent = ScrollingFrame
	return tab
end

-- Button
function Elements:AddButton(parent, text, callback)
	local holder = ContentHolder:FindFirstChild("ButtonPlaceHolder"):Clone()
	holder.Name = text .. "_Button"
	holder.TextButton.Text = text
	holder.Parent = parent
	
	holder.TextButton.MouseButton1Click:Connect(function()
		callback()
	end)
	return holder
end

-- Toggle / Switch
function Elements:AddToggle(parent, text, default, callback)
	local holder = ContentHolder:FindFirstChild("SwitchButtonPlaceHolder"):Clone()
	holder.Name = text .. "_Toggle"
	holder.Parent = parent
	
	holder.Name.Text = text
	
	local toggleBtn = holder["On/OffButton"]
	local state = default or false
	
	local function UpdateVisual()
		if state then
			toggleBtn.Text = "ON"
			toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
		else
			toggleBtn.Text = "OFF"
			toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
		end
	end
	
	UpdateVisual()
	
	toggleBtn.MouseButton1Click:Connect(function()
		state = not state
		UpdateVisual()
		if callback then callback(state) end
	end)
	
	return holder
end

-- Label
function Elements:AddLabel(parent, text)
	local holder = ContentHolder:FindFirstChild("TextPlaceHolder"):Clone()
	holder.Name = text .. "_Label"
	holder.Text.Text = text
	holder.Parent = parent
	return holder
end

-- ==================== TABS SETUP ====================
local HomeTab    = Elements:AddTab("Home")
local GamesTab   = Elements:AddTab("Games")
local SettingsTab = Elements:AddTab("Settings")

local function ClearContent()
	for _, child in pairs(ContentHolder:GetChildren()) do
		if child:IsA("Frame") and child.Name ~= "UIListLayout" then
			child:Destroy()
		end
	end
end

HomeTab.MouseButton1Click:Connect(function()
	ClearContent()
	ContentFrame.Visible = true
	
	Elements:AddLabel(ContentHolder, "Welcome to LuisGamerCoolHub!")
	Elements:AddLabel(ContentHolder, "Made by LuisGamerCool")
	
	Elements:AddButton(ContentHolder, "Click Me", function()
		print("Button Pressed!")
	end)
	
	Elements:AddToggle(ContentHolder, "Auto Something", false, function(state)
		print("Toggle changed to:", state)
	end)
end)

GamesTab.MouseButton1Click:Connect(function()
	ClearContent()
	ContentFrame.Visible = true
	Elements:AddLabel(ContentHolder, "Games Section")
	Elements:AddLabel(ContentHolder, "(Coming Soon)")
end)

SettingsTab.MouseButton1Click:Connect(function()
	ClearContent()
	ContentFrame.Visible = true
	Elements:AddLabel(ContentHolder, "Settings")
	
	Elements:AddToggle(ContentHolder, "Disable 3D Rendering", false, function(s)
		game:GetService("RunService"):Set3dRenderingEnabled(not s)
	end)
end)

-- ==================== KEYBIND (K) ====================
local Visible = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.K then
		Visible = not Visible
		MainFrame.Visible = Visible
		
		if Visible then
			HomeTab:Click()  -- Auto open Home
		end
	end
end)

print("✅ LuisGamerCoolHub Loaded! Press K to open.")
