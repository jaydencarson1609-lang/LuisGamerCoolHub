--[=[ Your exact GUI from GitHub + fixed working logic ]=]

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
G2L["2"]["Name"] = [[MainFrame]];

-- Logo
G2L["3"] = Instance.new("ImageLabel", G2L["2"]);
G2L["3"]["BorderSizePixel"] = 0;
G2L["3"]["ScaleType"] = Enum.ScaleType.Fit;
G2L["3"]["BackgroundTransparency"] = 1;
G2L["3"]["Image"] = [[rbxassetid://139606442690248]];
G2L["3"]["Size"] = UDim2.new(0, 173, 0, 159);
G2L["3"]["Name"] = [[Logo]];
G2L["3"]["Position"] = UDim2.new(-0.0192, 0, -0.34729, 0);

G2L["4"] = Instance.new("UIStroke", G2L["2"]);
G2L["4"]["Thickness"] = 3;

-- CloseButton
G2L["5"] = Instance.new("TextButton", G2L["2"]);
G2L["5"]["TextScaled"] = true;
G2L["5"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5"]["BackgroundColor3"] = Color3.fromRGB(254, 10, 0);
G2L["5"]["Size"] = UDim2.new(0, 73, 0, 58);
G2L["5"]["Text"] = [[X]];
G2L["5"]["Name"] = [[CloseButton]];
G2L["5"]["Position"] = UDim2.new(0.89217, 0, -0.14286, 0);

G2L["6"] = Instance.new("UIShadow", G2L["5"]);

-- TabHolder + ScrollingFrame + UIListLayout
G2L["7"] = Instance.new("Frame", G2L["2"]);
G2L["7"]["BorderSizePixel"] = 0;
G2L["7"]["BackgroundTransparency"] = 1;
G2L["7"]["Size"] = UDim2.new(0, 171, 0, 406);
G2L["7"]["Name"] = [[TabHolder]];

G2L["8"] = Instance.new("UIShadow", G2L["7"]);

G2L["9"] = Instance.new("ScrollingFrame", G2L["7"]);
G2L["9"]["Active"] = true;
G2L["9"]["BackgroundTransparency"] = 1;
G2L["9"]["Size"] = UDim2.new(0, 160, 0, 406);
G2L["9"]["ScrollBarThickness"] = 6;
G2L["9"]["Name"] = [[ScrollingFrame]];

G2L["a"] = Instance.new("UIListLayout", G2L["9"]);
G2L["a"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
G2L["a"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

-- TabButtonTemplate (your template)
G2L["b"] = Instance.new("TextButton", G2L["9"]);
G2L["b"]["TextScaled"] = true;
G2L["b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["b"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40); -- dark like your screenshot
G2L["b"]["Size"] = UDim2.new(0, 147, 0, 44);
G2L["b"]["Text"] = [[Home]];
G2L["b"]["Name"] = [[TabButtonTemplate]];
G2L["b"]["Visible"] = false; -- hide template

G2L["c"] = Instance.new("UIShadow", G2L["b"]);
G2L["d"] = Instance.new("UICorner", G2L["b"]);
G2L["d"]["CornerRadius"] = UDim.new(1, 0);

-- ContentFrame
G2L["e"] = Instance.new("Frame", G2L["2"]);
G2L["e"]["Visible"] = false;
G2L["e"]["BackgroundTransparency"] = 0; -- solid so green doesn't bleed
G2L["e"]["BackgroundColor3"] = Color3.fromRGB(35, 35, 35);
G2L["e"]["Size"] = UDim2.new(0, 517, 0, 406);
G2L["e"]["Position"] = UDim2.new(0.23634, 0, 0, 0);
G2L["e"]["Name"] = [[ContentFrame]];

G2L["f"] = Instance.new("UIShadow", G2L["e"]);

-- TitleHolder
G2L["10"] = Instance.new("TextLabel", G2L["e"]);
G2L["10"]["TextScaled"] = true;
G2L["10"]["BackgroundTransparency"] = 1;
G2L["10"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["10"]["Size"] = UDim2.new(0, 309, 0, 67);
G2L["10"]["Text"] = [[Title]];
G2L["10"]["Name"] = [[TitleHolder]];
G2L["10"]["Position"] = UDim2.new(0.17795, 0, 0, 0);

G2L["11"] = Instance.new("UIStroke", G2L["10"]);
G2L["11"]["Thickness"] = 2.1;
G2L["11"]["Color"] = Color3.fromRGB(255, 255, 255);

-- ContentHolder
G2L["12"] = Instance.new("Frame", G2L["e"]);
G2L["12"]["BackgroundTransparency"] = 1;
G2L["12"]["Size"] = UDim2.new(0, 477, 0, 333);
G2L["12"]["Position"] = UDim2.new(0.07544, 0, 0.1798, 0);
G2L["12"]["Name"] = [[ContentHolder]];

G2L["13"] = Instance.new("UIListLayout", G2L["12"]);
G2L["13"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

-- Your placeholders (we hide them and clone when needed)
G2L["14"] = Instance.new("Frame", G2L["12"]); -- SwitchButtonPlaceHolder
G2L["14"]["BackgroundTransparency"] = 1;
G2L["14"]["Size"] = UDim2.new(0, 478, 0, 54);
G2L["14"]["Name"] = [[SwitchButtonPlaceHolder]];
G2L["14"]["Visible"] = false;

G2L["15"] = Instance.new("TextLabel", G2L["14"]);
G2L["15"]["BackgroundTransparency"] = 1;
G2L["15"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["15"]["Size"] = UDim2.new(0, 271, 0, 56);
G2L["15"]["Text"] = [[SwitchButtonName]];
G2L["15"]["Name"] = [[Name]];

G2L["17"] = Instance.new("TextButton", G2L["14"]);
G2L["17"]["BackgroundColor3"] = Color3.fromRGB(40, 40, 40);
G2L["17"]["Size"] = UDim2.new(0, 64, 0, 50);
G2L["17"]["Text"] = [[ON]];
G2L["17"]["Name"] = [[On/OffButton]];

-- TextPlaceHolder
G2L["19"] = Instance.new("Frame", G2L["12"]);
G2L["19"]["BackgroundTransparency"] = 1;
G2L["19"]["Size"] = UDim2.new(0, 478, 0, 54);
G2L["19"]["Name"] = [[TextPlaceHolder]];
G2L["19"]["Visible"] = false;

G2L["1a"] = Instance.new("TextLabel", G2L["19"]);
G2L["1a"]["BackgroundTransparency"] = 1;
G2L["1a"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1a"]["Size"] = UDim2.new(0, 400, 0, 50);
G2L["1a"]["Text"] = [[Text]];
G2L["1a"]["Name"] = [[Text]];

-- ButtonPlaceHolder
G2L["1c"] = Instance.new("Frame", G2L["12"]);
G2L["1c"]["BackgroundTransparency"] = 1;
G2L["1c"]["Size"] = UDim2.new(0, 208, 0, 53);
G2L["1c"]["Name"] = [[ButtonPlaceHolder]];
G2L["1c"]["Visible"] = false;

G2L["1d"] = Instance.new("TextButton", G2L["1c"]);
G2L["1d"]["BackgroundColor3"] = Color3.fromRGB(79, 214, 69);
G2L["1d"]["Size"] = UDim2.new(0, 200, 0, 52);
G2L["1d"]["Text"] = [[Button]];
G2L["1d"]["Name"] = [[TextButton]];

G2L["20"] = Instance.new("UIAspectRatioConstraint", G2L["2"]);

-- ==================== WORKING LOGIC ====================

local MainFrame = G2L["2"]
local CloseButton = G2L["5"]
local ContentFrame = G2L["e"]
local ContentHolder = G2L["12"]
local TabTemplate = G2L["b"]
local TextPlaceHolder = G2L["19"]
local ButtonPlaceHolder = G2L["1c"]
local SwitchPlaceHolder = G2L["14"]

local UserInputService = game:GetService("UserInputService")

local function Clear()
    for _, v in ipairs(ContentHolder:GetChildren()) do
        if v:IsA("Frame") and v.Name ~= "UIListLayout" then
            v:Destroy()
        end
    end
end

-- Create visible elements (fixed visibility)
local function AddTab(name)
    local tab = TabTemplate:Clone()
    tab.Text = name
    tab.Visible = true
    tab.Parent = G2L["9"]
    return tab
end

local function AddLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.Size = UDim2.new(0, 450, 0, 50)
    lbl.Text = text
    lbl.Parent = ContentHolder
    return lbl
end

local function AddButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.fromRGB(79, 214, 69)
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.TextScaled = true
    btn.Size = UDim2.new(0, 200, 0, 50)
    btn.Text = text
    btn.Parent = ContentHolder
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function AddToggle(text, default, callback)
    local tog = Instance.new("Frame")
    tog.BackgroundTransparency = 1
    tog.Size = UDim2.new(0, 450, 0, 50)
    tog.Parent = ContentHolder

    local lbl = Instance.new("TextLabel", tog)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Text = text

    local btn = Instance.new("TextButton", tog)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Size = UDim2.new(0.3, 0, 0.8, 0)
    btn.Position = UDim2.new(0.65, 0, 0.1, 0)
    btn.TextScaled = true

    local state = default or false
    local function update()
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(79, 214, 69) or Color3.fromRGB(254, 10, 0)
    end
    update()

    btn.MouseButton1Click:Connect(function()
        state = not state
        update()
        if callback then callback(state) end
    end)
    return tog
end

-- Create the 3 tabs (black style like your screenshot)
local homeTab = AddTab("Home")
local gamesTab = AddTab("Games")
local settingsTab = AddTab("Settings")

-- Tab handlers
homeTab.MouseButton1Click:Connect(function()
    Clear()
    ContentFrame.Visible = true
    G2L["10"].Text = "Home"
    AddLabel("Welcome to LuisGamerCoolHub!")
    AddButton("Test Button", function() print("Button works!") end)
    AddToggle("Test Toggle", false, function(s) print("Toggle:", s) end)
end)

gamesTab.MouseButton1Click:Connect(function()
    Clear()
    ContentFrame.Visible = true
    G2L["10"].Text = "Games"
    AddLabel("Games - Coming Soon")
end)

settingsTab.MouseButton1Click:Connect(function()
    Clear()
    ContentFrame.Visible = true
    G2L["10"].Text = "Settings"
    AddToggle("Disable 3D", false, function(v)
        game:GetService("RunService"):Set3dRenderingEnabled(not v)
    end)
end)

-- Close button
CloseButton.MouseButton1Click:Connect(function()
    G2L["1"]:Destroy()
end)

-- K keybind
local visible = false
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.K then
        visible = not visible
        MainFrame.Visible = visible
        if visible then
            homeTab:Fire("MouseButton1Click")
        end
    end
end)

print("✅ LuisGamerCoolHub loaded! Press K")
return G2L["1"]
