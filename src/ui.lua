local UserInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui")
gui.Name = "LuisGamerCoolHub"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 677, 0, 406)
MainFrame.Position = UDim2.new(0.312, 0, 0.1696, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(52, 183, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = gui

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

local UIList = Instance.new("UIListLayout", ScrollingFrame)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)

local TabTemplate = ScrollingFrame:FindFirstChild("TabButtonTemplate")

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

-- Elements (inline for now to avoid HttpGet issues during test)
local Elements = {}

function Elements:AddTab(name)
	local tab = TabTemplate:Clone()
	tab.Text = name
	tab.Parent = ScrollingFrame
	return tab
end

function Elements:AddLabel(text)
	local temp = ContentHolder:FindFirstChild("TextPlaceHolder")
	if not temp then return end
	local lbl = temp:Clone()
	lbl.Text.Text = text
	lbl.Parent = ContentHolder
	return lbl
end

function Elements:AddButton(text, callback)
	local temp = ContentHolder:FindFirstChild("ButtonPlaceHolder")
	if not temp then return end
	local btn = temp:Clone()
	btn.TextButton.Text = text
	btn.Parent = ContentHolder
	btn.TextButton.MouseButton1Click:Connect(callback)
	return btn
end

function Elements:AddToggle(text, default, callback)
	local temp = ContentHolder:FindFirstChild("SwitchButtonPlaceHolder")
	if not temp then return end
	local tog = temp:Clone()
	tog.Name = text
	tog.Parent = ContentHolder
	tog.Name.Text = text
	local btn = tog["On/OffButton"]
	local state = default or false
	
	local function update()
		btn.Text = state and "ON" or "OFF"
		btn.BackgroundColor3 = state and Color3.fromRGB(59, 164, 57) or Color3.fromRGB(164, 58, 58)
	end
	update()
	
	btn.MouseButton1Click:Connect(function()
		state = not state
		update()
		callback(state)
	end)
	return tog
end

-- Tabs
local HomeTab = Elements:AddTab("Home")
local GamesTab = Elements:AddTab("Games")
local SettingsTab = Elements:AddTab("Settings")

local function Clear()
	for _, v in pairs(ContentHolder:GetChildren()) do
		if v:IsA("Frame") and v.Name ~= "UIListLayout" then v:Destroy() end
	end
end

HomeTab.MouseButton1Click:Connect(function()
	Clear()
	ContentFrame.Visible = true
	Elements:AddLabel("Welcome to LuisGamerCoolHub!")
	Elements:AddButton("Test Button", function() print("Button works!") end)
	Elements:AddToggle("Test Toggle", false, function(s) print("Toggle:", s) end)
end)

GamesTab.MouseButton1Click:Connect(function()
	Clear()
	ContentFrame.Visible = true
	Elements:AddLabel("Games - Coming Soon")
end)

SettingsTab.MouseButton1Click:Connect(function()
	Clear()
	ContentFrame.Visible = true
	Elements:AddLabel("Settings")
	Elements:AddToggle("Disable 3D", false, function(v)
		game:GetService("RunService"):Set3dRenderingEnabled(not v)
	end)
end)

-- Keybind
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
