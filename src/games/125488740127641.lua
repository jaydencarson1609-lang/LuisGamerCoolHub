--[[
src/games/125488740127641.lua — Build Anything
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local lp = Players.LocalPlayer
    local victimName = ""

    local function getHRP()
        local char = lp.Character
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    local function equipDestroyTool()
        local char = lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum then
            return false
        end

        local tool = char:FindFirstChild("Destroy Blocks")
            or lp.Backpack:FindFirstChild("Destroy Blocks")
        if not tool then
            return false
        end

        if tool.Parent ~= char then
            hum:EquipTool(tool)
            task.wait(0.15)
        end

        return char:FindFirstChild("Destroy Blocks") ~= nil
    end

    -- The game only accepts DestroyBlock if the Destroy Blocks tool is
    -- equipped and you are within 30 studs of the part.
    local function deletePlots(plots)
        task.spawn(function()
            if not equipDestroyTool() then
                return
            end

            local Event = ReplicatedStorage.Events.DestroyBlock
            local remaining = {}

            for _, plot in pairs(plots) do
                if plot then
                    for _, block in pairs(plot:GetChildren()) do
                        if block:IsA("BasePart") then
                            table.insert(remaining, block)
                        end
                    end
                end
            end

            while #remaining > 0 do
                if not equipDestroyTool() then
                    break
                end

                local hrp = getHRP()
                if not hrp then
                    break
                end

                local nextBlock
                for i = #remaining, 1, -1 do
                    local block = remaining[i]
                    if not (block and block.Parent) then
                        table.remove(remaining, i)
                    else
                        nextBlock = block
                        break
                    end
                end

                if not nextBlock then
                    break
                end

                if (hrp.Position - nextBlock.Position).Magnitude > 28 then
                    hrp.CFrame = CFrame.new(nextBlock.Position + Vector3.new(0, 6, 0))
                    task.wait(0.05)
                    hrp = getHRP()
                    if not hrp then
                        break
                    end
                end

                local origin = hrp.Position
                for i = #remaining, 1, -1 do
                    local block = remaining[i]
                    if not (block and block.Parent) then
                        table.remove(remaining, i)
                    elseif (block.Position - origin).Magnitude <= 30 then
                        table.remove(remaining, i)
                        task.spawn(function()
                            Event:InvokeServer(block)
                        end)
                    end
                end

                task.wait(0.05)
            end
        end)
    end

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
        return workspace.Built:FindFirstChild(player.Name)
    end

    api.Tab("Main", function(tab)
        tab.Section("Delete builds")

        tab.Button("Delete All", function()
            deletePlots(workspace.Built:GetChildren())
        end)

        tab.Input("Victim Name", "Type a username...", "", function(text)
            victimName = text or ""
        end)

        tab.Button("Delete Victim", function()
            local victim = findPlayer(victimName)
            local plot = getPlot(victim)
            if plot then
                deletePlots({ plot })
            end
        end)

        tab.Button("Delete My Blocks", function()
            pcall(function()
                ReplicatedStorage.Events.DeleteAllPlayerBlocks:FireServer()
            end)
            local plot = getPlot(lp)
            if plot then
                deletePlots({ plot })
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
        tab.Text("Thanks for using the hub!")
    end)
end
