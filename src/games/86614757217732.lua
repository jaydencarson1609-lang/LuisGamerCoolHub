--[[
src/games/86614757217732.lua — UI Test
]]

return function(_, api)
    api.Tab("Main", function(tab)
        tab.Toggle("Test Toggle One", false, function(state)
            print("Test Toggle One:", state)
        end)

        tab.Toggle("Test Toggle Two", false, function(state)
            print("Test Toggle Two:", state)
        end)

        tab.Toggle("Test Toggle Three", false, function(state)
            print("Test Toggle Three:", state)
        end)
    end)

    api.Tab("Extra", function(tab)
        tab.Button("Press Me", function()
            print("Extra button was pressed")
        end)
    end)

    api.Tab("Credits", function(tab)
        tab.Text("LuisGamerCoolHub")
        tab.Text("Created by Jayden")
    end)
end
