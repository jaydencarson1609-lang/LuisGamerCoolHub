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
    local autoBuySpeed = false
    local autoBuyMultiplier = false
    local autoBuySpawnSpeed = false

    local function getBits()
        local stats = lp:FindFirstChild("leaderstats")
        local bits = stats and stats:FindFirstChild("Bits")
        if bits then
            return bits.Value
        end
        return tonumber(lp:GetAttribute("TotalBits")) or 0
    end

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

    local function speedUpgradeCost()
        local level = lp:GetAttribute("SpeedUpgradeLevel") or 0
        return math.floor(500 + 100 * 1.5 ^ level)
    end

    local function multiplierUpgradeCost()
        local level = lp:GetAttribute("MultiplierUpgradeLevel") or 0
        return math.floor(1000 + 100 * 2 ^ level)
    end

    local function spawnSpeedUpgradeCost()
        local level = lp:GetAttribute("SpawnSpeedUpgradeLevel") or 0
        return math.floor(500 + 100 * 1.75 ^ level)
    end

    local function tryBuySpeed()
        if (lp:GetAttribute("SpeedUpgradeLevel") or 0) >= 10 then
            return false
        end
        if getBits() < speedUpgradeCost() then
            return false
        end
        local ok, result = pcall(function()
            return BuySpeedUpgrade:InvokeServer()
        end)
        return ok and type(result) == "table" and result.success == true
    end

    local function tryBuyMultiplier()
        if (lp:GetAttribute("MultiplierUpgradeLevel") or 0) >= 20 then
            return false
        end
        if getBits() < multiplierUpgradeCost() then
            return false
        end
        local ok, result = pcall(function()
            return BuyMultiplierUpgrade:InvokeServer()
        end)
        return ok and type(result) == "table" and result.success == true
    end

    local function tryBuySpawnSpeed()
        if (lp:GetAttribute("SpawnSpeedUpgradeLevel") or 0) >= 28 then
            return false
        end
        if getBits() < spawnSpeedUpgradeCost() then
            return false
        end
        local ok, result = pcall(function()
            return BuySpawnSpeedUpgrade:InvokeServer()
        end)
        return ok and type(result) == "table" and result.success == true
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

        tab.Toggle("Speed Boost", false, function(state)
            speedBoost = state == true
            applySpeed()
        end)

        tab.Section("Auto Upgrades")

        tab.Toggle("Auto Buy Speed Upgrade", false, function(state)
            autoBuySpeed = state == true
            if not autoBuySpeed then
                return
            end

            task.spawn(function()
                while autoBuySpeed do
                    pcall(tryBuySpeed)
                    task.wait(0.5)
                end
            end)
        end)

        tab.Toggle("Auto Buy Multiplier Upgrade", false, function(state)
            autoBuyMultiplier = state == true
            if not autoBuyMultiplier then
                return
            end

            task.spawn(function()
                while autoBuyMultiplier do
                    pcall(tryBuyMultiplier)
                    task.wait(0.5)
                end
            end)
        end)

        tab.Toggle("Auto Buy Spawn Speed Upgrade", false, function(state)
            autoBuySpawnSpeed = state == true
            if not autoBuySpawnSpeed then
                return
            end

            task.spawn(function()
                while autoBuySpawnSpeed do
                    pcall(tryBuySpawnSpeed)
                    task.wait(0.5)
                end
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
        tab.Text("Version: 1.1 - Auto upgrade toggles")
        tab.Text("Thanks for using the hub!")
    end)
end
