--[[
src/games/89072926726733.lua — Cross the Road for Brainrot
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local LOAD_CFRAME = CFrame.new(360, 2, 2076)
    local SECRET_LOAD_CFRAME = CFrame.new(383, 2, 2093)   -- near Secret so it streams
    local LOBBY_CFRAME = CFrame.new(349, 2, -19)

    local farming = false
    local farmSession = 0
    local startCFrame = nil

    local function getRootPart()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        return char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
    end

    local function teleport(root, cframe)
        if root and cframe then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = cframe
        end
    end

    local function activatePrompt(prompt)
        if not prompt or not prompt:IsA("ProximityPrompt") then return end

        if typeof(fireproximityprompt) == "function" then
            pcall(function() fireproximityprompt(prompt, 0) end)
            return
        end

        local old = prompt.HoldDuration
        pcall(function()
            prompt.HoldDuration = 0
            prompt:InputHoldBegin()
            task.wait(0.1)
            prompt:InputHoldEnd()
        end)
        pcall(function() prompt.HoldDuration = old end)
    end

    local function isBestBrainrot(item)
        local name = item.Name:lower()
        if name:find("legendary") or name:find("mythical") then
            return false
        end
        local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt and prompt.ObjectText then
            local text = prompt.ObjectText:lower()
            if text:find("legendary") or text:find("mythical") then
                return false
            end
        end
        return true
    end

    local function getTargetSpawnedItems()
        local items = {}
        local spawners = workspace:FindFirstChild("ItemSpawners")
        if not spawners then return items end

        -- === SECRET (force load first, then look for ItemSpawn → SpawnedItem) ===
        local secret = spawners:FindFirstChild("Secret")
        if secret then
            -- Teleport near Secret so it loads
            local root = getRootPart()
            if root then
                teleport(root, SECRET_LOAD_CFRAME)
                task.wait(1.2)
            end

            -- Look for "ItemSpawn" models inside Secret
            for _, child in ipairs(secret:GetDescendants()) do
                if child:IsA("Model") and child.Name == "ItemSpawn" then
                    for _, item in ipairs(child:GetDescendants()) do
                        if item:IsA("Model") and item.Name == "SpawnedItem" and isBestBrainrot(item) then
                            table.insert(items, item)
                        end
                    end
                end
            end
        end

        -- === CELESTIAL (already working) ===
        local celestial = spawners:FindFirstChild("Celestial")
        if celestial then
            for _, item in ipairs(celestial:GetDescendants()) do
                if item:IsA("Model") and item.Name == "SpawnedItem" and isBestBrainrot(item) then
                    table.insert(items, item)
                end
            end
        end

        return items
    end

    local function startFarming()
        local root = getRootPart()
        if not root then return end

        startCFrame = root.CFrame
        farming = true
        farmSession += 1
        local session = farmSession

        task.spawn(function()
            -- Initial load area
            teleport(root, LOAD_CFRAME)
            task.wait(1.0)

            while farming and farmSession == session do
                local items = getTargetSpawnedItems()

                for _, item in ipairs(items) do
                    if not farming or farmSession ~= session then break end

                    local pos = item.PrimaryPart and item.PrimaryPart.Position or item:GetPivot().Position
                    teleport(root, CFrame.new(pos + Vector3.new(0, 3, 0)))
                    task.wait(0.15)

                    local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then
                        for i = 1, 5 do
                            activatePrompt(prompt)
                            task.wait(0.03)
                        end
                    end

                    task.wait(0.2)

                    teleport(root, LOBBY_CFRAME)
                    task.wait(0.6)
                end

                task.wait(0.3)
            end

            if startCFrame then
                teleport(root, startCFrame)
            end
        end)
    end

    local function stopFarming()
        farming = false
        farmSession += 1
        local root = getRootPart()
        if root and startCFrame then
            teleport(root, startCFrame)
        end
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
        tab.Text("Version: 1.5 - Secret + ItemSpawn Fixed")
        tab.Text("Thanks for using the hub!")
    end)
end
