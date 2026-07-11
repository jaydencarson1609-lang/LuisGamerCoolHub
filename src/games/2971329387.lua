--[[
src/games/2971329387.lua — Cook Burgers script
PlaceId: 2971329387[](https://www.roblox.com/games/2971329387/Cook-Burgers)
]]

return function(container, api)
    local Players = game:GetService("Players")
    local plr = Players.LocalPlayer

    api.Text("Loaded script for Cook Burgers.")

    -- Test button as requested
    api.Button("Test Button", function()
        print("it worked")
    end)

    -- Example toggle (you can expand this later with real game logic)
    local running = false
    api.Toggle("Auto Farm (placeholder)", false, function(state)
        running = state
        if state then
            task.spawn(function()
                while running do
                    -- Replace this with real logic later:
                    -- e.g. fireproximityprompt, remote calls, teleport, etc.
                    print("Auto Farm loop running...")
                    task.wait(1)
                end
            end)
        end
    end)

    api.Button("One-off Action", function()
        print("Button pressed for PlaceId " .. tostring(game.PlaceId))
    end)
end
