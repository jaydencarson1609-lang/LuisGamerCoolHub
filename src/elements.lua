--[[
	element.lua — LuisGamerCoolHub UI Elements (Expanded)
	-------------------------------------------------------
	Easy reusable UI elements for your tabs.

	BASIC ELEMENTS
		Element.Text(parent, message)
		Element.Paragraph(parent, title, message)
		Element.Section(parent, title)
		Element.Divider(parent)
		Element.Spacer(parent, height)
		Element.Button(parent, text, callback)
		Element.Switch(parent, name, default, callback)
		Element.Select(parent, name, options, default, callback)
		Element.MultiSelect(parent, name, options, defaults, callback)
		Element.Slider(parent, name, minimum, maximum, default, step, callback)
		Element.Input(parent, name, placeholder, default, callback)
		Element.Keybind(parent, name, defaultKey, onPressed, onChanged)
		Element.Status(parent, name, defaultText, defaultColor)

	TAB EXAMPLE
		Element.Tab("Player", function(tab)
			tab.Section("Movement")

			local speed = tab.Slider("WalkSpeed", 16, 100, 16, 1, function(value)
				print("Speed:", value)
			end)

			tab.Select("Mode", {"Normal", "Fast", "Extreme"}, "Normal", function(value)
				print("Mode:", value)
			end)

			tab.MultiSelect("Targets", {"Players", "NPCs", "Items"}, {"Players"}, function(values)
				print("Selected:", table.concat(values, ", "))
			end)

			tab.Input("Player Name", "Type a username...", "", function(text, enterPressed)
				print(text, enterPressed)
			end)

			tab.Keybind("Open Menu", Enum.KeyCode.RightShift, function()
				print("Key pressed")
			end)

			tab.Button("Reset Speed", function()
				speed:Set(16)
			end)
		end)

	ALIASES
		tab.Label       = tab.Text
		tab.Toggle      = tab.Switch
		tab.Dropdown    = tab.Select
		tab.MultiChoice = tab.MultiSelect
		tab.Textbox     = tab.Input

	MOST ELEMENTS RETURN A CONTROLLER
		controller:Get()
		controller:Set(value)
		controller:SetVisible(true/false)
		controller:Destroy()

	Select controllers also have:
		:Open(), :Close(), :Toggle(), :Refresh(newOptions, keepValue)

	MultiSelect controllers also have:
		:Clear(), :SelectAll(), :Refresh(newOptions, keepValues)

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
local UserInputService = game:GetService("UserInputService")

local Element = {}

-- ================= THEME =================

Element.Theme = {
	Accent = Color3.fromRGB(79, 214, 69),
	AccentOff = Color3.fromRGB(254, 10, 0),
	Text = Color3.fromRGB(255, 255, 255),
	MutedText = Color3.fromRGB(190, 190, 190),
	Surface = Color3.fromRGB(36, 36, 36),
	Surface2 = Color3.fromRGB(48, 48, 48),
	Outline = Color3.fromRGB(0, 0, 0),
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

local function applyStroke(inst, thickness, transparency, color)
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = thickness or 1.5
	stroke.Color = color or Element.Theme.Outline
	stroke.Transparency = transparency or 0.5
	stroke.Parent = inst
	return stroke
end

local function playTween(inst, duration, properties, easingStyle, easingDirection)
	local tween = TweenService:Create(
		inst,
		TweenInfo.new(
			duration or 0.15,
			easingStyle or Enum.EasingStyle.Quad,
			easingDirection or Enum.EasingDirection.Out
		),
		properties
	)

	tween:Play()
	return tween
end

local function safeCallback(context, callback, ...)
	if typeof(callback) ~= "function" then
		return
	end

	local ok, err = pcall(callback, ...)

	if not ok then
		warn(
			"[LuisGamerCoolHub] "
				.. tostring(context)
				.. " callback error: "
				.. tostring(err)
		)
	end
end

local function cloneArray(values)
	local result = {}

	if typeof(values) ~= "table" then
		return result
	end

	for _, value in ipairs(values) do
		table.insert(result, value)
	end

	return result
end

local function containsValue(values, target)
	for _, value in ipairs(values) do
		if value == target then
			return true
		end
	end

	return false
end

local function valueExists(options, target)
	for _, option in ipairs(options) do
		if option == target then
			return true
		end
	end

	return false
end

local function setCommonControllerMethods(controller, instance)
	controller.Instance = instance
	controller.Object = instance

	function controller:SetVisible(visible)
		instance.Visible = visible == true
		return controller
	end

	function controller:IsVisible()
		return instance.Visible
	end

	function controller:Destroy()
		if instance and instance.Parent then
			instance:Destroy()
		end
	end
end

local function createTextLabel(parent, name, text, size, position)
	local label = Instance.new("TextLabel")
	label.Name = name or "Label"
	label.BackgroundTransparency = 1
	label.Size = size or UDim2.new(1, 0, 1, 0)
	label.Position = position or UDim2.new()
	label.FontFace = Element.Theme.Font
	label.TextColor3 = Element.Theme.Text
	label.TextScaled = true
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = tostring(text or "")
	label.Parent = parent
	return label
end

local function updateScrollingCanvas(scrollingFrame, layout, extra)
	if not scrollingFrame:IsA("ScrollingFrame") then
		return
	end

	local height = layout.AbsoluteContentSize.Y + (extra or 0)
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, height)
end

local function configureAutomaticCanvas(holder)
	if not holder:IsA("ScrollingFrame") then
		return
	end

	pcall(function()
		holder.AutomaticCanvasSize = Enum.AutomaticSize.Y
	end)
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
		playTween(
			ActiveTab,
			0.16,
			{
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(255, 255, 255),
			}
		)
	end

	ActiveTab = tabButton

	if ActiveTab and ActiveTab.Parent then
		playTween(
			ActiveTab,
			0.16,
			{
				BackgroundTransparency = 0.82,
				TextColor3 = Color3.fromRGB(0, 0, 0),
			}
		)
	end
end

local function addTabHover(tabButton)
	tabButton.MouseEnter:Connect(function()
		if ActiveTab == tabButton then
			return
		end

		playTween(tabButton, 0.14, {
			BackgroundTransparency = 0.87,
		})
	end)

	tabButton.MouseLeave:Connect(function()
		if ActiveTab == tabButton then
			return
		end

		playTween(tabButton, 0.18, {
			BackgroundTransparency = 1,
		})
	end)
end

local function makeScopedApi()
	local api = {}
	local parent = TabConfig.ContentHolder

	function api.Text(message)
		return Element.Text(parent, message)
	end

	api.Label = api.Text

	function api.Paragraph(title, message)
		return Element.Paragraph(parent, title, message)
	end

	function api.Section(title)
		return Element.Section(parent, title)
	end

	function api.Divider()
		return Element.Divider(parent)
	end

	function api.Spacer(height)
		return Element.Spacer(parent, height)
	end

	function api.Button(text, callback)
		return Element.Button(parent, text, callback)
	end

	function api.Switch(name, default, callback)
		return Element.Switch(parent, name, default, callback)
	end

	api.Toggle = api.Switch

	function api.Select(name, options, default, callback)
		return Element.Select(parent, name, options, default, callback)
	end

	api.Dropdown = api.Select

	function api.MultiSelect(name, options, defaults, callback)
		return Element.MultiSelect(parent, name, options, defaults, callback)
	end

	api.MultiChoice = api.MultiSelect
	api.MultiDropdown = api.MultiSelect

	function api.Slider(name, minimum, maximum, default, step, callback)
		return Element.Slider(
			parent,
			name,
			minimum,
			maximum,
			default,
			step,
			callback
		)
	end

	function api.Input(name, placeholder, default, callback)
		return Element.Input(parent, name, placeholder, default, callback)
	end

	api.Textbox = api.Input
	api.TextBox = api.Input

	function api.Keybind(name, defaultKey, onPressed, onChanged)
		return Element.Keybind(
			parent,
			name,
			defaultKey,
			onPressed,
			onChanged
		)
	end

	function api.Status(name, defaultText, defaultColor)
		return Element.Status(parent, name, defaultText, defaultColor)
	end

	function api.Tab(name, builder)
		return Element.Tab(name, builder)
	end

	return api
end

-- ================= TAB CONFIGURATION =================

function Element.ConfigureTabs(config)
	assert(typeof(config) == "table", "Element.ConfigureTabs expected a table")
	assert(typeof(config.TabScroll) == "Instance", "Element.ConfigureTabs is missing TabScroll")
	assert(typeof(config.TabTemplate) == "Instance", "Element.ConfigureTabs is missing TabTemplate")
	assert(typeof(config.ContentFrame) == "Instance", "Element.ConfigureTabs is missing ContentFrame")
	assert(typeof(config.TitleHolder) == "Instance", "Element.ConfigureTabs is missing TitleHolder")
	assert(typeof(config.ContentHolder) == "Instance", "Element.ConfigureTabs is missing ContentHolder")

	TabConfig = config

	configureAutomaticCanvas(config.TabScroll)
	configureAutomaticCanvas(config.ContentHolder)
end

-- ================= TEXT =================

function Element.Text(parent, message)
	assert(typeof(parent) == "Instance", "Element.Text expected a parent Instance")

	local row = createTextLabel(
		parent,
		"Text",
		message,
		UDim2.new(1, -10, 0, 40)
	)

	applyStroke(row, 1.4, 0.4)
	return row
end

-- ================= PARAGRAPH =================

function Element.Paragraph(parent, title, message)
	assert(typeof(parent) == "Instance", "Element.Paragraph expected a parent Instance")

	local row = Instance.new("Frame")
	row.Name = "Paragraph"
	row.BackgroundColor3 = Element.Theme.Surface
	row.Size = UDim2.new(1, -10, 0, 82)
	row.Parent = parent

	applyCorner(row, 10)
	applyStroke(row, 1.5, 0.45)
	applyShadow(row, 0.78, 5, 2)

	local titleLabel = createTextLabel(
		row,
		"Title",
		title or "Information",
		UDim2.new(1, -20, 0, 28),
		UDim2.new(0, 10, 0, 6)
	)
	titleLabel.TextColor3 = Element.Theme.Accent
	applyStroke(titleLabel, 1.2, 0.48)

	local bodyLabel = createTextLabel(
		row,
		"Message",
		message or "",
		UDim2.new(1, -20, 0, 38),
		UDim2.new(0, 10, 0, 36)
	)
	bodyLabel.TextColor3 = Element.Theme.MutedText
	applyStroke(bodyLabel, 1, 0.58)

	local controller = {}
	setCommonControllerMethods(controller, row)

	function controller:SetTitle(newTitle)
		titleLabel.Text = tostring(newTitle or "")
		return controller
	end

	function controller:SetText(newText)
		bodyLabel.Text = tostring(newText or "")
		return controller
	end

	function controller:Get()
		return bodyLabel.Text
	end

	return controller
end

-- ================= SECTION =================

function Element.Section(parent, title)
	assert(typeof(parent) == "Instance", "Element.Section expected a parent Instance")

	local row = Instance.new("Frame")
	row.Name = "Section"
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1, -10, 0, 32)
	row.Parent = parent

	local label = createTextLabel(
		row,
		"Title",
		title or "Section",
		UDim2.new(1, -36, 1, 0)
	)
	label.TextColor3 = Element.Theme.Accent
	applyStroke(label, 1.3, 0.42)

	local line = Instance.new("Frame")
	line.Name = "Line"
	line.AnchorPoint = Vector2.new(1, 0.5)
	line.Position = UDim2.new(1, 0, 0.5, 0)
	line.Size = UDim2.new(0, 28, 0, 2)
	line.BackgroundColor3 = Element.Theme.Accent
	line.BorderSizePixel = 0
	line.Parent = row
	applyCorner(line, 2)

	local controller = {}
	setCommonControllerMethods(controller, row)

	function controller:Set(newTitle)
		label.Text = tostring(newTitle or "")
		return controller
	end

	function controller:Get()
		return label.Text
	end

	return controller
end

-- ================= DIVIDER =================

function Element.Divider(parent)
	assert(typeof(parent) == "Instance", "Element.Divider expected a parent Instance")

	local holder = Instance.new("Frame")
	holder.Name = "Divider"
	holder.BackgroundTransparency = 1
	holder.Size = UDim2.new(1, -10, 0, 12)
	holder.Parent = parent

	local line = Instance.new("Frame")
	line.AnchorPoint = Vector2.new(0.5, 0.5)
	line.Position = UDim2.new(0.5, 0, 0.5, 0)
	line.Size = UDim2.new(1, 0, 0, 2)
	line.BackgroundColor3 = Element.Theme.Surface2
	line.BorderSizePixel = 0
	line.Parent = holder
	applyCorner(line, 2)

	return holder
end

-- ================= SPACER =================

function Element.Spacer(parent, height)
	assert(typeof(parent) == "Instance", "Element.Spacer expected a parent Instance")

	local spacer = Instance.new("Frame")
	spacer.Name = "Spacer"
	spacer.BackgroundTransparency = 1
	spacer.Size = UDim2.new(1, -10, 0, math.max(0, tonumber(height) or 8))
	spacer.Parent = parent
	return spacer
end

-- ================= BUTTON =================

function Element.Button(parent, text, callback)
	assert(typeof(parent) == "Instance", "Element.Button expected a parent Instance")

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

	local enabled = true
	local normalColor = Element.Theme.Accent
	local hoverColor = normalColor:Lerp(Color3.new(1, 1, 1), 0.15)
	local pressedColor = normalColor:Lerp(Color3.new(0, 0, 0), 0.12)
	local disabledColor = Element.Theme.Surface2

	btn.MouseEnter:Connect(function()
		if enabled then
			playTween(btn, 0.14, {BackgroundColor3 = hoverColor})
		end
	end)

	btn.MouseLeave:Connect(function()
		playTween(btn, 0.16, {
			BackgroundColor3 = enabled and normalColor or disabledColor,
		})
	end)

	btn.MouseButton1Down:Connect(function()
		if enabled then
			playTween(btn, 0.08, {BackgroundColor3 = pressedColor})
		end
	end)

	btn.MouseButton1Up:Connect(function()
		if enabled then
			playTween(btn, 0.1, {BackgroundColor3 = hoverColor})
		end
	end)

	local controller = {}
	setCommonControllerMethods(controller, btn)

	function controller:Fire()
		if enabled then
			safeCallback("Button", callback)
		end
		return controller
	end

	function controller:SetText(newText)
		btn.Text = tostring(newText or "")
		return controller
	end

	function controller:SetEnabled(value)
		enabled = value == true
		btn.Active = enabled
		btn.TextTransparency = enabled and 0 or 0.45
		playTween(btn, 0.15, {
			BackgroundColor3 = enabled and normalColor or disabledColor,
		})
		return controller
	end

	function controller:IsEnabled()
		return enabled
	end

	btn.MouseButton1Click:Connect(function()
		controller:Fire()
	end)

	return controller
end

-- ================= SWITCH =================

function Element.Switch(parent, name, default, callback)
	assert(typeof(parent) == "Instance", "Element.Switch expected a parent Instance")

	local row = Instance.new("Frame")
	row.Name = "SwitchRow"
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1, -10, 0, 46)
	row.Parent = parent

	local label = createTextLabel(
		row,
		"Name",
		name or "Switch",
		UDim2.new(0.65, 0, 1, 0)
	)
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
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
	local controller = {}
	setCommonControllerMethods(controller, row)

	local function update(animate)
		local goalColor = state and Element.Theme.Accent or Element.Theme.AccentOff
		local goalPos = state
			and UDim2.new(1, -23, 0.5, 0)
			or UDim2.new(0, 3, 0.5, 0)

		if animate then
			playTween(track, 0.15, {BackgroundColor3 = goalColor})
			playTween(knob, 0.15, {Position = goalPos})
		else
			track.BackgroundColor3 = goalColor
			knob.Position = goalPos
		end
	end

	function controller:Set(value, fireCallback)
		state = value == true
		update(true)

		if fireCallback ~= false then
			safeCallback("Switch", callback, state)
		end

		return controller
	end

	function controller:Get()
		return state
	end

	function controller:Toggle(fireCallback)
		return controller:Set(not state, fireCallback)
	end

	function controller:SetText(newText)
		label.Text = tostring(newText or "")
		return controller
	end

	update(false)

	click.MouseButton1Click:Connect(function()
		controller:Toggle(true)
	end)

	return controller
end

-- ================= SELECT / DROPDOWN =================

function Element.Select(parent, name, options, default, callback)
	assert(typeof(parent) == "Instance", "Element.Select expected a parent Instance")

	local values = cloneArray(options)
	local selected = default

	if selected == nil or not valueExists(values, selected) then
		selected = values[1]
	end

	local row = Instance.new("Frame")
	row.Name = "SelectRow"
	row.BackgroundTransparency = 1
	row.ClipsDescendants = true
	row.Size = UDim2.new(1, -10, 0, 48)
	row.Parent = parent

	local header = Instance.new("TextButton")
	header.Name = "Header"
	header.AutoButtonColor = false
	header.BackgroundColor3 = Element.Theme.Surface
	header.Size = UDim2.new(1, 0, 0, 44)
	header.Text = ""
	header.Parent = row
	applyCorner(header, 10)
	applyStroke(header, 1.5, 0.42)
	applyShadow(header, 0.78, 5, 2)

	local nameLabel = createTextLabel(
		header,
		"Name",
		name or "Select",
		UDim2.new(0.46, -10, 1, 0),
		UDim2.new(0, 10, 0, 0)
	)
	applyStroke(nameLabel, 1.2, 0.48)

	local valueLabel = createTextLabel(
		header,
		"Value",
		selected ~= nil and tostring(selected) or "None",
		UDim2.new(0.42, -10, 1, 0),
		UDim2.new(0.46, 0, 0, 0)
	)
	valueLabel.TextColor3 = Element.Theme.Accent
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	applyStroke(valueLabel, 1.2, 0.48)

	local arrow = createTextLabel(
		header,
		"Arrow",
		"▼",
		UDim2.new(0, 26, 1, 0),
		UDim2.new(1, -32, 0, 0)
	)
	arrow.TextXAlignment = Enum.TextXAlignment.Center
	applyStroke(arrow, 1.2, 0.48)

	local optionsHolder = Instance.new("ScrollingFrame")
	optionsHolder.Name = "Options"
	optionsHolder.BackgroundColor3 = Element.Theme.Surface
	optionsHolder.BorderSizePixel = 0
	optionsHolder.Position = UDim2.new(0, 0, 0, 48)
	optionsHolder.Size = UDim2.new(1, 0, 0, 0)
	optionsHolder.ScrollBarThickness = 4
	optionsHolder.ScrollBarImageColor3 = Element.Theme.Accent
	optionsHolder.CanvasSize = UDim2.new()
	optionsHolder.Visible = false
	optionsHolder.Parent = row
	applyCorner(optionsHolder, 10)
	applyStroke(optionsHolder, 1.5, 0.45)

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 5)
	padding.PaddingBottom = UDim.new(0, 5)
	padding.PaddingLeft = UDim.new(0, 5)
	padding.PaddingRight = UDim.new(0, 5)
	padding.Parent = optionsHolder

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 4)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = optionsHolder

	local open = false
	local optionButtons = {}
	local maxVisibleOptions = 5
	local controller = {}
	setCommonControllerMethods(controller, row)

	local function openHeight()
		local shown = math.min(#values, maxVisibleOptions)
		return shown > 0 and (shown * 34 + math.max(0, shown - 1) * 4 + 10) or 44
	end

	local function updateHeader()
		valueLabel.Text = selected ~= nil and tostring(selected) or "None"
	end

	local function setOpen(value, animate)
		open = value == true and #values > 0
		optionsHolder.Visible = open

		local targetOptionsHeight = open and openHeight() or 0
		local targetRowHeight = open and (52 + targetOptionsHeight) or 48
		local targetRotation = open and 180 or 0

		if animate then
			playTween(row, 0.18, {Size = UDim2.new(1, -10, 0, targetRowHeight)})
			playTween(optionsHolder, 0.18, {Size = UDim2.new(1, 0, 0, targetOptionsHeight)})
			playTween(arrow, 0.18, {Rotation = targetRotation})
		else
			row.Size = UDim2.new(1, -10, 0, targetRowHeight)
			optionsHolder.Size = UDim2.new(1, 0, 0, targetOptionsHeight)
			arrow.Rotation = targetRotation
		end
	end

	local function rebuildOptions()
		for _, button in ipairs(optionButtons) do
			button:Destroy()
		end

		table.clear(optionButtons)

		for index, option in ipairs(values) do
			local button = Instance.new("TextButton")
			button.Name = "Option_" .. tostring(index)
			button.AutoButtonColor = false
			button.BackgroundColor3 = option == selected
				and Element.Theme.Accent
				or Element.Theme.Surface2
			button.Size = UDim2.new(1, 0, 0, 34)
			button.FontFace = Element.Theme.Font
			button.TextColor3 = option == selected
				and Color3.fromRGB(0, 0, 0)
				or Element.Theme.Text
			button.TextScaled = true
			button.Text = tostring(option)
			button.LayoutOrder = index
			button.Parent = optionsHolder
			applyCorner(button, 8)
			applyStroke(button, 1, 0.55)

			button.MouseEnter:Connect(function()
				if option ~= selected then
					playTween(button, 0.12, {
						BackgroundColor3 = Element.Theme.Surface2:Lerp(Color3.new(1, 1, 1), 0.08),
					})
				end
			end)

			button.MouseLeave:Connect(function()
				if option ~= selected then
					playTween(button, 0.12, {BackgroundColor3 = Element.Theme.Surface2})
				end
			end)

			button.MouseButton1Click:Connect(function()
				controller:Set(option, true)
				controller:Close()
			end)

			table.insert(optionButtons, button)
		end

		task.defer(function()
			updateScrollingCanvas(optionsHolder, layout, 10)
		end)
	end

	function controller:Set(value, fireCallback)
		if value ~= nil and not valueExists(values, value) then
			warn("[LuisGamerCoolHub] Select value is not inside the options list: " .. tostring(value))
			return controller
		end

		selected = value
		updateHeader()
		rebuildOptions()

		if fireCallback ~= false then
			safeCallback("Select", callback, selected)
		end

		return controller
	end

	function controller:Get()
		return selected
	end

	function controller:Open()
		setOpen(true, true)
		return controller
	end

	function controller:Close()
		setOpen(false, true)
		return controller
	end

	function controller:Toggle()
		setOpen(not open, true)
		return controller
	end

	function controller:IsOpen()
		return open
	end

	function controller:SetText(newName)
		nameLabel.Text = tostring(newName or "")
		return controller
	end

	function controller:Refresh(newOptions, keepValue)
		values = cloneArray(newOptions)

		if keepValue ~= true or not valueExists(values, selected) then
			selected = values[1]
		end

		updateHeader()
		rebuildOptions()

		if open then
			setOpen(true, false)
		end

		return controller
	end

	header.MouseButton1Click:Connect(function()
		controller:Toggle()
	end)

	rebuildOptions()
	updateHeader()
	setOpen(false, false)

	return controller
end

Element.Dropdown = Element.Select

-- ================= MULTI SELECT =================

function Element.MultiSelect(parent, name, options, defaults, callback)
	assert(typeof(parent) == "Instance", "Element.MultiSelect expected a parent Instance")

	local values = cloneArray(options)
	local selectedMap = {}
	local defaultValues = cloneArray(defaults)

	for _, value in ipairs(defaultValues) do
		if valueExists(values, value) then
			selectedMap[value] = true
		end
	end

	local row = Instance.new("Frame")
	row.Name = "MultiSelectRow"
	row.BackgroundTransparency = 1
	row.ClipsDescendants = true
	row.Size = UDim2.new(1, -10, 0, 48)
	row.Parent = parent

	local header = Instance.new("TextButton")
	header.Name = "Header"
	header.AutoButtonColor = false
	header.BackgroundColor3 = Element.Theme.Surface
	header.Size = UDim2.new(1, 0, 0, 44)
	header.Text = ""
	header.Parent = row
	applyCorner(header, 10)
	applyStroke(header, 1.5, 0.42)
	applyShadow(header, 0.78, 5, 2)

	local nameLabel = createTextLabel(
		header,
		"Name",
		name or "Multi Select",
		UDim2.new(0.43, -10, 1, 0),
		UDim2.new(0, 10, 0, 0)
	)
	applyStroke(nameLabel, 1.2, 0.48)

	local valueLabel = createTextLabel(
		header,
		"Value",
		"None",
		UDim2.new(0.45, -10, 1, 0),
		UDim2.new(0.43, 0, 0, 0)
	)
	valueLabel.TextColor3 = Element.Theme.Accent
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	applyStroke(valueLabel, 1.2, 0.48)

	local arrow = createTextLabel(
		header,
		"Arrow",
		"▼",
		UDim2.new(0, 26, 1, 0),
		UDim2.new(1, -32, 0, 0)
	)
	arrow.TextXAlignment = Enum.TextXAlignment.Center
	applyStroke(arrow, 1.2, 0.48)

	local optionsHolder = Instance.new("ScrollingFrame")
	optionsHolder.Name = "Options"
	optionsHolder.BackgroundColor3 = Element.Theme.Surface
	optionsHolder.BorderSizePixel = 0
	optionsHolder.Position = UDim2.new(0, 0, 0, 48)
	optionsHolder.Size = UDim2.new(1, 0, 0, 0)
	optionsHolder.ScrollBarThickness = 4
	optionsHolder.ScrollBarImageColor3 = Element.Theme.Accent
	optionsHolder.CanvasSize = UDim2.new()
	optionsHolder.Visible = false
	optionsHolder.Parent = row
	applyCorner(optionsHolder, 10)
	applyStroke(optionsHolder, 1.5, 0.45)

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 5)
	padding.PaddingBottom = UDim.new(0, 5)
	padding.PaddingLeft = UDim.new(0, 5)
	padding.PaddingRight = UDim.new(0, 5)
	padding.Parent = optionsHolder

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 4)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = optionsHolder

	local open = false
	local optionRows = {}
	local maxVisibleOptions = 5
	local controller = {}
	setCommonControllerMethods(controller, row)

	local function getSelectedValues()
		local result = {}

		for _, option in ipairs(values) do
			if selectedMap[option] then
				table.insert(result, option)
			end
		end

		return result
	end

	local function updateHeader()
		local selectedValues = getSelectedValues()

		if #selectedValues == 0 then
			valueLabel.Text = "None"
		elseif #selectedValues == 1 then
			valueLabel.Text = tostring(selectedValues[1])
		elseif #selectedValues == 2 then
			valueLabel.Text = tostring(selectedValues[1]) .. ", " .. tostring(selectedValues[2])
		else
			valueLabel.Text = tostring(#selectedValues) .. " selected"
		end
	end

	local function openHeight()
		local shown = math.min(#values, maxVisibleOptions)
		return shown > 0 and (shown * 36 + math.max(0, shown - 1) * 4 + 10) or 44
	end

	local function setOpen(value, animate)
		open = value == true and #values > 0
		optionsHolder.Visible = open

		local targetOptionsHeight = open and openHeight() or 0
		local targetRowHeight = open and (52 + targetOptionsHeight) or 48
		local targetRotation = open and 180 or 0

		if animate then
			playTween(row, 0.18, {Size = UDim2.new(1, -10, 0, targetRowHeight)})
			playTween(optionsHolder, 0.18, {Size = UDim2.new(1, 0, 0, targetOptionsHeight)})
			playTween(arrow, 0.18, {Rotation = targetRotation})
		else
			row.Size = UDim2.new(1, -10, 0, targetRowHeight)
			optionsHolder.Size = UDim2.new(1, 0, 0, targetOptionsHeight)
			arrow.Rotation = targetRotation
		end
	end

	local function rebuildOptions()
		for _, optionRow in ipairs(optionRows) do
			optionRow:Destroy()
		end

		table.clear(optionRows)

		for index, option in ipairs(values) do
			local optionButton = Instance.new("TextButton")
			optionButton.Name = "Option_" .. tostring(index)
			optionButton.AutoButtonColor = false
			optionButton.BackgroundColor3 = Element.Theme.Surface2
			optionButton.Size = UDim2.new(1, 0, 0, 36)
			optionButton.Text = ""
			optionButton.LayoutOrder = index
			optionButton.Parent = optionsHolder
			applyCorner(optionButton, 8)
			applyStroke(optionButton, 1, 0.55)

			local check = Instance.new("Frame")
			check.Name = "Check"
			check.AnchorPoint = Vector2.new(0, 0.5)
			check.Position = UDim2.new(0, 8, 0.5, 0)
			check.Size = UDim2.new(0, 22, 0, 22)
			check.BackgroundColor3 = selectedMap[option]
				and Element.Theme.Accent
				or Element.Theme.Surface
			check.Parent = optionButton
			applyCorner(check, 6)
			applyStroke(check, 1, 0.42)

			local tick = createTextLabel(
				check,
				"Tick",
				selectedMap[option] and "✓" or "",
				UDim2.new(1, 0, 1, 0)
			)
			tick.TextColor3 = Color3.fromRGB(0, 0, 0)
			tick.TextXAlignment = Enum.TextXAlignment.Center

			local optionLabel = createTextLabel(
				optionButton,
				"OptionName",
				option,
				UDim2.new(1, -44, 1, 0),
				UDim2.new(0, 38, 0, 0)
			)
			applyStroke(optionLabel, 1.1, 0.52)

			optionButton.MouseEnter:Connect(function()
				playTween(optionButton, 0.12, {
					BackgroundColor3 = Element.Theme.Surface2:Lerp(Color3.new(1, 1, 1), 0.08),
				})
			end)

			optionButton.MouseLeave:Connect(function()
				playTween(optionButton, 0.12, {BackgroundColor3 = Element.Theme.Surface2})
			end)

			optionButton.MouseButton1Click:Connect(function()
				selectedMap[option] = not selectedMap[option]
				check.BackgroundColor3 = selectedMap[option]
					and Element.Theme.Accent
					or Element.Theme.Surface
				tick.Text = selectedMap[option] and "✓" or ""
				updateHeader()

				safeCallback(
					"MultiSelect",
					callback,
					getSelectedValues(),
					option,
					selectedMap[option] == true
				)
			end)

			table.insert(optionRows, optionButton)
		end

		task.defer(function()
			updateScrollingCanvas(optionsHolder, layout, 10)
		end)
	end

	function controller:Set(newValues, fireCallback)
		selectedMap = {}

		for _, value in ipairs(cloneArray(newValues)) do
			if valueExists(values, value) then
				selectedMap[value] = true
			end
		end

		updateHeader()
		rebuildOptions()

		if fireCallback ~= false then
			safeCallback("MultiSelect", callback, getSelectedValues())
		end

		return controller
	end

	function controller:Get()
		return getSelectedValues()
	end

	function controller:Contains(value)
		return selectedMap[value] == true
	end

	function controller:Clear(fireCallback)
		return controller:Set({}, fireCallback)
	end

	function controller:SelectAll(fireCallback)
		return controller:Set(values, fireCallback)
	end

	function controller:Open()
		setOpen(true, true)
		return controller
	end

	function controller:Close()
		setOpen(false, true)
		return controller
	end

	function controller:Toggle()
		setOpen(not open, true)
		return controller
	end

	function controller:IsOpen()
		return open
	end

	function controller:SetText(newName)
		nameLabel.Text = tostring(newName or "")
		return controller
	end

	function controller:Refresh(newOptions, keepValues)
		local oldSelected = getSelectedValues()
		values = cloneArray(newOptions)
		selectedMap = {}

		if keepValues == true then
			for _, value in ipairs(oldSelected) do
				if valueExists(values, value) then
					selectedMap[value] = true
				end
			end
		end

		updateHeader()
		rebuildOptions()

		if open then
			setOpen(true, false)
		end

		return controller
	end

	header.MouseButton1Click:Connect(function()
		controller:Toggle()
	end)

	updateHeader()
	rebuildOptions()
	setOpen(false, false)

	return controller
end

Element.MultiChoice = Element.MultiSelect
Element.MultiDropdown = Element.MultiSelect

-- ================= SLIDER =================

function Element.Slider(parent, name, minimum, maximum, default, step, callback)
	assert(typeof(parent) == "Instance", "Element.Slider expected a parent Instance")

	minimum = tonumber(minimum) or 0
	maximum = tonumber(maximum) or 100

	if minimum > maximum then
		minimum, maximum = maximum, minimum
	end

	step = math.abs(tonumber(step) or 1)
	if step == 0 then
		step = 1
	end

	local value = tonumber(default)
	if value == nil then
		value = minimum
	end

	local row = Instance.new("Frame")
	row.Name = "SliderRow"
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1, -10, 0, 66)
	row.Parent = parent

	local nameLabel = createTextLabel(
		row,
		"Name",
		name or "Slider",
		UDim2.new(0.7, 0, 0, 28)
	)
	applyStroke(nameLabel, 1.3, 0.45)

	local valueLabel = createTextLabel(
		row,
		"Value",
		"0",
		UDim2.new(0.3, 0, 0, 28),
		UDim2.new(0.7, 0, 0, 0)
	)
	valueLabel.TextColor3 = Element.Theme.Accent
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	applyStroke(valueLabel, 1.3, 0.45)

	local bar = Instance.new("Frame")
	bar.Name = "Bar"
	bar.Active = true
	bar.AnchorPoint = Vector2.new(0, 0.5)
	bar.Position = UDim2.new(0, 0, 0, 47)
	bar.Size = UDim2.new(1, 0, 0, 12)
	bar.BackgroundColor3 = Element.Theme.Surface2
	bar.Parent = row
	applyCorner(bar, 6)
	applyStroke(bar, 1, 0.52)

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Element.Theme.Accent
	fill.BorderSizePixel = 0
	fill.Parent = bar
	applyCorner(fill, 6)

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.new(0, 0, 0.5, 0)
	knob.Size = UDim2.new(0, 20, 0, 20)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.Parent = bar
	applyCorner(knob, 10)
	applyShadow(knob, 0.62, 4, 1)
	applyStroke(knob, 1, 0.45)

	local dragging = false
	local dragInput = nil
	local controller = {}
	setCommonControllerMethods(controller, row)

	local function decimalPlaces(number)
		local text = tostring(number)
		local dot = string.find(text, ".", 1, true)
		return dot and (#text - dot) or 0
	end

	local displayDecimals = math.min(decimalPlaces(step), 4)

	local function roundToStep(rawValue)
		local stepped = minimum + math.floor(((rawValue - minimum) / step) + 0.5) * step
		return math.clamp(stepped, minimum, maximum)
	end

	local function percentageForValue(current)
		if maximum == minimum then
			return 0
		end

		return math.clamp((current - minimum) / (maximum - minimum), 0, 1)
	end

	local function formatValue(current)
		if displayDecimals > 0 then
			return string.format("%." .. tostring(displayDecimals) .. "f", current)
		end

		return tostring(math.floor(current + 0.5))
	end

	local function updateVisual(animate)
		local percentage = percentageForValue(value)
		valueLabel.Text = formatValue(value)

		local fillSize = UDim2.new(percentage, 0, 1, 0)
		local knobPosition = UDim2.new(percentage, 0, 0.5, 0)

		if animate then
			playTween(fill, 0.08, {Size = fillSize})
			playTween(knob, 0.08, {Position = knobPosition})
		else
			fill.Size = fillSize
			knob.Position = knobPosition
		end
	end

	local function setFromInput(input)
		local width = bar.AbsoluteSize.X
		if width <= 0 then
			return
		end

		local percentage = math.clamp(
			(input.Position.X - bar.AbsolutePosition.X) / width,
			0,
			1
		)
		local rawValue = minimum + (maximum - minimum) * percentage
		controller:Set(rawValue, true, false)
	end

	function controller:Set(newValue, fireCallback, animate)
		local numeric = tonumber(newValue)
		if numeric == nil then
			return controller
		end

		local newRoundedValue = roundToStep(numeric)
		local changed = newRoundedValue ~= value
		value = newRoundedValue
		updateVisual(animate ~= false)

		if fireCallback ~= false and changed then
			safeCallback("Slider", callback, value)
		end

		return controller
	end

	function controller:Get()
		return value
	end

	function controller:SetRange(newMinimum, newMaximum, keepValue)
		newMinimum = tonumber(newMinimum) or minimum
		newMaximum = tonumber(newMaximum) or maximum

		if newMinimum > newMaximum then
			newMinimum, newMaximum = newMaximum, newMinimum
		end

		minimum = newMinimum
		maximum = newMaximum

		if keepValue ~= true then
			value = minimum
		end

		value = roundToStep(value)
		updateVisual(false)
		return controller
	end

	function controller:SetText(newName)
		nameLabel.Text = tostring(newName or "")
		return controller
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragInput = input
			setFromInput(input)
		end
	end)

	bar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			dragInput = input
		end
	end)

	local changedConnection = UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			setFromInput(input)
		end
	end)

	local endedConnection = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = false
			dragInput = nil
		end
	end)

	local originalDestroy = controller.Destroy
	function controller:Destroy()
		changedConnection:Disconnect()
		endedConnection:Disconnect()
		originalDestroy(controller)
	end

	value = roundToStep(value)
	updateVisual(false)

	return controller
end

-- ================= INPUT / TEXTBOX =================

function Element.Input(parent, name, placeholder, default, callback)
	assert(typeof(parent) == "Instance", "Element.Input expected a parent Instance")

	local row = Instance.new("Frame")
	row.Name = "InputRow"
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1, -10, 0, 76)
	row.Parent = parent

	local label = createTextLabel(
		row,
		"Name",
		name or "Input",
		UDim2.new(1, 0, 0, 28)
	)
	applyStroke(label, 1.3, 0.45)

	local box = Instance.new("TextBox")
	box.Name = "TextBox"
	box.BackgroundColor3 = Element.Theme.Surface
	box.Position = UDim2.new(0, 0, 0, 32)
	box.Size = UDim2.new(1, 0, 0, 40)
	box.ClearTextOnFocus = false
	box.FontFace = Element.Theme.Font
	box.PlaceholderColor3 = Element.Theme.MutedText
	box.PlaceholderText = tostring(placeholder or "Type here...")
	box.TextColor3 = Element.Theme.Text
	box.TextScaled = true
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.Text = tostring(default or "")
	box.Parent = row
	applyCorner(box, 9)
	applyStroke(box, 1.5, 0.42)
	applyShadow(box, 0.8, 4, 2)

	local boxPadding = Instance.new("UIPadding")
	boxPadding.PaddingLeft = UDim.new(0, 10)
	boxPadding.PaddingRight = UDim.new(0, 10)
	boxPadding.Parent = box

	local controller = {}
	setCommonControllerMethods(controller, row)

	function controller:Set(newText, fireCallback)
		box.Text = tostring(newText or "")

		if fireCallback == true then
			safeCallback("Input", callback, box.Text, false)
		end

		return controller
	end

	function controller:Get()
		return box.Text
	end

	function controller:Clear(fireCallback)
		return controller:Set("", fireCallback)
	end

	function controller:Focus()
		box:CaptureFocus()
		return controller
	end

	function controller:ReleaseFocus(submit)
		box:ReleaseFocus(submit == true)
		return controller
	end

	function controller:SetPlaceholder(newPlaceholder)
		box.PlaceholderText = tostring(newPlaceholder or "")
		return controller
	end

	function controller:SetText(newName)
		label.Text = tostring(newName or "")
		return controller
	end

	box.Focused:Connect(function()
		playTween(box, 0.15, {BackgroundColor3 = Element.Theme.Surface2})
	end)

	box.FocusLost:Connect(function(enterPressed)
		playTween(box, 0.15, {BackgroundColor3 = Element.Theme.Surface})
		safeCallback("Input", callback, box.Text, enterPressed == true)
	end)

	return controller
end

Element.Textbox = Element.Input
Element.TextBox = Element.Input

-- ================= KEYBIND =================

function Element.Keybind(parent, name, defaultKey, onPressed, onChanged)
	assert(typeof(parent) == "Instance", "Element.Keybind expected a parent Instance")

	local function resolveKeyCode(value)
		if typeof(value) == "EnumItem" and value.EnumType == Enum.KeyCode then
			return value
		end

		if typeof(value) == "string" then
			local ok, result = pcall(function()
				return Enum.KeyCode[value]
			end)

			if ok and result then
				return result
			end
		end

		return Enum.KeyCode.Unknown
	end

	local key = resolveKeyCode(defaultKey)
	local listening = false

	local row = Instance.new("Frame")
	row.Name = "KeybindRow"
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1, -10, 0, 46)
	row.Parent = parent

	local label = createTextLabel(
		row,
		"Name",
		name or "Keybind",
		UDim2.new(0.62, 0, 1, 0)
	)
	applyStroke(label, 1.4, 0.4)

	local button = Instance.new("TextButton")
	button.Name = "KeyButton"
	button.AnchorPoint = Vector2.new(1, 0.5)
	button.Position = UDim2.new(1, 0, 0.5, 0)
	button.Size = UDim2.new(0, 105, 0, 34)
	button.AutoButtonColor = false
	button.BackgroundColor3 = Element.Theme.Surface
	button.FontFace = Element.Theme.Font
	button.TextColor3 = Element.Theme.Accent
	button.TextScaled = true
	button.Text = key == Enum.KeyCode.Unknown and "None" or key.Name
	button.Parent = row
	applyCorner(button, 8)
	applyStroke(button, 1.5, 0.42)
	applyShadow(button, 0.8, 4, 2)

	local controller = {}
	setCommonControllerMethods(controller, row)

	local function updateButton()
		if listening then
			button.Text = "..."
			button.TextColor3 = Element.Theme.Text
			button.BackgroundColor3 = Element.Theme.Surface2
		else
			button.Text = key == Enum.KeyCode.Unknown and "None" or key.Name
			button.TextColor3 = Element.Theme.Accent
			button.BackgroundColor3 = Element.Theme.Surface
		end
	end

	function controller:Set(newKey, fireCallback)
		key = resolveKeyCode(newKey)
		listening = false
		updateButton()

		if fireCallback ~= false then
			safeCallback("Keybind changed", onChanged, key)
		end

		return controller
	end

	function controller:Get()
		return key
	end

	function controller:Listen()
		listening = true
		updateButton()
		return controller
	end

	function controller:CancelListening()
		listening = false
		updateButton()
		return controller
	end

	function controller:IsListening()
		return listening
	end

	function controller:SetText(newName)
		label.Text = tostring(newName or "")
		return controller
	end

	button.MouseButton1Click:Connect(function()
		controller:Listen()
	end)

	local inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if listening then
			if input.KeyCode == Enum.KeyCode.Escape then
				controller:CancelListening()
				return
			end

			if input.KeyCode ~= Enum.KeyCode.Unknown then
				controller:Set(input.KeyCode, true)
			end

			return
		end

		if not gameProcessed
			and key ~= Enum.KeyCode.Unknown
			and input.KeyCode == key then

			safeCallback("Keybind pressed", onPressed, key)
		end
	end)

	local originalDestroy = controller.Destroy
	function controller:Destroy()
		inputConnection:Disconnect()
		originalDestroy(controller)
	end

	updateButton()
	return controller
end

-- ================= STATUS =================

function Element.Status(parent, name, defaultText, defaultColor)
	assert(typeof(parent) == "Instance", "Element.Status expected a parent Instance")

	local row = Instance.new("Frame")
	row.Name = "StatusRow"
	row.BackgroundColor3 = Element.Theme.Surface
	row.Size = UDim2.new(1, -10, 0, 44)
	row.Parent = parent
	applyCorner(row, 10)
	applyStroke(row, 1.4, 0.48)

	local nameLabel = createTextLabel(
		row,
		"Name",
		name or "Status",
		UDim2.new(0.55, -10, 1, 0),
		UDim2.new(0, 10, 0, 0)
	)
	applyStroke(nameLabel, 1.2, 0.5)

	local statusLabel = createTextLabel(
		row,
		"Status",
		defaultText or "Ready",
		UDim2.new(0.45, -14, 1, 0),
		UDim2.new(0.55, 0, 0, 0)
	)
	statusLabel.TextColor3 = typeof(defaultColor) == "Color3"
		and defaultColor
		or Element.Theme.Accent
	statusLabel.TextXAlignment = Enum.TextXAlignment.Right
	applyStroke(statusLabel, 1.2, 0.5)

	local controller = {}
	setCommonControllerMethods(controller, row)

	function controller:Set(newText, newColor)
		statusLabel.Text = tostring(newText or "")

		if typeof(newColor) == "Color3" then
			statusLabel.TextColor3 = newColor
		end

		return controller
	end

	function controller:Get()
		return statusLabel.Text, statusLabel.TextColor3
	end

	function controller:SetColor(newColor)
		if typeof(newColor) == "Color3" then
			statusLabel.TextColor3 = newColor
		end
		return controller
	end

	function controller:SetText(newName)
		nameLabel.Text = tostring(newName or "")
		return controller
	end

	return controller
end

-- ================= CUSTOM TAB =================

function Element.Tab(name, builder)
	assert(TabConfig, "Call Element.ConfigureTabs(...) before Element.Tab(...)")

	name = tostring(name or "New Tab")

	if CreatedTabs[name] then
		warn("[LuisGamerCoolHub] A tab named '" .. name .. "' already exists.")
		return CreatedTabs[name]
	end

	assert(typeof(builder) == "function", "Element.Tab builder must be a function")

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
			Element.Text(TabConfig.ContentHolder, "⚠️ Error opening tab: " .. name)
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

function Element.SelectTab(name)
	local tab = CreatedTabs[tostring(name)]

	if not tab then
		warn("[LuisGamerCoolHub] Could not find tab: " .. tostring(name))
		return false
	end

	tab:Activate()
	return true
end

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

function Element.GetTab(name)
	return CreatedTabs[tostring(name)]
end

function Element.GetTabs()
	local result = {}

	for name, tab in pairs(CreatedTabs) do
		result[name] = tab
	end

	return result
end

return Element
