--[[
	element.lua — LuisGamerCoolHub UI Elements
	----------------------------------------------
	This module gives you easy functions for building tab content:

		Element.Text(parent, message)
		Element.Button(parent, text, callback)
		Element.Switch(parent, name, default, callback)

	It also supports creating your own tabs:

		Element.ConfigureTabs({...})
		Element.Tab("Tab Name", function(tab)
			tab.Text("Hello!")
			tab.Button("Click Me", function()
				print("Clicked")
			end)
			tab.Switch("Auto Farm", false, function(state)
				print(state)
			end)
		end)

	HOW TO LOAD IT
	--------------
	Studio ModuleScript:
		local Element = require(path.to.element)

	Hub style:
		local Element = loadstring(game:HttpGet(
			"https://raw.githubusercontent.com/jaydencarson1609-lang/LuisGamerCoolHub/main/src/element.lua"
		))()
]]

local TweenService = game:GetService("TweenService")

local Element = {}

-- ================= THEME =================

Element.Theme = {
	Accent = Color3.fromRGB(79, 214, 69),
	AccentOff = Color3.fromRGB(254, 10, 0),
	Text = Color3.fromRGB(255, 255, 255),
	Font = Font.new(
		"rbxasset://fonts/families/ComicNeueAngular.json",
		Enum.FontWeight.Regular,
		Enum.FontStyle.Normal
	),
}

-- ================= INTERNAL TAB DATA =================

local TabConfig = nil
local CreatedTabs = {}
local ActiveTab = nil

-- ================= HELPERS =================

local function applyCorner(inst, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = inst
	return corner
end

local function applyShadow(inst, transparency, blur, offsetY)
	local shadow = Instance.new("UIShadow")
	shadow.Color = Color3.fromRGB(0, 0, 0)
	shadow.Transparency = transparency or 0.7
	shadow.BlurRadius = UDim.new(0, blur or 6)
	shadow.Offset = UDim2.new(0, 0, 0, offsetY or 2)
	shadow.Parent = inst
	return shadow
end

local function applyStroke(inst, thickness, transparency)
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = thickness or 1.5
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Transparency = transparency or 0.5
	stroke.Parent = inst
	return stroke
end

local function clearContent()
	if not TabConfig or not TabConfig.ContentHolder then
		return
	end

	if typeof(TabConfig.Clear) == "function" then
		TabConfig.Clear()
		return
	end

	for _, child in ipairs(TabConfig.ContentHolder:GetChildren()) do
		if not child:IsA("UIListLayout")
			and not child:IsA("UIPadding") then

			child:Destroy()
		end
	end
end

local function setTabSelected(tabButton)
	if ActiveTab and ActiveTab.Parent then
		TweenService:Create(
			ActiveTab,
			TweenInfo.new(
				0.16,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			{
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(255, 255, 255),
			}
		):Play()
	end

	ActiveTab = tabButton

	if ActiveTab and ActiveTab.Parent then
		TweenService:Create(
			ActiveTab,
			TweenInfo.new(
				0.16,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			{
				BackgroundTransparency = 0.82,
				TextColor3 = Color3.fromRGB(0, 0, 0),
			}
		):Play()
	end
end

local function addTabHover(tabButton)
	tabButton.MouseEnter:Connect(function()
		if ActiveTab == tabButton then
			return
		end

		TweenService:Create(
			tabButton,
			TweenInfo.new(
				0.14,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			{
				BackgroundTransparency = 0.87,
			}
		):Play()
	end)

	tabButton.MouseLeave:Connect(function()
		if ActiveTab == tabButton then
			return
		end

		TweenService:Create(
			tabButton,
			TweenInfo.new(
				0.18,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			{
				BackgroundTransparency = 1,
			}
		):Play()
	end)
end

local function makeScopedApi()
	local api = {}

	function api.Text(message)
		return Element.Text(
			TabConfig.ContentHolder,
			message
		)
	end

	function api.Button(text, callback)
		return Element.Button(
			TabConfig.ContentHolder,
			text,
			callback
		)
	end

	function api.Switch(name, default, callback)
		return Element.Switch(
			TabConfig.ContentHolder,
			name,
			default,
			callback
		)
	end

	function api.Tab(name, builder)
		return Element.Tab(name, builder)
	end

	return api
end

-- ================= TAB CONFIGURATION =================

-- Call this once from your main UI script after loading Element.
--
-- Element.ConfigureTabs({
--     TabScroll = TabScroll,
--     TabTemplate = TabTemplate,
--     ContentFrame = ContentFrame,
--     TitleHolder = TitleHolder,
--     ContentHolder = ContentHolder,
--     Clear = Clear,
-- })
function Element.ConfigureTabs(config)
	assert(
		typeof(config) == "table",
		"Element.ConfigureTabs expected a table"
	)

	assert(
		typeof(config.TabScroll) == "Instance",
		"Element.ConfigureTabs is missing TabScroll"
	)

	assert(
		typeof(config.TabTemplate) == "Instance",
		"Element.ConfigureTabs is missing TabTemplate"
	)

	assert(
		typeof(config.ContentFrame) == "Instance",
		"Element.ConfigureTabs is missing ContentFrame"
	)

	assert(
		typeof(config.TitleHolder) == "Instance",
		"Element.ConfigureTabs is missing TitleHolder"
	)

	assert(
		typeof(config.ContentHolder) == "Instance",
		"Element.ConfigureTabs is missing ContentHolder"
	)

	TabConfig = config
end

-- ================= TEXT =================

function Element.Text(parent, message)
	assert(
		typeof(parent) == "Instance",
		"Element.Text expected a parent Instance"
	)

	local row = Instance.new("TextLabel")
	row.Name = "Text"
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1, -10, 0, 40)
	row.FontFace = Element.Theme.Font
	row.TextColor3 = Element.Theme.Text
	row.TextScaled = true
	row.TextXAlignment = Enum.TextXAlignment.Left
	row.TextWrapped = true
	row.Text = tostring(message or "")
	row.Parent = parent

	applyStroke(row, 1.4, 0.4)

	return row
end

-- ================= BUTTON =================

function Element.Button(parent, text, callback)
	assert(
		typeof(parent) == "Instance",
		"Element.Button expected a parent Instance"
	)

	local btn = Instance.new("TextButton")
	btn.Name = "Button"
	btn.AutoButtonColor = false
	btn.BackgroundColor3 = Element.Theme.Accent
	btn.Size = UDim2.new(1, -10, 0, 48)
	btn.FontFace = Element.Theme.Font
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.TextScaled = true
	btn.Text = tostring(text or "Button")
	btn.Parent = parent

	applyCorner(btn, 10)
	applyShadow(btn, 0.7, 6, 3)
	applyStroke(btn, 2, 0.4)

	local normalColor = Element.Theme.Accent
	local hoverColor = normalColor:Lerp(
		Color3.new(1, 1, 1),
		0.15
	)
	local pressedColor = normalColor:Lerp(
		Color3.new(0, 0, 0),
		0.12
	)

	btn.MouseEnter:Connect(function()
		TweenService:Create(
			btn,
			TweenInfo.new(0.14),
			{
				BackgroundColor3 = hoverColor,
			}
		):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(
			btn,
			TweenInfo.new(0.16),
			{
				BackgroundColor3 = normalColor,
			}
		):Play()
	end)

	btn.MouseButton1Down:Connect(function()
		TweenService:Create(
			btn,
			TweenInfo.new(0.08),
			{
				BackgroundColor3 = pressedColor,
			}
		):Play()
	end)

	btn.MouseButton1Up:Connect(function()
		TweenService:Create(
			btn,
			TweenInfo.new(0.1),
			{
				BackgroundColor3 = hoverColor,
			}
		):Play()
	end)

	if callback then
		btn.MouseButton1Click:Connect(function()
			local ok, err = pcall(callback)

			if not ok then
				warn(
					"[LuisGamerCoolHub] Button callback error: "
						.. tostring(err)
				)
			end
		end)
	end

	return btn
end

-- ================= SWITCH =================

function Element.Switch(parent, name, default, callback)
	assert(
		typeof(parent) == "Instance",
		"Element.Switch expected a parent Instance"
	)

	local row = Instance.new("Frame")
	row.Name = "SwitchRow"
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1, -10, 0, 46)
	row.Parent = parent

	local label = Instance.new("TextLabel")
	label.Name = "Name"
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(0.65, 0, 1, 0)
	label.FontFace = Element.Theme.Font
	label.TextColor3 = Element.Theme.Text
	label.TextScaled = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = tostring(name or "Switch")
	label.Parent = row

	applyStroke(label, 1.4, 0.4)

	local track = Instance.new("Frame")
	track.Name = "Track"
	track.AnchorPoint = Vector2.new(1, 0.5)
	track.Position = UDim2.new(1, 0, 0.5, 0)
	track.Size = UDim2.new(0, 60, 0, 26)
	track.BackgroundColor3 = Element.Theme.AccentOff
	track.Parent = row

	applyCorner(track, 13)

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.AnchorPoint = Vector2.new(0, 0.5)
	knob.Position = UDim2.new(0, 3, 0.5, 0)
	knob.Size = UDim2.new(0, 20, 0, 20)
	knob.BackgroundColor3 = Color3.fromRGB(
		255,
		255,
		255
	)
	knob.Parent = track

	applyCorner(knob, 10)
	applyShadow(knob, 0.6, 3, 1)

	local click = Instance.new("TextButton")
	click.Name = "ClickArea"
	click.BackgroundTransparency = 1
	click.Text = ""
	click.Size = UDim2.new(1, 0, 1, 0)
	click.Parent = track

	local state = default == true

	local function update(animate)
		local goalColor = state
			and Element.Theme.Accent
			or Element.Theme.AccentOff

		local goalPos = state
			and UDim2.new(1, -23, 0.5, 0)
			or UDim2.new(0, 3, 0.5, 0)

		if animate then
			TweenService:Create(
				track,
				TweenInfo.new(
					0.15,
					Enum.EasingStyle.Quad,
					Enum.EasingDirection.Out
				),
				{
					BackgroundColor3 = goalColor,
				}
			):Play()

			TweenService:Create(
				knob,
				TweenInfo.new(
					0.15,
					Enum.EasingStyle.Quad,
					Enum.EasingDirection.Out
				),
				{
					Position = goalPos,
				}
			):Play()
		else
			track.BackgroundColor3 = goalColor
			knob.Position = goalPos
		end
	end

	update(false)

	click.MouseButton1Click:Connect(function()
		state = not state
		update(true)

		if callback then
			local ok, err = pcall(callback, state)

			if not ok then
				warn(
					"[LuisGamerCoolHub] Switch callback error: "
						.. tostring(err)
				)
			end
		end
	end)

	return row
end

-- ================= CUSTOM TAB =================

-- Creates a new tab using your existing TabTemplate.
--
-- Example:
--
-- Element.Tab("Player", function(tab)
--     tab.Text("Player options")
--
--     tab.Switch("Infinite Jump", false, function(state)
--         print("Infinite Jump:", state)
--     end)
-- end)
function Element.Tab(name, builder)
	assert(
		TabConfig,
		"Call Element.ConfigureTabs(...) before Element.Tab(...)"
	)

	name = tostring(name or "New Tab")

	if CreatedTabs[name] then
		warn(
			"[LuisGamerCoolHub] A tab named '"
				.. name
				.. "' already exists."
		)

		return CreatedTabs[name]
	end

	assert(
		typeof(builder) == "function",
		"Element.Tab builder must be a function"
	)

	local tabButton = TabConfig.TabTemplate:Clone()
	tabButton.Name = "CustomTab_" .. name
	tabButton.Text = name
	tabButton.Visible = true
	tabButton.Parent = TabConfig.TabScroll

	addTabHover(tabButton)

	tabButton.MouseButton1Click:Connect(function()
		clearContent()

		TabConfig.ContentFrame.Visible = true
		TabConfig.TitleHolder.Text = name

		setTabSelected(tabButton)

		local api = makeScopedApi()

		local ok, err = pcall(builder, api)

		if not ok then
			Element.Text(
				TabConfig.ContentHolder,
				"⚠️ Error opening tab: " .. name
			)

			warn(
				"[LuisGamerCoolHub] Tab '"
					.. name
					.. "' error: "
					.. tostring(err)
			)
		end
	end)

	CreatedTabs[name] = tabButton

	return tabButton
end

-- Opens a tab by its name.
function Element.SelectTab(name)
	local tab = CreatedTabs[tostring(name)]

	if not tab then
		warn(
			"[LuisGamerCoolHub] Could not find tab: "
				.. tostring(name)
		)

		return false
	end

	tab:Activate()

	return true
end

-- Removes a custom tab.
function Element.RemoveTab(name)
	name = tostring(name)

	local tab = CreatedTabs[name]

	if not tab then
		return false
	end

	if ActiveTab == tab then
		ActiveTab = nil
	end

	tab:Destroy()
	CreatedTabs[name] = nil

	return true
end

return Element
