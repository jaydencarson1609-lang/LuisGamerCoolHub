-- VERIFIED UI.LUA VERSION — SINGLE GUI ONLY
-- Supported game: current game tab + Settings
-- Unsupported game: Home + Supported Games + Settings
-- Removes any older LuisGamerCoolHub GUI before loading.

--[=[
d888b db db d888888b .d888b. db db db .d8b.
88' Y8b 88 88 88' VP 8D 88 88 88 d8' `8b
88 88 88 88 odD' 88 88 88 88ooo88
88 ooo 88 88 88 .88' 88 88 88 88~~~88
88. ~8~ 88b d88 .88. j88. 88booo. 88b d88 88 88 @uniquadev
Y888P ~Y8888P' Y888888P 888888D Y88888P ~Y8888P' YP YP CONVERTER
]=]
-- FIXED VERSION - All game("Service") → game:GetService("Service")
-- FIXED VERSION - All remote loading now uses game:HttpGet + JSONDecode properly
-- Teleport now correctly uses TeleportService (ExperienceService was invalid)
-- CUSTOM TABS - wired to src/elements.lua through Element.ConfigureTabs

--============================================================
-- SINGLE-GUI PROTECTION
--============================================================

local PlayersService = game:GetService("Players")
local HttpServiceForLock = game:GetService("HttpService")
local LocalPlayerForLock = PlayersService.LocalPlayer
local PlayerGuiForLock = LocalPlayerForLock:WaitForChild("PlayerGui")

local Environment = (typeof(getgenv) == "function" and getgenv()) or _G
local SINGLETON_KEY = "__LUIS_GAMER_COOL_HUB_SINGLETON_V3"

local previousState = Environment[SINGLETON_KEY]

if type(previousState) == "table" then
    if typeof(previousState.Cleanup) == "function" then
        pcall(previousState.Cleanup)
    elseif typeof(previousState.Gui) == "Instance" then
        pcall(function()
            previousState.Gui:Destroy()
        end)
    end
elseif typeof(previousState) == "Instance" then
    pcall(function()
        previousState:Destroy()
    end)
end

local runToken = HttpServiceForLock:GenerateGUID(false)
local singletonState = {
    Token = runToken,
    Gui = nil,
    ToggleConnection = nil,
}

Environment[SINGLETON_KEY] = singletonState

local function destroyNamedCopies(root)
    if typeof(root) ~= "Instance" then
        return
    end

    local objects = { root }

    local ok, descendants = pcall(function()
        return root:GetDescendants()
    end)

    if ok then
        for _, object in ipairs(descendants) do
            table.insert(objects, object)
        end
    end

    for _, object in ipairs(objects) do
        if object:IsA("ScreenGui") then
            local isHub =
                object.Name == "LuisGamerCoolHub"
                or object.Name:match("^LuisGamerCoolHub[_%-]")
                or object:GetAttribute("LuisGamerCoolHub") == true

            if isHub then
                pcall(function()
                    object:Destroy()
                end)
            end
        end
    end
end

local checkedRoots = {}

local function cleanRoot(root)
    if typeof(root) ~= "Instance" or checkedRoots[root] then
        return
    end

    checkedRoots[root] = true
    destroyNamedCopies(root)
end

cleanRoot(PlayerGuiForLock)

pcall(function()
    cleanRoot(game:GetService("CoreGui"))
end)

pcall(function()
    if typeof(gethui) == "function" then
        cleanRoot(gethui())
    end
end)

-- If two copies start on the same frame, only the newest copy continues.
task.wait()

if Environment[SINGLETON_KEY] ~= singletonState
    or singletonState.Token ~= runToken then
    return nil
end

local G2L = {};

-- StarterGui.LuisGamerCoolHub
G2L["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
G2L["1"]["Name"] = [[LuisGamerCoolHub]];
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
G2L["1"]["ResetOnSpawn"] = false;
G2L["1"]:SetAttribute("LuisGamerCoolHub", true);
G2L["1"]:SetAttribute("RunToken", runToken);

singletonState.Gui = G2L["1"];

singletonState.Cleanup = function()
    if singletonState.ToggleConnection then
        pcall(function()
            singletonState.ToggleConnection:Disconnect()
        end)
        singletonState.ToggleConnection = nil
    end

    if singletonState.Gui and singletonState.Gui.Parent then
        pcall(function()
            singletonState.Gui:Destroy()
        end)
    end

    singletonState.Gui = nil

    if Environment[SINGLETON_KEY] == singletonState then
        Environment[SINGLETON_KEY] = nil
    end
end;

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
G2L["5"]["ClipsDescendants"] = true;

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
G2L["14"]["Visible"] = false;

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
G2L["19"]["Visible"] = false;

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
G2L["1c"]["Visible"] = false;

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

-- UIDragDetector
pcall(function()
    G2L["21"] = Instance.new("UIDragDetector", G2L["2"]);
    G2L["21"]["Name"] = [[Drag]];
    G2L["21"]["DragStyle"] = Enum.UIDragDetectorDragStyle.TranslatePlane;
end)

-- ==================== WORKING LOGIC ====================
local MainFrame = G2L["2"]
local CloseButton = G2L["5"]
local TabScroll = G2L["9"]
local TabTemplate = G2L["b"]
local ContentFrame = G2L["e"]
local TitleHolder = G2L["10"]
local ContentHolder = G2L["12"]
local SwitchTemplate = G2L["14"]
local TextTemplate = G2L["19"]
local ButtonTemplate = G2L["1c"]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local REPO_RAW = "https://raw.githubusercontent.com/jaydencarson1609-lang/LuisGamerCoolHub/main/src/"

-- Load Element module properly
local Element
do
    local ok, src = pcall(function()
        return game:HttpGet(REPO_RAW .. "elements.lua")
    end)
    if ok and src then
        local fn = loadstring(src)
        if fn then
            Element = fn()
        end
    end
    if not Element then
        warn("[LuisGamerCoolHub] Failed to load elements.lua - using fallback")
        Element = {
            Text = function(parent, text)
                local lbl = Instance.new("TextLabel")
                lbl.Text = text
                lbl.Size = UDim2.new(1, 0, 0, 30)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.new(0,0,0)
                lbl.Parent = parent
                return lbl
            end,
            Button = function(parent, text, callback)
                local btn = Instance.new("TextButton")
                btn.Text = text
                btn.Size = UDim2.new(1, 0, 0, 40)
                btn.BackgroundColor3 = Color3.fromRGB(79, 214, 69)
                btn.TextColor3 = Color3.new(0,0,0)
                btn.Parent = parent
                if callback then btn.MouseButton1Click:Connect(callback) end
                return btn
            end,
            Switch = function(parent, text, default, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, 40)
                frame.BackgroundTransparency = 1
                frame.Parent = parent
                
                local lbl = Instance.new("TextLabel")
                lbl.Text = text
                lbl.Size = UDim2.new(0.7, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.new(0,0,0)
                lbl.Parent = frame
                
                local btn = Instance.new("TextButton")
                btn.Text = default and "ON" or "OFF"
                btn.Size = UDim2.new(0.25, 0, 1, 0)
                btn.Position = UDim2.new(0.72, 0, 0, 0)
                btn.BackgroundColor3 = default and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
                btn.TextColor3 = Color3.new(1,1,1)
                btn.Parent = frame
                
                local state = default
                btn.MouseButton1Click:Connect(function()
                    state = not state
                    btn.Text = state and "ON" or "OFF"
                    btn.BackgroundColor3 = state and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
                    if callback then callback(state) end
                end)
                return frame
            end
        }
    end
end

-- ==================== GAMES LIST + AUTO DETECTION ====================
local GamesList = {}
local GameById = {}
local VerifiedGames = {}

do
    local ok, raw = pcall(function()
        return game:HttpGet(REPO_RAW .. "gameslist.json")
    end)

    if ok and raw then
        local decodeOk, decoded = pcall(function()
            return HttpService:JSONDecode(raw)
        end)

        if decodeOk and typeof(decoded) == "table" then
            GamesList = decoded

            -- Only keep games that have a real numeric Place ID.
            for _, entry in ipairs(GamesList) do
                local placeId = tonumber(entry.id)
                local gameName = tostring(entry.game or "Unknown Game")

                if placeId and placeId > 0 then
                    local cleanEntry = {
                        game = gameName,
                        id = placeId,
                        status = tostring(entry.status or "")
                    }

                    table.insert(VerifiedGames, cleanEntry)
                    GameById[tostring(placeId)] = cleanEntry
                end
            end
        else
            warn("[LuisGamerCoolHub] Failed to decode gameslist.json")
        end
    else
        warn("[LuisGamerCoolHub] Failed to fetch gameslist.json: " .. tostring(raw))
    end
end

local CurrentPlaceId = tostring(game.PlaceId)
local CurrentGameEntry = GameById[CurrentPlaceId]
local originalPosition = MainFrame.Position
local SLIDE_OFFSET = 40

-- HOLD-TO-CLOSE BAR
local HoldFill = Instance.new("Frame")
HoldFill.Name = "HoldFill"
HoldFill.BackgroundColor3 = Color3.new(0, 0, 0)
HoldFill.BackgroundTransparency = 0.1
HoldFill.BorderSizePixel = 0
HoldFill.AnchorPoint = Vector2.new(0, 1)
HoldFill.Position = UDim2.new(0, 0, 1, 0)
HoldFill.Size = UDim2.new(1, 0, 0, 0)
HoldFill.ZIndex = CloseButton.ZIndex + 1
HoldFill.Parent = CloseButton

local HOLD_DURATION = 0.9

local CloseScale = Instance.new("UIScale")
CloseScale.Scale = 1
CloseScale.Parent = CloseButton

local closeOriginalColor = CloseButton.BackgroundColor3
local closeHoverColor = Color3.fromRGB(255, 72, 62)

-- FADE SYSTEM
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

local function Fade(alpha, duration)
    duration = duration or 0.25
    local info = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    for _, data in ipairs(fadeTargets) do
        local inst, prop, orig = data[1], data[2], data[3]
        local target = orig + (1 - orig) * alpha
        TweenService:Create(inst, info, { [prop] = target }):Play()
    end
end

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

-- Connect elements.lua to this hub's tab system.
-- This allows game scripts to call api.Tab("Name", function(tab) ... end).
Element.ConfigureTabs({
    TabScroll = TabScroll,
    TabTemplate = TabTemplate,
    ContentFrame = ContentFrame,
    TitleHolder = TitleHolder,
    ContentHolder = ContentHolder,
    Clear = Clear,
})

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

-- Supported Games uses the imported GameElement design from asset 113037265185555.
-- The emoji from gameslist.json is never shown as text; it only selects the
-- colour of the status ImageLabel contained inside the imported template.
local GAME_ELEMENTS_ASSET = "rbxassetid://113037265185555"
local ImportedGameElementTemplate

-- Supported Games row theme
local GAME_ROW_COLOR = Color3.fromRGB(19, 74, 38)
local GAME_ROW_HOVER_COLOR = Color3.fromRGB(24, 88, 45)
local GAME_ROW_PRESSED_COLOR = Color3.fromRGB(16, 64, 33)
local GAME_ROW_TEXT_COLOR = Color3.fromRGB(245, 255, 247)
local GAME_ROW_DIVIDER_COLOR = Color3.fromRGB(115, 190, 130)

local function FindGameElementTemplate(value)
    if typeof(value) == "Instance" then
        if value.Name == "GameElement" then
            return value
        end

        return value:FindFirstChild("GameElement", true)
    end

    if type(value) == "table" then
        local direct = value.GameElement
        if typeof(direct) == "Instance" then
            return direct
        end

        for _, item in pairs(value) do
            local found = FindGameElementTemplate(item)
            if found then
                return found
            end
        end
    end

    return nil
end

do
    -- Some executors provide import(), matching the example supplied.
    if typeof(import) == "function" then
        local ok, imported = pcall(function()
            return import(GAME_ELEMENTS_ASSET)
        end)

        if ok then
            ImportedGameElementTemplate = FindGameElementTemplate(imported)
        end
    end

    -- Supported fallback when import() is unavailable.
    if not ImportedGameElementTemplate then
        local ok, loadedObjects = pcall(function()
            return game:GetObjects(GAME_ELEMENTS_ASSET)
        end)

        if ok then
            ImportedGameElementTemplate = FindGameElementTemplate(loadedObjects)
        end
    end

    if ImportedGameElementTemplate then
        ImportedGameElementTemplate = ImportedGameElementTemplate:Clone()
        ImportedGameElementTemplate.Parent = nil
    else
        warn("[LuisGamerCoolHub] Could not load GameElement from " .. GAME_ELEMENTS_ASSET .. "; using the built-in text-row fallback.")
    end
end

local function GetStatusColour(status)
    status = tostring(status or "")

    if status == "🟢" or status:lower() == "working" then
        return Color3.fromRGB(0, 255, 0)
    elseif status == "🟡" or status:lower() == "partial" or status:lower() == "partly working" then
        return Color3.fromRGB(255, 255, 0)
    elseif status == "🔴" or status:lower() == "patched" or status:lower() == "not working" then
        return Color3.fromRGB(255, 0, 0)
    end

    return Color3.fromRGB(175, 175, 175)
end


local function CloneStatusImage(entry)
    local statusTemplate

    if ImportedGameElementTemplate then
        statusTemplate = ImportedGameElementTemplate:FindFirstChild("status", true)
    end

    local status

    if statusTemplate and (statusTemplate:IsA("ImageLabel") or statusTemplate:IsA("ImageButton")) then
        status = statusTemplate:Clone()
    else
        status = Instance.new("ImageLabel")
        status.Image = GAME_ELEMENTS_ASSET
    end

    status.Name = "status"
    status.BackgroundTransparency = 1
    status.AnchorPoint = Vector2.new(1, 0.5)
    status.Position = UDim2.new(1, -14, 0.5, 0)
    status.Size = UDim2.new(0, 29, 0, 29)
    status.ScaleType = Enum.ScaleType.Fit
    status.ImageColor3 = GetStatusColour(entry.status)
    status.ZIndex = 3

    return status
end

local function CreateGameElement(entry, layoutOrder)
    -- This is a Frame, not a TextButton. It looks like a clean information row.
    local row = Instance.new("Frame")
    row.Name = "GameElement"
    row.LayoutOrder = layoutOrder
    row.Size = UDim2.new(1, -2, 0, 48)
    row.BackgroundColor3 = GAME_ROW_COLOR
    row.BackgroundTransparency = 0.28
    row.BorderSizePixel = 0
    row.ClipsDescendants = true
    row.Active = true
    row.Selectable = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = row

    local header = Instance.new("TextLabel")
    header.Name = "header"
    header.BackgroundTransparency = 1
    header.Position = UDim2.new(0, 16, 0, 0)
    header.Size = UDim2.new(1, -66, 1, 0)
    header.FontFace = Font.new(
        "rbxasset://fonts/families/GothamSSm.json",
        Enum.FontWeight.Medium,
        Enum.FontStyle.Normal
    )
    header.Text = tostring(entry.game or "Unknown Game")
    header.TextColor3 = GAME_ROW_TEXT_COLOR
    header.TextSize = 17
    header.TextScaled = false
    header.TextWrapped = true
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextYAlignment = Enum.TextYAlignment.Center
    header.TextStrokeTransparency = 1
    header.ZIndex = 2
    header.Parent = row

    local status = CloneStatusImage(entry)
    status.Parent = row

    -- A small divider gives structure without making the row look like a button.
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.AnchorPoint = Vector2.new(0.5, 1)
    divider.Position = UDim2.new(0.5, 0, 1, 0)
    divider.Size = UDim2.new(1, -28, 0, 1)
    divider.BackgroundColor3 = GAME_ROW_DIVIDER_COLOR
    divider.BackgroundTransparency = 0.72
    divider.BorderSizePixel = 0
    divider.ZIndex = 2
    divider.Parent = row

    return row, row, header, status
end

local function AddSupportedGamesList()
    local list = Instance.new("ScrollingFrame")
    list.Name = "SupportedGamesList"
    list.Active = true
    list.Selectable = true
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.Size = UDim2.new(1, -8, 1, -4)
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.CanvasPosition = Vector2.new(0, 0)
    list.ScrollingDirection = Enum.ScrollingDirection.Y
    list.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    list.ScrollBarThickness = 7
    list.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    list.ScrollBarImageTransparency = 0.2
    list.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    list.Parent = ContentHolder

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 4)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = list

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = list

    local function updateCanvas()
        list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

    if #VerifiedGames == 0 then
        local empty = Instance.new("TextLabel")
        empty.Name = "NoGames"
        empty.Size = UDim2.new(1, 0, 0, 46)
        empty.BackgroundTransparency = 1
        empty.Text = "No supported games with a valid Place ID."
        empty.TextColor3 = Color3.fromRGB(0, 0, 0)
        empty.TextScaled = true
        empty.FontFace = Font.new(
            "rbxasset://fonts/families/ComicNeueAngular.json",
            Enum.FontWeight.Regular,
            Enum.FontStyle.Normal
        )
        empty.Parent = list
        updateCanvas()
        return
    end

    for index, entry in ipairs(VerifiedGames) do
        local row, clickTarget, header = CreateGameElement(entry, index)
        row.Parent = list

        -- No emoji text is displayed. Only the game name is shown.
        if header and (header:IsA("TextLabel") or header:IsA("TextButton")) then
            header.Text = tostring(entry.game or "Unknown Game")
        end

        if clickTarget and clickTarget:IsA("GuiObject") then
            local busy = false
            local pressStart

            clickTarget.MouseEnter:Connect(function()
                if busy or not clickTarget.Parent then
                    return
                end

                TweenService:Create(
                    clickTarget,
                    TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {
                        BackgroundColor3 = GAME_ROW_HOVER_COLOR,
                        BackgroundTransparency = 0.18
                    }
                ):Play()
            end)

            clickTarget.MouseLeave:Connect(function()
                if busy or not clickTarget.Parent then
                    return
                end

                TweenService:Create(
                    clickTarget,
                    TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {
                        BackgroundColor3 = GAME_ROW_COLOR,
                        BackgroundTransparency = 0.28
                    }
                ):Play()
            end)

            local function activateGame()
                if busy then
                    return
                end

                local placeId = tonumber(entry.id)

                if not placeId then
                    warn("[LuisGamerCoolHub] Invalid PlaceId for " .. tostring(entry.game))
                    return
                end

                if placeId == game.PlaceId then
                    local oldText = header.Text
                    header.Text = "Already in " .. tostring(entry.game)

                    task.delay(1.4, function()
                        if header and header.Parent then
                            header.Text = oldText
                        end
                    end)

                    return
                end

                busy = true
                clickTarget.Active = false
                header.Text = "Loading " .. tostring(entry.game) .. "..."

                TweenService:Create(
                    clickTarget,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {
                        BackgroundColor3 = GAME_ROW_PRESSED_COLOR,
                        BackgroundTransparency = 0.1
                    }
                ):Play()

                local ok, err = pcall(function()
                    TeleportService:Teleport(placeId, LocalPlayer)
                end)

                if not ok then
                    warn("[LuisGamerCoolHub] Teleport failed: " .. tostring(err))
                    busy = false
                    clickTarget.Active = true
                    header.Text = tostring(entry.game or "Unknown Game")

                    TweenService:Create(
                        clickTarget,
                        TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {
                            BackgroundColor3 = GAME_ROW_COLOR,
                            BackgroundTransparency = 0.28
                        }
                    ):Play()
                else
                    task.delay(8, function()
                        if clickTarget and clickTarget.Parent then
                            busy = false
                            clickTarget.Active = true
                            clickTarget.BackgroundColor3 = GAME_ROW_COLOR
                            clickTarget.BackgroundTransparency = 0.28
                        end

                        if header and header.Parent then
                            header.Text = tostring(entry.game or "Unknown Game")
                        end
                    end)
                end
            end

            clickTarget.InputBegan:Connect(function(input)
                if busy then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    pressStart = input.Position

                    TweenService:Create(
                        clickTarget,
                        TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {
                            BackgroundColor3 = GAME_ROW_PRESSED_COLOR,
                            BackgroundTransparency = 0.12
                        }
                    ):Play()
                end
            end)

            clickTarget.InputEnded:Connect(function(input)
                if busy then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    local moved = pressStart and (input.Position - pressStart).Magnitude or 0
                    pressStart = nil

                    TweenService:Create(
                        clickTarget,
                        TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {
                            BackgroundColor3 = GAME_ROW_HOVER_COLOR,
                            BackgroundTransparency = 0.18
                        }
                    ):Play()

                    -- Avoid teleporting when the user was only dragging the list.
                    if moved <= 12 then
                        activateGame()
                    end
                end
            end)
        end
    end

    updateCanvas()

    -- Smooth vertical wheel/trackpad scrolling on desktop.
    -- Touch devices keep Roblox's normal touch scrolling.
    if not UserInputService.TouchEnabled then
        list.ScrollingEnabled = false

        local targetY = 0
        local activeTween

        local function smoothScroll(amount)
            local maxY = math.max(0, list.AbsoluteCanvasSize.Y - list.AbsoluteWindowSize.Y)
            targetY = math.clamp(targetY + amount, 0, maxY)

            if activeTween then
                activeTween:Cancel()
            end

            activeTween = TweenService:Create(
                list,
                TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { CanvasPosition = Vector2.new(0, targetY) }
            )
            activeTween:Play()
        end

        list.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
                smoothScroll(-input.Position.Z * 85)
            end
        end)
    end
end

-- Game API
-- Text/Button/Toggle build inside the currently open page.
-- Tab creates a completely new sidebar tab through elements.lua.
local GameApi = {
    Text = AddText,
    Button = AddButton,
    Toggle = AddToggle,

    Tab = function(name, builder)
        return Element.Tab(name, builder)
    end,
}

-- Load current game's script
local function LoadCurrentGameScript()
    if not CurrentPlaceId or CurrentPlaceId == "0" then
        AddText("⚠️ Invalid PlaceId")
        return
    end

    local fetchOk, moduleFnOrErr = pcall(function()
        local src = game:HttpGet(REPO_RAW .. "games/" .. CurrentPlaceId .. ".lua")
        return loadstring(src)()
    end)

    if not fetchOk then
        AddText("⚠️ Failed to load script for this game.")
        warn("[LuisGamerCoolHub] " .. tostring(moduleFnOrErr))
        return
    end

    if typeof(moduleFnOrErr) ~= "function" then
        AddText("⚠️ Game script did not return a function.")
        return
    end

    local runOk, runErr = pcall(function()
        moduleFnOrErr(ContentHolder, GameApi)
    end)
    
    if not runOk then
        AddText("⚠️ Error running this game's script.")
        warn("[LuisGamerCoolHub] Error running game script: " .. tostring(runErr))
    end
end

-- ==================== TABS ====================
-- Supported game:
--     Current game tab + Settings
--
-- Unsupported game:
--     Home + Supported Games + Settings
local homeTab
local supportedGamesTab
local gameTab

if CurrentGameEntry then
    gameTab = AddTab(CurrentGameEntry.game)
else
    homeTab = AddTab("Home")
    supportedGamesTab = AddTab("Supported Games")
end

local settingsTab = AddTab("Settings")

local function ShowHome()
    Clear()
    ContentFrame.Visible = true
    TitleHolder.Text = "Home"
    AddText("Welcome to LuisGamerCoolHub!")

    if CurrentGameEntry then
        AddText("✅ Supported game detected: " .. CurrentGameEntry.game)
    else
        AddText("You're not currently in a supported game.")
    end

    AddText("Open Supported Games to view and join every game with a valid Place ID.")
end

local function ShowSupportedGames()
    Clear()
    ContentFrame.Visible = true

    -- Uses your original title placeholder.
    TitleHolder.Text = "Supported Games"

    -- The content area contains only the vertical scrolling list of game buttons.
    AddSupportedGamesList()
end

local function ShowGame()
    if not CurrentGameEntry then return end
    Clear()
    ContentFrame.Visible = true
    TitleHolder.Text = CurrentGameEntry.game
    LoadCurrentGameScript()
end

local function ShowSettings()
    Clear()
    ContentFrame.Visible = true
    TitleHolder.Text = "Settings"

    AddToggle("Disable Shadow", false, function(disabled)
        Lighting.GlobalShadows = not disabled
    end)

    AddToggle("Disable Rendering", false, function(disabled)
        RunService:Set3dRenderingEnabled(not disabled)
    end)
end

if homeTab then
    homeTab.MouseButton1Click:Connect(ShowHome)
end

if supportedGamesTab then
    supportedGamesTab.MouseButton1Click:Connect(ShowSupportedGames)
end

if gameTab then
    gameTab.MouseButton1Click:Connect(ShowGame)
end

settingsTab.MouseButton1Click:Connect(ShowSettings)

-- OPEN / CLOSE
local guiVisible = false
local animating = false

local function OpenGui()
    if animating or guiVisible then return end
    animating = true
    guiVisible = true

    MainFrame.Position = originalPosition + UDim2.new(0, 0, 0, SLIDE_OFFSET)
    MainFrame.Visible = true
    Fade(1, 0)

    if CurrentGameEntry then
        -- Open the supported game's features automatically.
        ShowGame()
    else
        ShowHome()
    end

    SlideFade(true, 0.35)
    animating = false
end

local function CloseGui()
    if animating or not guiVisible then return end
    animating = true

    SlideFade(false, 0.3)

    MainFrame.Visible = false
    MainFrame.Position = originalPosition
    guiVisible = false
    animating = false
end

-- K keybind
local toggleConnection = UserInputService.InputBegan:Connect(function(input, gp)
    if gp then
        return
    end

    if Environment[SINGLETON_KEY] ~= singletonState then
        return
    end

    if input.KeyCode == Enum.KeyCode.K then
        if guiVisible then
            CloseGui()
        else
            OpenGui()
        end
    end
end)

singletonState.ToggleConnection = toggleConnection

-- CLOSE BUTTON HOLD-TO-CLOSE
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

    TweenService:Create(HoldFill, TweenInfo.new(0.1), { BackgroundTransparency = 0 }):Play()
    task.wait(0.1)

    SlideFade(false, 0.35)
    MainFrame.Visible = false
    guiVisible = false

    task.wait(0.05)
    singletonState.Cleanup()
end

local function StartHold()
    if holding or animating then return end
    holding = true
    local startTime = os.clock()

    TweenService:Create(CloseScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Scale = 0.94
    }):Play()

    holdConn = RunService.Heartbeat:Connect(function()
        if not holding then return end
        local elapsed = os.clock() - startTime
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

G2L["1"].AncestryChanged:Connect(function(_, parent)
    if parent == nil and Environment[SINGLETON_KEY] == singletonState then
        if singletonState.ToggleConnection then
            pcall(function()
                singletonState.ToggleConnection:Disconnect()
            end)
            singletonState.ToggleConnection = nil
        end

        singletonState.Gui = nil
        Environment[SINGLETON_KEY] = nil
    end
end)

print("✅ LuisGamerCoolHub ui.lua loaded once! Press K to open, hold X to close")
return G2L["1"];
