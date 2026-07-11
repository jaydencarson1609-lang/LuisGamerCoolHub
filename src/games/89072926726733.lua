--[[
src/games/89072926726733.lua — Cross the Road for Brainrot
LuisGamerCoolHub

Auto Farm behaviour:
1. Saves the player's position when enabled.
2. Always teleports to 360, 2, 2076 first so the area loads.
3. Teleports to each SpawnedItem's ProximityPrompt.
4. Activates the prompt (fireproximityprompt if available, else InputHold).
5. Returns to the saved starting position after every pickup.
6. Returns to the saved position when Auto Farm is disabled.
]]

return function(_, api)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local LOAD_CFRAME = CFrame.new(360, 2, 2076)
    local LOAD_WAIT_TIME = 1.5

    local farming = false
    local farmSession = 0
    local startCFrame = nil

    local function getRootPart()
        local character = LocalPlayer.Character
        if not character then
            character = LocalPlayer.CharacterAdded:Wait()
        end
        return character:FindFirstChild("HumanoidRootPart")
            or character:WaitForChild("HumanoidRootPart", 5)
    end

    local function teleportRoot(rootPart, targetCFrame)
        if not rootPart or not rootPart.Parent or not targetCFrame then
            return false
        end
        rootPart.AssemblyLinearVelocity = Vector3.zero
        rootPart.AssemblyAngularVelocity = Vector3.zero
        rootPart.CFrame = targetCFrame
        return true
    end

    local function getPromptPosition(prompt)
        if not prompt or not prompt.Parent then return nil end
        local parent = prompt.Parent

        if parent:IsA("Attachment") then
            return parent.WorldPosition
        elseif parent:IsA("BasePart") then
            return parent.Position
        end

        local basePart = parent:FindFirstAncestorWhichIsA("BasePart")
        return basePart and basePart.Position or nil
    end

    local function activatePrompt(prompt)
        if not prompt or not prompt:IsA("ProximityPrompt") then
            return false
        end

        -- Best method: fireproximityprompt (many executors have this)
        if typeof(fireproximityprompt) == "function" then
            local ok = pcall(function() fireproximityprompt(prompt, 0) end)
            if ok then return true end
            local ok2 = pcall(function() fireproximityprompt(prompt) end)
            return ok2
        end

        -- Fallback
        local old = prompt.HoldDuration
        local ok = pcall(function()
            prompt.HoldDuration = 0
            prompt:InputHoldBegin()
            task.wait(0.1)
            prompt:InputHoldEnd()
        end)
        pcall(function() prompt.HoldDuration = old end)
        return ok
    end

    local function getSpawnedItems()
        local items = {}
        local spawners = workspace:FindFirstChild("ItemSpawners")
        if not spawners then return items end

        for _, obj in ipairs(spawners:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == "SpawnedItem" then
                table.insert(items, obj)
            end
        end
        return items
    end

    local function returnToStart()
        if not startCFrame then return end
        local root = getRootPart()
        if root then teleportRoot(root, startCFrame) end
    end

    local function loadFarmArea(session)
        if not farming or farmSession ~= session then return false end

        local root = getRootPart()
        if not root then return false end

        teleportRoot(root, LOAD_CFRAME)
        task.wait(LOAD_WAIT_TIME)

        local started = os.clock()
        while farming and farmSession == session and not workspace:FindFirstChild("ItemSpawners") and os.clock() - started < 5 do
            task.wait(0.25)
        end
        return farming and farmSession == session
    end

    local function farmItem(item, session)
        if not farming or farmSession ~= session or not item or not item.Parent then
            return
        end

        local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
        if not prompt then return end

        local root = getRootPart()
        if not root then return end

        local pos = getPromptPosition(prompt)
        local target = pos and CFrame.new(pos + Vector3.new(0, 2.5, 0)) or (item:GetPivot() + Vector3.new(0, 3, 0))

        teleportRoot(root, target)
        task.wait(0.18)

        if not farming or farmSession ~= session then
            returnToStart()
            return
        end

        activatePrompt(prompt)
        task.wait(0.35)
        returnToStart()
        task.wait(0.5)
    end

    local function startFarming()
        local root = getRootPart()
        if not root then
            warn("[Auto Farm] HumanoidRootPart not found.")
            farming = false
            return
        end

        startCFrame = root.CFrame
        farming = true
        farmSession += 1
        local session = farmSession

        task.spawn(function()
            while farming and farmSession == session do
                if not loadFarmArea(session) then break end

                local items = getSpawnedItems()
                if #items == 0 then
                    returnToStart()
                    task.wait(0.7)
                    continue
                end

                for _, item in ipairs(items) do
                    if not farming or farmSession ~= session then break end
                    farmItem(item, session)
                end
                task.wait(0.2)
            end
            returnToStart()
        end)
    end

    local function stopFarming()
        farming = false
        farmSession += 1
        returnToStart()
    end

    -- ================= MAIN TAB =================
    api.Tab("Main", function(tab)
        tab.Toggle("Auto Farm Best Brainrots", false, function(state)
            if state then
                if not farming then startFarming() end
            else
                stopFarming()
            end
        end)
    end)

    -- ================= EXTRA TAB =================
    api.Tab("Extra", function(tab)
        tab.Button("Infinite Yield", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
        tab.Button("Dex Explorer", function()
            loadstring(game:HttpGet("https://github.com/BOXLEGENDARY/Dex/releases/latest/download/out.lua"))()
        end)
        tab.Button("Cobalt", function()
            loadstring(game:HttpGet("https://github.com/notpoiu/cobalt/releases/latest/download/Cobalt.luau"))()
        end)
    end)

    -- ================= CREDITS TAB =================
    api.Tab("Credits", function(tab)
        tab.Text("LuisGamerCoolHub")
        tab.Text("Created by LuisGamerCool")
        tab.Text("Thanks for using the hub!")
    end)
end
