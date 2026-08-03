--[[
src/games/16276623981.lua — Find The Flags
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local lp = Players.LocalPlayer
    local toFind = workspace:WaitForChild("ToFind")
    local farming = false

    local function getChar()
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        return char, hum, hrp
    end

    local function ensureAlive()
        local char, hum, hrp = getChar()
        if not hrp or not hum or hum.Health <= 0 then
            lp:LoadCharacter()
            char = lp.Character or lp.CharacterAdded:Wait()
            hum = char:WaitForChild("Humanoid")
            hrp = char:WaitForChild("HumanoidRootPart")
            task.wait(0.4)
        end
        return char, hum, hrp
    end

    local function enableGod(char, hum)
        pcall(function()
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end)
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end

    local function getFoundSet()
        local found = {}
        local ok, sf = pcall(function()
            return lp.PlayerGui.Flags.Frame.Frame.ScrollingFrame
        end)
        if not ok or not sf then
            return found
        end
        for _, frame in ipairs(sf:GetChildren()) do
            local nf = frame:FindFirstChild("NotFound", true)
            if nf and nf:IsA("TextLabel") and nf.Text == "Found" then
                found[frame.Name] = true
            end
        end
        return found
    end

    local function getType(flag)
        local conf = flag:FindFirstChild("Configuration")
        local t = conf and conf:FindFirstChild("TypeV")
        return t and tostring(t.Value) or ""
    end

    local function touchFlag(flag, loops)
        local char, hum, hrp = ensureAlive()
        if not hrp or not hum or not char then
            return false
        end

        local before = lp.leaderstats.Flags.Value
        enableGod(char, hum)
        hrp.Anchored = false

        for _ = 1, loops do
            if not farming or not getgenv().FlagsAutoFarm then
                break
            end
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(flag.Position + Vector3.new(0, 2.5, 0))
            pcall(function()
                firetouchinterest(hrp, flag, 0)
            end)
            task.wait(0.1)
            pcall(function()
                firetouchinterest(hrp, flag, 1)
            end)
            if lp.leaderstats.Flags.Value > before then
                return true
            end
        end

        hrp.CFrame = flag.CFrame
        task.wait(0.3)
        return lp.leaderstats.Flags.Value > before
    end

    local function startFarming()
        farming = true
        getgenv().FlagsAutoFarm = true

        task.spawn(function()
            pcall(function()
                ReplicatedStorage.GroupReward:FireServer()
            end)

            local stagnantPasses = 0

            while farming and getgenv().FlagsAutoFarm do
                local found = getFoundSet()
                local targets = {}
                for _, flag in ipairs(toFind:GetChildren()) do
                    if flag:IsA("BasePart") and not found[flag.Name] then
                        table.insert(targets, flag)
                    end
                end

                local _, _, hrp = ensureAlive()
                if hrp then
                    table.sort(targets, function(a, b)
                        return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
                    end)
                end

                if #targets == 0 then
                    break
                end

                local beforePass = lp.leaderstats.Flags.Value
                for _, flag in ipairs(targets) do
                    if not farming or not getgenv().FlagsAutoFarm then
                        break
                    end

                    if lp.leaderstats.Flags.Value % 10 == 0 then
                        found = getFoundSet()
                        if found[flag.Name] then
                            continue
                        end
                    end

                    local loops = 18
                    local t = getType(flag)
                    if t == "Legendary" or t == "Unknown" or t == "Rare" then
                        loops = 28
                    end

                    touchFlag(flag, loops)

                    if getType(flag) == "Group" then
                        pcall(function()
                            ReplicatedStorage.GroupReward:FireServer()
                        end)
                    end
                end

                local gained = lp.leaderstats.Flags.Value - beforePass
                if gained <= 0 then
                    stagnantPasses += 1
                    if stagnantPasses >= 3 then
                        break
                    end
                else
                    stagnantPasses = 0
                end

                task.wait(0.4)
            end

            farming = false
            getgenv().FlagsAutoFarm = false
        end)
    end

    local function stopFarming()
        farming = false
        getgenv().FlagsAutoFarm = false
    end

    api.Tab("Main", function(tab)
        tab.Toggle("Auto Collect Flags", false, function(state)
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
