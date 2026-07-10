--[=[
LuisGamerCoolHub - Made with love
]=]

local G2L = {};

-- Your original GUI code (I kept your instances)
G2L["1"] = Instance.new("ScreenGui", game:GetService("CoreGui"));
G2L["1"]["Name"] = [[LuisGamerCoolHub]];
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;

G2L["2"] = Instance.new("Frame", G2L["1"]); -- MainFrame
G2L["2"]["BorderSizePixel"] = 0;
G2L["2"]["BackgroundColor3"] = Color3.fromRGB(52, 183, 45);
G2L["2"]["Size"] = UDim2.new(0, 677, 0, 406);
G2L["2"]["Position"] = UDim2.new(0.312, 0, 0.1696, 0);
G2L["2"]["Name"] = [[MainFrame]];

-- Remove Logo and Close Button
if G2L["3"] then G2L["3"]:Destroy() end  -- Logo
if G2L["5"] then G2L["5"]:Destroy() end  -- Close Button

G2L["2"].Visible = false; -- Start hidden

-- TabHolder and ScrollingFrame (your code)
G2L["7"] = Instance.new("Frame", G2L["2"]);
G2L["7"]["Name"] = [[TabHolder]];
G2L["7"]["BackgroundTransparency"] = 1;
G2L["7"]["Size"] = UDim2.new(0, 171, 0, 406);

G2L["9"] = Instance.new("ScrollingFrame", G2L["7"]);
G2L["9"]["Name"] = [[ScrollingFrame]];
G2L["9"]["Size"] = UDim2.new(0, 160, 0, 406);
G2L["9"]["BackgroundTransparency"] = 1;
G2L["9"]["ScrollBarThickness"] = 6;

G2L["a"] = Instance.new("UIListLayout", G2L["9"]);
G2L["a"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
G2L["a"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;

G2L["b"] = Instance.new("TextButton", G2L["9"]); -- TabButtonTemplate
G2L["b"]["Name"] = [[TabButtonTemplate]];
G2L["b"]["Size"] = UDim2.new(0, 147, 0, 44);
G2L["b"]["BackgroundTransparency"] = 1;
G2L["b"]["Text"] = [[Home]];
G2L["b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["b"]["TextScaled"] = true;

-- ContentFrame
G2L["e"] = Instance.new("Frame", G2L["2"]);
G2L["e"]["Name"] = [[ContentFrame]];
G2L["e"]["Size"] = UDim2.new(0, 517, 0, 406);
G2L["e"]["Position"] = UDim2.new(0.23634, 0, 0, 0);
G2L["e"]["BackgroundTransparency"] = 1;
G2L["e"].Visible = false;

G2L["12"] = Instance.new("Frame", G2L["e"]); -- ContentHolder
G2L["12"]["Name"] = [[ContentHolder]];
G2L["12"]["Size"] = UDim2.new(0, 477, 0, 333);
G2L["12"]["Position"] = UDim2.new(0.07544, 0, 0.1798, 0);
G2L["12"]["BackgroundTransparency"] = 1;

local UIList = Instance.new("UIListLayout", G2L["12"]);
UIList.SortOrder = Enum.SortOrder.LayoutOrder;
UIList.Padding = UDim.new(0, 5);

-- ====================== ELEMENTS SYSTEM ======================
local Elements = {}

function Elements:AddTab(name)
	local tab = G2L["b"]:Clone()
	tab.Text = name
	tab.Name = name.."Tab"
	tab.Parent = G2L["9"]
	return tab
end

function Elements:AddButton(parent, text, callback)
	local holder = G2L["1c"]:Clone() -- ButtonPlaceHolder
	holder.TextButton.Text = text
	holder.Parent = parent
	
	holder.TextButton.MouseButton1Click:Connect(callback)
	return holder
end

function Elements:AddToggle(parent, text, default, callback)
	local holder = G2L["14"]:Clone() -- SwitchButtonPlaceHolder
	holder.Name = text
	holder.Parent = parent
	
	holder.Name.Text = text
	
	local toggleBtn = holder["On/OffButton"]
	local state = default or false
	
	local function update()
		if state then
			toggleBtn.Text = "ON"
			toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
		else
			toggleBtn.Text = "OFF"
			toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
		end
	end
	
	update()
	
	toggleBtn.MouseButton1Click:Connect(function()
		state = not state
		update()
		if callback then callback(state) end
	end)
	
	return holder
end

function Elements:AddLabel(parent, text)
	local holder = G2L["19"]:Clone() -- TextPlaceHolder
	holder.Text.Text = text
	holder.Parent = parent
	return holder
end

-- ====================== TABS ======================
local HomeTabBtn   = Elements:AddTab("Home")
local GamesTabBtn  = Elements:AddTab("Games")
local SettingsTabBtn = Elements:AddTab("Settings")

local CurrentContent = nil

local function ShowContent()
	G2L["e"].Visible = true
end

HomeTabBtn.MouseButton1Click:Connect(function()
	ShowContent()
	-- Clear old content
	for _, v in pairs(G2L["12"]:GetChildren()) do
		if v:IsA("Frame") and v.Name ~= "UIListLayout" then
			v:Destroy()
		end
	end
	
	Elements:AddLabel(G2L["12"], "Welcome to LuisGamerCoolHub!")
	Elements:AddButton(G2L["12"], "Test Button", function()
		print("Button Clicked!")
	end)
	Elements:AddToggle(G2L["12"], "Auto Farm", false, function(state)
		print("Auto Farm:", state)
	end)
end)

GamesTabBtn.MouseButton1Click:Connect(function()
	ShowContent()
	for _, v in pairs(G2L["12"]:GetChildren()) do
		if v:IsA("Frame") and v.Name ~= "UIListLayout" then v:Destroy() end
	end
	
	Elements:AddLabel(G2L["12"], "Games List Coming Soon...")
	Elements:AddButton(G2L["12"], "Launch Game", function()
		print("Launch game clicked")
	end)
end)

SettingsTabBtn.MouseButton1Click:Connect(function()
	ShowContent()
	for _, v in pairs(G2L["12"]:GetChildren()) do
		if v:IsA("Frame") and v.Name ~= "UIListLayout" then v:Destroy() end
	end
	
	Elements:AddLabel(G2L["12"], "Settings")
	Elements:AddToggle(G2L["12"], "Disable 3D", false, function(s) print("3D:", s) end)
end)

-- ====================== KEYBIND (K) ======================
local UserInputService = game:GetService("UserInputService")
local MainFrame = G2L["2"]

local visible = false

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.K then
		visible = not visible
		MainFrame.Visible = visible
		if visible then
			HomeTabBtn:Click() -- Auto open Home tab
		end
	end
end)

print("LuisGamerCoolHub Loaded! Press K to open.")
