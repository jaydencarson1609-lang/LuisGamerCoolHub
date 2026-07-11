--[[
src/games/2971329387.lua — Cook Burgers
LuisGamerCoolHub
]]

return function(ContentHolder, api)
    api.Tab("main", function(tab)
        tab.Button("spawn plate", function()
            local Event = workspace.Restaurant.PlateDispenser.DispenserButton.ContextAction
            Event:FireServer()
        end)
    end)
end
