--[[
src/games/137045336777529.lua — Run on Ice For Brainrots
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local LOBBY_CFRAME = CFrame.new(-14, 4, -268)
    local FARM_CFRAME = CFrame.new(78, 7, 4397)
    local farming = false
    local farmSession = 0

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
        pcall(function()
            fireproximityprompt(prompt, 0)
        end)
    end

    local function isValidBrainrot(model)
        if not model:IsA("Model") then return false end
        if not model:FindFirstChild("Mesh") then return false end
        if not model.Mesh:FindFirstChildOfClass("ProximityPrompt") then return false end
        if model:GetAttribute("Lifetime") == nil or model:GetAttribute("SpawnTime") == nil then
            return false
        end
        return true
    end

    local function startFarming()
        local root = getRootPart()
        if not root then return end

        farming = true
        farmSession += 1
        local session = farmSession

        task.spawn(function()
            while farming and farmSession == session do
                teleport(root, FARM_CFRAME)
                task.wait(0.8)

                local platform9 = workspace:FindFirstChild("Map")
                    and workspace.Map:FindFirstChild("Outer")
                    and workspace.Map.Outer:FindFirstChild("Platforms")
                    and workspace.Map.Outer.Platforms:FindFirstChild("Platform9")

                if platform9 then
                    for _, brainrot in ipairs(platform9:GetChildren()) do
                        if not farming or farmSession ~= session then break end

                        if isValidBrainrot(brainrot) then
                            local pos = brainrot:GetPivot().Position
                            teleport(root, CFrame.new(pos + Vector3.new(0, 3, 0)))
                            task.wait(0.2)

                            local prompt = brainrot.Mesh:FindFirstChildOfClass("ProximityPrompt")
                            if prompt then
                                for i = 1, 8 do
                                    activatePrompt(prompt)
                                    task.wait(0.03)
                                end
                            end

                            task.wait(0.25)
                            teleport(root, LOBBY_CFRAME)
                            task.wait(0.7)
                        end
                    end
                end

                task.wait(0.4)
            end

            if root then
                teleport(root, LOBBY_CFRAME)
            end
        end)
    end

    local function stopFarming()
        farming = false
        farmSession += 1
        local root = getRootPart()
        if root then
            teleport(root, LOBBY_CFRAME)
        end
    end

    -- ================= MAIN TAB =================
    api.Tab("Main", function(tab)
        tab.Toggle("Auto Farm Best Brainrots", false, function(state)
            if state then
                startFarming()
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
        tab.Text("Version: 1.0 - Run on Ice For Brainrots")
        tab.Text("Thanks for using the hub!")
    end)
end
