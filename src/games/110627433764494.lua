--[[
src/games/110627433764494.lua — Fake a Brainrot
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local plots = workspace.Plots
    local lazerevent = game:GetService("ReplicatedStorage").Events.LaserVisibility
    local fakeevent = game:GetService("ReplicatedStorage").Events.FakeSystem_StartFake

    local farming = false
    local fakeBrainrot = "Tim Cheese"

    api.Tab("Main", function(tab)
        tab.Input("Brainrot to Fake", "Tim Cheese", "", function(text)
            fakeBrainrot = text
        end)

        tab.Toggle("Farm Stealing", false, function(state)
            farming = state
            if state then
                task.spawn(function()
                    while farming do
                        pcall(function()
                            fakeevent:FireServer(fakeBrainrot)

                            local complete = false
                            local connection

                            task.spawn(function()
                                while not complete do
                                    LocalPlayer.Character.Humanoid:MoveTo(Vector3.new(
                                        math.random(-37, 80), 0, math.random(-399, -119)
                                    ))
                                    task.wait(math.random(1, 5))
                                end
                            end)

                            connection = lazerevent.OnClientEvent:Connect(function(userId, isOn)
                                if isOn then return end
                                for _, plot in ipairs(plots:GetChildren()) do
                                    if plot:GetAttribute("OwnerUserId") == userId then
                                        for _, slot in ipairs(plot.Slots:GetChildren()) do
                                            if slot:FindFirstChild("PlacedBrainrot") then
                                                LocalPlayer.Character:MoveTo(slot.PlacedBrainrot.PrimaryPart.Position)
                                                repeat
                                                    fireproximityprompt(slot.StealPrompt)
                                                    task.wait()
                                                until not slot.StealPrompt.Enabled
                                                LocalPlayer.Character:MoveTo(plot.CollectAllZone.Position)
                                                task.wait(1)
                                                complete = true
                                                break
                                            end
                                        end
                                    end
                                end
                                if connection then connection:Disconnect() end
                            end)

                            repeat task.wait(0.5) until complete
                        end)
                        task.wait(0.5)
                    end
                end)
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
        tab.Text("Version: 1.0 - Fake a Brainrot")
        tab.Text("Thanks for using the hub!")
    end)
end
