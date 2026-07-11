--[[
src/games/89072926726733.lua — Cross the Road for Brainrot
LuisGamerCoolHub

Auto Farm behaviour:
1. Saves the player's position when enabled.
2. Always teleports to 360, 2, 2076 first so the area loads.
3. Teleports to each SpawnedItem's ProximityPrompt.
4. Activates the prompt.
5. Returns to the saved starting position after every pickup.
6. Returns to the saved position when Auto Farm is disabled.
]]

return function(_, api)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- Always visit this position first so the area's parts and
    -- brainrot spawners stream/load before scanning for items.
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
        if not prompt or not prompt.Parent then
            return nil
        end

        local parent = prompt.Parent

        if parent:IsA("Attachment") then
            return parent.WorldPosition
        end

        if parent:IsA("BasePart") then
            return parent.Position
        end

        local basePart = parent:FindFirstAncestorWhichIsA("BasePart")

        if basePart then
            return basePart.Position
        end

        return nil
    end

    local function activatePrompt(prompt)
        if not prompt or not prompt:IsA("ProximityPrompt") then
            return false
        end

        -- Executor-supported prompt activation.
        if typeof(fireproximityprompt) == "function" then
            local success = pcall(function()
                fireproximityprompt(prompt, 0)
            end)

            if not success then
                success = pcall(function()
                    fireproximityprompt(prompt)
                end)
            end

            return success
        end

        -- Normal Roblox fallback. Some games may still require their
        -- own server-side interaction or distance checks.
        local oldHoldDuration = prompt.HoldDuration

        local success = pcall(function()
            prompt.HoldDuration = 0
            prompt:InputHoldBegin()
            task.wait(0.12)
            prompt:InputHoldEnd()
        end)

        pcall(function()
            prompt.HoldDuration = oldHoldDuration
        end)

        return success
    end

    local function getSpawnedItems()
        local items = {}
        local itemSpawners = workspace:FindFirstChild("ItemSpawners")

        if not itemSpawners then
            return items
        end

        for _, object in ipairs(itemSpawners:GetDescendants()) do
            if object:IsA("Model") and object.Name == "SpawnedItem" then
                table.insert(items, object)
            end
        end

        return items
    end

    local function returnToStart()
        if not startCFrame then
            return
        end

        local rootPart = getRootPart()

        if rootPart then
            teleportRoot(rootPart, startCFrame)
        end
    end

    local function loadFarmArea(session)
        if not farming or farmSession ~= session then
            return false
        end

        local rootPart = getRootPart()

        if not rootPart then
            return false
        end

        teleportRoot(rootPart, LOAD_CFRAME)
        task.wait(LOAD_WAIT_TIME)

        -- Give streaming a little extra time if the folder has not loaded yet.
        local started = os.clock()

        while farming
            and farmSession == session
            and not workspace:FindFirstChild("ItemSpawners")
            and os.clock() - started < 5 do

            task.wait(0.25)
        end

        return farming and farmSession == session
    end

    local function farmItem(item, session)
        if not farming or farmSession ~= session then
            return
        end

        if not item or not item.Parent then
            return
        end

        local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)

        if not prompt then
            return
        end

        local rootPart = getRootPart()

        if not rootPart then
            return
        end

        local promptPosition = getPromptPosition(prompt)
        local targetCFrame

        if promptPosition then
            targetCFrame = CFrame.new(
                promptPosition + Vector3.new(0, 2.5, 0)
            )
        else
            targetCFrame = item:GetPivot() + Vector3.new(0, 3, 0)
        end

        teleportRoot(rootPart, targetCFrame)
        task.wait(0.18)

        if not farming or farmSession ~= session then
            returnToStart()
            return
        end

        activatePrompt(prompt)
        task.wait(0.4)

        -- Return to the exact position where Auto Farm was enabled.
        returnToStart()
        task.wait(0.55)
    end

    local function startFarming()
        local rootPart = getRootPart()

        if not rootPart then
            warn("[Auto Farm] HumanoidRootPart was not found.")
            farming = false
            return
        end

        -- Save the player's first/original position.
        startCFrame = rootPart.CFrame

        farming = true
        farmSession += 1

        local session = farmSession

        task.spawn(function()
            while farming and farmSession == session do
                -- Always go to the loading area before looking for brainrots.
                local loaded = loadFarmArea(session)

                if not loaded then
                    break
                end

                local items = getSpawnedItems()

                if #items == 0 then
                    returnToStart()
                    task.wait(0.75)
                    continue
                end

                for _, item in ipairs(items) do
                    if not farming or farmSession ~= session then
                        break
                    end

                    farmItem(item, session)
                end

                task.wait(0.25)
            end

            returnToStart()
        end)
    end

    local function stopFarming()
        farming = false
        farmSession += 1
        returnToStart()
    end

    local function runRemoteScript(url, scriptName)
        local success, result = pcall(function()
            local source = game:HttpGet(url)
            local loaded = loadstring(source)

            if not loaded then
                error("loadstring returned nil")
            end

            return loaded()
        end)

        if not success then
            warn(
                "[LuisGamerCoolHub] Failed to load "
                    .. tostring(scriptName)
                    .. ": "
                    .. tostring(result)
            )
        end
    end

    -- ================= MAIN TAB =================

    api.Tab("Main", function(tab)
        tab.Toggle(
            "Auto Farm Best Brainrots",
            false,
            function(state)
                if state then
                    if not farming then
                        startFarming()
                    end
                else
                    stopFarming()
                end
            end
        )
    end)

    -- ================= EXTRA TAB =================

    api.Tab("Extra", function(tab)
        tab.Button("Infinite Yield", function()
            runRemoteScript(
                "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",
                "Infinite Yield"
            )
        end)

        tab.Button("Dex Explorer", function()
            runRemoteScript(
                "https://github.com/BOXLEGENDARY/Dex/releases/latest/download/out.lua",
                "Dex Explorer"
            )
        end)

        tab.Button("Cobalt", function()
            runRemoteScript(
                "https://github.com/notpoiu/cobalt/releases/latest/download/Cobalt.luau",
                "Cobalt"
            )
        end)
    end)

    -- ================= CREDITS TAB =================

    api.Tab("Credits", function(tab)
        tab.Text("LuisGamerCoolHub")
        tab.Text("Created by LuisGamerCool")
        tab.Text("Thanks for using the hub!")
    end)
end
