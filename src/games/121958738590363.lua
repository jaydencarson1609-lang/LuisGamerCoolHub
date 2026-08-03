--[[
src/games/121958738590363.lua — Find the Digital Circus
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local lp = Players.LocalPlayer
    local GiveEntity = ReplicatedStorage:WaitForChild("Communication"):WaitForChild("Functions"):WaitForChild("GiveEntity")
    local EntityData = require(ReplicatedStorage:WaitForChild("DataModules"):WaitForChild("EntityData"))

    local farming = false
    local done = {}

    local function getHRP()
        local char = lp.Character or lp.CharacterAdded:Wait()
        return char:FindFirstChild("HumanoidRootPart")
    end

    local function collectName(name)
        if done[name] then
            return false
        end
        local ok, result = pcall(function()
            return GiveEntity:InvokeServer(name)
        end)
        if ok and result then
            done[name] = true
            return true
        end
        if ok and result == false then
            done[name] = true
        end
        return false
    end

    local function touchNearbyBoxes()
        local hrp = getHRP()
        local boxes = workspace:FindFirstChild("BoundingBoxCache")
        if not hrp or not boxes then
            return
        end

        for _, box in ipairs(boxes:GetChildren()) do
            if not farming or not getgenv().CircusAutoFarm then
                break
            end
            if box:IsA("BasePart") then
                hrp.CFrame = CFrame.new(box.Position + Vector3.new(0, 3, 0))
                pcall(function()
                    firetouchinterest(hrp, box, 0)
                    firetouchinterest(hrp, box, 1)
                end)
                task.wait(0.05)
            end
        end
    end

    local function startFarming()
        farming = true
        getgenv().CircusAutoFarm = true
        done = {}

        task.spawn(function()
            local names = {}
            for name, _ in pairs(EntityData) do
                if typeof(name) == "string" then
                    table.insert(names, name)
                end
            end
            table.sort(names)

            for i, name in ipairs(names) do
                if not farming or not getgenv().CircusAutoFarm then
                    break
                end
                collectName(name)
                if i % 5 == 0 then
                    task.wait()
                end
            end

            local spawns = workspace:FindFirstChild("EntitySpawns")
            if spawns then
                for _, part in ipairs(spawns:GetChildren()) do
                    if not farming or not getgenv().CircusAutoFarm then
                        break
                    end
                    collectName(part.Name)
                end
            end

            pcall(touchNearbyBoxes)

            farming = false
            getgenv().CircusAutoFarm = false
        end)
    end

    local function stopFarming()
        farming = false
        getgenv().CircusAutoFarm = false
    end

    api.Tab("Main", function(tab)
        tab.Toggle("Auto Collect Entities", false, function(state)
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
