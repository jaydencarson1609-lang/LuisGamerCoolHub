-- ui.lua - Main GUI for LuisGamerCoolHub

local UserInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui")
gui.Name = "LuisGamerCoolHub"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- MainFrame (your original)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 677, 0, 406)
MainFrame.Position = UDim2.new(0.312, 0, 0.1696, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(52, 183, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = gui

-- TabHolder + ScrollingFrame (your original)
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

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- Your TabButtonTemplate should already be inside ScrollingFrame

-- ContentFrame
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

local ContentList = Instance.new("UIListLayout", ContentHolder)
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Padding = UDim.new(0, 10)

-- Load Elements
local Elements = loadstring(game:HttpGet("https://raw.githubusercontent.com/jaydenkarson1609-lang/LuisGamerCoolHub/refs/heads/main/src/elements.lua"))()

-- Tabs
local HomeTab    = Elements:AddTab(ScrollingFrame, ScrollingFrame.TabButtonTemplate, "Home")
local GamesTab   = Elements:AddTab(ScrollingFrame, ScrollingFrame.TabButtonTemplate, "Games")
local SettingsTab = Elements:AddTab(ScrollingFrame, ScrollingFrame.TabButtonTemplate, "Settings")

local function ClearContent()
	for _, v in pairs(ContentHolder:GetChildren()) do
		if v:IsA("Frame") and v.Name ~= "UIListLayout" then
			v:Destroy()
		end
	end
end

HomeTab.MouseButton1Click:Connect(function()
	ClearContent()
	ContentFrame.Visible = true
	Elements:AddLabel(ContentHolder, ContentHolder.TextPlaceHolder, "Welcome to LuisGamerCoolHub!")
	Elements:AddButton(ContentHolder, ContentHolder.ButtonPlaceHolder, "Test Button", function() print("Button clicked!") end)
	Elements:AddToggle(ContentHolder, ContentHolder.SwitchButtonPlaceHolder, "Example Toggle", false, function(s) print("Toggle:", s) end)
end)

GamesTab.MouseButton1Click:Connect(function()
	ClearContent()
	ContentFrame.Visible = true
	Elements:AddLabel(ContentHolder, ContentHolder.TextPlaceHolder, "Games Section (Coming Soon)")
end)

SettingsTab.MouseButton1Click:Connect(function()
	ClearContent()
	ContentFrame.Visible = true
	Elements:AddLabel(ContentHolder, ContentHolder.TextPlaceHolder, "Settings")
	Elements:AddToggle(ContentHolder, ContentHolder.SwitchButtonPlaceHolder, "Disable 3D", false, function(v)
		game:GetService("RunService"):Set3dRenderingEnabled(not v)
	end)
end)

-- Keybind K
local visible = false
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.K then
		visible = not visible
		MainFrame.Visible = visible
		if visible then HomeTab:Click() end
	end
end)

print("✅ LuisGamerCoolHub Loaded! Press K")
