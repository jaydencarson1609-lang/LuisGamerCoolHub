--[[
src/games/110373292461174.lua — Paper Plane for Brainrot
LuisGamerCoolHub
]]

return function(_, api)
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local farming = false
    local strengthFarm = false

    api.Tab("Main", function(tab)
        tab.Toggle("Farm Brainrots", false, function(state)
            farming = state
            if state then
                task.spawn(function()
                    while farming do
                        pcall(function()
                            game:GetService("ReplicatedStorage").SharedModules.Network.RequestPendingFlight:FireServer()
                            task.wait(1)

                            local results = game:GetService("ReplicatedStorage").SharedModules.Network.RequestActiveFlight:InvokeServer({
                                plotIndex = 3,
                                intensity = 1,
                                player = LocalPlayer,
                                flightUID = require(game:GetService("ReplicatedStorage").UtilityCore).StringUtility.GenerateUID(),
                                serverFloors = 10000000,
                                visualStartPos = Vector3.new(-347.2116394043, 89.037544250488, 25.892095565796),
                                startTime = require(game:GetService("ReplicatedStorage").GameCore).GetSycnedTime(),
                                startPos = Vector3.new(-347.2116394043, 85.050003051758, 25.892095565796),
                                serverStrength = 10000000
                            })

                            if results then
                                local chosen = results.spawnedBrainrots[1]
                                task.wait(results.timeInAir + 0.5)
                                game:GetService("ReplicatedStorage").SharedModules.Network.ClaimFlight:InvokeServer(chosen.uid)
                            end
                        end)
                        task.wait(1)
                    end
                end)
            end
        end)

        tab.Toggle("Farm Strength", false, function(state)
            strengthFarm = state
            if state then
                task.spawn(function()
                    while strengthFarm do
                        game:GetService("ReplicatedStorage").SharedModules.Network.RequestStrength:InvokeServer()
                        game:GetService("ReplicatedStorage").SharedModules.Network.RequestDoubleStrength:InvokeServer()
                        task.wait(0.1)
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
        tab.Text("Version: 1.0 - Paper Plane for Brainrot")
        tab.Text("Thanks for using the hub!")
    end)
end
