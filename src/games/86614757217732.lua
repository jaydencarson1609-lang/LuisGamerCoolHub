--[[
src/games/86614757217732.lua — +1 Health for Brainrots
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local farming = false

    -- ================= MAIN TAB =================
    api.Tab("Main", function(tab)
        tab.Toggle("Farm Brainrots", false, function(state)
            farming = state

            if state then
                task.spawn(function()
                    while farming do
                        pcall(function()
                            -- Find the brainrot with highest CashPerSec
                            local topRot = nil
                            local bestAmt = 0

                            for _, br in ipairs(workspace.SpawnedBrainrots:GetChildren()) do
                                if br:GetAttribute("CashPerSec") and br:GetAttribute("CashPerSec") > bestAmt then
                                    bestAmt = br:GetAttribute("CashPerSec")
                                    topRot = br
                                end
                            end

                            if topRot and topRot.PrimaryPart then
                                -- Teleport to best brainrot
                                LocalPlayer.Character:MoveTo(topRot.PrimaryPart.Position)
                                task.wait(0.3)

                                -- Pickup the brainrot
                                local prompt = topRot:FindFirstChild("PickupHitbox") and 
                                               topRot.PickupHitbox:FindFirstChildOfClass("ProximityPrompt")

                                if prompt then
                                    repeat
                                        fireproximityprompt(prompt)
                                        task.wait()
                                    until not farming or not topRot or topRot.Parent ~= workspace.SpawnedBrainrots
                                end

                                task.wait(0.3)

                                -- Collect / Sell at the collection point
                                local collectionPart = workspace.Map:FindFirstChild("BrainrotCollectionPart")
                                if collectionPart then
                                    firetouchinterest(LocalPlayer.Character.Head, collectionPart, true)
                                    task.wait(0.1)
                                    firetouchinterest(LocalPlayer.Character.Head, collectionPart, false)
                                end
                            end
                        end)

                        task.wait(0.6)
                    end
                end)
            end
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
        tab.Text("Version: 1.0 - +1 Health for Brainrots")
        tab.Text("Thanks for using the hub!")
    end)
end
