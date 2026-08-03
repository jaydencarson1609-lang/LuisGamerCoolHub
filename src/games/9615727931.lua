--[[
src/games/9615727931.lua — Find The Eggs
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local lp = Players.LocalPlayer
    local farming = false
    local collected = {}

    local function ensureAlive()
        local char = lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not hrp or hum.Health <= 0 then
            lp:LoadCharacter()
            char = lp.Character or lp.CharacterAdded:Wait()
            hum = char:WaitForChild("Humanoid")
            hrp = char:WaitForChild("HumanoidRootPart")
            task.wait(0.3)
        end
        pcall(function()
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end)
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
        hrp.Anchored = false
        return hrp
    end

    local function isEggPart(inst)
        return inst:IsA("BasePart") and inst:FindFirstChild("Difficulty") ~= nil
    end

    local function touchEgg(egg)
        if collected[egg.Name] then
            return false
        end

        local hrp = ensureAlive()
        if not hrp then
            return false
        end

        if not egg:IsDescendantOf(workspace) then
            local eggsFolder = workspace:FindFirstChild("Eggs")
            egg.Parent = eggsFolder or workspace
        end

        local before = lp.leaderstats.Eggs.Value
        for _ = 1, 14 do
            if not farming or not getgenv().EggsAutoFarm then
                break
            end
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(egg.Position + Vector3.new(0, 3, 0))
            pcall(function()
                firetouchinterest(hrp, egg, 0)
            end)
            task.wait(0.07)
            pcall(function()
                firetouchinterest(hrp, egg, 1)
            end)
            if lp.leaderstats.Eggs.Value > before then
                collected[egg.Name] = true
                return true
            end
        end

        hrp.CFrame = egg.CFrame
        task.wait(0.2)
        local ok = lp.leaderstats.Eggs.Value > before
        if ok then
            collected[egg.Name] = true
        end
        return ok
    end

    local function gatherEggs()
        local eggs = {}
        local seen = {}

        local function addFrom(root)
            if not root then
                return
            end
            for _, inst in ipairs(root:GetDescendants()) do
                if isEggPart(inst) and not seen[inst] then
                    if inst:IsDescendantOf(workspace.CurrentCamera) then
                        continue
                    end
                    seen[inst] = true
                    table.insert(eggs, inst)
                end
            end
            for _, inst in ipairs(root:GetChildren()) do
                if isEggPart(inst) and not seen[inst] then
                    seen[inst] = true
                    table.insert(eggs, inst)
                end
            end
        end

        addFrom(workspace:FindFirstChild("Eggs"))
        addFrom(ReplicatedStorage:FindFirstChild("NewEggs"))
        addFrom(ReplicatedStorage:FindFirstChild("Eggs2"))
        addFrom(workspace:FindFirstChild("Map"))
        addFrom(workspace:FindFirstChild("Areas"))

        local hrp = ensureAlive()
        if hrp then
            table.sort(eggs, function(a, b)
                return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
            end)
        end
        return eggs
    end

    local function startFarming()
        farming = true
        getgenv().EggsAutoFarm = true
        collected = {}

        task.spawn(function()
            local stagnant = 0

            while farming and getgenv().EggsAutoFarm do
                local eggs = gatherEggs()
                local before = lp.leaderstats.Eggs.Value

                for _, egg in ipairs(eggs) do
                    if not farming or not getgenv().EggsAutoFarm then
                        break
                    end
                    if not collected[egg.Name] then
                        pcall(touchEgg, egg)
                    end
                end

                if lp.leaderstats.Eggs.Value - before <= 0 then
                    stagnant += 1
                    if stagnant >= 3 then
                        break
                    end
                else
                    stagnant = 0
                end
                task.wait(0.3)
            end

            farming = false
            getgenv().EggsAutoFarm = false
        end)
    end

    local function stopFarming()
        farming = false
        getgenv().EggsAutoFarm = false
    end

    api.Tab("Main", function(tab)
        tab.Toggle("Auto Collect Eggs", false, function(state)
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
