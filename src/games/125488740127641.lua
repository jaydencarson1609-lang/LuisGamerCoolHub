--[[
src/games/125488740127641.lua — Build Anything
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local lp = Players.LocalPlayer
    local DestroyBlock = ReplicatedStorage:WaitForChild("Events"):WaitForChild("DestroyBlock")
    local Built = workspace:WaitForChild("Built")

    local victimName = ""

    local function findPlayer(query)
        if type(query) ~= "string" or query == "" then
            return nil
        end
        local q = string.lower(query)
        for _, plr in ipairs(Players:GetPlayers()) do
            if string.find(string.lower(plr.Name), q, 1, true) then
                return plr
            end
        end
        return nil
    end

    local function getPlot(player)
        if not player then
            return nil
        end
        return Built:FindFirstChild(player.Name)
    end

    local function deleteBlocks(folder)
        if not folder then
            return
        end
        for _, block in ipairs(folder:GetChildren()) do
            task.spawn(function()
                pcall(function()
                    DestroyBlock:InvokeServer(block)
                end)
            end)
        end
    end

    api.Tab("Main", function(tab)
        tab.Section("Delete builds")

        tab.Button("Delete All", function()
            for _, plot in ipairs(Built:GetChildren()) do
                deleteBlocks(plot)
            end
        end)

        tab.Input("Victim Name", "Type a username...", "", function(text)
            victimName = text or ""
        end)

        tab.Button("Delete Victim", function()
            local victim = findPlayer(victimName)
            if not victim then
                return
            end
            deleteBlocks(getPlot(victim))
        end)

        tab.Button("Delete My Blocks", function()
            deleteBlocks(getPlot(lp))
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
        tab.Text("Thanks for using the hub!")
    end)
end
