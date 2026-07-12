--[[
src/games/86614757217732.lua — UI Test (Only Tabs 1 and 2)
]]

return function(_, api)
    api.Tab("1", function(tab)
        tab.Text("This is tab 1")
        tab.Button("Press Me", function()
            print("Button in tab 1 was pressed")
        end)
    end)

    api.Tab("2", function(tab)
        tab.Text("This is tab 2")
        tab.Button("Press Me Too", function()
            print("Button in tab 2 was pressed")
        end)
    end)
end
