--[[
src/games/2971329387.lua — Cook Burgers
LuisGamerCoolHub
]]

return function(_, api)
    -- ================= MAIN TAB =================
    api.Tab("Main", function(tab)
        tab.Button("Spawn Plate", function()
            local restaurant = workspace:WaitForChild("Restaurant")
            local dispenser = restaurant:WaitForChild("PlateDispenser")
            local button = dispenser:WaitForChild("DispenserButton")
            local event = button:WaitForChild("ContextAction")
            event:FireServer()
        end)
    end)

    -- ================= EXTRA TAB =================
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

    -- ================= CREDITS TAB =================
    api.Tab("Credits", function(tab)
        tab.Text("LuisGamerCoolHub")
        tab.Text("Created by LuisGamerCool")
        tab.Text("Thanks for using the hub!")
    end)
end
