--[=[
 d888b  db    db d888888b      .d888b.      db      db    db  .d8b.  
88' Y8b 88    88   `88'        VP  `8D      88      88    88 d8' `8b 
88      88    88    88            odD'      88      88    88 88ooo88 
88  ooo 88    88    88          .88'        88      88    88 88~~~88 
88. ~8~ 88b  d88   .88.        j88.         88booo. 88b  d88 88   88    @uniquadev
 Y888P  ~Y8888P' Y888888P      888888D      Y88888P ~Y8888P' YP   YP  CONVERTER 
]=]

-- Instances: 32 | Scripts: 0 | Modules: 0 | Tags: 0
local G2L = {};

-- StarterGui.LuisGamerCoolHub
G2L["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
G2L["1"]["Name"] = [[LuisGamerCoolHub]];
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;


-- StarterGui.LuisGamerCoolHub.MainFrame
G2L["2"] = Instance.new("Frame", G2L["1"]);
G2L["2"]["BorderSizePixel"] = 0;
G2L["2"]["BackgroundColor3"] = Color3.fromRGB(52, 183, 45);
G2L["2"]["Size"] = UDim2.new(0, 677, 0, 406);
G2L["2"]["Position"] = UDim2.new(0.312, 0, 0.1696, 0);
G2L["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2"]["Name"] = [[MainFrame]];
G2L["2"]["Visible"] = false; -- hidden until K is pressed


-- StarterGui.LuisGamerCoolHub.MainFrame.Logo
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


-- StarterGui.LuisGamerCoolHub.MainFrame.UIStroke
G2L["4"] = Instance.new("UIStroke", G2L["2"]);
G2L["4"]["Thickness"] = 3;


-- StarterGui.LuisGamerCoolHub.MainFrame.CloseButton
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


-- StarterGui.LuisGamerCoolHub.MainFrame.CloseButton.UIShadow
G2L["6"] = Instance.new("UIShadow", G2L["5"]);
G2L["6"]["Color"] = Color3.fromRGB(0, 0, 0);
G2L["6"]["Transparency"] = 0.65;
G2L["6"]["BlurRadius"] = UDim.new(0, 6);
G2L["6"]["Offset"] = UDim2.new(0, 0, 0, 3);



-- StarterGui.LuisGamerCoolHub.MainFrame.TabHolder
G2L["7"] = Instance.new("Frame", G2L["2"]);
G2L["7"]["BorderSizePixel"] = 0;
G2L["7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["7"]["Size"] = UDim2.new(0, 171, 0, 406);
G2L["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["7"]["Name"] = [[TabHolder]];
G2L["7"]["BackgroundTransparency"] = 1;


-- StarterGui.LuisGamerCoolHub.MainFrame.TabHolder.UIShadow
G2L["8"] = Instance.new("UIShadow", G2L["7"]);
G2L["8"]["Color"] = Color3.fromRGB(0, 0, 0);
G2L["8"]["Transparency"] = 0.7;
G2L["8"]["BlurRadius"] = UDim.new(0, 8);
G2L["8"]["Offset"] = UDim2.new(0, 2, 0, 0);



-- StarterGui.LuisGamerCoolHub.MainFrame.TabHolder.ScrollingFrame
G2L["9"] = Instance.new("ScrollingFrame", G2L["7"]);
G2L["9"]["Active"] = true;
G2L["9"]["BorderSizePixel"] = 0;
G2L["9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["9"]["Size"] = UDim2.new(0, 160, 0, 406);
G2L["9"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
G2L["9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["9"]["ScrollBarThickness"] = 6;
G2L["9"]["BackgroundTransparency"] = 1;


-- StarterGui.LuisGamerCoolHub.MainFrame.TabHolder.ScrollingFrame.UIListLayout
G2L["a"] = Instance.new("UIListLayout", G2L["9"]);
G2L["a"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
G2L["a"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.LuisGamerCoolHub.MainFrame.TabHolder.ScrollingFrame.TabButtonTemplate
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
G2L["b"]["Visible"] = false; -- template, cloned per tab


-- StarterGui.LuisGamerCoolHub.MainFrame.TabHolder.ScrollingFrame.TabButtonTemplate.UIShadow
G2L["c"] = Instance.new("UIShadow", G2L["b"]);
G2L["c"]["Color"] = Color3.fromRGB(0, 0, 0);
G2L["c"]["Transparency"] = 0.75;
G2L["c"]["BlurRadius"] = UDim.new(0, 4);
G2L["c"]["Offset"] = UDim2.new(0, 0, 0, 2);



-- StarterGui.LuisGamerCoolHub.MainFrame.TabHolder.ScrollingFrame.TabButtonTemplate.UICorner
G2L["d"] = Instance.new("UICorner", G2L["b"]);
G2L["d"]["CornerRadius"] = UDim.new(1, 0);


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame
G2L["e"] = Instance.new("Frame", G2L["2"]);
G2L["e"]["Visible"] = false;
G2L["e"]["BorderSizePixel"] = 0;
G2L["e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e"]["Size"] = UDim2.new(0, 517, 0, 406);
G2L["e"]["Position"] = UDim2.new(0.23634, 0, 0, 0);
G2L["e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["e"]["Name"] = [[ContentFrame]];
G2L["e"]["BackgroundTransparency"] = 1;


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.UIShadow
G2L["f"] = Instance.new("UIShadow", G2L["e"]);
G2L["f"]["Color"] = Color3.fromRGB(0, 0, 0);
G2L["f"]["Transparency"] = 0.7;
G2L["f"]["BlurRadius"] = UDim.new(0, 8);
G2L["f"]["Offset"] = UDim2.new(0, -2, 0, 0);



-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.TitleHolder
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


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.TitleHolder.UIStroke
G2L["11"] = Instance.new("UIStroke", G2L["10"]);
G2L["11"]["Thickness"] = 2.1;
G2L["11"]["Color"] = Color3.fromRGB(255, 255, 255);


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.ContentHolder
G2L["12"] = Instance.new("Frame", G2L["e"]);
G2L["12"]["BorderSizePixel"] = 0;
G2L["12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["12"]["Size"] = UDim2.new(0, 477, 0, 333);
G2L["12"]["Position"] = UDim2.new(0.07544, 0, 0.1798, 0);
G2L["12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["12"]["Name"] = [[ContentHolder]];
G2L["12"]["BackgroundTransparency"] = 1;


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.ContentHolder.UIListLayout
G2L["13"] = Instance.new("UIListLayout", G2L["12"]);
G2L["13"]["SortOrder"] = Enum.SortOrder.LayoutOrder;


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.ContentHolder.SwitchButtonPlaceHolder
G2L["14"] = Instance.new("Frame", G2L["12"]);
G2L["14"]["BorderSizePixel"] = 0;
G2L["14"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["14"]["Size"] = UDim2.new(0, 478, 0, 54);
G2L["14"]["Position"] = UDim2.new(0, 0, -0.01802, 0);
G2L["14"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["14"]["Name"] = [[SwitchButtonPlaceHolder]];
G2L["14"]["BackgroundTransparency"] = 1;
G2L["14"]["Visible"] = false; -- template, cloned per switch row


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.ContentHolder.SwitchButtonPlaceHolder.Name
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


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.ContentHolder.SwitchButtonPlaceHolder.Name.UIStroke
G2L["16"] = Instance.new("UIStroke", G2L["15"]);
G2L["16"]["Thickness"] = 1.7;
G2L["16"]["Color"] = Color3.fromRGB(255, 255, 255);


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.ContentHolder.SwitchButtonPlaceHolder.On/OffButton
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


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.ContentHolder.SwitchButtonPlaceHolder.On/OffButton.UICorner
G2L["18"] = Instance.new("UICorner", G2L["17"]);
G2L["18"]["CornerRadius"] = UDim.new(1, 0);


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.ContentHolder.TextPlaceHolder
G2L["19"] = Instance.new("Frame", G2L["12"]);
G2L["19"]["BorderSizePixel"] = 0;
G2L["19"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["19"]["Size"] = UDim2.new(0, 478, 0, 54);
G2L["19"]["Position"] = UDim2.new(0, 0, 0.16216, 0);
G2L["19"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["19"]["Name"] = [[TextPlaceHolder]];
G2L["19"]["BackgroundTransparency"] = 1;
G2L["19"]["Visible"] = false; -- template, cloned per text row


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.ContentHolder.TextPlaceHolder.Text
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


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.ContentHolder.TextPlaceHolder.Text.UIStroke
G2L["1b"] = Instance.new("UIStroke", G2L["1a"]);
G2L["1b"]["Thickness"] = 1.7;
G2L["1b"]["Color"] = Color3.fromRGB(255, 255, 255);


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.ContentHolder.ButtonPlaceHolder
G2L["1c"] = Instance.new("Frame", G2L["12"]);
G2L["1c"]["BorderSizePixel"] = 0;
G2L["1c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1c"]["Size"] = UDim2.new(0, 208, 0, 53);
G2L["1c"]["Position"] = UDim2.new(0, 0, 0.32432, 0);
G2L["1c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1c"]["Name"] = [[ButtonPlaceHolder]];
G2L["1c"]["BackgroundTransparency"] = 1;
G2L["1c"]["Visible"] = false; -- template, cloned per button row


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.ContentHolder.ButtonPlaceHolder.TextButton
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


-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.ContentHolder.ButtonPlaceHolder.TextButton.UICorner
G2L["1e"] = Instance.new("UICorner", G2L["1d"]);



-- StarterGui.LuisGamerCoolHub.MainFrame.ContentFrame.ContentHolder.ButtonPlaceHolder.TextButton.UIStroke
G2L["1f"] = Instance.new("UIStroke", G2L["1d"]);
G2L["1f"]["Thickness"] = 3;
G2L["1f"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;


-- StarterGui.LuisGamerCoolHub.MainFrame.UIAspectRatioConstraint
G2L["20"] = Instance.new("UIAspectRatioConstraint", G2L["2"]);
G2L["20"]["AspectRatio"] = 1.66749;


-- StarterGui.LuisGamerCoolHub.MainFrame.UIDragDetector (makes the whole panel draggable, no scripting required)
G2L["21"] = Instance.new("UIDragDetector", G2L["2"]);
G2L["21"]["Name"] = [[Drag]];
G2L["21"]["DragStyle"] = Enum.UIDragDetectorDragStyle.TranslatePlane;


-- ==================== WORKING LOGIC (no visual properties changed above) ====================

local MainFrame       = G2L["2"]
local CloseButton     = G2L["5"]
local TabScroll        = G2L["9"]
local TabTemplate     = G2L["b"]
local ContentFrame    = G2L["e"]
local TitleHolder     = G2L["10"]
local ContentHolder   = G2L["12"]
local SwitchTemplate  = G2L["14"]
local TextTemplate    = G2L["19"]
local ButtonTemplate  = G2L["1c"]
local UserInputService = game:GetService("UserInputService")

local rowTemplates = { SwitchTemplate, TextTemplate, ButtonTemplate }

local function isTemplate(inst)
	for _, t in ipairs(rowTemplates) do
		if inst == t then return true end
	end
	return false
end

-- Clears everything in ContentHolder except the layout and the 3 hidden templates
local function Clear()
	for _, v in ipairs(ContentHolder:GetChildren()) do
		if v:IsA("Frame") and not isTemplate(v) then
			v:Destroy()
		end
	end
end

local function AddTab(name)
	local tab = TabTemplate:Clone()
	tab.Text = name
	tab.Visible = true
	tab.Parent = TabScroll
	return tab
end

-- Clones your real TextPlaceHolder template
local function AddText(text)
	local row = TextTemplate:Clone()
	row.Text.Text = text
	row.Visible = true
	row.Parent = ContentHolder
	return row
end

-- Clones your real ButtonPlaceHolder template
local function AddButton(text, callback)
	local row = ButtonTemplate:Clone()
	row.TextButton.Text = text
	row.Visible = true
	row.Parent = ContentHolder
	row.TextButton.MouseButton1Click:Connect(callback)
	return row
end

-- Clones your real SwitchButtonPlaceHolder template
local function AddToggle(text, default, callback)
	local row = SwitchTemplate:Clone()
	row.Name.Text = text
	row.Visible = true
	row.Parent = ContentHolder

	local btn = row["On/OffButton"]
	local state = default or false

	local function update()
		btn.Text = state and "ON" or "OFF"
	end
	update()

	btn.MouseButton1Click:Connect(function()
		state = not state
		update()
		if callback then callback(state) end
	end)

	return row
end

-- Tabs
local homeTab = AddTab("Home")
local gamesTab = AddTab("Games")
local settingsTab = AddTab("Settings")

local function ShowHome()
	Clear()
	ContentFrame.Visible = true
	TitleHolder.Text = "Home"
	AddText("Welcome to LuisGamerCoolHub!")
	AddButton("Test Button", function() print("Button works!") end)
	AddToggle("Test Toggle", false, function(s) print("Toggle:", s) end)
end

local function ShowGames()
	Clear()
	ContentFrame.Visible = true
	TitleHolder.Text = "Games"
	AddText("Games - Coming Soon")
end

local function ShowSettings()
	Clear()
	ContentFrame.Visible = true
	TitleHolder.Text = "Settings"
	AddToggle("Disable 3D", false, function(v)
		game:GetService("RunService"):Set3dRenderingEnabled(not v)
	end)
end

homeTab.MouseButton1Click:Connect(ShowHome)
gamesTab.MouseButton1Click:Connect(ShowGames)
settingsTab.MouseButton1Click:Connect(ShowSettings)

CloseButton.MouseButton1Click:Connect(function()
	G2L["1"]:Destroy()
end)

-- K keybind toggles the whole menu
local visible = false
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.K then
		visible = not visible
		MainFrame.Visible = visible
		if visible then
			ShowHome()
		end
	end
end)

print("✅ LuisGamerCoolHub loaded! Press K")

return G2L["1"];
