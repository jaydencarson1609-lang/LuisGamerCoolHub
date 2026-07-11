--[[
	element.lua — LuisGamerCoolHub UI Elements
	----------------------------------------------
	Drop this next to ui.lua. It gives you three easy functions to
	build content for a tab: Element.Text, Element.Button, Element.Switch.
	Each one just needs a parent (your ContentHolder) and returns the
	row it created, so you can style/position further if you want.

	HOW TO LOAD IT
	--------------
	Option A — Studio ModuleScript:
		local Element = require(path.to.element)

	Option B — hub style (loadstring from your raw GitHub file):
		local Element = loadstring(game:HttpGet(
			"https://raw.githubusercontent.com/jaydencarson1609-lang/LuisGamerCoolHub/main/src/element.lua"
		))()

	EXAMPLE
	-------
	Element.Text(ContentHolder, "Welcome to the hub!")
	Element.Button(ContentHolder, "Click Me", function()
		print("Button pressed!")
	end)
	Element.Switch(ContentHolder, "Auto Farm", false, function(state)
		print("Auto Farm:", state)
	end)
]]

local TweenService = game:GetService("TweenService")

local Element = {}

-- ================= THEME =================
-- Change these once and every element updates.
Element.Theme = {
	Accent    = Color3.fromRGB(79, 214, 69),   -- hub green (matches your MainFrame)
	AccentOff = Color3.fromRGB(254, 10, 0),    -- matches your CloseButton red
	Text      = Color3.fromRGB(255, 255, 255),
	Font      = Font.new("rbxasset://fonts/families/ComicNeueAngular.json"),
}

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

-- ================= TEXT =================
-- A single readable line, left aligned, with a soft outline so it
-- stays legible over the green background.
function Element.Text(parent, message)
	local row = Instance.new("TextLabel")
	row.Name = "Text"
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1, -10, 0, 40)
	row.FontFace = Element.Theme.Font
	row.TextColor3 = Element.Theme.Text
	row.TextScaled = true
	row.TextXAlignment = Enum.TextXAlignment.Left
	row.TextWrapped = true
	row.Text = message
	row.Parent = parent

	applyStroke(row, 1.4, 0.4)

	return row
end

-- ================= BUTTON =================
-- Rounded, shadowed, hover-highlighted button.
function Element.Button(parent, text, callback)
	local btn = Instance.new("TextButton")
	btn.Name = "Button"
	btn.AutoButtonColor = false
	btn.BackgroundColor3 = Element.Theme.Accent
	btn.Size = UDim2.new(1, -10, 0, 48)
	btn.FontFace = Element.Theme.Font
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.TextScaled = true
	btn.Text = text
	btn.Parent = parent

	applyCorner(btn, 10)
	applyShadow(btn, 0.7, 6, 3)
	applyStroke(btn, 2, 0.4)

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Element.Theme.Accent:Lerp(Color3.new(1, 1, 1), 0.15)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Element.Theme.Accent
	end)

	if callback then
		btn.MouseButton1Click:Connect(function()
			callback()
		end)
	end

	return btn
end

-- ================= SWITCH =================
-- Animated pill toggle: red/off -> green/on, knob slides across.
function Element.Switch(parent, name, default, callback)
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
	label.Text = name
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
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.Parent = track
	applyCorner(knob, 10)
	applyShadow(knob, 0.6, 3, 1)

	local click = Instance.new("TextButton")
	click.BackgroundTransparency = 1
	click.Text = ""
	click.Size = UDim2.new(1, 0, 1, 0)
	click.Parent = track

	local state = default or false

	local function update(animate)
		local goalColor = state and Element.Theme.Accent or Element.Theme.AccentOff
		local goalPos = state and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)

		if animate then
			TweenService:Create(track, TweenInfo.new(0.15), { BackgroundColor3 = goalColor }):Play()
			TweenService:Create(knob, TweenInfo.new(0.15), { Position = goalPos }):Play()
		else
			track.BackgroundColor3 = goalColor
			knob.Position = goalPos
		end
	end
	update(false)

	click.MouseButton1Click:Connect(function()
		state = not state
		update(true)
		if callback then callback(state) end
	end)

	return row
end

return Element
