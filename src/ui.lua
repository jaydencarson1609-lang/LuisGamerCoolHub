if not game:IsLoaded() then
    game.Loaded:Wait()
end

local UserInputService = game:GetService("UserInputService")

-- Create GUI
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

-- Templates (NOW created AFTER ContentHolder & ScrollingFrame exist)
local TabTemplate = Instance.new("TextButton")
TabTemplate.Name = "TabButtonTemplate"
TabTemplate.Size = UDim2.new(0, 150, 0, 40)
TabTemplate.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TabTemplate.BorderSizePixel = 0
TabTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
TabTemplate.Font = Enum.Font.GothamBold
TabTemplate.TextSize = 16
TabTemplate.Visible = false
TabTemplate.Parent = ScrollingFrame

local TextPlaceHolder = Instance.new("Frame")
TextPlaceHolder.Name = "TextPlaceHolder"
TextPlaceHolder.Size = UDim2.new(0, 450, 0, 40)
TextPlaceHolder.BackgroundTransparency = 1
TextPlaceHolder.Visible = false
TextPlaceHolder.Parent = ContentHolder

local TextLabel = Instance.new("TextLabel", TextPlaceHolder)
TextLabel.Name = "Text"
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Font = Enum.Font.Gotham
TextLabel.TextSize = 18
TextLabel.TextXAlignment = Enum.TextXAlignment.Left

local ButtonPlaceHolder = Instance.new("Frame")
ButtonPlaceHolder.Name = "ButtonPlaceHolder"
ButtonPlaceHolder.Size = UDim2.new(0, 450, 0, 50)
ButtonPlaceHolder.BackgroundTransparency = 1
ButtonPlaceHolder.Visible = false
ButtonPlaceHolder.Parent = ContentHolder

local Button = Instance.new("TextButton", ButtonPlaceHolder)
Button.Name = "TextButton"
Button.Size = UDim2.new(1, 0, 1, 0)
Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Button.BorderSizePixel = 0
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 18

local SwitchButtonPlaceHolder = Instance.new("Frame")
SwitchButtonPlaceHolder.Name = "SwitchButtonPlaceHolder"
SwitchButtonPlaceHolder.Size = UDim2.new(0, 450, 0, 50)
SwitchButtonPlaceHolder.BackgroundTransparency = 1
SwitchButtonPlaceHolder.Visible = false
SwitchButtonPlaceHolder.Parent = ContentHolder

local ToggleNameLabel = Instance.new("TextLabel", SwitchButtonPlaceHolder)
ToggleNameLabel.Name = "Name"
ToggleNameLabel.Size = UDim2.new(0.6, 0, 1, 0)
ToggleNameLabel.BackgroundTransparency = 1
ToggleNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleNameLabel.Font = Enum.Font.Gotham
ToggleNameLabel.TextSize = 18
ToggleNameLabel.TextXAlignment = Enum.TextXAlignment.Left

local ToggleBtnTemplate = Instance.new("TextButton", SwitchButtonPlaceHolder)
ToggleBtnTemplate.Name = "On/OffButton"
ToggleBtnTemplate.Size = UDim2.new(0.3, 0, 0.7, 0)
ToggleBtnTemplate.Position = UDim2.new(0.65, 0, 0.15, 0)
ToggleBtnTemplate.BackgroundColor3 = Color3.fromRGB(164, 58, 58)
ToggleBtnTemplate.BorderSizePixel = 0
ToggleBtnTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtnTemplate.Font = Enum.Font.GothamBold
ToggleBtnTemplate.TextSize = 16

-- Elements
local Elements = {}

function Elements:AddTab(name)
    local tab = TabTemplate:Clone()
    tab.Visible = true
    tab.Text = name
    tab.Parent = ScrollingFrame
    return tab
end

function Elements:AddLabel(text)
    local temp = ContentHolder:FindFirstChild("TextPlaceHolder")
    if not temp then return end
    local lbl = temp:Clone()
    lbl.Visible = true
    lbl.Text.Text = text
    lbl.Parent = ContentHolder
    return lbl
end

function Elements:AddButton(text, callback)
    local temp = ContentHolder:FindFirstChild("ButtonPlaceHolder")
    if not temp then return end
    local btn = temp:Clone()
    btn.Visible = true
    btn.TextButton.Text = text
    btn.Parent = ContentHolder
    btn.TextButton.MouseButton1Click:Connect(callback)
    return btn
end

function Elements:AddToggle(text, default, callback)
    local temp = ContentHolder:FindFirstChild("SwitchButtonPlaceHolder")
    if not temp then return end
    local tog = temp:Clone()
    tog.Visible = true
    tog.Name = text .. "_Toggle"
    tog.Parent = ContentHolder

    local nameLabel = tog:FindFirstChild("Name")
    if nameLabel then nameLabel.Text = text end

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
        if callback then callback(state) end
    end)
    return tog
end

-- Tabs
local HomeTab = Elements:AddTab("Home")
local GamesTab = Elements:AddTab("Games")
local SettingsTab = Elements:AddTab("Settings")

local function Clear()
    for _, v in pairs(ContentHolder:GetChildren()) do
        if v:IsA("Frame") and v.Name ~= "UIListLayout" then
            v:Destroy()
        end
    end
end

local function loadHomeTab()
    Clear()
    ContentFrame.Visible = true
    Elements:AddLabel("Welcome to LuisGamerCoolHub!")
    Elements:AddButton("Test Button", function() print("Button works!") end)
    Elements:AddToggle("Test Toggle", false, function(s) print("Toggle:", s) end)
end

HomeTab.MouseButton1Click:Connect(loadHomeTab)

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

-- Keybind (K)
local visible = false
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.K then
        visible = not visible
        MainFrame.Visible = visible
        if visible then
            loadHomeTab()
        end
    end
end)

print("✅ LuisGamerCoolHub ui.lua Loaded! Press K to open")
