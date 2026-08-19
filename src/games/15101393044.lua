--[[
src/games/15101393044.lua — Dress to Impress
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local lp = Players.LocalPlayer
    local crashing = false

    local function startGameCrash()
        if crashing then
            return
        end
        crashing = true

        task.spawn(function()
            local distanceX = 10
            local distanceY = -1
            local addon = true
            local char = lp.Character

            task.spawn(function()
                while crashing and task.wait() do
                    distanceX = addon and distanceX + 1 or distanceX - 1
                    if distanceX >= 60 then
                        addon = false
                    elseif distanceX <= 5 then
                        addon = true
                    end
                end
            end)

            if char and char:FindFirstChild("Head") then
                char.Head:Destroy()
            end

            char = lp.CharacterAdded:Wait()
            char:WaitForChild("HumanoidRootPart")

            local remotes = ReplicatedStorage:WaitForChild("RemoteEvents")
            local addVFX = remotes:WaitForChild("AddVFX")
            local emitVFX = remotes:WaitForChild("EmitVFX")
            local camera3 = workspace:WaitForChild("Locators"):WaitForChild("Runway"):WaitForChild("Camera3")

            local angle = 0
            while crashing do
                angle += math.rad(15)
                addVFX:FireServer("Gassy")
                emitVFX:FireServer("Gassy")
                addVFX:FireServer("WaterPose")
                emitVFX:FireServer("WaterPose")

                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame =
                        CFrame.new(camera3.Position + Vector3.new(distanceX, distanceY, 0))
                        * CFrame.Angles(angle, angle, 0)
                end

                task.wait()
            end
        end)
    end

    api.Tab("Main", function(tab)
        tab.Button("Game Crash", function()
            startGameCrash()
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
