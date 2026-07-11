--[[
src/games/2971329387.lua — Cook Burgers
PlaceId: 2971329387
]]

return function(container, api)
    local Players = game:GetService("Players")
    local plr = Players.LocalPlayer

    -- Title
    api.Text("=== Plate Spawner ===")

    -- Button with exact text "spawn plate"
    api.Button("spawn plate", function()
        -- Cobalt generated remote
        local Event = workspace.Restaurant.PlateDispenser.DispenserButton.ContextAction
        Event:FireServer()
        print("Plate spawned!")
    end)

    -- Optional: keep the old test button if you want
    api.Button("Test Button", function()
        print("it worked")
    end)
end
