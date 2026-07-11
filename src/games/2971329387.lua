--[[
src/games/2971329387.lua — Cook Burgers
LuisGamerCoolHub
]]

return function(_, api)
    api.Tab("Main", function(tab)
        tab.Button("Spawn Plate", function()
            local restaurant = workspace:WaitForChild("Restaurant")
            local dispenser = restaurant:WaitForChild("PlateDispenser")
            local button = dispenser:WaitForChild("DispenserButton")
            local event = button:WaitForChild("ContextAction")

            event:FireServer()
        end)
    end)
end
