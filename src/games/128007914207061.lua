--[[
src/games/128007914207061.lua — Find The YouTuber
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local lp = Players.LocalPlayer
    local brainrots = ReplicatedStorage:WaitForChild("brainrots")
    local farming = false

    local function getHRP()
        local char = lp.Character or lp.CharacterAdded:Wait()
        return char:FindFirstChild("HumanoidRootPart")
    end

    local function collectPart(part)
        local hrp = getHRP()
        if not hrp then
            return
        end

        hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
        pcall(function()
            firetouchinterest(hrp, part, 0)
            task.wait(0.05)
            firetouchinterest(hrp, part, 1)
        end)
        hrp.CFrame = part.CFrame
        task.wait(0.35)
    end

    local function startFarming()
        farming = true
        getgenv().YouTuberAutoFarm = true

        task.spawn(function()
            while farming and getgenv().YouTuberAutoFarm do
                local anyMissing = false

                for _, v in ipairs(brainrots:GetChildren()) do
                    if not farming or not getgenv().YouTuberAutoFarm then
                        break
                    end

                    local part = workspace:FindFirstChild(v.Name, true)
                    if part and part:IsA("BasePart") then
                        anyMissing = true
                        pcall(collectPart, part)
                    end
                end

                if not anyMissing then
                    break
                end
                task.wait(0.5)
            end

            farming = false
            getgenv().YouTuberAutoFarm = false
        end)
    end

    local function stopFarming()
        farming = false
        getgenv().YouTuberAutoFarm = false
    end

    api.Tab("Main", function(tab)
        tab.Toggle("Auto Collect YouTubers", false, function(state)
            if state then
                startFarming()
            else
                stopFarming()
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
