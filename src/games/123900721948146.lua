--[[
src/games/123900721948146.lua — Find The Cats
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local lp = Players.LocalPlayer
    local CatCatalog = require(ReplicatedStorage.Shared.Cats.CatCatalog)
    local discover = ReplicatedStorage.Remotes.CatDiscoverAction

    local farming = false

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

    local function resolvePath(path)
        local cur = game
        for part in string.gmatch(path, "[^%.]+") do
            if not cur then
                return nil
            end
            cur = cur:FindFirstChild(part)
        end
        return cur
    end

    local function discoverCat(cat)
        local hrp = ensureAlive()
        if not hrp then
            return false
        end

        local before = lp.leaderstats["Total Found"].Value
        local model = cat.discoveryModelPath and resolvePath(cat.discoveryModelPath)
        local part = model and (model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true))

        if part then
            hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
            task.wait(0.05)
            pcall(function()
                firetouchinterest(hrp, part, 0)
                firetouchinterest(hrp, part, 1)
            end)
        end

        discover:FireServer({ catId = cat.id })
        task.wait(0.12)
        return lp.leaderstats["Total Found"].Value > before
    end

    local function startFarming()
        farming = true
        getgenv().CatsAutoFarm = true

        task.spawn(function()
            local list = {}
            for _, cat in pairs(CatCatalog.getAll()) do
                table.insert(list, cat)
            end

            local hrp = ensureAlive()
            if hrp then
                table.sort(list, function(a, b)
                    local ma = a.discoveryModelPath and resolvePath(a.discoveryModelPath)
                    local mb = b.discoveryModelPath and resolvePath(b.discoveryModelPath)
                    local pa = ma and (ma:IsA("BasePart") and ma or ma:FindFirstChildWhichIsA("BasePart", true))
                    local pb = mb and (mb:IsA("BasePart") and mb or mb:FindFirstChildWhichIsA("BasePart", true))
                    if not pa then
                        return false
                    end
                    if not pb then
                        return true
                    end
                    return (pa.Position - hrp.Position).Magnitude < (pb.Position - hrp.Position).Magnitude
                end)
            end

            for _, cat in ipairs(list) do
                if not farming or not getgenv().CatsAutoFarm then
                    break
                end
                discoverCat(cat)
            end

            for _, cat in ipairs(list) do
                if not farming or not getgenv().CatsAutoFarm then
                    break
                end
                discoverCat(cat)
            end

            farming = false
            getgenv().CatsAutoFarm = false
        end)
    end

    local function stopFarming()
        farming = false
        getgenv().CatsAutoFarm = false
    end

    api.Tab("Main", function(tab)
        tab.Toggle("Auto Collect Cats", false, function(state)
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
