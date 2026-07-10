-- elements.lua for LuisGamerCoolHub

local Elements = {}

function Elements:AddTab(scrollingFrame, template, name)
	local tab = template:Clone()
	tab.Name = name .. "Tab"
	tab.Text = name
	tab.Visible = true
	tab.Parent = scrollingFrame
	return tab
end

function Elements:AddLabel(contentHolder, template, text)
	local holder = template:Clone()
	holder.Text.Text = text
	holder.Parent = contentHolder
	return holder
end

function Elements:AddButton(contentHolder, template, text, callback)
	local holder = template:Clone()
	holder.TextButton.Text = text
	holder.Parent = contentHolder
	
	holder.TextButton.MouseButton1Click:Connect(callback)
	return holder
end

function Elements:AddToggle(contentHolder, template, text, default, callback)
	local holder = template:Clone()
	holder.Name = text .. "_Toggle"
	holder.Parent = contentHolder
	
	holder.Name.Text = text
	local toggleBtn = holder["On/OffButton"]
	local state = default or false
	
	local function updateVisual()
		if state then
			toggleBtn.Text = "ON"
			toggleBtn.BackgroundColor3 = Color3.fromRGB(59, 164, 57)
		else
			toggleBtn.Text = "OFF"
			toggleBtn.BackgroundColor3 = Color3.fromRGB(164, 58, 58)
		end
	end
	
	updateVisual()
	
	toggleBtn.MouseButton1Click:Connect(function()
		state = not state
		updateVisual()
		if callback then callback(state) end
	end)
	
	return holder
end

return Elements
