--[=[
 d888b db db d888888b .d888b. db db db .d8b.
88' Y8b 88 88 `88' VP `8D 88 88 88 d8' `8b
88 88 88 88 odD' 88 88 88 88ooo88
88 ooo 88 88 88 .88' 88 88 88 88~~~88
88. ~8~ 88b d88 .88. j88. 88booo. 88b d88 88 88 @uniquadev
 Y888P ~Y8888P' Y888888P 888888D Y88888P ~Y8888P' YP YP CONVERTER
]=]

local G2L = {};

-- StarterGui.LuisGamerCoolHub
G2L["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
G2L["1"]["Name"] = [[LuisGamerCoolHub]];
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;

-- MainFrame
G2L["2"] = Instance.new("Frame", G2L["1"]);
G2L["2"]["BorderSizePixel"] = 0;
G2L["2"]["BackgroundColor3"] = Color3.fromRGB(52, 183, 45);
G2L["2"]["Size"] = UDim2.new(0, 677, 0, 406);
G2L["2"]["Position"] = UDim2.new(0.312, 0, 0.1696, 0);
G2L["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2"]["Name"] = [[MainFrame]];

-- Logo
G2L["3"] = Instance.new("ImageLabel", G2L["2"]);
G2L["3"]["BorderSizePixel"] = 0;
G2L["3"]["ScaleType"] = Enum.ScaleType.Fit;
G2L["3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["3"]["Image"] = [[rbxassetid://139606442690248]];
G2L["3"]["Size"] = UDim2.new(0, 173, 0, 159);
G2L["3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["3"]["BackgroundTransparency"] = 1;
G2L["3"]["Name"] = [[Logo]];
G2L["3"]["Position"] = UDim2.new(-0.0192, 0, -0.34729, 0);

-- UIStroke
G2L["4"] = Instance.new("UIStroke", G2L["2"]);
G2L["4"]["Thickness"] = 3;

-- CloseButton
G2L["5"] = Instance.new("TextButton", G2L["2"]);
G2L["5"]["TextWrapped"] = true;
G2L["5"]["RichText"] = true;
G2L["5"]["BorderSizePixel"] = 0;
G2L["5"]["TextSize"] = 14;
G2L["5"]["TextScaled"] = true;
G2L["5"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5"]["BackgroundColor3"] = Color3.fromRGB(254, 10, 0);
G2L["5"]["FontFace"] = Font.new([[rbxasset://fonts/families/ComicNeueAngular.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["5"]["Size"] = UDim2.new(0, 73, 0, 58);
G2L["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5"]["Text"] = [[X]];
G2L["5"]["Name"] = [[CloseButton]];
G2L["5"]["Position"] = UDim2.new(0.89217, 0, -0.14286, 0);

G2L["6"] = Instance.new("UIShadow", G2L["5"]);

-- TabHolder
G2L["7"] = Instance.new("Frame", G2L["2"]);
G2L["7"]["BorderSizePixel"] = 0;
G2L["7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["7"]["Size"] = UDim2.new(0, 171, 0, 406);
G2L["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["7"]["Name"] = [[TabHolder]];
G2L["7"]["BackgroundTransparency"] = 1;

G2L["8"] = Instance.new("UIShadow", G2L["7"]);

-- ScrollingFrame
G2L["9"] = Instance.new("ScrollingFrame", G2L["7"]);
G2L["9"]["Active"] = true;
G2L["9"]["BorderSizePixel"] = 0;
G2L["9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["9"]["Size"] = UDim2.new(0, 160, 0, 406);
G2L["9"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
G2L["9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["9"]["ScrollBarThickness"] = 6;
G2L["9"]["BackgroundTransparency"] = 1;

G2L["a"] = Instance.new("UIListLayout", G2L["9"]);
G2L["a"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
G2L["a"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

-- TabButtonTemplate (already exists in your GUI)
G2L["b"] = Instance.new("TextButton", G2L["9"]);
G2L["b"]["TextWrapped"] = true;
G2L["b"]["BorderSizePixel"] = 0;
G2L["b"]["TextSize"] = 14;
G2L["b"]["TextScaled"] = true;
G2L["b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["b"]["FontFace"] = Font.new([[rbxasset://fonts/families/ComicNeueAngular.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["b"]["BackgroundTransparency"] = 1;
G2L["b"]["Size"] = UDim2.new(0, 147, 0, 44);
G2L["b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["b"]["Text"] = [[Home]];
G2L["b"]["Name"] = [[TabButtonTemplate]];
G2L["b"]["Position"] = UDim2.new(0.04062, 0, 0.00739, 0);

G2L["c"] = Instance.new("UIShadow", G2L["b"]);
G2L["d"] = Instance.new("UICorner", G2L["b"]);
G2L["d"]["CornerRadius"] = UDim.new(1, 0);

-- ContentFrame
G2L["e"] = Instance.new("Frame", G2L["2"]);
G2L["e"]["Visible"] = false;
G2L["e"]["BorderSizePixel"] = 0;
G2L["e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e"]["Size"] = UDim2.new(0, 517, 0, 406);
G2L["e"]["Position"] = UDim2.new(0.23634, 0, 0, 0);
G2L["e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["e"]["Name"] = [[ContentFrame]];
G2L["e"]["BackgroundTransparency"] = 1;

G2L["f"] = Instance.new("UIShadow", G2L["e"]);

-- TitleHolder
G2L["10"] = Instance.new("TextLabel", G2L["e"]);
G2L["10"]["TextWrapped"] = true;
G2L["10"]["BorderSizePixel"] = 0;
G2L["10"]["TextSize"] = 14;
G2L["10"]["TextScaled"] = true;
G2L["10"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["10"]["FontFace"] = Font.new([[rbxasset://fonts/families/ComicNeueAngular.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["10"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["10"]["BackgroundTransparency"] = 1;
G2L["10"]["Size"] = UDim2.new(0, 309, 0, 67);
G2L["10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["10"]["Text"] = [[Title]];
G2L["10"]["Name"] = [[TitleHolder]];
G2L["10"]["Position"] = UDim2.new(0.17795, 0, 0, 0);

G2L["11"] = Instance.new("UIStroke", G2L["10"]);
G2L["11"]["Thickness"] = 2.1;
G2L["11"]["Color"] = Color3.fromRGB(255, 255, 255);

-- ContentHolder
G2L["12"] = Instance.new("Frame", G2L["e"]);
G2L["12"]["BorderSizePixel"] = 0;
G2L["12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["12"]["Size"] = UDim2.new(0, 477, 0, 333);
G2L["12"]["Position"] = UDim2.new(0.07544, 0, 0.1798, 0);
G2L["12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["12"]["Name"] = [[ContentHolder]];
G2L["12"]["BackgroundTransparency"] = 1;

G2L["13"] = Instance.new("UIListLayout", G2L["12"]);
G2L["13"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

-- SwitchButtonPlaceHolder (already in your GUI)
G2L["14"] = Instance.new("Frame", G2L["12"]);
G2L["14"]["BorderSizePixel"] = 0;
G2L["14"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["14"]["Size"] = UDim2.new(0, 478, 0, 54);
G2L["14"]["Position"] = UDim2.new(0, 0, -0.01802, 0);
G2L["14"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["14"]["Name"] = [[SwitchButtonPlaceHolder]];
G2L["14"]["BackgroundTransparency"] = 1;

G2L["15"] = Instance.new("TextLabel", G2L["14"]);
G2L["15"]["TextWrapped"] = true;
G2L["15"]["BorderSizePixel"] = 0;
G2L["15"]["TextSize"] = 14;
G2L["15"]["TextScaled"] = true;
G2L["15"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["15"]["FontFace"] = Font.new([[rbxasset://fonts/families/ComicNeueAngular.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["15"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["15"]["BackgroundTransparency"] = 1;
G2L["15"]["Size"] = UDim2.new(0, 271, 0, 56);
G2L["15"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["15"]["Text"] = [[SwitchButtonName]];
G2L["15"]["Name"] = [[Name]];
G2L["15"]["Position"] = UDim2.new(0.01883, 0, -0.11111, 0);

G2L["16"] = Instance.new("UIStroke", G2L["15"]);
G2L["16"]["Thickness"] = 1.7;
G2L["16"]["Color"] = Color3.fromRGB(255, 255, 255);

G2L["17"] = Instance.new("TextButton", G2L["14"]);
G2L["17"]["TextWrapped"] = true;
G2L["17"]["RichText"] = true;
G2L["17"]["BorderSizePixel"] = 0;
G2L["17"]["TextSize"] = 14;
G2L["17"]["TextScaled"] = true;
G2L["17"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["17"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["17"]["Size"] = UDim2.new(0, 64, 0, 50);
G2L["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["17"]["Text"] = [[ON]];
G2L["17"]["Name"] = [[On/OffButton]];
G2L["17"]["Position"] = UDim2.new(0.58483, 0, 0, 0);

G2L["18"] = Instance.new("UICorner", G2L["17"]);
G2L["18"]["CornerRadius"] = UDim.new(1, 0);

-- TextPlaceHolder (already in your GUI)
G2L["19"] = Instance.new("Frame", G2L["12"]);
G2L["19"]["BorderSizePixel"] = 0;
G2L["19"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["19"]["Size"] = UDim2.new(0, 478, 0, 54);
G2L["19"]["Position"] = UDim2.new(0, 0, 0.16216, 0);
G2L["19"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["19"]["Name"] = [[TextPlaceHolder]];
G2L["19"]["BackgroundTransparency"] = 1;

G2L["1a"] = Instance.new("TextLabel", G2L["19"]);
G2L["1a"]["TextWrapped"] = true;
G2L["1a"]["BorderSizePixel"] = 0;
G2L["1a"]["TextSize"] = 14;
G2L["1a"]["TextScaled"] = true;
G2L["1a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1a"]["FontFace"] = Font.new([[rbxasset://fonts/families/ComicNeueAngular.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1a"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1a"]["BackgroundTransparency"] = 1;
G2L["1a"]["Size"] = UDim2.new(0, 115, 0, 56);
G2L["1a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1a"]["Text"] = [[Text]];
G2L["1a"]["Name"] = [[Text]];
G2L["1a"]["Position"] = UDim2.new(0, 0, -0.07407, 0);

G2L["1b"] = Instance.new("UIStroke", G2L["1a"]);
G2L["1b"]["Thickness"] = 1.7;
G2L["1b"]["Color"] = Color3.fromRGB(255, 255, 255);

-- ButtonPlaceHolder (already in your GUI)
G2L["1c"] = Instance.new("Frame", G2L["12"]);
G2L["1c"]["BorderSizePixel"] = 0;
G2L["1c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1c"]["Size"] = UDim2.new(0, 208, 0, 53);
G2L["1c"]["Position"] = UDim2.new(0, 0, 0.32432, 0);
G2L["1c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1c"]["Name"] = [[ButtonPlaceHolder]];
G2L["1c"]["BackgroundTransparency"] = 1;

G2L["1d"] = Instance.new("TextButton", G2L["1c"]);
G2L["1d"]["TextWrapped"] = true;
G2L["1d"]["RichText"] = true;
G2L["1d"]["BorderSizePixel"] = 4;
G2L["1d"]["TextSize"] = 14;
G2L["1d"]["TextScaled"] = true;
G2L["1d"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1d"]["BackgroundColor3"] = Color3.fromRGB(79, 214, 69);
G2L["1d"]["FontFace"] = Font.new([[rbxasset://fonts/families/ComicNeueAngular.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1d"]["BackgroundTransparency"] = 0.8;
G2L["1d"]["Size"] = UDim2.new(0, 200, 0, 52);
G2L["1d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1d"]["Position"] = UDim2.new(0, 0, 0.16981, 0);

G2L["1e"] = Instance.new("UICorner", G2L["1d"]);
G2L["1f"] = Instance.new("UIStroke", G2L["1d"]);
G2L["1f"]["Thickness"] = 3;
G2L["1f"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

G2L["20"] = Instance.new("UIAspectRatioConstraint", G2L["2"]);
G2L["20"]["AspectRatio"] = 1.66749;

-- ==================== LOGIC (added on top of your GUI) ====================

local MainFrame = G2L["2"]
local CloseButton = G2L["5"]
local ContentFrame = G2L["e"]
local ContentHolder = G2L["12"]
local TabTemplate = G2L["b"]          -- your existing TabButtonTemplate
local TextPlaceHolder = G2L["19"]
local ButtonPlaceHolder = G2L["1c"]
local SwitchButtonPlaceHolder = G2L["14"]

-- Hide the template instances so they don't show until cloned
TabTemplate.Visible = false
TextPlaceHolder.Visible = false
ButtonPlaceHolder.Visible = false
SwitchButtonPlaceHolder.Visible = false

local function ClearContent()
    for _, child in ipairs(ContentHolder:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "UIListLayout" then
            child:Destroy()
        end
    end
end

-- Clone your existing templates
local function AddTab(name)
    local tab = TabTemplate:Clone()
    tab.Text = name
    tab.Visible = true
    tab.Parent = G2L["9"]
    return tab
end

local function AddLabel(text)
    local lbl = TextPlaceHolder:Clone()
    lbl.Visible = true
    lbl.Text.Text = text
    lbl.Parent = ContentHolder
    return lbl
end

local function AddButton(text, callback)
    local btn = ButtonPlaceHolder:Clone()
    btn.Visible = true
    btn.TextButton.Text = text
    btn.Parent = ContentHolder
    btn.TextButton.MouseButton1Click:Connect(callback)
    return btn
end

local function AddToggle(text, default, callback)
    local tog = SwitchButtonPlaceHolder:Clone()
    tog.Visible = true
    tog.Name = text .. "_Toggle"
    tog.Parent = ContentHolder

    local nameLabel = tog:FindFirstChild("Name")
    if nameLabel then nameLabel.Text = text end

    local btn = tog:FindFirstChild("On/OffButton")
    local state = default or false

    local function update()
        if btn then
            btn.Text = state and "ON" or "OFF"
            btn.BackgroundColor3 = state and Color3.fromRGB(79, 214, 69) or Color3.fromRGB(254, 10, 0)
        end
    end
    update()

    if btn then
        btn.MouseButton1Click:Connect(function()
            state = not state
            update()
            if callback then callback(state) end
        end)
    end
    return tog
end

-- Create the tabs
local homeTab = AddTab("Home")
local gamesTab = AddTab("Games")
local settingsTab = AddTab("Settings")

-- Tab click handlers
homeTab.MouseButton1Click:Connect(function()
    ClearContent()
    ContentFrame.Visible = true
    G2L["10"].Text = "Home"
    AddLabel("Welcome to LuisGamerCoolHub!")
    AddButton("Test Button", function() print("Button clicked!") end)
    AddToggle("Test Toggle", false, function(state) print("Toggle:", state) end)
end)

gamesTab.MouseButton1Click:Connect(function()
    ClearContent()
    ContentFrame.Visible = true
    G2L["10"].Text = "Games"
    AddLabel("Games section - Coming soon!")
end)

settingsTab.MouseButton1Click:Connect(function()
    ClearContent()
    ContentFrame.Visible = true
    G2L["10"].Text = "Settings"
    AddToggle("Disable 3D Rendering", false, function(state)
        game:GetService("RunService"):Set3dRenderingEnabled(not state)
    end)
end)

-- Close button
CloseButton.MouseButton1Click:Connect(function()
    G2L["1"]:Destroy()
end)

-- K keybind to toggle
local UserInputService = game:GetService("UserInputService")
local visible = false

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.K then
        visible = not visible
        MainFrame.Visible = visible
        if visible then
            homeTab:Fire("MouseButton1Click") -- open home by default
        end
    end
end)

-- Make MainFrame draggable (bonus)
local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

print("✅ LuisGamerCoolHub loaded! Press K to open (your original design + fixed logic)")
return G2L["1"]
