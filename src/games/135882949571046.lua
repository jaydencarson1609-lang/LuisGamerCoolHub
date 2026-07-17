--[[
src/games/135882949571046.lua — Dream for Brainrots
LuisGamerCoolHub
]]

return function(_, api)
    local farming = false

    api.Tab("Main", function(tab)
        tab.Toggle("Farming", false, function(state)
            farming = state
            if state then
                task.spawn(function()
                    while farming do
                        pcall(function()
                            game:GetService("ReplicatedStorage").Remotes.DreamStateChanged:FireServer(true)
                            game:GetService("ReplicatedStorage").Remotes.RequestDreamBrainrots:FireServer()
                            game:GetService("ReplicatedStorage").Remotes.PickupDreamBrainrot:FireServer("60")
                            task.wait()
                            game:GetService("ReplicatedStorage").Remotes.RequestDreamWallExit:FireServer()
                        end)
                        task.wait()
                    end
                end)
            end
        end)
    end)

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

    api.Tab("Credits", function(tab)
        tab.Text("LuisGamerCoolHub")
        tab.Text("Created by LuisGamerCool")
        tab.Text("Version: 1.0 - Dream for Brainrots")
        tab.Text("Thanks for using the hub!")
    end)
end
