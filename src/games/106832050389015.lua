--[[
src/games/106832050389015.lua — Collect A Meme
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local lp = Players.LocalPlayer
    local CollectPal = ReplicatedStorage:WaitForChild("CollectPal")
    local palsFolder = ReplicatedStorage:WaitForChild("pals")

    local farming = false
    local collected = {}

    local function getHRP()
        local char = lp.Character or lp.CharacterAdded:Wait()
        return char:FindFirstChild("HumanoidRootPart")
    end

    local function isWorldCollected(part)
        local check = part:FindFirstChild("Checkmark")
        return check ~= nil and check:IsA("BillboardGui") and check.Enabled
    end

    local function collectName(name)
        if collected[name] then
            return
        end
        CollectPal:FireServer(name)
        collected[name] = true
    end

    local function collectWorldPal(part)
        if isWorldCollected(part) then
            collected[part.Name] = true
            return
        end

        local hrp = getHRP()
        if hrp then
            hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
            pcall(function()
                firetouchinterest(hrp, part, 0)
                firetouchinterest(hrp, part, 1)
            end)
        end

        collectName(part.Name)
    end

    local function startFarming()
        farming = true
        getgenv().MemeAutoFarm = true
        collected = {}

        task.spawn(function()
            while farming and getgenv().MemeAutoFarm do
                local world = workspace:FindFirstChild("Pals")
                if world then
                    local targets = {}
                    for _, pal in ipairs(world:GetChildren()) do
                        if pal:IsA("BasePart") and not isWorldCollected(pal) and not collected[pal.Name] then
                            table.insert(targets, pal)
                        end
                    end

                    local hrp = getHRP()
                    if hrp then
                        table.sort(targets, function(a, b)
                            return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
                        end)
                    end

                    for _, pal in ipairs(targets) do
                        if not farming or not getgenv().MemeAutoFarm then
                            break
                        end
                        pcall(collectWorldPal, pal)
                        task.wait(0.08)
                    end
                end

                local remoteNames = {}
                for _, v in ipairs(palsFolder:GetChildren()) do
                    if v:IsA("BoolValue") and not collected[v.Name] then
                        local worldPal = world and world:FindFirstChild(v.Name)
                        if not (worldPal and worldPal:IsA("BasePart") and isWorldCollected(worldPal)) then
                            table.insert(remoteNames, v.Name)
                        else
                            collected[v.Name] = true
                        end
                    end
                end

                for i, name in ipairs(remoteNames) do
                    if not farming or not getgenv().MemeAutoFarm then
                        break
                    end
                    pcall(collectName, name)
                    if i % 10 == 0 then
                        task.wait()
                    end
                end

                local memes = lp:FindFirstChild("leaderstats") and lp.leaderstats:FindFirstChild("Memes")
                if memes and memes.Value >= #palsFolder:GetChildren() then
                    break
                end

                task.wait(0.5)
            end

            farming = false
            getgenv().MemeAutoFarm = false
        end)
    end

    local function stopFarming()
        farming = false
        getgenv().MemeAutoFarm = false
    end

    api.Tab("Main", function(tab)
        tab.Toggle("Auto Collect Memes", false, function(state)
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
