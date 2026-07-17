--[[
src/games/114640202062357.lua — Swing Obby for Brainrots
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local farming = false

    api.Tab("Main", function(tab)
        tab.Toggle("Autofarm", false, function(state)
            farming = state
            if state then
                task.spawn(function()
                    while farming do
                        pcall(function()
                            game:GetService("ReplicatedStorage").Packages.Knit.Services.GameplayService.RF.ReturnToPlot:InvokeServer()
                            task.wait(0.5)

                            for _, v in ipairs(workspace.ActiveBrainrots:GetChildren()) do
                                if v:GetAttribute("Zone") == 14 or v:GetAttribute("Zone") == 13 then
                                    LocalPlayer.Character:PivotTo(v.CFrame)
                                    repeat
                                        fireproximityprompt(v.Attachment.ProximityPrompt)
                                        task.wait()
                                    until not farming or not v or v.Parent ~= workspace.ActiveBrainrots
                                end
                            end
                        end)
                        task.wait(1)
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
        tab.Text("Version: 1.0 - Swing Obby for Brainrots")
        tab.Text("Thanks for using the hub!")
    end)
end
