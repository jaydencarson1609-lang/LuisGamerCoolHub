--[[
src/games/106772177198260.lua — Reel for Brainrots
LuisGamerCoolHub
]]

return function(_, api)
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local farming = false

    api.Tab("Main", function(tab)
        tab.Toggle("Farming", false, function(state)
            farming = state
            if state then
                task.spawn(function()
                    while farming do
                        game:GetService("ReplicatedStorage").RemoteHandler.Fishing:FireServer("Caught", 3)
                        task.wait(0.1)
                    end
                end)
            end
        end)

        tab.Button("Dupe Brainrot InHand", function()
            local char = LocalPlayer.Character
            local br = char:FindFirstChildOfClass("Tool")
            if br and br:GetAttribute("brainrot") then
                for i = 1, 30 do
                    game:GetService("ReplicatedStorage").RemoteHandler.Plot:FireServer("Add", "Plot" .. i, br.Name)
                    task.wait(0.5)
                end
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
        tab.Text("Version: 1.0 - Reel for Brainrots")
        tab.Text("Thanks for using the hub!")
    end)
end
