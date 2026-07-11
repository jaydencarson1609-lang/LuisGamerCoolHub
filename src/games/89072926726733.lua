--[[
src/games/89072926726733.lua — Cross the Road for Brainrot
LuisGamerCoolHub
]]

return function(_, api)
    -- ================= MAIN TAB (ONLY THE TOGGLE) =================
    api.Tab("Main", function(tab)
        local farming = false

        tab.Toggle("Auto Farm Best Brainrots", false, function(state)
            farming = state

            if state then
                task.spawn(function()
                    while farming do
                        local plr = game.Players.LocalPlayer
                        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = plr.Character.HumanoidRootPart

                            for _, folder in pairs(workspace.ItemSpawners:GetChildren()) do
                                for _, item in pairs(folder:GetDescendants()) do
                                    if item.Name == "SpawnedItem" and item:IsA("Model") then
                                        -- Teleport to the SpawnedItem
                                        if item.PrimaryPart then
                                            hrp.CFrame = item.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                                        else
                                            hrp.CFrame = item:GetPivot() + Vector3.new(0, 3, 0)
                                        end

                                        task.wait(0.12)

                                        -- Find and properly activate the ProximityPrompt (spam E)
                                        local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                                        if prompt then
                                            for i = 1, 6 do
                                                prompt:InputHoldBegin()
                                                task.wait(0.04)
                                                prompt:InputHoldEnd()
                                                task.wait(0.02)
                                            end
                                        end

                                        task.wait(0.2)

                                        -- Teleport back to lobby
                                        hrp.CFrame = CFrame.new(349, 2, -19)
                                        task.wait(0.7)
                                    end
                                end
                            end
                        end
                        task.wait(0.25)
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
