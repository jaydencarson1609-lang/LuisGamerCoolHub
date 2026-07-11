--[[
src/games/89072926726733.lua — Cross the Road for Brainrot
LuisGamerCoolHub
]]

return function(_, api)
    -- ================= MAIN TAB =================
    api.Tab("Main", function(tab)
        tab.Text("Cross the Road for Brainrot")

        -- Keep the spawn plate button
        tab.Button("Spawn Plate", function()
            local restaurant = workspace:WaitForChild("Restaurant")
            local dispenser = restaurant:WaitForChild("PlateDispenser")
            local button = dispenser:WaitForChild("DispenserButton")
            local event = button:WaitForChild("ContextAction")
            event:FireServer()
        end)

        -- ================= AUTO FARM BEST BRAINROTS =================
        local farming = false

        tab.Toggle("Auto Farm Best Brainrots", false, function(state)
            farming = state

            if state then
                task.spawn(function()
                    while farming do
                        local plr = game.Players.LocalPlayer
                        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = plr.Character.HumanoidRootPart

                            -- Step 1: Teleport to farm spot
                            hrp.CFrame = CFrame.new(383, 2, 2093)
                            task.wait(0.6)

                            -- Step 2: Fire all ProximityPrompts in ItemSpawners (Secret + Celestial)
                            for _, obj in pairs(workspace.ItemSpawners:GetDescendants()) do
                                if obj:IsA("ProximityPrompt") and obj.Enabled then
                                    obj:Fire()
                                end
                            end

                            task.wait(0.4)

                            -- Step 3: Teleport back to lobby
                            hrp.CFrame = CFrame.new(349, 2, -19)
                        end

                        task.wait(1.2)
                    end
                end)
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
