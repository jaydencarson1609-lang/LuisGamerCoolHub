--[[
src/games/105767799784652.lua — Clean the WORLD!
LuisGamerCoolHub
]]

return function(_, api)
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local lp = Players.LocalPlayer
	local Remotes = ReplicatedStorage:WaitForChild("Remotes")
	local CollectPaper = Remotes:WaitForChild("CollectPaper")
	local CollectTrashBag = Remotes:WaitForChild("CollectTrashBag")

	local state = {
		autoFarm = false,
		autoPickup = false,
		autoDump = false,
		autoUpgrade = false,
		autoSkill = false,
		conns = {},
	}

	local function clearConns(list)
		for _, c in list do
			pcall(function()
				if typeof(c) == "RBXScriptConnection" then
					c:Disconnect()
				elseif typeof(c) == "thread" then
					task.cancel(c)
				end
			end)
		end
		table.clear(list)
	end

	local function getHRP()
		local char = lp.Character
		return char and char:FindFirstChild("HumanoidRootPart")
	end

	local function getMoney()
		local m = lp:FindFirstChild("PrivateStats") and lp.PrivateStats:FindFirstChild("Money")
		return m and m.Value or 0
	end

	local function getGum()
		local g = lp:FindFirstChild("leaderstats") and lp.leaderstats:FindFirstChild("Gum")
		return g and g.Value or 0
	end

	local function vacuumRubbish()
		local drop = workspace:FindFirstChild("DropArea")
		if not drop then
			return
		end
		for _, p in drop:GetChildren() do
			CollectPaper:FireServer(p)
			CollectPaper:FireServer(p)
		end
		CollectTrashBag:FireServer()
	end

	local function dumpAtBin()
		local trash = workspace:FindFirstChild("Trash Can") or workspace:FindFirstChild("Trash Can2")
		local part = trash and trash:FindFirstChildWhichIsA("BasePart", true)
		local hrp = getHRP()
		if hrp and part then
			hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 5, 0))
		end
		CollectTrashBag:FireServer()
		if part then
			CollectTrashBag:FireServer(part)
		end
		if trash then
			CollectTrashBag:FireServer(trash)
		end
	end

	local function autoSkillTree()
		local skills = Remotes.GetSkillUpgrades:InvokeServer()
		if not skills or not skills.costs then
			return
		end
		local gum = skills.gum or getGum()
		local currencies = skills.currencies or {}
		local list = {}
		for skill, cost in pairs(skills.costs) do
			if currencies[skill] == "Gum" and type(cost) == "number" and cost > 0 and cost < 1e9 then
				table.insert(list, { skill = skill, cost = cost })
			end
		end
		table.sort(list, function(a, b)
			return a.cost < b.cost
		end)

		for _ = 1, 40 do
			local boughtAny = false
			for _, item in list do
				if gum >= item.cost then
					local res = Remotes.PurchaseSkillUpgrade:InvokeServer(item.skill)
					if typeof(res) == "table" then
						gum = res.gum or gum
						if res.success then
							boughtAny = true
							if res.costs and res.costs[item.skill] then
								item.cost = res.costs[item.skill]
							end
						elseif res.reason == "Not enough gum" then
							return
						elseif res.reason == "Max upgrade level" then
							item.cost = math.huge
						end
					end
				end
			end
			if not boughtAny then
				break
			end
			table.sort(list, function(a, b)
				return a.cost < b.cost
			end)
		end
	end

	local function autoUpgrades()
		pcall(function()
			local info = Remotes.GetPaperUpgrade:InvokeServer()
			while info and info.level < info.maxLevel and getMoney() >= (info.cost or math.huge) do
				Remotes.PurchasePaperUpgrade:InvokeServer()
				info = Remotes.GetPaperUpgrade:InvokeServer()
			end
		end)

		pcall(function()
			local gum = Remotes.GetGum:InvokeServer()
			if gum and not gum.unlocked and getMoney() >= (gum.cost or math.huge) then
				Remotes.PurchaseGum:InvokeServer()
			end
		end)

		for _ = 1, 15 do
			pcall(function()
				Remotes.PurchaseNPC:InvokeServer()
			end)
			pcall(function()
				Remotes.PurchaseRat:InvokeServer()
			end)
		end

		for _, name in {
			"PurchaseHorse",
			"PurchaseThundergum",
			"PurchaseUnicorn",
			"PurchaseGorilla",
			"PurchaseDinosaur",
			"PurchaseSeagull",
			"PurchaseSeaweed",
			"PurchasePoopUpgrade",
			"PurchaseBananaUpgrade",
			"PurchaseEggUpgrade",
		} do
			pcall(function()
				Remotes[name]:InvokeServer()
			end)
		end
	end

	local function stopAll()
		state.autoFarm = false
		state.autoPickup = false
		state.autoDump = false
		state.autoUpgrade = false
		state.autoSkill = false
		clearConns(state.conns)
	end

	local function startPickup()
		table.insert(
			state.conns,
			RunService.RenderStepped:Connect(function()
				if state.autoPickup or state.autoFarm then
					pcall(vacuumRubbish)
				end
			end)
		)
		table.insert(
			state.conns,
			RunService.Heartbeat:Connect(function()
				if state.autoPickup or state.autoFarm then
					pcall(vacuumRubbish)
				end
			end)
		)
		local drop = workspace:FindFirstChild("DropArea")
		if drop then
			table.insert(
				state.conns,
				drop.ChildAdded:Connect(function(child)
					if not (state.autoPickup or state.autoFarm) then
						return
					end
					for _ = 1, 8 do
						CollectPaper:FireServer(child)
					end
				end)
			)
		end
	end

	local pickupStarted = false
	local function ensurePickupLoops()
		if pickupStarted then
			return
		end
		pickupStarted = true
		startPickup()
	end

	api.Tab("Clean the WORLD", function(tab)
		tab.Text("Clean the WORLD! Autofarm")
		tab.Text("Instant rubbish vacuum + upgrades + skill tree")

		tab.Section("Main")
		tab.Toggle("Full Autofarm (all-in-one)", false, function(on)
			state.autoFarm = on == true
			if state.autoFarm then
				ensurePickupLoops()
				state.autoPickup = true
				state.autoDump = true
				state.autoUpgrade = true
				state.autoSkill = true
			end
		end)

		tab.Section("Farm")
		tab.Toggle("Instant Auto Pickup Rubbish", false, function(on)
			state.autoPickup = on == true
			if state.autoPickup then
				ensurePickupLoops()
			end
		end)
		tab.Toggle("Auto Dump Trash Bag", false, function(on)
			state.autoDump = on == true
			if not state.autoDump then
				return
			end
			task.spawn(function()
				while state.autoDump or state.autoFarm do
					pcall(dumpAtBin)
					task.wait(0.35)
				end
			end)
		end)

		tab.Section("Upgrades")
		tab.Toggle("Auto Shop Upgrades (paper/NPC/rats/...)", false, function(on)
			state.autoUpgrade = on == true
			if not state.autoUpgrade then
				return
			end
			task.spawn(function()
				while state.autoUpgrade or state.autoFarm do
					pcall(autoUpgrades)
					task.wait(0.45)
				end
			end)
		end)
		tab.Toggle("Auto Skill Tree (Gum skills)", false, function(on)
			state.autoSkill = on == true
			if not state.autoSkill then
				return
			end
			task.spawn(function()
				while state.autoSkill or state.autoFarm do
					pcall(autoSkillTree)
					task.wait(0.35)
				end
			end)
		end)

		tab.Section("Actions")
		tab.Button("Vacuum All Rubbish Now", function()
			task.spawn(function()
				for _ = 1, 30 do
					vacuumRubbish()
				end
			end)
		end)
		tab.Button("Dump Trash Now", function()
			task.spawn(dumpAtBin)
		end)
		tab.Button("Buy Skills Now", function()
			task.spawn(autoSkillTree)
		end)
		tab.Button("Buy Upgrades Now", function()
			task.spawn(autoUpgrades)
		end)
		tab.Button("Stop All", function()
			stopAll()
			pickupStarted = false
		end)

		tab.Section("Stats")
		tab.Text("Money / Gum update in console while farming")
		tab.Button("Print Stats", function()
			print(("[CleanWorld] $%s | Gum %s"):format(tostring(getMoney()), tostring(getGum())))
		end)
	end)

	api.Tab("Credits", function(tab)
		tab.Text("LuisGamerCoolHub")
		tab.Text("Clean the WORLD!")
		tab.Text("Created by LuisGamerCool")
		tab.Text("Instant pickup + dump + upgrades + skill tree")
	end)
end
