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
    local collectingMoney = false

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
        farming = true
        farmSession += 1
        local session = farmSession

        task.spawn(function()
            while farming and farmSession == session do
                local root = getRootPart()
                if not root then task.wait(0.5) continue end

                teleport(root, FARM_CFRAME)
                task.wait(0.5)

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
                            task.wait(0.1)

                            local prompt = brainrot.Mesh:FindFirstChildOfClass("ProximityPrompt")
                            if prompt then
                                for i = 1, 10 do
                                    activatePrompt(prompt)
                                    task.wait(0.02)
                                end
                            end

                            task.wait(0.15)
                            teleport(root, LOBBY_CFRAME)
                            task.wait(0.5)
                        end
                    end
                end
                task.wait(0.25)
            end
        end)
    end

    local function stopFarming()
        farming = false
        farmSession += 1
    end

    -- ================= AUTO COLLECT MONEY (getnilinstances METHOD) =================
    local function startCollectingMoney()
        collectingMoney = true
        task.spawn(function()
            while collectingMoney do
                pcall(function()
                    for _, v in next, getnilinstances() do
                        if v.ClassName == "TouchTransmitter" and v.Parent and v.Parent.Name == "Button" then
                            local head = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
                            if head then
                                firetouchinterest(head, v, true)
                                task.wait()
                                firetouchinterest(head, v, false)
                            end
                        end
                    end
                end)
                task.wait(0.15)
            end
        end)
    end

    local function stopCollectingMoney()
        collectingMoney = false
    end

    -- Resume after death
    LocalPlayer.CharacterAdded:Connect(function()
        if farming then
            task.wait(1.5)
            startFarming()
        end
    end)

    -- ================= MAIN TAB =================
    api.Tab("Main", function(tab)
        tab.Toggle("Auto Farm Best Brainrots", false, function(state)
            if state then
                startFarming()
            else
                stopFarming()
            end
        end)

        tab.Toggle("Auto Collect Money", false, function(state)
            if state then
                startCollectingMoney()
            else
                stopCollectingMoney()
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
        tab.Text("Version: 1.9 - getnilinstances Method")
        tab.Text("Thanks for using the hub!")
    end)
end
