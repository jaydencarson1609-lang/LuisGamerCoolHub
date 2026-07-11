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
G2L["5"]["ClipsDescendants"] = true; -- keeps the hold-fill bar inside the button's shape


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
-- wrapped in pcall: older executors / clients that predate UIDragDetector
-- would otherwise throw here and kill the whole script before it finishes loading
pcall(function()
	G2L["21"] = Instance.new("UIDragDetector", G2L["2"]);
	G2L["21"]["Name"] = [[Drag]];
	G2L["21"]["DragStyle"] = Enum.UIDragDetectorDragStyle.TranslatePlane;
end)


-- ==================== WORKING LOGIC (no visual properties changed above) ====================

local MainFrame        = G2L["2"]
local CloseButton      = G2L["5"]
local TabScroll         = G2L["9"]
local TabTemplate      = G2L["b"]
local ContentFrame     = G2L["e"]
local TitleHolder      = G2L["10"]
local ContentHolder    = G2L["12"]
local SwitchTemplate   = G2L["14"]
local TextTemplate     = G2L["19"]
local ButtonTemplate   = G2L["1c"]
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")

-- Your old templates (SwitchTemplate/TextTemplate/ButtonTemplate) are no
-- longer used for content — Element.lua builds nicer versions from scratch.
-- They're kept hidden in the GUI tree above only so your export stays intact.

-- Load the Element module (hub-style loadstring — swap for require() if
-- you convert this into Studio ModuleScripts instead)
local Element = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/jaydencarson1609-lang/LuisGamerCoolHub/main/src/elements.lua"
))()

local originalPosition = MainFrame.Position -- captured once, before anything moves it
local SLIDE_OFFSET = 40 -- px the panel travels while sliding

--============================================================
-- HOLD-TO-CLOSE BAR
-- A black frame parented to CloseButton that fills bottom -> up
-- while the button is held down, like a charging meter.
-- Completing the hold triggers the full-GUI close animation + destroy.
--============================================================
local HoldFill = Instance.new("Frame")
HoldFill.Name = "HoldFill"
HoldFill.BackgroundColor3 = Color3.new(0, 0, 0)
HoldFill.BackgroundTransparency = 0.1
HoldFill.BorderSizePixel = 0
HoldFill.AnchorPoint = Vector2.new(0, 1)
HoldFill.Position = UDim2.new(0, 0, 1, 0)
HoldFill.Size = UDim2.new(1, 0, 0, 0) -- starts empty, grows upward
HoldFill.ZIndex = CloseButton.ZIndex + 1
HoldFill.Parent = CloseButton

local HOLD_DURATION = 0.9 -- seconds to hold before it closes

-- Press-feedback scale for the close button (hover + press states)
local CloseScale = Instance.new("UIScale")
CloseScale.Scale = 1
CloseScale.Parent = CloseButton

local closeOriginalColor = CloseButton.BackgroundColor3
local closeHoverColor = Color3.fromRGB(255, 72, 62)

--============================================================
-- FADE SYSTEM
-- Caches every descendant's original transparency once, then can
-- smoothly tween the whole tree between "fully shown" (alpha 0)
-- and "fully hidden" (alpha 1).
--============================================================
local fadeTargets = {}

local function RegisterFadeTargets(root)
	local function addTarget(inst, prop)
		local ok, orig = pcall(function() return inst[prop] end)
		if ok then
			table.insert(fadeTargets, { inst, prop, orig })
		end
	end

	addTarget(root, "BackgroundTransparency")

	for _, obj in ipairs(root:GetDescendants()) do
		if obj:IsA("GuiObject") then
			addTarget(obj, "BackgroundTransparency")
			if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
				addTarget(obj, "TextTransparency")
			end
			if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
				addTarget(obj, "ImageTransparency")
			end
			if obj:IsA("ScrollingFrame") then
				addTarget(obj, "ScrollBarImageTransparency")
			end
		elseif obj:IsA("UIStroke") then
			addTarget(obj, "Transparency")
		elseif obj.ClassName == "UIShadow" then
			addTarget(obj, "Transparency")
		end
	end
end

RegisterFadeTargets(MainFrame)

-- alpha: 0 = fully visible (original transparency), 1 = fully invisible
-- runs async (no wait) so it can be layered with a Position tween
local function Fade(alpha, duration)
	duration = duration or 0.25
	local info = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	for _, data in ipairs(fadeTargets) do
		local inst, prop, orig = data[1], data[2], data[3]
		local target = orig + (1 - orig) * alpha
		TweenService:Create(inst, info, { [prop] = target }):Play()
	end
end

-- Slides MainFrame up/down while fading it, and waits for it to finish.
-- showing = true  -> slides up into place + fades in
-- showing = false -> slides further up + fades out
local function SlideFade(showing, duration)
	duration = duration or 0.32
	local style = Enum.EasingStyle.Quart
	local direction = showing and Enum.EasingDirection.Out or Enum.EasingDirection.In
	local targetPos = showing and originalPosition
		or (originalPosition - UDim2.new(0, 0, 0, SLIDE_OFFSET))

	TweenService:Create(MainFrame, TweenInfo.new(duration, style, direction), {
		Position = targetPos
	}):Play()
	Fade(showing and 0 or 1, duration)
	task.wait(duration)
end

local function Clear()
	for _, v in ipairs(ContentHolder:GetChildren()) do
		if not v:IsA("UIListLayout") then
			v:Destroy()
		end
	end
end

local function AddTabHover(tab)
	local hoverIn = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local hoverOut = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	tab.MouseEnter:Connect(function()
		TweenService:Create(tab, hoverIn, { BackgroundTransparency = 0.85 }):Play()
	end)
	tab.MouseLeave:Connect(function()
		TweenService:Create(tab, hoverOut, { BackgroundTransparency = 1 }):Play()
	end)
end

local function AddTab(name)
	local tab = TabTemplate:Clone()
	tab.Text = name
	tab.Visible = true
	tab.Parent = TabScroll
	AddTabHover(tab)
	return tab
end

local function AddText(text)
	return Element.Text(ContentHolder, text)
end

local function AddButton(text, callback)
	return Element.Button(ContentHolder, text, callback)
end

local function AddToggle(text, default, callback)
	return Element.Switch(ContentHolder, text, default, callback)
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

--============================================================
-- OPEN / CLOSE (slide up + fade, driven by K)
--============================================================
local guiVisible = false
local animating = false

local function OpenGui()
	if animating or guiVisible then return end
	animating = true
	guiVisible = true

	MainFrame.Position = originalPosition + UDim2.new(0, 0, 0, SLIDE_OFFSET)
	MainFrame.Visible = true
	Fade(1, 0) -- snap fully transparent first (no flash of opaque frame)
	ShowHome()

	SlideFade(true, 0.35) -- slides up into place while fading in

	animating = false
end

local function CloseGui()
	if animating or not guiVisible then return end
	animating = true

	SlideFade(false, 0.3) -- slides further up while fading out

	MainFrame.Visible = false
	MainFrame.Position = originalPosition -- reset so next open starts clean
	guiVisible = false

	animating = false
end

-- K keybind toggles the whole menu, smoothly
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.K then
		if guiVisible then
			CloseGui()
		else
			OpenGui()
		end
	end
end)

--============================================================
-- CLOSE BUTTON: hover + hold-to-close
--============================================================
local holding = false
local holdConn

CloseButton.MouseEnter:Connect(function()
	if holding then return end
	TweenService:Create(CloseButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundColor3 = closeHoverColor
	}):Play()
	TweenService:Create(CloseScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Scale = 1.06
	}):Play()
end)

local function ResetCloseVisual()
	TweenService:Create(CloseButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundColor3 = closeOriginalColor
	}):Play()
	TweenService:Create(CloseScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Scale = 1
	}):Play()
end

local function CancelHold()
	if not holding then return end
	holding = false
	if holdConn then
		holdConn:Disconnect()
		holdConn = nil
	end
	TweenService:Create(HoldFill, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(1, 0, 0, 0)
	}):Play()
	ResetCloseVisual()
end

local function FinishHold()
	holding = false
	if holdConn then
		holdConn:Disconnect()
		holdConn = nil
	end

	-- brief solid black flash on the button, then close the whole GUI
	TweenService:Create(HoldFill, TweenInfo.new(0.1), { BackgroundTransparency = 0 }):Play()
	task.wait(0.1)

	SlideFade(false, 0.35)
	MainFrame.Visible = false
	guiVisible = false

	task.wait(0.05)
	G2L["1"]:Destroy()
end

local function StartHold()
	if holding or animating then return end
	holding = true
	local startTime = os.clock()

	-- quick press-in feedback
	TweenService:Create(CloseScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Scale = 0.94
	}):Play()

	holdConn = RunService.Heartbeat:Connect(function()
		if not holding then return end
		local elapsed = os.clock() - startTime
		-- eased fill: quick start, gentle settle near completion — reads as more deliberate than a linear bar
		local t = math.clamp(elapsed / HOLD_DURATION, 0, 1)
		local eased = TweenService:GetValue(t, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		HoldFill.Size = UDim2.new(1, 0, eased, 0)

		if t >= 1 then
			FinishHold()
		end
	end)
end

CloseButton.MouseButton1Down:Connect(StartHold)
CloseButton.MouseButton1Up:Connect(CancelHold)
CloseButton.MouseLeave:Connect(function()
	CancelHold()
	ResetCloseVisual()
end)

print("✅ LuisGamerCoolHub loaded! Hold X to close, press K to toggle")

return G2L["1"];
