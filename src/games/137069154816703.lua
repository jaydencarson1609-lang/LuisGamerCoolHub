--[[
src/games/137069154816703.lua — Hack Vault for Brainrots
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local farming = false

    -- ================= MAIN TAB =================
    api.Tab("Main", function(tab)
        tab.Toggle("Farm Brainrots", false, function(state)
            farming = state

            if state then
                task.spawn(function()
                    while farming do
                        pcall(function()
                            -- Go to starting position
                            LocalPlayer.Character:MoveTo(Vector3.new(-2494, 4, -726))
                            task.wait(0.5)

                            for _, br in ipairs(workspace.EntitiesFolder:GetChildren()) do
                                if not farming then break end

                                -- Only process SpawnZone 22
                                if br:GetAttribute("SpawnZone") ~= 22 then
                                    continue
                                end

                                if not br.PrimaryPart then
                                    continue
                                end

                                -- Teleport to brainrot
                                LocalPlayer.Character:MoveTo(br.PrimaryPart.Position)
                                task.wait(0.2)

                                -- Pickup
                                local prompt = br.PrimaryPart:FindFirstChild("TakeBrainrotPrompt")
                                if prompt then
                                    repeat
                                        fireproximityprompt(prompt)
                                        task.wait()
                                    until not farming or not br.PrimaryPart or br.PrimaryPart:FindFirstChild("Attachment")
                                end

                                -- Go to collection position
                                LocalPlayer.Character:MoveTo(Vector3.new(77, 4, -729))
                                task.wait(1)
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
        tab.Text("Version: 1.0 - Hack Vault for Brainrots")
        tab.Text("Thanks for using the hub!")
    end)
end
