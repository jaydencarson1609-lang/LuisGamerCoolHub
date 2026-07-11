--[[
src/games/2971329387.lua — Cook Burgers
]]

return function(container, api)
    api.Text("cookburger")

    api.Button("spawn plate", function()
        local Event = workspace.Restaurant.PlateDispenser.DispenserButton.ContextAction
        Event:FireServer()
    end)
end
