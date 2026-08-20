--[[
src/games/131159351966135.lua — Brick Collectors
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local lp = Players.LocalPlayer
    local GetBitValue = ReplicatedStorage:WaitForChild("GetBitValue")
    local BuySpeedUpgrade = ReplicatedStorage:WaitForChild("BuySpeedUpgrade")
    local BuyMultiplierUpgrade = ReplicatedStorage:WaitForChild("BuyMultiplierUpgrade")
    local BuySpawnSpeedUpgrade = ReplicatedStorage:WaitForChild("BuySpawnSpeedUpgrade")

    local autoCollect = false
    local speedBoost = false

    local function getCollector()
        return workspace:FindFirstChild("Collector")
    end

    local function isOwnedBit(part)
        if not part or not part:IsA("BasePart") then
            return false
        end
        if part:GetAttribute("Owner") == lp.UserId then
            return true
        end
        local name = string.lower(part.Name)
        return string.find(name, " bit", 1, true) ~= nil and part:FindFirstChildOfClass("BillboardGui") ~= nil
    end

    local function collectBit(part)
        if not part or not part.Parent then
            return
        end

        local collector = getCollector()
        local name = part.Name

        if collector and part:IsA("BasePart") then
            pcall(function()
                part.CFrame = collector.CFrame
                part.AssemblyLinearVelocity = Vector3.zero
            end)
            pcall(function()
                firetouchinterest(part, collector, 0)
                firetouchinterest(part, collector, 1)
            end)
        end

        pcall(function()
            GetBitValue:InvokeServer(name)
        end)

        if part.Parent then
            pcall(function()
                part:Destroy()
            end)
        end
    end

    local function collectAll()
        local collector = getCollector()
        if collector then
            collector.CanTouch = true
            collector.CanQuery = true
        end

        for _, inst in ipairs(workspace:GetChildren()) do
            if isOwnedBit(inst) then
                collectBit(inst)
            end
        end
    end

    local function applySpeed()
        local char = lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = speedBoost and 80 or 16
        end
    end

    lp.CharacterAdded:Connect(function()
        task.wait(0.3)
        applySpeed()
    end)

    api.Tab("Main", function(tab)
        tab.Section("Collect")

        tab.Toggle("Auto Collect Bricks", false, function(state)
            autoCollect = state == true
            if not autoCollect then
                return
            end

            task.spawn(function()
                while autoCollect do
                    pcall(collectAll)
                    task.wait(0.05)
                end
            end)
        end)

        tab.Button("Collect All Bricks", function()
            collectAll()
        end)

        tab.Section("Movement")

        tab.Toggle("Speed Boost", false, function(state)
            speedBoost = state == true
            applySpeed()
        end)

        tab.Section("Upgrades")

        tab.Button("Buy Speed Upgrade", function()
            pcall(function()
                BuySpeedUpgrade:InvokeServer()
            end)
        end)

        tab.Button("Buy Multiplier Upgrade", function()
            pcall(function()
                BuyMultiplierUpgrade:InvokeServer()
            end)
        end)

        tab.Button("Buy Spawn Speed Upgrade", function()
            pcall(function()
                BuySpawnSpeedUpgrade:InvokeServer()
            end)
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
        tab.Text("Version: 1.0 - Brick Collectors")
        tab.Text("Thanks for using the hub!")
    end)
end
