--[[
src/games/85411355002110.lua — +1 Dash for Brainrots
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local endPos = Vector3.new(-74, 63, 15784)
    local colPos = Vector3.new(-74, 20, -447)
    local farming = false

    -- ================= MAIN TAB =================
    api.Tab("Main", function(tab)
        tab.Toggle("Farm Brainrots", false, function(state)
            farming = state

            if state then
                task.spawn(function()
                    while farming do
                        pcall(function()
                            -- Go to spawn area
                            LocalPlayer.Character:MoveTo(endPos)
                            task.wait(0.5)

                            local spawner = workspace.Map.Spawners:FindFirstChild("???xLuck")
                            if not spawner then return end

                            local container = spawner:FindFirstChild("???")
                            if not container then return end

                            for _, brainrot in ipairs(container:GetChildren()) do
                                if not farming then break end
                                if not brainrot:IsA("Model") then continue end
                                if not brainrot.PrimaryPart then continue end

                                -- Wait until not paused
                                repeat task.wait() until not LocalPlayer.GameplayPaused

                                -- Teleport to brainrot
                                LocalPlayer.Character:MoveTo(brainrot.PrimaryPart.Position)
                                task.wait(0.2)

                                -- Pickup
                                local prompt = brainrot.PrimaryPart:FindFirstChildOfClass("ProximityPrompt")
                                if prompt then
                                    repeat
                                        fireproximityprompt(prompt)
                                        task.wait()
                                    until not farming or not brainrot or brainrot.Parent ~= container
                                end

                                task.wait(0.5)

                                -- Go to collection point
                                repeat
                                    LocalPlayer.Character:MoveTo(colPos)
                                    task.wait()
                                until not farming or not LocalPlayer.Character:FindFirstChildOfClass("Model")

                                break
                            end
                        end)
                        task.wait()
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
        tab.Text("Version: 1.0 - +1 Dash for Brainrots")
        tab.Text("Thanks for using the hub!")
    end)
end
