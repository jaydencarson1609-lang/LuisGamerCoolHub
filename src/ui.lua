-- CUSTOM TAB TEXT VISIBILITY FIX
-- POSH LETTER-ONLY SEARCH TYPING + EXPANDED HELPFUL SETTINGS
-- VERIFIED UI.LUA VERSION — SINGLE GUI ONLY
-- Supported game: custom api.Tab tabs + Settings; no automatic game-name tab
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

    if singletonState.BlurEffect and singletonState.BlurEffect.Parent then
        pcall(function()
            singletonState.BlurEffect:Destroy()
        end)
    end

    singletonState.Gui = nil
    singletonState.BlurEffect = nil

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

-- Native UIDragDetector intentionally disabled.
-- A custom RenderStepped drag controller is created later so dragging feels
-- smooth and does not jump or fight with Roblox's default detector.
G2L["21"] = nil

-- ==================== WORKING LOGIC ====================
local MainFrame = G2L["2"]
local Logo = G2L["3"]
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
local SoundService = game:GetService("SoundService")
local StatsService = game:GetService("Stats")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local REPO_RAW = "https://raw.githubusercontent.com/jaydencarson1609-lang/LuisGamerCoolHub/main/src/"

-- Load Element module properly
local Element
do
    local ok, src = pcall(function()
        return game:HttpGet(REPO_RAW .. "elements.lua?cache=" .. tostring(os.time()))
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
local ReduceUIAnimations = false

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
    if ReduceUIAnimations then
        duration = math.min(duration, 0.08)
    end
    local info = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    for _, data in ipairs(fadeTargets) do
        local inst, prop, orig = data[1], data[2], data[3]
        local target = orig + (1 - orig) * alpha
        TweenService:Create(inst, info, { [prop] = target }):Play()
    end
end

local function SlideFade(showing, duration)
    duration = duration or 0.32
    if ReduceUIAnimations then
        duration = math.min(duration, 0.08)
    end
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

-- elements.lua still creates Text, Button and Switch elements.
-- Custom tabs are handled directly by ui.lua below, so the hub does not
-- depend on Element.Tab being present or up to date.
if typeof(Element.ConfigureTabs) == "function" then
    pcall(function()
        Element.ConfigureTabs({
            TabScroll = TabScroll,
            TabTemplate = TabTemplate,
            ContentFrame = ContentFrame,
            TitleHolder = TitleHolder,
            ContentHolder = ContentHolder,
            Clear = Clear,
        })
    end)
end

local ActiveSidebarTab = nil
local SidebarTabTweens = {}

local function cancelSidebarTween(tab)
    local tween = SidebarTabTweens[tab]

    if tween then
        pcall(function()
            tween:Cancel()
        end)

        SidebarTabTweens[tab] = nil
    end
end

local function applySidebarTabVisual(tab, selected, instant)
    if typeof(tab) ~= "Instance" or not tab:IsA("TextButton") then
        return
    end

    cancelSidebarTween(tab)

    local goals = {
        BackgroundTransparency = selected and 0.82 or 1,
        TextColor3 = selected
            and Color3.fromRGB(0, 0, 0)
            or Color3.fromRGB(255, 255, 255),
    }

    if instant then
        tab.BackgroundTransparency = goals.BackgroundTransparency
        tab.TextColor3 = goals.TextColor3
    else
        local tween = TweenService:Create(
            tab,
            TweenInfo.new(
                0.18,
                Enum.EasingStyle.Quart,
                Enum.EasingDirection.Out
            ),
            goals
        )

        SidebarTabTweens[tab] = tween
        tween:Play()
    end

    local shadow = tab:FindFirstChildOfClass("UIShadow")
    if shadow then
        local targetTransparency = selected and 0.55 or 0.75

        if instant then
            shadow.Transparency = targetTransparency
        else
            TweenService:Create(
                shadow,
                TweenInfo.new(
                    0.18,
                    Enum.EasingStyle.Quart,
                    Enum.EasingDirection.Out
                ),
                { Transparency = targetTransparency }
            ):Play()
        end
    end
end

-- One shared selected-state controller for every sidebar tab, including
-- game-created tabs and the built-in Settings tab.
local function setTabSelected(selectedTab, instant)
    ActiveSidebarTab = selectedTab

    for _, tab in ipairs(TabScroll:GetChildren()) do
        if tab:IsA("TextButton")
            and tab.Visible
            and tab:GetAttribute("LuisSidebarTab") == true then

            applySidebarTabVisual(tab, tab == selectedTab, instant)
        end
    end

    -- Enforce the final colours after the tween. This prevents an older hover
    -- tween from leaving previously clicked tabs black.
    if not instant then
        task.delay(0.2, function()
            if ActiveSidebarTab ~= selectedTab then
                return
            end

            for _, tab in ipairs(TabScroll:GetChildren()) do
                if tab:IsA("TextButton")
                    and tab.Visible
                    and tab:GetAttribute("LuisSidebarTab") == true then

                    local selected = tab == selectedTab
                    tab.BackgroundTransparency = selected and 0.82 or 1
                    tab.TextColor3 = selected
                        and Color3.fromRGB(0, 0, 0)
                        or Color3.fromRGB(255, 255, 255)
                end
            end
        end)
    end
end

local function AddTabHover(tab)
    local hoverIn = TweenInfo.new(
        0.15,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )

    tab.MouseEnter:Connect(function()
        if ActiveSidebarTab == tab then
            return
        end

        cancelSidebarTween(tab)
        SidebarTabTweens[tab] = TweenService:Create(tab, hoverIn, {
            BackgroundTransparency = 0.87,
        })
        SidebarTabTweens[tab]:Play()
    end)

    tab.MouseLeave:Connect(function()
        applySidebarTabVisual(
            tab,
            ActiveSidebarTab == tab,
            false
        )
    end)
end

local function AddTab(name)
    local tab = TabTemplate:Clone()

    tab.Text = tostring(name or "Tab")
    tab.Visible = true
    tab.TextTransparency = 0
    tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab.BackgroundTransparency = 1
    tab:SetAttribute("LuisSidebarTab", true)

    local tabShadow = tab:FindFirstChildOfClass("UIShadow")
    if tabShadow then
        tabShadow.Transparency = 0.75
    end

    local tabStroke = tab:FindFirstChildOfClass("UIStroke")
    if tabStroke then
        tabStroke.Transparency = 0
    end

    tab.Parent = TabScroll
    AddTabHover(tab)

    tab.MouseButton1Click:Connect(function()
        setTabSelected(tab)
    end)

    return tab
end

local function AddText(text)
    return Element.Text(ContentHolder, text)
end

local function AddButton(text, callback)
    return Element.Button(ContentHolder, text, callback)
end

-- Gives every switch a dark faded card, rounded border, shadow,
-- smooth hover animation and a responsive press animation.
-- This works with both the downloaded elements.lua switch and the fallback switch.
local function StyleSwitchElement(switchResult)
    local row = switchResult

    -- Newer element modules may return a controller table instead of the Frame.
    if type(switchResult) == "table" then
        row = switchResult.Instance
            or switchResult.Row
            or switchResult.Root
            or switchResult.Frame
    end

    if typeof(row) ~= "Instance" or not row:IsA("GuiObject") then
        return switchResult
    end

    -- Do not connect the hover events twice if this function is called again.
    if row:GetAttribute("LuisSwitchHoverStyled") == true then
        return switchResult
    end
    row:SetAttribute("LuisSwitchHoverStyled", true)

    local BASE_ROW_COLOR = Color3.fromRGB(18, 18, 18)
    local HOVER_ROW_COLOR = Color3.fromRGB(29, 31, 29)
    local BASE_BORDER_COLOR = Color3.fromRGB(8, 8, 8)
    local HOVER_BORDER_COLOR = Color3.fromRGB(67, 126, 62)
    local PRESS_BORDER_COLOR = Color3.fromRGB(92, 181, 84)

    local BASE_ROW_TRANSPARENCY = 0.72
    local HOVER_ROW_TRANSPARENCY = 0.56

    local BASE_ROW_SCALE = 1
    local HOVER_ROW_SCALE = 1.015
    local PRESS_ROW_SCALE = 0.992

    local BASE_CONTROL_SCALE = 1
    local HOVER_CONTROL_SCALE = 1.055
    local PRESS_CONTROL_SCALE = 0.93

    row.Active = true
    row.BackgroundColor3 = BASE_ROW_COLOR
    row.BackgroundTransparency = BASE_ROW_TRANSPARENCY
    row.BorderSizePixel = 0
    row.ClipsDescendants = false

    local rowCorner = row:FindFirstChild("SwitchRowCorner")
    if not rowCorner then
        rowCorner = Instance.new("UICorner")
        rowCorner.Name = "SwitchRowCorner"
        rowCorner.CornerRadius = UDim.new(0, 11)
        rowCorner.Parent = row
    end

    local rowStroke = row:FindFirstChild("SwitchRowBorder")
    if not rowStroke then
        rowStroke = Instance.new("UIStroke")
        rowStroke.Name = "SwitchRowBorder"
        rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        rowStroke.Parent = row
    end
    rowStroke.Color = BASE_BORDER_COLOR
    rowStroke.Thickness = 2
    rowStroke.Transparency = 0.18

    local rowShadow = row:FindFirstChild("SwitchRowShadow")
    if not rowShadow then
        rowShadow = Instance.new("UIShadow")
        rowShadow.Name = "SwitchRowShadow"
        rowShadow.Parent = row
    end
    rowShadow.Color = Color3.fromRGB(0, 0, 0)
    rowShadow.Transparency = 0.5
    rowShadow.BlurRadius = UDim.new(0, 8)
    rowShadow.Offset = UDim2.new(0, 0, 0, 3)

    local rowScale = row:FindFirstChild("SwitchRowScale")
    if not rowScale then
        rowScale = Instance.new("UIScale")
        rowScale.Name = "SwitchRowScale"
        rowScale.Parent = row
    end
    rowScale.Scale = BASE_ROW_SCALE

    -- Find the visible toggle control. The normal elements.lua uses "Track";
    -- the original placeholder/fallback uses "On/OffButton".
    local switchControl = row:FindFirstChild("Track", true)
        or row:FindFirstChild("On/OffButton", true)

    if not switchControl then
        for _, object in ipairs(row:GetDescendants()) do
            if object:IsA("TextButton")
                and object.Name ~= "ClickArea"
                and object.BackgroundTransparency < 1 then

                switchControl = object
                break
            end
        end
    end

    local controlStroke
    local controlShadow
    local controlScale

    if switchControl and switchControl:IsA("GuiObject") then
        switchControl.Active = true
        switchControl.BorderSizePixel = 0

        local controlCorner = switchControl:FindFirstChild("SwitchControlCorner")
            or switchControl:FindFirstChildOfClass("UICorner")

        if not controlCorner then
            controlCorner = Instance.new("UICorner")
            controlCorner.Name = "SwitchControlCorner"
            controlCorner.CornerRadius = UDim.new(1, 0)
            controlCorner.Parent = switchControl
        end

        controlStroke = switchControl:FindFirstChild("SwitchControlBorder")
        if not controlStroke then
            controlStroke = Instance.new("UIStroke")
            controlStroke.Name = "SwitchControlBorder"
            controlStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            controlStroke.Parent = switchControl
        end
        controlStroke.Color = Color3.fromRGB(0, 0, 0)
        controlStroke.Thickness = 2
        controlStroke.Transparency = 0.12

        controlShadow = switchControl:FindFirstChild("SwitchControlShadow")
        if not controlShadow then
            controlShadow = Instance.new("UIShadow")
            controlShadow.Name = "SwitchControlShadow"
            controlShadow.Parent = switchControl
        end
        controlShadow.Color = Color3.fromRGB(0, 0, 0)
        controlShadow.Transparency = 0.42
        controlShadow.BlurRadius = UDim.new(0, 6)
        controlShadow.Offset = UDim2.new(0, 0, 0, 2)

        controlScale = switchControl:FindFirstChild("SwitchControlScale")
        if not controlScale then
            controlScale = Instance.new("UIScale")
            controlScale.Name = "SwitchControlScale"
            controlScale.Parent = switchControl
        end
        controlScale.Scale = BASE_CONTROL_SCALE
    end

    local hoverInfo = TweenInfo.new(
        0.18,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )

    local leaveInfo = TweenInfo.new(
        0.22,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )

    local pressInfo = TweenInfo.new(
        0.09,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )

    local releaseInfo = TweenInfo.new(
        0.16,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    )

    local activeTweens = {}
    local hovered = false
    local pressing = false

    local function playTween(key, object, info, properties)
        if not object or not object.Parent then
            return
        end

        local previous = activeTweens[key]
        if previous then
            pcall(function()
                previous:Cancel()
            end)
        end

        local tween = TweenService:Create(object, info, properties)
        activeTweens[key] = tween
        tween:Play()
    end

    local function showNormal(info)
        info = info or leaveInfo

        playTween("RowBackground", row, info, {
            BackgroundColor3 = BASE_ROW_COLOR,
            BackgroundTransparency = BASE_ROW_TRANSPARENCY,
        })

        playTween("RowScale", rowScale, info, {
            Scale = BASE_ROW_SCALE,
        })

        playTween("RowStroke", rowStroke, info, {
            Color = BASE_BORDER_COLOR,
            Thickness = 2,
            Transparency = 0.18,
        })

        playTween("RowShadow", rowShadow, info, {
            Transparency = 0.5,
            Offset = UDim2.new(0, 0, 0, 3),
        })

        if controlScale then
            playTween("ControlScale", controlScale, info, {
                Scale = BASE_CONTROL_SCALE,
            })
        end

        if controlStroke then
            playTween("ControlStroke", controlStroke, info, {
                Color = Color3.fromRGB(0, 0, 0),
                Thickness = 2,
                Transparency = 0.12,
            })
        end

        if controlShadow then
            playTween("ControlShadow", controlShadow, info, {
                Transparency = 0.42,
                Offset = UDim2.new(0, 0, 0, 2),
            })
        end
    end

    local function showHover(info)
        info = info or hoverInfo

        playTween("RowBackground", row, info, {
            BackgroundColor3 = HOVER_ROW_COLOR,
            BackgroundTransparency = HOVER_ROW_TRANSPARENCY,
        })

        playTween("RowScale", rowScale, info, {
            Scale = HOVER_ROW_SCALE,
        })

        playTween("RowStroke", rowStroke, info, {
            Color = HOVER_BORDER_COLOR,
            Thickness = 2.4,
            Transparency = 0.02,
        })

        playTween("RowShadow", rowShadow, info, {
            Transparency = 0.3,
            Offset = UDim2.new(0, 0, 0, 5),
        })

        if controlScale then
            playTween("ControlScale", controlScale, info, {
                Scale = HOVER_CONTROL_SCALE,
            })
        end

        if controlStroke then
            playTween("ControlStroke", controlStroke, info, {
                Color = Color3.fromRGB(69, 117, 65),
                Thickness = 2.4,
                Transparency = 0.03,
            })
        end

        if controlShadow then
            playTween("ControlShadow", controlShadow, info, {
                Transparency = 0.25,
                Offset = UDim2.new(0, 0, 0, 4),
            })
        end
    end

    local function showPressed()
        playTween("RowScale", rowScale, pressInfo, {
            Scale = PRESS_ROW_SCALE,
        })

        playTween("RowStroke", rowStroke, pressInfo, {
            Color = PRESS_BORDER_COLOR,
            Thickness = 2.7,
            Transparency = 0,
        })

        playTween("RowShadow", rowShadow, pressInfo, {
            Transparency = 0.48,
            Offset = UDim2.new(0, 0, 0, 2),
        })

        if controlScale then
            playTween("ControlScale", controlScale, pressInfo, {
                Scale = PRESS_CONTROL_SCALE,
            })
        end

        if controlStroke then
            playTween("ControlStroke", controlStroke, pressInfo, {
                Color = Color3.fromRGB(102, 205, 94),
                Thickness = 2.7,
                Transparency = 0,
            })
        end

        if controlShadow then
            playTween("ControlShadow", controlShadow, pressInfo, {
                Transparency = 0.5,
                Offset = UDim2.new(0, 0, 0, 1),
            })
        end
    end

    local function releasePressed()
        pressing = false

        if hovered then
            showHover(releaseInfo)
        else
            showNormal(releaseInfo)
        end
    end

    row.MouseEnter:Connect(function()
        hovered = true

        if not pressing then
            showHover()
        end
    end)

    row.MouseLeave:Connect(function()
        hovered = false

        if not pressing then
            showNormal()
        end
    end)

    -- The downloaded switch normally has a transparent ClickArea inside Track.
    -- The fallback switch uses the visible TextButton itself.
    local clickTarget = row:FindFirstChild("ClickArea", true)

    if not clickTarget and switchControl and switchControl:IsA("GuiObject") then
        clickTarget = switchControl
    end

    if clickTarget and clickTarget:IsA("GuiObject") then
        clickTarget.Active = true

        clickTarget.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then

                pressing = true
                showPressed()
            end
        end)

        clickTarget.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then

                releasePressed()
            end
        end)
    end

    return switchResult
end

local function AddToggle(text, default, callback)
    local switchResult = Element.Switch(ContentHolder, text, default, callback)
    return StyleSwitchElement(switchResult)
end

local function callElementFunction(functionName, ...)
    local elementFunction = Element[functionName]

    if typeof(elementFunction) ~= "function" then
        error(
            "[LuisGamerCoolHub] Element."
                .. tostring(functionName)
                .. " is missing. Replace src/elements.lua with the expanded elements file.",
            2
        )
    end

    return elementFunction(ContentHolder, ...)
end

local function AddParagraph(title, message)
    return callElementFunction("Paragraph", title, message)
end

local function AddSection(title)
    return callElementFunction("Section", title)
end

local function AddDivider()
    return callElementFunction("Divider")
end

local function AddSpacer(height)
    return callElementFunction("Spacer", height)
end

local function AddSelect(name, options, default, callback)
    return callElementFunction("Select", name, options, default, callback)
end

local function AddMultiSelect(name, options, defaults, callback)
    return callElementFunction("MultiSelect", name, options, defaults, callback)
end

local function AddSlider(name, minimum, maximum, default, step, callback)
    return callElementFunction(
        "Slider",
        name,
        minimum,
        maximum,
        default,
        step,
        callback
    )
end

local function AddInput(name, placeholder, default, callback)
    return callElementFunction("Input", name, placeholder, default, callback)
end

local function AddKeybind(name, defaultKey, onPressed, onChanged)
    return callElementFunction(
        "Keybind",
        name,
        defaultKey,
        onPressed,
        onChanged
    )
end

local function AddStatus(name, defaultText, defaultColor)
    return callElementFunction("Status", name, defaultText, defaultColor)
end

-- Supported Games is a static, vertically scrolling information list.
-- Rows are not buttons. The status asset is only used as a coloured indicator.
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

    status.Name = "StatusSignal"
    status.BackgroundTransparency = 1
    status.AnchorPoint = Vector2.new(1, 0.5)
    status.Position = UDim2.new(1, -9, 0.5, 0)
    status.Size = UDim2.new(0, 31, 0, 31)
    status.ScaleType = Enum.ScaleType.Fit
    status.ImageColor3 = GetStatusColour(entry.status)
    status.ZIndex = 4

    return status
end

local GAME_LIST_FONT = Font.new(
    "rbxasset://fonts/families/ComicNeueAngular.json",
    Enum.FontWeight.Bold,
    Enum.FontStyle.Normal
)

local function CreateGameElement(entry, layoutOrder)
    -- This is a clean information row, not a button.
    -- Only the game name, status signal and a faint divider are displayed.
    local row = Instance.new("Frame")
    row.Name = "GameElement"
    row.LayoutOrder = layoutOrder
    row.Size = UDim2.new(1, -2, 0, 50)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.ClipsDescendants = true
    row.Active = false
    row.Selectable = false

    local header = Instance.new("TextLabel")
    header.Name = "GameName"
    header.BackgroundTransparency = 1
    header.Position = UDim2.new(0, 10, 0, 0)
    header.Size = UDim2.new(1, -59, 1, 0)
    header.FontFace = GAME_LIST_FONT
    header.Text = tostring(entry.game or "Unknown Game")
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.TextSize = 23
    header.TextScaled = false
    header.TextWrapped = false
    header.TextTruncate = Enum.TextTruncate.AtEnd
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.TextYAlignment = Enum.TextYAlignment.Center
    header.TextStrokeTransparency = 1
    header.ZIndex = 3
    header.Parent = row

    local headerStroke = Instance.new("UIStroke")
    headerStroke.Name = "GameNameOutline"
    headerStroke.Thickness = 1.75
    headerStroke.Color = Color3.fromRGB(0, 0, 0)
    headerStroke.Transparency = 0.12
    headerStroke.Parent = header

    local status = CloneStatusImage(entry)
    status.Parent = row

    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.AnchorPoint = Vector2.new(0.5, 1)
    divider.Position = UDim2.new(0.5, 0, 1, 0)
    divider.Size = UDim2.new(1, -18, 0, 2)
    divider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    divider.BackgroundTransparency = 0.70
    divider.BorderSizePixel = 0
    divider.ZIndex = 2
    divider.Parent = row

    return row
end

local function AddSupportedGamesList()
    -- One wrapper is inserted into ContentHolder so its UIListLayout does not
    -- interfere with the search bar and scrolling list positions.
    local shell = Instance.new("Frame")
    shell.Name = "SupportedGamesBrowser"
    shell.Size = UDim2.new(1, -8, 1, -4)
    shell.BackgroundTransparency = 1
    shell.BorderSizePixel = 0
    shell.ClipsDescendants = true
    shell.Parent = ContentHolder

    -- ==================== SEARCH BAR ====================
    local searchBar = Instance.new("Frame")
    searchBar.Name = "SearchBar"
    searchBar.Position = UDim2.new(0, 4, 0, 2)
    searchBar.Size = UDim2.new(1, -12, 0, 48)
    searchBar.BackgroundColor3 = Color3.fromRGB(12, 67, 28)
    searchBar.BackgroundTransparency = 0.24
    searchBar.BorderSizePixel = 0
    searchBar.ClipsDescendants = true
    searchBar.Parent = shell

    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 12)
    searchCorner.Parent = searchBar

    local searchStroke = Instance.new("UIStroke")
    searchStroke.Name = "SearchBorder"
    searchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    searchStroke.Thickness = 2
    searchStroke.Color = Color3.fromRGB(0, 0, 0)
    searchStroke.Transparency = 0.48
    searchStroke.Parent = searchBar

    pcall(function()
        local shadow = Instance.new("UIShadow")
        shadow.Name = "SearchShadow"
        shadow.Color = Color3.fromRGB(0, 0, 0)
        shadow.Transparency = 0.72
        shadow.BlurRadius = UDim.new(0, 7)
        shadow.Offset = UDim2.new(0, 0, 0, 3)
        shadow.Parent = searchBar
    end)

    local searchIcon = Instance.new("Frame")
    searchIcon.Name = "SearchIcon"
    searchIcon.BackgroundTransparency = 1
    searchIcon.Position = UDim2.new(0, 13, 0.5, -13)
    searchIcon.Size = UDim2.new(0, 28, 0, 28)
    searchIcon.ZIndex = 3
    searchIcon.Parent = searchBar

    local searchCircle = Instance.new("Frame")
    searchCircle.Name = "Circle"
    searchCircle.BackgroundTransparency = 1
    searchCircle.Position = UDim2.new(0, 2, 0, 1)
    searchCircle.Size = UDim2.new(0, 17, 0, 17)
    searchCircle.ZIndex = 3
    searchCircle.Parent = searchIcon

    local searchCircleCorner = Instance.new("UICorner")
    searchCircleCorner.CornerRadius = UDim.new(1, 0)
    searchCircleCorner.Parent = searchCircle

    local searchCircleStroke = Instance.new("UIStroke")
    searchCircleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    searchCircleStroke.Thickness = 2.4
    searchCircleStroke.Color = Color3.fromRGB(255, 255, 255)
    searchCircleStroke.Transparency = 0.08
    searchCircleStroke.Parent = searchCircle

    local searchHandle = Instance.new("Frame")
    searchHandle.Name = "Handle"
    searchHandle.AnchorPoint = Vector2.new(0.5, 0.5)
    searchHandle.Position = UDim2.new(0, 20, 0, 20)
    searchHandle.Size = UDim2.new(0, 10, 0, 3)
    searchHandle.Rotation = 45
    searchHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    searchHandle.BackgroundTransparency = 0.08
    searchHandle.BorderSizePixel = 0
    searchHandle.ZIndex = 3
    searchHandle.Parent = searchIcon

    local searchHandleCorner = Instance.new("UICorner")
    searchHandleCorner.CornerRadius = UDim.new(1, 0)
    searchHandleCorner.Parent = searchHandle

    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.BackgroundTransparency = 1
    searchBox.Position = UDim2.new(0, 48, 0, 0)
    searchBox.Size = UDim2.new(1, -93, 1, 0)
    searchBox.ClearTextOnFocus = false
    searchBox.FontFace = GAME_LIST_FONT
    searchBox.PlaceholderText = "Search supported games..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(205, 226, 208)
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.TextSize = 20
    searchBox.TextWrapped = false
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.TextYAlignment = Enum.TextYAlignment.Center
    searchBox.ZIndex = 3
    searchBox.Parent = searchBar

    -- Posh letter-only typing animation. The search bar, icon and results do
    -- not bounce when typing. Only the newly entered character softly rises
    -- and fades into place while the previous characters stay completely still.
    local stableSearchText = Instance.new("TextLabel")
    stableSearchText.Name = "StableSearchText"
    stableSearchText.BackgroundTransparency = 1
    stableSearchText.Position = searchBox.Position
    stableSearchText.Size = searchBox.Size
    stableSearchText.FontFace = searchBox.FontFace
    stableSearchText.Text = ""
    stableSearchText.TextColor3 = searchBox.TextColor3
    stableSearchText.TextSize = searchBox.TextSize
    stableSearchText.TextWrapped = false
    stableSearchText.TextXAlignment = searchBox.TextXAlignment
    stableSearchText.TextYAlignment = searchBox.TextYAlignment
    stableSearchText.TextTransparency = 0
    stableSearchText.MaxVisibleGraphemes = -1
    stableSearchText.ZIndex = 4
    stableSearchText.Active = false
    stableSearchText.Parent = searchBar

    local revealSearchText = stableSearchText:Clone()
    revealSearchText.Name = "RevealingSearchText"
    revealSearchText.TextTransparency = 1
    revealSearchText.ZIndex = 4
    revealSearchText.Parent = searchBar

    -- Keep the real TextBox above the labels so its caret and selection still
    -- work. Its text is hidden whenever the mirrored labels are displaying it.
    searchBox.ZIndex = 5

    local searchTextBasePosition = searchBox.Position
    local revealTween = nil
    local revealAnimationId = 0

    local function getGraphemeCount(value)
        local ok, count = pcall(function()
            return utf8.len(value)
        end)

        if ok and count then
            return count
        end

        return #value
    end

    local function setMirroredSearchText(currentText, previousText)
        revealAnimationId += 1
        local thisAnimation = revealAnimationId

        if revealTween then
            pcall(function()
                revealTween:Cancel()
            end)
            revealTween = nil
        end

        currentText = tostring(currentText or "")
        previousText = tostring(previousText or "")

        if currentText == "" then
            searchBox.TextTransparency = 0
            stableSearchText.Text = ""
            revealSearchText.Text = ""
            revealSearchText.TextTransparency = 1
            revealSearchText.Position = searchTextBasePosition
            return
        end

        searchBox.TextTransparency = 1
        stableSearchText.Text = currentText
        revealSearchText.Text = currentText

        local appendedAtEnd = #currentText > #previousText
            and string.sub(currentText, 1, #previousText) == previousText

        if not appendedAtEnd then
            stableSearchText.MaxVisibleGraphemes = -1
            revealSearchText.TextTransparency = 1
            revealSearchText.Position = searchTextBasePosition
            return
        end

        local graphemeCount = getGraphemeCount(currentText)

        -- The stable label shows everything except the newest character. The
        -- reveal label contains the full text and fades in over it, which means
        -- only the final character appears to animate.
        stableSearchText.MaxVisibleGraphemes = math.max(0, graphemeCount - 1)
        revealSearchText.MaxVisibleGraphemes = -1
        revealSearchText.TextTransparency = 1
        revealSearchText.Position = UDim2.new(
            searchTextBasePosition.X.Scale,
            searchTextBasePosition.X.Offset,
            searchTextBasePosition.Y.Scale,
            searchTextBasePosition.Y.Offset + 3
        )

        revealTween = TweenService:Create(
            revealSearchText,
            TweenInfo.new(
                0.16,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            {
                TextTransparency = 0,
                Position = searchTextBasePosition,
            }
        )

        revealTween.Completed:Connect(function(playbackState)
            if playbackState ~= Enum.PlaybackState.Completed
                or thisAnimation ~= revealAnimationId then
                return
            end

            stableSearchText.MaxVisibleGraphemes = -1
            revealSearchText.TextTransparency = 1
            revealSearchText.Position = searchTextBasePosition
        end)

        revealTween:Play()
    end

    local clearSearch = Instance.new("TextButton")
    clearSearch.Name = "ClearSearch"
    clearSearch.AnchorPoint = Vector2.new(1, 0.5)
    clearSearch.Position = UDim2.new(1, -9, 0.5, 0)
    clearSearch.Size = UDim2.new(0, 32, 0, 32)
    clearSearch.AutoButtonColor = false
    clearSearch.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    clearSearch.BackgroundTransparency = 0.72
    clearSearch.BorderSizePixel = 0
    clearSearch.FontFace = GAME_LIST_FONT
    clearSearch.Text = "×"
    clearSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearSearch.TextSize = 25
    clearSearch.Visible = false
    clearSearch.ZIndex = 4
    clearSearch.Parent = searchBar

    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(1, 0)
    clearCorner.Parent = clearSearch

    local clearScale = Instance.new("UIScale")
    clearScale.Name = "ClearSearchScale"
    clearScale.Scale = 0.72
    clearScale.Parent = clearSearch

    local clearVisibilityId = 0
    local clearVisibilityTween

    local function setClearSearchVisible(visible)
        clearVisibilityId += 1
        local thisVisibility = clearVisibilityId

        if clearVisibilityTween then
            pcall(function()
                clearVisibilityTween:Cancel()
            end)
        end

        if visible then
            clearSearch.Visible = true
            clearSearch.TextTransparency = math.max(clearSearch.TextTransparency, 0.15)

            clearVisibilityTween = TweenService:Create(
                clearScale,
                TweenInfo.new(0.17, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                { Scale = 1 }
            )
            clearVisibilityTween:Play()

            TweenService:Create(
                clearSearch,
                TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { TextTransparency = 0 }
            ):Play()
        else
            clearVisibilityTween = TweenService:Create(
                clearScale,
                TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                { Scale = 0.72 }
            )
            clearVisibilityTween:Play()

            TweenService:Create(
                clearSearch,
                TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                { TextTransparency = 1 }
            ):Play()

            task.delay(0.13, function()
                if thisVisibility == clearVisibilityId and clearSearch.Parent then
                    clearSearch.Visible = false
                end
            end)
        end
    end

    clearSearch.MouseEnter:Connect(function()
        TweenService:Create(
            clearSearch,
            TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { BackgroundTransparency = 0.48 }
        ):Play()
    end)

    clearSearch.MouseLeave:Connect(function()
        TweenService:Create(
            clearSearch,
            TweenInfo.new(0.17, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { BackgroundTransparency = 0.72 }
        ):Play()
    end)

    searchBox.Focused:Connect(function()
        TweenService:Create(
            searchBar,
            TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                BackgroundTransparency = 0.12,
                BackgroundColor3 = Color3.fromRGB(15, 79, 33),
            }
        ):Play()

        TweenService:Create(
            searchStroke,
            TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Color = Color3.fromRGB(104, 255, 88),
                Transparency = 0.12,
            }
        ):Play()
    end)

    searchBox.FocusLost:Connect(function()
        TweenService:Create(
            searchBar,
            TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                BackgroundTransparency = 0.24,
                BackgroundColor3 = Color3.fromRGB(12, 67, 28),
            }
        ):Play()

        TweenService:Create(
            searchStroke,
            TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Color = Color3.fromRGB(0, 0, 0),
                Transparency = 0.48,
            }
        ):Play()
    end)

    -- ==================== SCROLLING RESULTS ====================
    local list = Instance.new("ScrollingFrame")
    list.Name = "SupportedGamesList"
    list.Active = true
    list.Selectable = true
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.Position = UDim2.new(0, 0, 0, 58)
    list.Size = UDim2.new(1, -3, 1, -58)
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.CanvasPosition = Vector2.new(0, 0)
    list.AutomaticCanvasSize = Enum.AutomaticSize.None
    list.ScrollingDirection = Enum.ScrollingDirection.Y
    list.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    list.ScrollBarThickness = 8
    list.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    list.ScrollBarImageTransparency = 0.18
    list.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    list.ScrollingEnabled = true
    list.Parent = shell

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 2)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 11)
    padding.Parent = list

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 3)
    layout.Parent = list

    local empty = Instance.new("TextLabel")
    empty.Name = "NoSearchResults"
    empty.LayoutOrder = 1000000
    empty.Size = UDim2.new(1, -4, 0, 62)
    empty.BackgroundTransparency = 1
    empty.FontFace = GAME_LIST_FONT
    empty.Text = "No supported games found."
    empty.TextColor3 = Color3.fromRGB(255, 255, 255)
    empty.TextSize = 21
    empty.TextWrapped = true
    empty.Visible = false
    empty.Parent = list

    local emptyStroke = Instance.new("UIStroke")
    emptyStroke.Thickness = 1.5
    emptyStroke.Color = Color3.fromRGB(0, 0, 0)
    emptyStroke.Transparency = 0.18
    emptyStroke.Parent = empty

    local rows = {}

    for index, entry in ipairs(VerifiedGames) do
        local row = CreateGameElement(entry, index)
        row.Parent = list

        local rowScale = Instance.new("UIScale")
        rowScale.Name = "SearchResultScale"
        rowScale.Scale = 1
        rowScale.Parent = row

        table.insert(rows, {
            Entry = entry,
            Row = row,
            Scale = rowScale,
            Header = row:FindFirstChild("GameName"),
            Status = row:FindFirstChild("StatusSignal"),
            Divider = row:FindFirstChild("Divider"),
            SearchName = string.lower(tostring(entry.game or "")),
            IsShown = true,
            AnimationId = 0,
            Tweens = {},
        })
    end

    local function updateCanvas()
        list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 14)

        local maxY = math.max(0, list.AbsoluteCanvasSize.Y - list.AbsoluteWindowSize.Y)
        if list.CanvasPosition.Y > maxY then
            list.CanvasPosition = Vector2.new(0, maxY)
        end
    end

    local function normaliseSearch(value)
        value = string.lower(tostring(value or ""))
        value = value:gsub("^%s+", "")
        value = value:gsub("%s+$", "")
        return value
    end

    local function playRowTween(data, key, object, info, properties)
        if not object or not object.Parent then
            return
        end

        local previous = data.Tweens[key]
        if previous then
            pcall(function()
                previous:Cancel()
            end)
        end

        local tween = TweenService:Create(object, info, properties)
        data.Tweens[key] = tween
        tween:Play()
    end

    local function setResultShown(data, shown)
        if data.IsShown == shown and data.Row.Visible == shown then
            return
        end

        data.AnimationId += 1
        local thisAnimation = data.AnimationId
        data.IsShown = shown

        local fastInfo = TweenInfo.new(
            0.11,
            Enum.EasingStyle.Quad,
            shown and Enum.EasingDirection.Out or Enum.EasingDirection.In
        )

        local settleInfo = TweenInfo.new(
            0.18,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        )

        if shown then
            data.Row.Visible = true
            data.Scale.Scale = 0.965

            if data.Header then
                data.Header.TextTransparency = 1
            end

            if data.Status and (data.Status:IsA("ImageLabel") or data.Status:IsA("ImageButton")) then
                data.Status.ImageTransparency = 1
            end

            if data.Divider then
                data.Divider.BackgroundTransparency = 1
            end

            playRowTween(data, "Scale", data.Scale, settleInfo, {
                Scale = 1,
            })

            if data.Header then
                playRowTween(data, "Header", data.Header, fastInfo, {
                    TextTransparency = 0,
                })
            end

            if data.Status and (data.Status:IsA("ImageLabel") or data.Status:IsA("ImageButton")) then
                playRowTween(data, "Status", data.Status, fastInfo, {
                    ImageTransparency = 0,
                })
            end

            if data.Divider then
                playRowTween(data, "Divider", data.Divider, fastInfo, {
                    BackgroundTransparency = 0.70,
                })
            end
        else
            playRowTween(data, "Scale", data.Scale, fastInfo, {
                Scale = 0.965,
            })

            if data.Header then
                playRowTween(data, "Header", data.Header, fastInfo, {
                    TextTransparency = 1,
                })
            end

            if data.Status and (data.Status:IsA("ImageLabel") or data.Status:IsA("ImageButton")) then
                playRowTween(data, "Status", data.Status, fastInfo, {
                    ImageTransparency = 1,
                })
            end

            if data.Divider then
                playRowTween(data, "Divider", data.Divider, fastInfo, {
                    BackgroundTransparency = 1,
                })
            end

            task.delay(0.115, function()
                if data.AnimationId == thisAnimation
                    and not data.IsShown
                    and data.Row.Parent then
                    data.Row.Visible = false
                    task.defer(updateCanvas)
                end
            end)
        end
    end

    local emptyScale = Instance.new("UIScale")
    emptyScale.Name = "NoResultsScale"
    emptyScale.Scale = 0.96
    emptyScale.Parent = empty

    local emptyAnimationId = 0
    local function setEmptyVisible(visible)
        emptyAnimationId += 1
        local thisAnimation = emptyAnimationId

        if visible then
            empty.Visible = true
            empty.TextTransparency = 1
            emptyScale.Scale = 0.96

            TweenService:Create(
                empty,
                TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { TextTransparency = 0 }
            ):Play()

            TweenService:Create(
                emptyScale,
                TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                { Scale = 1 }
            ):Play()
        elseif empty.Visible then
            TweenService:Create(
                empty,
                TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                { TextTransparency = 1 }
            ):Play()

            TweenService:Create(
                emptyScale,
                TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                { Scale = 0.96 }
            ):Play()

            task.delay(0.11, function()
                if thisAnimation == emptyAnimationId and empty.Parent then
                    empty.Visible = false
                end
            end)
        end
    end

    local function applySearch()
        local query = normaliseSearch(searchBox.Text)
        local visibleCount = 0

        for _, data in ipairs(rows) do
            local matches = query == ""
                or string.find(data.SearchName, query, 1, true) ~= nil

            -- Filtering is immediate and clean. There are no row bounces or
            -- icon pulses; the only typing animation is the entered letter.
            data.IsShown = matches
            data.Row.Visible = matches
            data.Scale.Scale = 1

            if data.Header then
                data.Header.TextTransparency = 0
            end

            if data.Status
                and (data.Status:IsA("ImageLabel")
                    or data.Status:IsA("ImageButton")) then
                data.Status.ImageTransparency = 0
            end

            if data.Divider then
                data.Divider.BackgroundTransparency = 0.70
            end

            if matches then
                visibleCount += 1
            end
        end

        empty.Visible = visibleCount == 0
        empty.TextTransparency = 0
        emptyScale.Scale = 1

        local hasSearch = query ~= ""
        clearSearch.Visible = hasSearch
        clearSearch.TextTransparency = 0
        clearScale.Scale = 1

        list.CanvasPosition = Vector2.new(0, 0)
        task.defer(updateCanvas)
    end

    local previousSearchText = searchBox.Text
    setMirroredSearchText(previousSearchText, "")

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local currentText = searchBox.Text
        setMirroredSearchText(currentText, previousSearchText)
        previousSearchText = currentText
        applySearch()
    end)

    clearSearch.MouseButton1Click:Connect(function()
        searchBox.Text = ""
        searchBox:CaptureFocus()
    end)

    applySearch()
    task.defer(updateCanvas)
end

--============================================================
-- CUSTOM GAME TABS
-- ui.lua owns these tabs directly. This avoids failures caused by an
-- outdated/cached Element.Tab implementation in elements.lua.
--============================================================

local CustomTabsByName = {}
local CustomTabOpeners = {}
local FirstCustomTab = nil
local nextCustomTabOrder = 1
local GameApi

local function MakeCustomTabApi()
    local tabApi = {}

    function tabApi.Text(message)
        return AddText(message)
    end

    function tabApi.Paragraph(title, message)
        return AddParagraph(title, message)
    end

    function tabApi.Section(title)
        return AddSection(title)
    end

    function tabApi.Divider()
        return AddDivider()
    end

    function tabApi.Spacer(height)
        return AddSpacer(height)
    end

    function tabApi.Button(text, callback)
        return AddButton(text, callback)
    end

    function tabApi.Switch(name, default, callback)
        return AddToggle(name, default, callback)
    end

    function tabApi.Toggle(name, default, callback)
        return AddToggle(name, default, callback)
    end

    function tabApi.Select(name, options, default, callback)
        return AddSelect(name, options, default, callback)
    end

    tabApi.Dropdown = tabApi.Select

    function tabApi.MultiSelect(name, options, defaults, callback)
        return AddMultiSelect(name, options, defaults, callback)
    end

    tabApi.MultiChoice = tabApi.MultiSelect
    tabApi.MultiDropdown = tabApi.MultiSelect

    function tabApi.Slider(name, minimum, maximum, default, step, callback)
        return AddSlider(name, minimum, maximum, default, step, callback)
    end

    function tabApi.Input(name, placeholder, default, callback)
        return AddInput(name, placeholder, default, callback)
    end

    tabApi.Textbox = tabApi.Input

    function tabApi.Keybind(name, defaultKey, onPressed, onChanged)
        return AddKeybind(name, defaultKey, onPressed, onChanged)
    end

    function tabApi.Status(name, defaultText, defaultColor)
        return AddStatus(name, defaultText, defaultColor)
    end

    function tabApi.Tab(name, builder)
        return GameApi.Tab(name, builder)
    end

    return tabApi
end

local function AddGameCustomTab(name, builder)
    name = tostring(name or "New Tab")

    if typeof(builder) ~= "function" then
        warn("[LuisGamerCoolHub] api.Tab builder must be a function")
        return nil
    end

    if CustomTabsByName[name] then
        return CustomTabsByName[name]
    end

    local tabButton = AddTab(name)
    tabButton.Name = "GameCustomTab_" .. name
    tabButton.LayoutOrder = nextCustomTabOrder
    tabButton.Text = name
    tabButton.TextTransparency = 0
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    nextCustomTabOrder += 1

    local function openTab()
        setTabSelected(tabButton)
        Clear()
        ContentFrame.Visible = true
        TitleHolder.Text = name

        local scopedApi = MakeCustomTabApi()
        local ok, err = pcall(builder, scopedApi)

        if not ok then
            AddText("⚠️ Error opening tab: " .. name)
            warn(
                "[LuisGamerCoolHub] Custom tab '"
                    .. name
                    .. "' error: "
                    .. tostring(err)
            )
        end
    end

    tabButton.MouseButton1Click:Connect(openTab)

    CustomTabsByName[name] = tabButton
    CustomTabOpeners[tabButton] = openTab

    if not FirstCustomTab then
        FirstCustomTab = tabButton
    end

    return tabButton
end

-- Game API used by src/games/<PlaceId>.lua
GameApi = {
    Text = AddText,
    Paragraph = AddParagraph,
    Section = AddSection,
    Divider = AddDivider,
    Spacer = AddSpacer,
    Button = AddButton,
    Toggle = AddToggle,
    Switch = AddToggle,
    Select = AddSelect,
    Dropdown = AddSelect,
    MultiSelect = AddMultiSelect,
    MultiChoice = AddMultiSelect,
    MultiDropdown = AddMultiSelect,
    Slider = AddSlider,
    Input = AddInput,
    Textbox = AddInput,
    Keybind = AddKeybind,
    Status = AddStatus,
    Tab = AddGameCustomTab,
}

local function OpenFirstCustomTab()
    if not FirstCustomTab then
        return false
    end

    local opener = CustomTabOpeners[FirstCustomTab]

    if opener then
        opener()
        return true
    end

    return false
end

-- Load the current game's file only once.
local gameScriptLoaded = false

local function LoadCurrentGameScript()
    if gameScriptLoaded then
        return true
    end

    if not CurrentPlaceId or CurrentPlaceId == "0" then
        AddText("⚠️ Invalid PlaceId")
        return
    end

    local fetchOk, moduleFnOrErr = pcall(function()
        local gameFileUrl =
            REPO_RAW
            .. "games/"
            .. CurrentPlaceId
            .. ".lua?cache="
            .. tostring(os.time())

        local src = game:HttpGet(gameFileUrl)
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
        return false
    end

    gameScriptLoaded = true
    return true
end

-- ==================== TABS ====================
-- Supported game:
--     Settings only in the sidebar.
--     The supported game's content still loads automatically.
--
-- Unsupported game:
--     Home + Supported Games + Settings.
local homeTab
local supportedGamesTab

if not CurrentGameEntry then
    homeTab = AddTab("Home")
    supportedGamesTab = AddTab("Supported Games")
end

local settingsTab = AddTab("Settings")
settingsTab.LayoutOrder = 1000

local function ShowHome()
    if homeTab then
        setTabSelected(homeTab)
    end
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
    if supportedGamesTab then
        setTabSelected(supportedGamesTab)
    end
    Clear()
    ContentFrame.Visible = true

    -- Uses your original title placeholder.
    TitleHolder.Text = "Supported Games"

    -- The content area contains only the vertical scrolling list of game buttons.
    AddSupportedGamesList()
end

--============================================================
-- SETTINGS STATE + CLEAN SECTIONED SETTINGS PAGE
-- The rounded labels such as "Performance" and "PC Controls" are section
-- headers. They keep the layout organised on both desktop and mobile.
--============================================================
local HubDefaultPosition = originalPosition

-- Forward declarations used by settings callbacks. The real drag handle and
-- drag target are created in the bottom-drag section later in this file.
local DragHandle
local dragTargetPosition
local MobileOpenButton
local applyMobileOpenButton
local snapHubOnScreen

local SettingsState = {
    -- Performance
    DisableShadows = false,
    DisableRendering = false,
    LowGraphics = false,
    DisableParticles = false,
    DisablePostProcessing = false,

    -- Visuals and information
    Fullbright = false,
    RemoveFog = false,
    ShowFPS = false,
    ShowPing = false,
    ShowMemory = false,
    ShowClock = false,
    ShowPlayerCount = false,

    -- PC controls
    RightShiftToggle = false,
    KeepMouseUnlocked = false,
    HidePlayerList = false,
    HideChat = false,
    HideBackpack = false,
    HideTopBar = false,

    -- Audio
    MuteAudio = false,
    PauseAudioWithHub = false,

    -- Extra information overlay
    ShowCoordinates = false,
    ShowMovementSpeed = false,
    ShowSessionTime = false,
    ShowGameName = false,

    -- Hub and interface
    CompactHub = false,
    AutoCompactMobile = UserInputService.TouchEnabled,
    LargerHub = false,
    HideLogo = false,
    ReduceAnimations = false,
    ShowDragHandle = true,
    BlurBehindHub = false,
    DimBackground = false,
    KeepEntireHubOnScreen = UserInputService.TouchEnabled,
    EscapeClosesHub = true,
    MobileOpenButton = UserInputService.TouchEnabled,

    -- Safety and convenience
    ConfirmImportantActions = true,
}

-- Read and write engine properties safely. Some executors or game builds can
-- block particular properties, so one unsupported setting must not stop the UI.
local function safeReadProperty(instance, propertyName, fallback)
    local ok, value = pcall(function()
        return instance[propertyName]
    end)

    if ok then
        return value
    end

    return fallback
end

local function safeWriteProperty(instance, propertyName, value)
    local ok, err = pcall(function()
        instance[propertyName] = value
    end)

    if not ok then
        warn(
            "[LuisGamerCoolHub] Could not change "
                .. tostring(propertyName)
                .. ": "
                .. tostring(err)
        )
    end

    return ok
end

local OriginalLighting = {
    GlobalShadows = safeReadProperty(Lighting, "GlobalShadows", true),
    Brightness = safeReadProperty(Lighting, "Brightness", 2),
    ClockTime = safeReadProperty(Lighting, "ClockTime", 14),
    Ambient = safeReadProperty(
        Lighting,
        "Ambient",
        Color3.fromRGB(128, 128, 128)
    ),
    OutdoorAmbient = safeReadProperty(
        Lighting,
        "OutdoorAmbient",
        Color3.fromRGB(128, 128, 128)
    ),
    FogStart = safeReadProperty(Lighting, "FogStart", 0),
    FogEnd = safeReadProperty(Lighting, "FogEnd", 100000),
    FogColor = safeReadProperty(
        Lighting,
        "FogColor",
        Color3.fromRGB(192, 192, 192)
    ),
}

local OriginalSoundVolume = safeReadProperty(SoundService, "Volume", 1)
local OriginalMouseBehavior = safeReadProperty(
    UserInputService,
    "MouseBehavior",
    Enum.MouseBehavior.Default
)
local OriginalMouseIconEnabled = safeReadProperty(
    UserInputService,
    "MouseIconEnabled",
    true
)

local SavedEffectStates = setmetatable({}, { __mode = "k" })
local SavedPostEffectStates = setmetatable({}, { __mode = "k" })
local MouseUnlockConnection = nil
local StatsOverlayConnection = nil
local StatsOverlay = nil
local StatsFrames = 0
local StatsElapsed = 0
local CurrentFPS = 0
local SessionStartedAt = os.clock()

local HubSettingsScale = MainFrame:FindFirstChild("HubSettingsScale")
if not HubSettingsScale then
    HubSettingsScale = Instance.new("UIScale")
    HubSettingsScale.Name = "HubSettingsScale"
    HubSettingsScale.Scale = 1
    HubSettingsScale.Parent = MainFrame
end

-- Optional dim and blur effects shown only while the hub is open.
local HubDimOverlay = Instance.new("Frame")
HubDimOverlay.Name = "HubDimOverlay"
HubDimOverlay.Size = UDim2.fromScale(1, 1)
HubDimOverlay.Position = UDim2.fromScale(0, 0)
HubDimOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
HubDimOverlay.BackgroundTransparency = 1
HubDimOverlay.BorderSizePixel = 0
HubDimOverlay.Active = false
HubDimOverlay.Visible = false
HubDimOverlay.ZIndex = 0
HubDimOverlay.Parent = G2L["1"]

MainFrame.ZIndex = math.max(MainFrame.ZIndex, 2)

local HubBlurEffect = Instance.new("BlurEffect")
HubBlurEffect.Name = "LuisGamerCoolHubBlur"
HubBlurEffect.Size = 0
HubBlurEffect.Enabled = false
HubBlurEffect.Parent = Lighting
singletonState.BlurEffect = HubBlurEffect

local BackdropAnimationId = 0
local BackdropTween = nil
local BlurTween = nil

local function applyBackdropSettings(animate, hubVisibleOverride)
    BackdropAnimationId += 1
    local thisAnimation = BackdropAnimationId

    local hubVisible = hubVisibleOverride
    if hubVisible == nil then
        hubVisible = MainFrame.Visible
    end

    local shouldDim = SettingsState.DimBackground and hubVisible
    local shouldBlur = SettingsState.BlurBehindHub and hubVisible
    local duration = (animate == false or SettingsState.ReduceAnimations) and 0 or 0.20

    if BackdropTween then
        pcall(function() BackdropTween:Cancel() end)
    end

    if BlurTween then
        pcall(function() BlurTween:Cancel() end)
    end

    if shouldDim then
        HubDimOverlay.Visible = true
    end

    if shouldBlur then
        HubBlurEffect.Enabled = true
    end

    BackdropTween = TweenService:Create(
        HubDimOverlay,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { BackgroundTransparency = shouldDim and 0.48 or 1 }
    )
    BackdropTween:Play()

    BlurTween = TweenService:Create(
        HubBlurEffect,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = shouldBlur and 14 or 0 }
    )
    BlurTween:Play()

    task.delay(duration + 0.02, function()
        if thisAnimation ~= BackdropAnimationId then
            return
        end

        if not shouldDim and HubDimOverlay.Parent then
            HubDimOverlay.Visible = false
        end

        if not shouldBlur and HubBlurEffect.Parent then
            HubBlurEffect.Enabled = false
        end
    end)
end

local function applyAudioSettings(hubVisibleOverride)
    local hubVisible = hubVisibleOverride
    if hubVisible == nil then
        hubVisible = MainFrame.Visible
    end

    local shouldMute = SettingsState.MuteAudio
        or (SettingsState.PauseAudioWithHub and hubVisible)

    safeWriteProperty(
        SoundService,
        "Volume",
        shouldMute and 0 or OriginalSoundVolume
    )
end

local function isVisualEffect(object)
    return object:IsA("ParticleEmitter")
        or object:IsA("Trail")
        or object:IsA("Beam")
        or object:IsA("Smoke")
        or object:IsA("Fire")
        or object:IsA("Sparkles")
end

local function isPostEffect(object)
    if object == HubBlurEffect then
        return false
    end

    return object:IsA("BloomEffect")
        or object:IsA("BlurEffect")
        or object:IsA("ColorCorrectionEffect")
        or object:IsA("DepthOfFieldEffect")
        or object:IsA("SunRaysEffect")
end

local function applyEffectSettings()
    local shouldDisable = SettingsState.DisableParticles
        or SettingsState.LowGraphics

    for _, object in ipairs(game:GetDescendants()) do
        if isVisualEffect(object) then
            if SavedEffectStates[object] == nil then
                SavedEffectStates[object] = safeReadProperty(
                    object,
                    "Enabled",
                    true
                )
            end

            if shouldDisable then
                safeWriteProperty(object, "Enabled", false)
            else
                local saved = SavedEffectStates[object]
                if saved ~= nil then
                    safeWriteProperty(object, "Enabled", saved)
                end
            end
        end
    end
end

local function applyPostProcessingSettings()
    local shouldDisable = SettingsState.DisablePostProcessing
        or SettingsState.LowGraphics

    for _, object in ipairs(Lighting:GetDescendants()) do
        if isPostEffect(object) then
            if SavedPostEffectStates[object] == nil then
                SavedPostEffectStates[object] = safeReadProperty(
                    object,
                    "Enabled",
                    true
                )
            end

            if shouldDisable then
                safeWriteProperty(object, "Enabled", false)
            else
                local saved = SavedPostEffectStates[object]
                if saved ~= nil then
                    safeWriteProperty(object, "Enabled", saved)
                end
            end
        end
    end
end

local function applyLightingSettings()
    local shadowsEnabled = OriginalLighting.GlobalShadows
        and not SettingsState.DisableShadows
        and not SettingsState.LowGraphics

    safeWriteProperty(Lighting, "GlobalShadows", shadowsEnabled)

    if SettingsState.Fullbright then
        safeWriteProperty(Lighting, "Brightness", 3)
        safeWriteProperty(Lighting, "ClockTime", 14)
        safeWriteProperty(
            Lighting,
            "Ambient",
            Color3.fromRGB(190, 190, 190)
        )
        safeWriteProperty(
            Lighting,
            "OutdoorAmbient",
            Color3.fromRGB(170, 170, 170)
        )
    else
        safeWriteProperty(Lighting, "Brightness", OriginalLighting.Brightness)
        safeWriteProperty(Lighting, "ClockTime", OriginalLighting.ClockTime)
        safeWriteProperty(Lighting, "Ambient", OriginalLighting.Ambient)
        safeWriteProperty(
            Lighting,
            "OutdoorAmbient",
            OriginalLighting.OutdoorAmbient
        )
    end

    if SettingsState.RemoveFog then
        safeWriteProperty(Lighting, "FogStart", 0)
        safeWriteProperty(Lighting, "FogEnd", 1000000)
    else
        safeWriteProperty(Lighting, "FogStart", OriginalLighting.FogStart)
        safeWriteProperty(Lighting, "FogEnd", OriginalLighting.FogEnd)
        safeWriteProperty(Lighting, "FogColor", OriginalLighting.FogColor)
    end
end

local function setCoreGuiVisible(coreGuiType, visible)
    local ok, err = pcall(function()
        StarterGui:SetCoreGuiEnabled(coreGuiType, visible)
    end)

    if not ok then
        warn(
            "[LuisGamerCoolHub] CoreGui setting unavailable: "
                .. tostring(err)
        )
    end
end

local function setTopBarVisible(visible)
    local ok, err = pcall(function()
        StarterGui:SetCore("TopbarEnabled", visible)
    end)

    if not ok then
        warn(
            "[LuisGamerCoolHub] Top bar setting unavailable: "
                .. tostring(err)
        )
    end
end

local function applyPCControlSettings()
    setCoreGuiVisible(
        Enum.CoreGuiType.PlayerList,
        not SettingsState.HidePlayerList
    )
    setCoreGuiVisible(
        Enum.CoreGuiType.Chat,
        not SettingsState.HideChat
    )
    setCoreGuiVisible(
        Enum.CoreGuiType.Backpack,
        not SettingsState.HideBackpack
    )
    setTopBarVisible(not SettingsState.HideTopBar)

    if MouseUnlockConnection then
        MouseUnlockConnection:Disconnect()
        MouseUnlockConnection = nil
    end

    if SettingsState.KeepMouseUnlocked then
        MouseUnlockConnection = RunService.RenderStepped:Connect(function()
            safeWriteProperty(
                UserInputService,
                "MouseBehavior",
                Enum.MouseBehavior.Default
            )
            safeWriteProperty(UserInputService, "MouseIconEnabled", true)
        end)
    else
        safeWriteProperty(
            UserInputService,
            "MouseBehavior",
            OriginalMouseBehavior
        )
        safeWriteProperty(
            UserInputService,
            "MouseIconEnabled",
            OriginalMouseIconEnabled
        )
    end
end

local function getPingText()
    local ok, result = pcall(function()
        local network = StatsService.Network
        local serverStats = network.ServerStatsItem
        local pingItem = serverStats["Data Ping"]

        if pingItem then
            return pingItem:GetValueString()
        end

        return "--"
    end)

    if ok then
        return tostring(result)
    end

    return "--"
end

local function getMemoryText()
    local ok, value = pcall(function()
        return StatsService:GetTotalMemoryUsageMb()
    end)

    if ok and type(value) == "number" then
        return tostring(math.floor(value + 0.5)) .. " MB"
    end

    return "--"
end

local function getClockText()
    local ok, result = pcall(function()
        return os.date("%H:%M:%S")
    end)

    return ok and tostring(result) or "--:--:--"
end

local function anyStatsEnabled()
    return SettingsState.ShowFPS
        or SettingsState.ShowPing
        or SettingsState.ShowMemory
        or SettingsState.ShowClock
        or SettingsState.ShowPlayerCount
        or SettingsState.ShowCoordinates
        or SettingsState.ShowMovementSpeed
        or SettingsState.ShowSessionTime
        or SettingsState.ShowGameName
end

local function createStatsOverlay()
    if StatsOverlay and StatsOverlay.Parent then
        return
    end

    StatsOverlay = Instance.new("TextLabel")
    StatsOverlay.Name = "LuisPCStatsOverlay"
    StatsOverlay.AnchorPoint = Vector2.new(1, 0)
    StatsOverlay.Position = UDim2.new(1, -14, 0, 14)
    StatsOverlay.Size = UDim2.new(0, 230, 0, 38)
    StatsOverlay.AutomaticSize = Enum.AutomaticSize.Y
    StatsOverlay.BackgroundColor3 = Color3.fromRGB(12, 45, 19)
    StatsOverlay.BackgroundTransparency = 0.18
    StatsOverlay.BorderSizePixel = 0
    StatsOverlay.FontFace = Font.new(
        "rbxasset://fonts/families/ComicNeueAngular.json",
        Enum.FontWeight.Bold,
        Enum.FontStyle.Normal
    )
    StatsOverlay.Text = ""
    StatsOverlay.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatsOverlay.TextSize = 18
    StatsOverlay.TextWrapped = true
    StatsOverlay.TextXAlignment = Enum.TextXAlignment.Left
    StatsOverlay.TextYAlignment = Enum.TextYAlignment.Top
    StatsOverlay.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    StatsOverlay.TextStrokeTransparency = 0.35
    StatsOverlay.ZIndex = 500
    StatsOverlay.Parent = G2L["1"]

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = StatsOverlay

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = StatsOverlay

    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 2
    stroke.Transparency = 0.25
    stroke.Parent = StatsOverlay
end

local function getCharacterRoot()
    local character = LocalPlayer.Character
    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function getCoordinatesText()
    local root = getCharacterRoot()
    if not root then
        return "--, --, --"
    end

    local position = root.Position
    return string.format(
        "%.1f, %.1f, %.1f",
        position.X,
        position.Y,
        position.Z
    )
end

local function getMovementSpeedText()
    local root = getCharacterRoot()
    if not root then
        return "--"
    end

    local velocity = safeReadProperty(
        root,
        "AssemblyLinearVelocity",
        Vector3.new(0, 0, 0)
    )

    return string.format("%.1f", velocity.Magnitude)
end

local function getSessionTimeText()
    local elapsed = math.max(0, math.floor(os.clock() - SessionStartedAt))
    local hours = math.floor(elapsed / 3600)
    local minutes = math.floor((elapsed % 3600) / 60)
    local seconds = elapsed % 60

    if hours > 0 then
        return string.format("%02d:%02d:%02d", hours, minutes, seconds)
    end

    return string.format("%02d:%02d", minutes, seconds)
end

local function getDisplayGameName()
    if CurrentGameEntry and CurrentGameEntry.game then
        return tostring(CurrentGameEntry.game)
    end

    return tostring(game.Name or "Current Game")
end

local function refreshStatsOverlay()
    if not anyStatsEnabled() then
        if StatsOverlayConnection then
            StatsOverlayConnection:Disconnect()
            StatsOverlayConnection = nil
        end

        if StatsOverlay then
            StatsOverlay:Destroy()
            StatsOverlay = nil
        end

        StatsFrames = 0
        StatsElapsed = 0
        CurrentFPS = 0
        return
    end

    createStatsOverlay()

    if StatsOverlayConnection then
        return
    end

    StatsOverlayConnection = RunService.RenderStepped:Connect(function(deltaTime)
        StatsFrames += 1
        StatsElapsed += deltaTime

        if StatsElapsed < 0.5 then
            return
        end

        CurrentFPS = math.floor((StatsFrames / StatsElapsed) + 0.5)
        StatsFrames = 0
        StatsElapsed = 0

        local lines = {}

        if SettingsState.ShowFPS then
            table.insert(lines, "FPS: " .. tostring(CurrentFPS))
        end

        if SettingsState.ShowPing then
            table.insert(lines, "Ping: " .. getPingText())
        end

        if SettingsState.ShowMemory then
            table.insert(lines, "Memory: " .. getMemoryText())
        end

        if SettingsState.ShowClock then
            table.insert(lines, "Time: " .. getClockText())
        end

        if SettingsState.ShowPlayerCount then
            table.insert(
                lines,
                "Players: " .. tostring(#Players:GetPlayers())
            )
        end

        if SettingsState.ShowCoordinates then
            table.insert(lines, "Position: " .. getCoordinatesText())
        end

        if SettingsState.ShowMovementSpeed then
            table.insert(lines, "Speed: " .. getMovementSpeedText())
        end

        if SettingsState.ShowSessionTime then
            table.insert(lines, "Session: " .. getSessionTimeText())
        end

        if SettingsState.ShowGameName then
            table.insert(lines, "Game: " .. getDisplayGameName())
        end

        if StatsOverlay and StatsOverlay.Parent then
            StatsOverlay.Text = table.concat(lines, "\n")
        end
    end)
end

local function getEffectiveCompactMode()
    return SettingsState.CompactHub
        or (SettingsState.AutoCompactMobile and UserInputService.TouchEnabled)
end

local function applyHubInterfaceSettings(animate)
    ReduceUIAnimations = SettingsState.ReduceAnimations

    local scale = 1

    if getEffectiveCompactMode() then
        scale = UserInputService.TouchEnabled and 0.78 or 0.90
    end

    if SettingsState.LargerHub then
        scale *= 1.08
    end

    local targetLogoVisible = not SettingsState.HideLogo

    if getEffectiveCompactMode() and UserInputService.TouchEnabled then
        targetLogoVisible = false
    end

    Logo.Visible = targetLogoVisible

    if DragHandle then
        DragHandle.Visible = SettingsState.ShowDragHandle
    end

    if animate == false or ReduceUIAnimations then
        HubSettingsScale.Scale = scale
    else
        TweenService:Create(
            HubSettingsScale,
            TweenInfo.new(
                0.24,
                Enum.EasingStyle.Quart,
                Enum.EasingDirection.Out
            ),
            { Scale = scale }
        ):Play()
    end

    if applyMobileOpenButton then
        applyMobileOpenButton()
    end

    applyBackdropSettings(animate)
end

local function centerHub()
    local camera = workspace.CurrentCamera

    if not camera then
        return
    end

    local viewport = camera.ViewportSize
    local frameSize = MainFrame.AbsoluteSize
    local target = UDim2.fromOffset(
        math.floor((viewport.X - frameSize.X) / 2),
        math.floor((viewport.Y - frameSize.Y) / 2)
    )

    originalPosition = target

    if dragTargetPosition then
        dragTargetPosition = target
    end

    TweenService:Create(
        MainFrame,
        TweenInfo.new(
            ReduceUIAnimations and 0.08 or 0.28,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        { Position = target }
    ):Play()
end

local function copyToClipboard(value, label)
    if typeof(setclipboard) ~= "function" then
        warn(
            "[LuisGamerCoolHub] Clipboard is unavailable. "
                .. tostring(label)
                .. ": "
                .. tostring(value)
        )
        return false
    end

    local ok, err = pcall(function()
        setclipboard(tostring(value))
    end)

    if not ok then
        warn(
            "[LuisGamerCoolHub] Could not copy "
                .. tostring(label)
                .. ": "
                .. tostring(err)
        )
    end

    return ok
end

local function AddSettingsSection(parent, text)
    local section = Instance.new("TextLabel")
    section.Name = "SettingsSection"
    section.Size = UDim2.new(1, -8, 0, 37)
    section.BackgroundColor3 = Color3.fromRGB(13, 57, 24)
    section.BackgroundTransparency = 0.30
    section.BorderSizePixel = 0
    section.FontFace = Font.new(
        "rbxasset://fonts/families/ComicNeueAngular.json",
        Enum.FontWeight.Bold,
        Enum.FontStyle.Normal
    )
    section.Text = tostring(text)
    section.TextColor3 = Color3.fromRGB(255, 255, 255)
    section.TextSize = 21
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    section.TextStrokeTransparency = 0.42
    section.Parent = parent

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 13)
    padding.Parent = section

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = section

    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.42
    stroke.Parent = section

    return section
end

local function AddSettingsToggle(parent, text, default, callback)
    local switchResult = Element.Switch(parent, text, default, callback)
    return StyleSwitchElement(switchResult)
end

local function AddSettingsButton(parent, text, callback)
    local button = Element.Button(parent, text, callback)

    local instance = button
    if type(button) == "table" then
        instance = button.Instance or button.Button or button.Root
    end

    if typeof(instance) == "Instance" and instance:IsA("GuiObject") then
        instance.Size = UDim2.new(1, -8, 0, 46)
    end

    return button
end

local function getElementInstance(element)
    if typeof(element) == "Instance" then
        return element
    end

    if type(element) == "table" then
        return element.Instance
            or element.Button
            or element.Root
            or element.Frame
    end

    return nil
end

local function AddSettingsConfirmButton(parent, text, callback)
    local armed = false
    local armId = 0
    local buttonResult

    buttonResult = AddSettingsButton(parent, text, function()
        local buttonInstance = getElementInstance(buttonResult)

        if not SettingsState.ConfirmImportantActions then
            callback()
            return
        end

        if not armed then
            armed = true
            armId += 1
            local thisArm = armId

            if buttonInstance and buttonInstance:IsA("TextButton") then
                buttonInstance.Text = "Click again to confirm"
            end

            task.delay(2, function()
                if thisArm ~= armId or not armed then
                    return
                end

                armed = false

                if buttonInstance and buttonInstance.Parent then
                    buttonInstance.Text = text
                end
            end)

            return
        end

        armed = false
        armId += 1

        if buttonInstance and buttonInstance.Parent then
            buttonInstance.Text = text
        end

        callback()
    end)

    return buttonResult
end

local function restoreDefaultSettings()
    SettingsState.DisableShadows = false
    SettingsState.DisableRendering = false
    SettingsState.LowGraphics = false
    SettingsState.DisableParticles = false
    SettingsState.DisablePostProcessing = false

    SettingsState.Fullbright = false
    SettingsState.RemoveFog = false
    SettingsState.ShowFPS = false
    SettingsState.ShowPing = false
    SettingsState.ShowMemory = false
    SettingsState.ShowClock = false
    SettingsState.ShowPlayerCount = false

    SettingsState.RightShiftToggle = false
    SettingsState.KeepMouseUnlocked = false
    SettingsState.HidePlayerList = false
    SettingsState.HideChat = false
    SettingsState.HideBackpack = false
    SettingsState.HideTopBar = false

    SettingsState.MuteAudio = false
    SettingsState.PauseAudioWithHub = false

    SettingsState.ShowCoordinates = false
    SettingsState.ShowMovementSpeed = false
    SettingsState.ShowSessionTime = false
    SettingsState.ShowGameName = false

    SettingsState.CompactHub = false
    SettingsState.AutoCompactMobile = UserInputService.TouchEnabled
    SettingsState.LargerHub = false
    SettingsState.HideLogo = false
    SettingsState.ReduceAnimations = false
    SettingsState.ShowDragHandle = true
    SettingsState.BlurBehindHub = false
    SettingsState.DimBackground = false
    SettingsState.KeepEntireHubOnScreen = UserInputService.TouchEnabled
    SettingsState.EscapeClosesHub = true
    SettingsState.MobileOpenButton = UserInputService.TouchEnabled
    SettingsState.ConfirmImportantActions = true

    pcall(function()
        RunService:Set3dRenderingEnabled(true)
    end)

    applyAudioSettings()
    applyLightingSettings()
    applyEffectSettings()
    applyPostProcessingSettings()
    applyPCControlSettings()
    refreshStatsOverlay()
    applyHubInterfaceSettings(true)
    applyBackdropSettings(true)

    if applyMobileOpenButton then
        applyMobileOpenButton()
    end

    originalPosition = HubDefaultPosition

    if dragTargetPosition then
        dragTargetPosition = HubDefaultPosition
    end

    TweenService:Create(
        MainFrame,
        TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { Position = HubDefaultPosition }
    ):Play()
end

local function ShowSettings()
    setTabSelected(settingsTab)
    Clear()
    ContentFrame.Visible = true
    TitleHolder.Text = "Settings"

    local list = Instance.new("ScrollingFrame")
    list.Name = "SettingsList"
    list.Size = UDim2.new(1, -6, 1, -2)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.Active = true
    list.ScrollingDirection = Enum.ScrollingDirection.Y
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.ScrollBarThickness = 6
    list.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    list.ScrollBarImageTransparency = 0.20
    list.Parent = ContentHolder

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 3)
    padding.PaddingBottom = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 3)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = list

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 9)
    layout.Parent = list

    local function updateCanvas()
        list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 18)
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

    -- ==================== PERFORMANCE ====================
    AddSettingsSection(list, "Performance")

    AddSettingsToggle(list, "Disable Shadows", SettingsState.DisableShadows, function(enabled)
        SettingsState.DisableShadows = enabled
        applyLightingSettings()
    end)

    AddSettingsToggle(list, "Low Graphics Mode", SettingsState.LowGraphics, function(enabled)
        SettingsState.LowGraphics = enabled
        applyLightingSettings()
        applyEffectSettings()
        applyPostProcessingSettings()
    end)

    AddSettingsToggle(list, "Disable Particles", SettingsState.DisableParticles, function(enabled)
        SettingsState.DisableParticles = enabled
        applyEffectSettings()
    end)

    AddSettingsToggle(list, "Disable Post Processing", SettingsState.DisablePostProcessing, function(enabled)
        SettingsState.DisablePostProcessing = enabled
        applyPostProcessingSettings()
    end)

    AddSettingsToggle(list, "Disable 3D Rendering", SettingsState.DisableRendering, function(enabled)
        SettingsState.DisableRendering = enabled

        local ok, err = pcall(function()
            RunService:Set3dRenderingEnabled(not enabled)
        end)

        if not ok then
            SettingsState.DisableRendering = false
            warn(
                "[LuisGamerCoolHub] 3D rendering control is unavailable: "
                    .. tostring(err)
            )
        end
    end)

    -- ==================== VISUALS AND INFORMATION ====================
    AddSettingsSection(list, "Visuals & Information")

    AddSettingsToggle(list, "Fullbright", SettingsState.Fullbright, function(enabled)
        SettingsState.Fullbright = enabled
        applyLightingSettings()
    end)

    AddSettingsToggle(list, "Remove Fog", SettingsState.RemoveFog, function(enabled)
        SettingsState.RemoveFog = enabled
        applyLightingSettings()
    end)

    AddSettingsToggle(list, "Show FPS Counter", SettingsState.ShowFPS, function(enabled)
        SettingsState.ShowFPS = enabled
        refreshStatsOverlay()
    end)

    AddSettingsToggle(list, "Show Ping Counter", SettingsState.ShowPing, function(enabled)
        SettingsState.ShowPing = enabled
        refreshStatsOverlay()
    end)

    AddSettingsToggle(list, "Show Memory Usage", SettingsState.ShowMemory, function(enabled)
        SettingsState.ShowMemory = enabled
        refreshStatsOverlay()
    end)

    AddSettingsToggle(list, "Show Clock", SettingsState.ShowClock, function(enabled)
        SettingsState.ShowClock = enabled
        refreshStatsOverlay()
    end)

    AddSettingsToggle(list, "Show Player Count", SettingsState.ShowPlayerCount, function(enabled)
        SettingsState.ShowPlayerCount = enabled
        refreshStatsOverlay()
    end)

    AddSettingsToggle(list, "Show Coordinates", SettingsState.ShowCoordinates, function(enabled)
        SettingsState.ShowCoordinates = enabled
        refreshStatsOverlay()
    end)

    AddSettingsToggle(list, "Show Movement Speed", SettingsState.ShowMovementSpeed, function(enabled)
        SettingsState.ShowMovementSpeed = enabled
        refreshStatsOverlay()
    end)

    AddSettingsToggle(list, "Show Session Time", SettingsState.ShowSessionTime, function(enabled)
        SettingsState.ShowSessionTime = enabled
        refreshStatsOverlay()
    end)

    AddSettingsToggle(list, "Show Current Game", SettingsState.ShowGameName, function(enabled)
        SettingsState.ShowGameName = enabled
        refreshStatsOverlay()
    end)

    -- ==================== PC CONTROLS ====================
    AddSettingsSection(list, "PC Controls")

    AddSettingsToggle(list, "Right Shift Opens Hub", SettingsState.RightShiftToggle, function(enabled)
        SettingsState.RightShiftToggle = enabled
    end)

    AddSettingsToggle(list, "Escape Closes Hub", SettingsState.EscapeClosesHub, function(enabled)
        SettingsState.EscapeClosesHub = enabled
    end)

    AddSettingsToggle(list, "Keep Mouse Unlocked", SettingsState.KeepMouseUnlocked, function(enabled)
        SettingsState.KeepMouseUnlocked = enabled
        applyPCControlSettings()
    end)

    AddSettingsToggle(list, "Hide Player List", SettingsState.HidePlayerList, function(enabled)
        SettingsState.HidePlayerList = enabled
        applyPCControlSettings()
    end)

    AddSettingsToggle(list, "Hide Chat", SettingsState.HideChat, function(enabled)
        SettingsState.HideChat = enabled
        applyPCControlSettings()
    end)

    AddSettingsToggle(list, "Hide Backpack", SettingsState.HideBackpack, function(enabled)
        SettingsState.HideBackpack = enabled
        applyPCControlSettings()
    end)

    AddSettingsToggle(list, "Hide Roblox Top Bar", SettingsState.HideTopBar, function(enabled)
        SettingsState.HideTopBar = enabled
        applyPCControlSettings()
    end)

    -- ==================== AUDIO ====================
    AddSettingsSection(list, "Audio")

    AddSettingsToggle(list, "Mute Game Audio", SettingsState.MuteAudio, function(enabled)
        SettingsState.MuteAudio = enabled
        applyAudioSettings()
    end)

    AddSettingsToggle(list, "Pause Audio While Hub Is Open", SettingsState.PauseAudioWithHub, function(enabled)
        SettingsState.PauseAudioWithHub = enabled
        applyAudioSettings()
    end)

    -- ==================== HUB AND INTERFACE ====================
    AddSettingsSection(list, "Hub & Interface")

    AddSettingsToggle(list, "Compact Hub", SettingsState.CompactHub, function(enabled)
        SettingsState.CompactHub = enabled
        applyHubInterfaceSettings(true)
    end)

    AddSettingsToggle(list, "Auto Compact on Mobile", SettingsState.AutoCompactMobile, function(enabled)
        SettingsState.AutoCompactMobile = enabled
        applyHubInterfaceSettings(true)
    end)

    AddSettingsToggle(list, "Larger Hub Scale", SettingsState.LargerHub, function(enabled)
        SettingsState.LargerHub = enabled
        applyHubInterfaceSettings(true)
    end)

    AddSettingsToggle(list, "Hide Large Logo", SettingsState.HideLogo, function(enabled)
        SettingsState.HideLogo = enabled
        applyHubInterfaceSettings(true)
    end)

    AddSettingsToggle(list, "Reduce UI Animations", SettingsState.ReduceAnimations, function(enabled)
        SettingsState.ReduceAnimations = enabled
        applyHubInterfaceSettings(false)
    end)

    AddSettingsToggle(list, "Show Bottom Drag Handle", SettingsState.ShowDragHandle, function(enabled)
        SettingsState.ShowDragHandle = enabled
        applyHubInterfaceSettings(true)
    end)

    AddSettingsToggle(list, "Blur Behind Hub", SettingsState.BlurBehindHub, function(enabled)
        SettingsState.BlurBehindHub = enabled
        applyBackdropSettings(true)
    end)

    AddSettingsToggle(list, "Dim Background Behind Hub", SettingsState.DimBackground, function(enabled)
        SettingsState.DimBackground = enabled
        applyBackdropSettings(true)
    end)

    AddSettingsToggle(list, "Keep Entire Hub On Screen", SettingsState.KeepEntireHubOnScreen, function(enabled)
        SettingsState.KeepEntireHubOnScreen = enabled

        if enabled and snapHubOnScreen then
            snapHubOnScreen()
        end
    end)

    AddSettingsToggle(list, "Mobile Reopen Button", SettingsState.MobileOpenButton, function(enabled)
        SettingsState.MobileOpenButton = enabled

        if applyMobileOpenButton then
            applyMobileOpenButton()
        end
    end)

    AddSettingsButton(list, "Centre Hub", function()
        centerHub()
    end)

    AddSettingsButton(list, "Reset Hub Position", function()
        originalPosition = HubDefaultPosition

        if dragTargetPosition then
            dragTargetPosition = HubDefaultPosition
        end

        TweenService:Create(
            MainFrame,
            TweenInfo.new(
                ReduceUIAnimations and 0.08 or 0.32,
                Enum.EasingStyle.Quart,
                Enum.EasingDirection.Out
            ),
            { Position = HubDefaultPosition }
        ):Play()
    end)

    -- ==================== SAFETY AND CONVENIENCE ====================
    AddSettingsSection(list, "Safety & Convenience")

    AddSettingsToggle(list, "Confirm Important Actions", SettingsState.ConfirmImportantActions, function(enabled)
        SettingsState.ConfirmImportantActions = enabled
    end)

    AddSettingsConfirmButton(list, "Reset Character", function()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            safeWriteProperty(humanoid, "Health", 0)
        end
    end)

    AddSettingsButton(list, "Copy Username", function()
        copyToClipboard(LocalPlayer.Name, "Username")
    end)

    AddSettingsButton(list, "Copy User ID", function()
        copyToClipboard(LocalPlayer.UserId, "User ID")
    end)

    AddSettingsButton(list, "Copy Coordinates", function()
        copyToClipboard(getCoordinatesText(), "Coordinates")
    end)

    AddSettingsButton(list, "Copy Game Link", function()
        copyToClipboard(
            "https://www.roblox.com/games/" .. tostring(game.PlaceId),
            "Game Link"
        )
    end)

    -- ==================== SERVER AND CLIPBOARD ====================
    AddSettingsSection(list, "Server & Clipboard")

    AddSettingsConfirmButton(list, "Rejoin Current Server", function()
        local ok, err = pcall(function()
            if game.JobId and game.JobId ~= "" then
                TeleportService:TeleportToPlaceInstance(
                    game.PlaceId,
                    game.JobId,
                    LocalPlayer
                )
            else
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        end)

        if not ok then
            warn("[LuisGamerCoolHub] Rejoin failed: " .. tostring(err))
        end
    end)

    AddSettingsConfirmButton(list, "Join a New Server", function()
        local ok, err = pcall(function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)

        if not ok then
            warn(
                "[LuisGamerCoolHub] New server teleport failed: "
                    .. tostring(err)
            )
        end
    end)

    AddSettingsButton(list, "Copy Place ID", function()
        copyToClipboard(game.PlaceId, "Place ID")
    end)

    AddSettingsButton(list, "Copy Job ID", function()
        copyToClipboard(game.JobId, "Job ID")
    end)

    AddSettingsConfirmButton(list, "Restore Default Settings", function()
        restoreDefaultSettings()
        task.defer(ShowSettings)
    end)

    updateCanvas()
end

-- Automatically use the compact scale on touch devices when the default
-- Auto Compact on Mobile option is enabled. The sectioned layout stays intact.
applyHubInterfaceSettings(false)
applyBackdropSettings(false, false)
applyAudioSettings(false)

local function ShowGame()
    if not CurrentGameEntry then
        return
    end

    Clear()
    ContentFrame.Visible = true
    TitleHolder.Text = CurrentGameEntry.game

    local loaded = LoadCurrentGameScript()

    if loaded and OpenFirstCustomTab() then
        return
    end

    -- If the game file did not create any api.Tab tabs, open Settings.
    ShowSettings()
end


if homeTab then
    homeTab.MouseButton1Click:Connect(ShowHome)
end

if supportedGamesTab then
    supportedGamesTab.MouseButton1Click:Connect(ShowSupportedGames)
end

settingsTab.MouseButton1Click:Connect(ShowSettings)

-- OPEN / CLOSE
local guiVisible = false
local animating = false

--============================================================
-- CLEAN, RELIABLE SMOOTH DRAGGING
-- Dragging is intentionally available ONLY from the bottom handle.
-- The title, sidebar and content area no longer move the hub.
--============================================================
local draggingGui = false
local dragMode = nil
local dragTouchInput = nil
local dragStartPointer = Vector2.new(0, 0)
local dragStartPosition = MainFrame.Position
local dragStartAbsolute = Vector2.new(0, 0)
dragTargetPosition = MainFrame.Position
local DRAG_RESPONSE = 28

-- Allow the bottom handle to render outside the main frame.
MainFrame.ClipsDescendants = false

-- Visible handle positioned underneath the entire hub.
DragHandle = Instance.new("Frame")
DragHandle.Name = "BottomDragHandle"
DragHandle.AnchorPoint = Vector2.new(0.5, 0)
DragHandle.Position = UDim2.new(0.5, 0, 1, 8)
DragHandle.Size = UDim2.new(0, 150, 0, 24)
DragHandle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DragHandle.BackgroundTransparency = 0.88
DragHandle.BorderSizePixel = 0
DragHandle.Active = true
DragHandle.Selectable = false
DragHandle.ZIndex = 80
DragHandle.Parent = MainFrame

local dragHandleCorner = Instance.new("UICorner")
dragHandleCorner.CornerRadius = UDim.new(1, 0)
dragHandleCorner.Parent = DragHandle

local dragHandleStroke = Instance.new("UIStroke")
dragHandleStroke.Name = "HandleBorder"
dragHandleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
dragHandleStroke.Color = Color3.fromRGB(0, 0, 0)
dragHandleStroke.Thickness = 1.5
dragHandleStroke.Transparency = 0.62
dragHandleStroke.Parent = DragHandle

local dragHandleShadow = Instance.new("UIShadow")
dragHandleShadow.Color = Color3.fromRGB(0, 0, 0)
dragHandleShadow.Transparency = 0.74
dragHandleShadow.BlurRadius = UDim.new(0, 7)
dragHandleShadow.Offset = UDim2.new(0, 0, 0, 3)
dragHandleShadow.Parent = DragHandle

local DragHandleHint = Instance.new("Frame")
DragHandleHint.Name = "DragHandleHint"
DragHandleHint.AnchorPoint = Vector2.new(0.5, 0.5)
DragHandleHint.Position = UDim2.new(0.5, 0, 0.5, 0)
DragHandleHint.Size = UDim2.new(0, 76, 0, 4)
DragHandleHint.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
DragHandleHint.BackgroundTransparency = 0.24
DragHandleHint.BorderSizePixel = 0
DragHandleHint.ZIndex = 81
DragHandleHint.Parent = DragHandle

local dragHintCorner = Instance.new("UICorner")
dragHintCorner.CornerRadius = UDim.new(1, 0)
dragHintCorner.Parent = DragHandleHint

local dragHandleScale = Instance.new("UIScale")
dragHandleScale.Scale = 1
dragHandleScale.Parent = DragHandle

local function getMousePointer()
    return UserInputService:GetMouseLocation()
end

local function getTouchPointer(input)
    return Vector2.new(input.Position.X, input.Position.Y)
end

local function clampDragAbsolute(desiredAbsolute)
    local camera = workspace.CurrentCamera

    if not camera then
        return desiredAbsolute
    end

    local viewport = camera.ViewportSize
    local frameSize = MainFrame.AbsoluteSize

    local minX
    local maxX
    local minY
    local maxY

    if SettingsState.KeepEntireHubOnScreen then
        -- Leave room for the logo, close button and bottom drag handle.
        minX = 6
        maxX = math.max(minX, viewport.X - frameSize.X - 6)
        minY = 70
        maxY = math.max(minY, viewport.Y - frameSize.Y - 38)
    else
        -- Keep enough of the UI visible to grab it again, while still allowing
        -- it to reach every side of the screen.
        minX = -frameSize.X + 125
        maxX = viewport.X - 125
        minY = 58
        maxY = math.max(minY, viewport.Y - 82)
    end

    return Vector2.new(
        math.clamp(desiredAbsolute.X, minX, maxX),
        math.clamp(desiredAbsolute.Y, minY, maxY)
    )
end

snapHubOnScreen = function()
    local currentAbsolute = MainFrame.AbsolutePosition
    local clampedAbsolute = clampDragAbsolute(currentAbsolute)
    local delta = clampedAbsolute - currentAbsolute

    local target = UDim2.new(
        MainFrame.Position.X.Scale,
        MainFrame.Position.X.Offset + delta.X,
        MainFrame.Position.Y.Scale,
        MainFrame.Position.Y.Offset + delta.Y
    )

    dragTargetPosition = target
    originalPosition = target

    TweenService:Create(
        MainFrame,
        TweenInfo.new(
            SettingsState.ReduceAnimations and 0.05 or 0.22,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        { Position = target }
    ):Play()
end

local function setDragTarget(pointerPosition)
    local pointerDelta = pointerPosition - dragStartPointer
    local desiredAbsolute = clampDragAbsolute(dragStartAbsolute + pointerDelta)
    local correctedDelta = desiredAbsolute - dragStartAbsolute

    dragTargetPosition = UDim2.new(
        dragStartPosition.X.Scale,
        dragStartPosition.X.Offset + correctedDelta.X,
        dragStartPosition.Y.Scale,
        dragStartPosition.Y.Offset + correctedDelta.Y
    )
end

local function beginSmoothDrag(input)
    if animating or not guiVisible or draggingGui then
        return
    end

    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    local isTouch = input.UserInputType == Enum.UserInputType.Touch

    if not isMouse and not isTouch then
        return
    end

    draggingGui = true
    dragMode = isTouch and "Touch" or "Mouse"
    dragTouchInput = isTouch and input or nil
    dragStartPointer = isTouch and getTouchPointer(input) or getMousePointer()
    dragStartPosition = MainFrame.Position
    dragStartAbsolute = MainFrame.AbsolutePosition
    dragTargetPosition = MainFrame.Position

    TweenService:Create(
        DragHandle,
        TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            BackgroundTransparency = 0.72,
        }
    ):Play()

    TweenService:Create(
        dragHandleScale,
        TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Scale = 0.96,
        }
    ):Play()

    TweenService:Create(
        DragHandleHint,
        TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            BackgroundTransparency = 0.05,
            Size = UDim2.new(0, 104, 0, 4),
        }
    ):Play()

    TweenService:Create(
        dragHandleStroke,
        TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Transparency = 0.30,
            Color = Color3.fromRGB(24, 105, 35),
        }
    ):Play()
end

local function endSmoothDrag()
    if not draggingGui then
        return
    end

    draggingGui = false
    dragMode = nil
    dragTouchInput = nil
    originalPosition = dragTargetPosition

    TweenService:Create(
        DragHandle,
        TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            BackgroundTransparency = 0.88,
        }
    ):Play()

    TweenService:Create(
        dragHandleScale,
        TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Scale = 1,
        }
    ):Play()

    TweenService:Create(
        DragHandleHint,
        TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            BackgroundTransparency = 0.24,
            Size = UDim2.new(0, 76, 0, 4),
        }
    ):Play()

    TweenService:Create(
        dragHandleStroke,
        TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Transparency = 0.62,
            Color = Color3.fromRGB(0, 0, 0),
        }
    ):Play()
end

-- Smooth hover feedback for the bottom handle.
DragHandle.MouseEnter:Connect(function()
    if draggingGui then
        return
    end

    TweenService:Create(
        DragHandle,
        TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            BackgroundTransparency = 0.77,
        }
    ):Play()

    TweenService:Create(
        dragHandleScale,
        TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Scale = 1.06,
        }
    ):Play()

    TweenService:Create(
        DragHandleHint,
        TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            BackgroundTransparency = 0.08,
            Size = UDim2.new(0, 94, 0, 4),
        }
    ):Play()

    TweenService:Create(
        dragHandleStroke,
        TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Transparency = 0.38,
            Color = Color3.fromRGB(24, 105, 35),
        }
    ):Play()
end)

DragHandle.MouseLeave:Connect(function()
    if draggingGui then
        return
    end

    TweenService:Create(
        DragHandle,
        TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            BackgroundTransparency = 0.88,
        }
    ):Play()

    TweenService:Create(
        dragHandleScale,
        TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Scale = 1,
        }
    ):Play()

    TweenService:Create(
        DragHandleHint,
        TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            BackgroundTransparency = 0.24,
            Size = UDim2.new(0, 76, 0, 4),
        }
    ):Play()

    TweenService:Create(
        dragHandleStroke,
        TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Transparency = 0.62,
            Color = Color3.fromRGB(0, 0, 0),
        }
    ):Play()
end)

DragHandle.InputBegan:Connect(beginSmoothDrag)

UserInputService.InputChanged:Connect(function(input)
    if not draggingGui then
        return
    end

    if dragMode == "Mouse"
        and input.UserInputType == Enum.UserInputType.MouseMovement then

        setDragTarget(getMousePointer())
    elseif dragMode == "Touch"
        and input == dragTouchInput then

        setDragTarget(getTouchPointer(input))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if not draggingGui then
        return
    end

    if dragMode == "Mouse"
        and input.UserInputType == Enum.UserInputType.MouseButton1 then

        endSmoothDrag()
    elseif dragMode == "Touch"
        and input == dragTouchInput then

        endSmoothDrag()
    end
end)

RunService.RenderStepped:Connect(function(deltaTime)
    if not MainFrame.Parent or animating then
        return
    end

    local current = MainFrame.Position
    local difference =
        math.abs(current.X.Scale - dragTargetPosition.X.Scale)
        + math.abs(current.X.Offset - dragTargetPosition.X.Offset)
        + math.abs(current.Y.Scale - dragTargetPosition.Y.Scale)
        + math.abs(current.Y.Offset - dragTargetPosition.Y.Offset)

    if draggingGui or difference > 0.01 then
        local alpha = 1 - math.exp(-DRAG_RESPONSE * deltaTime)
        MainFrame.Position = current:Lerp(dragTargetPosition, alpha)
    end
end)

local connectedViewportCamera = nil
local viewportSizeConnection = nil

local function connectViewportWatcher()
    local camera = workspace.CurrentCamera

    if connectedViewportCamera == camera then
        return
    end

    connectedViewportCamera = camera

    if viewportSizeConnection then
        viewportSizeConnection:Disconnect()
        viewportSizeConnection = nil
    end

    if camera then
        viewportSizeConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            if SettingsState.KeepEntireHubOnScreen and snapHubOnScreen then
                task.defer(snapHubOnScreen)
            end
        end)
    end
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(connectViewportWatcher)
connectViewportWatcher()

local function OpenGui()
    if animating or guiVisible then return end
    animating = true
    guiVisible = true

    dragTargetPosition = originalPosition
    MainFrame.Position = originalPosition + UDim2.new(0, 0, 0, SLIDE_OFFSET)
    MainFrame.Visible = true
    Fade(1, 0)
    applyBackdropSettings(true, true)
    applyAudioSettings(true)

    if applyMobileOpenButton then
        applyMobileOpenButton()
    end

    if CurrentGameEntry then
        -- Load the supported game's content without creating a game-name tab.
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

    applyBackdropSettings(true, false)
    applyAudioSettings(false)
    SlideFade(false, 0.3)

    MainFrame.Visible = false
    MainFrame.Position = originalPosition
    dragTargetPosition = originalPosition
    guiVisible = false
    animating = false

    if applyMobileOpenButton then
        applyMobileOpenButton()
    end
end

-- A small mobile-only reopen button. It stays hidden while the hub is open.
MobileOpenButton = Instance.new("TextButton")
MobileOpenButton.Name = "MobileHubOpenButton"
MobileOpenButton.AnchorPoint = Vector2.new(0, 1)
MobileOpenButton.Position = UDim2.new(0, 14, 1, -18)
MobileOpenButton.Size = UDim2.new(0, 56, 0, 56)
MobileOpenButton.AutoButtonColor = false
MobileOpenButton.BackgroundColor3 = Color3.fromRGB(24, 126, 35)
MobileOpenButton.BackgroundTransparency = 0.10
MobileOpenButton.BorderSizePixel = 0
MobileOpenButton.FontFace = Font.new(
    "rbxasset://fonts/families/ComicNeueAngular.json",
    Enum.FontWeight.Bold,
    Enum.FontStyle.Normal
)
MobileOpenButton.Text = "L"
MobileOpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MobileOpenButton.TextSize = 30
MobileOpenButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
MobileOpenButton.TextStrokeTransparency = 0.25
MobileOpenButton.Visible = false
MobileOpenButton.ZIndex = 300
MobileOpenButton.Parent = G2L["1"]

local mobileButtonCorner = Instance.new("UICorner")
mobileButtonCorner.CornerRadius = UDim.new(1, 0)
mobileButtonCorner.Parent = MobileOpenButton

local mobileButtonStroke = Instance.new("UIStroke")
mobileButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mobileButtonStroke.Color = Color3.fromRGB(0, 0, 0)
mobileButtonStroke.Thickness = 2
mobileButtonStroke.Transparency = 0.22
mobileButtonStroke.Parent = MobileOpenButton

local mobileButtonScale = Instance.new("UIScale")
mobileButtonScale.Scale = 1
mobileButtonScale.Parent = MobileOpenButton

applyMobileOpenButton = function()
    MobileOpenButton.Visible = UserInputService.TouchEnabled
        and SettingsState.MobileOpenButton
        and not guiVisible
end

MobileOpenButton.MouseButton1Down:Connect(function()
    TweenService:Create(
        mobileButtonScale,
        TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Scale = 0.92 }
    ):Play()
end)

MobileOpenButton.MouseButton1Up:Connect(function()
    TweenService:Create(
        mobileButtonScale,
        TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Scale = 1 }
    ):Play()
end)

MobileOpenButton.MouseButton1Click:Connect(function()
    OpenGui()
end)

applyMobileOpenButton()

-- K keybind
local toggleConnection = UserInputService.InputBegan:Connect(function(input, gp)
    if SettingsState.EscapeClosesHub
        and input.KeyCode == Enum.KeyCode.Escape
        and guiVisible then
        CloseGui()
        return
    end

    if gp then
        return
    end

    if Environment[SINGLETON_KEY] ~= singletonState then
        return
    end

    if input.KeyCode == Enum.KeyCode.K
        or (SettingsState.RightShiftToggle
            and input.KeyCode == Enum.KeyCode.RightShift) then
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

    applyBackdropSettings(true, false)
    applyAudioSettings(false)
    SlideFade(false, 0.35)
    MainFrame.Visible = false
    guiVisible = false

    task.wait(0.05)
    safeWriteProperty(SoundService, "Volume", OriginalSoundVolume)
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

        pcall(function()
            SoundService.Volume = OriginalSoundVolume
        end)

        if HubBlurEffect and HubBlurEffect.Parent then
            pcall(function()
                HubBlurEffect:Destroy()
            end)
        end

        singletonState.Gui = nil
        singletonState.BlurEffect = nil
        Environment[SINGLETON_KEY] = nil
    end
end)

print("✅ LuisGamerCoolHub loaded! Posh search typing + expanded helpful settings")
return G2L["1"];
