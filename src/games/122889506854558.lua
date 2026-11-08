--[[
    src/games/122889506854558.lua  —  Find and Snipe Brainrot
    LuisGamerCoolHub

    Features:
      Main     : Auto Snipe / Kill Bullet / No Spread / Auto Upgrade Floor
                 Auto Sell All / Auto Rebirth / Auto Collect Money
      Economy  : Range sliders, Sell interval, Rebirth threshold
      Teleports: Base, Sell Shop, Boss spawns, Workshop
      Extra    : Infinite Yield, Dex Explorer
      Credits

    Remotes discovered via client-side decomp:
      ShootEvent:FireServer(muzzleWorldPos, directionUnit)
      shared.RE:Get("Player"):FireServer("SetKillBulletOn", bool)
      shared.RE:Get("Floor"):FireServer("UpgradeFloor")
      shared.RE:Get("Rebirth"):FireServer("Rebirth")
      shared.RE:Get("SellF"):InvokeServer("SellAll" | "TryEnter" | "SellCurrentTiger")
      shared.RE:Get("Player"):FireServer("ChangePlayerPos", pos, rotY, ...)
]]

pcall(function()
    local Event = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
    if Event and Event:FindFirstChild("ShowNotification") and typeof(firesignal) == "function" then
        firesignal(Event.ShowNotification.OnClientEvent, "LuisGamerCoolHub loaded", "Success")
    end
end)

return function(_, api)
    local Players          = game:GetService("Players")
    local RunService       = game:GetService("RunService")
    local ReplicatedStorage= game:GetService("ReplicatedStorage")
    local CollectionService= game:GetService("CollectionService")
    local VirtualUser      = game:GetService("VirtualUser")
    local Workspace        = game:GetService("Workspace")
    local LP               = Players.LocalPlayer

    -----------------------------------------------------------------
    -- shared primitives
    -----------------------------------------------------------------
    local Core
    do
        local ok, src = pcall(function()
            return game:HttpGet(
                "https://raw.githubusercontent.com/jaydencarson1609-lang/LuisGamerCoolHub/main/src/lib/brainrot_core.lua?cache="
                .. tostring(os.time())
            )
        end)
        if ok and type(src) == "string" and #src > 0 then
            local fn = loadstring(src)
            if fn then Core = fn() end
        end
        if not Core then
            -- minimal inline fallback if the lib fetch fails
            Core = {}
            function Core.getChar()   return LP.Character or LP.CharacterAdded:Wait() end
            function Core.getRoot()
                local c = Core.getChar()
                return c:FindFirstChild("HumanoidRootPart") or c:WaitForChild("HumanoidRootPart", 5)
            end
            function Core.teleport(cf)
                local r = Core.getRoot(); if not r or not cf then return end
                r.AssemblyLinearVelocity = Vector3.zero
                r.AssemblyAngularVelocity = Vector3.zero
                r.CFrame = typeof(cf) == "Vector3" and CFrame.new(cf) or cf
            end
            function Core.AntiAFK()
                local c
                c = LP.Idled:Connect(function()
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                end)
                return { stop = function() if c then c:Disconnect() end end }
            end
        end
    end

    -----------------------------------------------------------------
    -- shared.RE resolver (game may not have loaded it yet)
    -----------------------------------------------------------------
    local function getSharedRE(name)
        if shared and shared.RE and typeof(shared.RE.Get) == "function" then
            local ok, r = pcall(shared.RE.Get, shared.RE, name)
            if ok and r then return r end
        end
        -- fallback: ReplicatedStorage.Remote.<name>
        local remoteFolder = ReplicatedStorage:FindFirstChild("Remote")
        return remoteFolder and remoteFolder:FindFirstChild(name)
    end

    local function fireRE(name, action, ...)
        local r = getSharedRE(name)
        if not r or not r.FireServer then return false end
        local args = { action, ... }
        local ok = pcall(function() r:FireServer(unpack(args)) end)
        return ok
    end

    local function invokeRE(name, action, ...)
        local r = getSharedRE(name)
        if not r or not r.InvokeServer then return false end
        local args = { action, ... }
        local ok, ret = pcall(function() return r:InvokeServer(unpack(args)) end)
        if ok then return true, ret end
        return false
    end

    -----------------------------------------------------------------
    -- ShootEvent (direct remote, not through shared.RE)
    -----------------------------------------------------------------
    local ShootEvent = ReplicatedStorage:FindFirstChild("Remote")
    ShootEvent = ShootEvent and ShootEvent:FindFirstChild("ShootEvent")

    -----------------------------------------------------------------
    -- Brainrot discovery
    -----------------------------------------------------------------
    local function isBrainrot(m)
        if not m or not m:IsA("Model") then return false end
        if not m:FindFirstChildOfClass("Humanoid") then return false end
        if not m:FindFirstChild("DecorationId") then return false end
        local hp = m:FindFirstChild("CurrentHP")
        if hp and hp.Value <= 0 then return false end
        return true
    end

    local function listBrainrots()
        local t = {}
        for _, c in ipairs(Workspace:GetChildren()) do
            if isBrainrot(c) then table.insert(t, c) end
        end
        return t
    end

    local QUALITY_WEIGHTS = {
        Common = 1, Rare = 2, Epic = 3, Legendary = 4, Mythical = 5,
        Secret = 6, Celestial = 7, Divine = 8,
    }
    local function qualityWeight(m)
        local q = m:FindFirstChild("Quality")
        return q and QUALITY_WEIGHTS[q.Value] or 1
    end

    local function bestBrainrot(maxRange, bestQualityOnly)
        local root = Core.getRoot(0); if not root then return nil end
        local best, bestScore
        for _, m in ipairs(listBrainrots()) do
            local hrp = m:FindFirstChild("HumanoidRootPart") or m:FindFirstChild("ScopeHitbox")
            if hrp then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist <= maxRange then
                    local score = qualityWeight(m) * 10000 - dist
                    if not bestScore or score > bestScore then
                        best, bestScore = m, score
                    end
                end
            end
            -- fast-exit if we only care about the first high-quality
            if bestQualityOnly and best and qualityWeight(best) >= 6 then
                return best
            end
        end
        return best
    end

    -----------------------------------------------------------------
    -- equipped tool + muzzle
    -----------------------------------------------------------------
    local function equippedTool()
        local c = LP.Character
        return c and c:FindFirstChildOfClass("Tool")
    end

    local function muzzleWorldPosition()
        local tool = equippedTool(); if not tool then return nil end
        for _, d in ipairs(tool:GetDescendants()) do
            if d.Name == "Muzzle" then
                if d:IsA("Attachment") then return d.WorldPosition end
                if d:IsA("BasePart")  then return d.Position end
            end
        end
        local handle = tool:FindFirstChild("Handle")
        return handle and handle.Position or nil
    end

    -----------------------------------------------------------------
    -- state
    -----------------------------------------------------------------
    local S = {
        autoShoot        = false,
        autoShootRange   = 500,
        autoShootRate    = 0.08,   -- seconds between shots (clamped by tool fire rate on server)
        bestQualityOnly  = false,
        killBullet       = false,
        autoUpgrade      = false,
        upgradeInterval  = 1.5,
        autoSell         = false,
        sellInterval     = 8,
        autoRebirth      = false,
        rebirthInterval  = 30,
        autoDailyLogin   = false,
        antiAFK          = nil,
    }

    -----------------------------------------------------------------
    -- status label + ranking refresh
    -----------------------------------------------------------------
    local status

    local function refreshRanking()
        if not status then return end
        local ok, data = invokeRE("RankF", "OnGetCurrRanking")
        if ok and type(data) == "table" and data.cash then
            status.setText(string.format("Cash: %s · Server Rank: #%s",
                tostring(data.cash),
                tostring(data.rank or "?")))
        end
    end

    -----------------------------------------------------------------
    -- loops
    -----------------------------------------------------------------
    local function startAutoShoot()
        task.spawn(function()
            while S.autoShoot do
                task.wait(S.autoShootRate)
                if not ShootEvent then continue end
                local muzzle = muzzleWorldPosition()
                if not muzzle then continue end
                local target = bestBrainrot(S.autoShootRange, S.bestQualityOnly)
                if not target then continue end
                local hrp = target:FindFirstChild("ScopeHitbox")
                            or target:FindFirstChild("HumanoidRootPart")
                if not hrp then continue end
                local dir = (hrp.Position - muzzle).Unit
                pcall(function() ShootEvent:FireServer(muzzle, dir) end)
            end
        end)
    end

    local function startAutoUpgrade()
        task.spawn(function()
            while S.autoUpgrade do
                fireRE("Floor", "UpgradeFloor")
                task.wait(S.upgradeInterval)
            end
        end)
    end

    local function startAutoSell()
        task.spawn(function()
            while S.autoSell do
                invokeRE("SellF", "TryEnter")
                invokeRE("SellF", "SellAll")
                task.wait(S.sellInterval)
            end
        end)
    end

    local function startAutoRebirth()
        task.spawn(function()
            while S.autoRebirth do
                fireRE("Rebirth", "Rebirth")
                task.wait(S.rebirthInterval)
            end
        end)
    end

    local function startAutoCollectMoney()
        task.spawn(function()
            while S.autoShoot or S.autoCollect do
                for _, trig in ipairs(CollectionService:GetTagged("MoneyTrigger")) do
                    if typeof(firetouchinterest) == "function" then
                        local char = LP.Character
                        local head = char and (char:FindFirstChild("Head") or char.PrimaryPart)
                        if head and trig:IsA("BasePart") then
                            pcall(firetouchinterest, head, trig, 0)
                            pcall(firetouchinterest, head, trig, 1)
                        end
                    end
                end
                task.wait(0.6)
            end
        end)
    end

    -- keep a lightweight status refresher running
    task.spawn(function()
        while true do
            pcall(refreshRanking)
            task.wait(4)
        end
    end)

    -----------------------------------------------------------------
    -- MAIN TAB
    -----------------------------------------------------------------
    api.Tab("Main", function(tab)
        tab.Section("Combat")

        tab.Toggle("Auto Snipe Brainrots", false, function(v)
            S.autoShoot = v
            if v then
                startAutoShoot()
                S.autoCollect = true
                startAutoCollectMoney()
            else
                S.autoCollect = false
            end
        end)

        tab.Toggle("Kill Bullet (one-shot)", false, function(v)
            S.killBullet = v
            fireRE("Player", "SetKillBulletOn", v)
        end)

        tab.Toggle("Best Quality Only", false, function(v)
            S.bestQualityOnly = v
        end)

        tab.Slider("Range (studs)", 50, 2000, S.autoShootRange, 1, function(v)
            S.autoShootRange = v
        end)

        tab.Slider("Shot Interval (seconds)", 0.03, 1.0, S.autoShootRate, 100, function(v)
            S.autoShootRate = v
        end)

        tab.Section("Economy")

        tab.Toggle("Auto Upgrade Floor", false, function(v)
            S.autoUpgrade = v
            if v then startAutoUpgrade() end
        end)

        tab.Slider("Upgrade Interval (seconds)", 0.5, 10, S.upgradeInterval, 10, function(v)
            S.upgradeInterval = v
        end)

        tab.Toggle("Auto Sell All", false, function(v)
            S.autoSell = v
            if v then startAutoSell() end
        end)

        tab.Slider("Sell Interval (seconds)", 2, 60, S.sellInterval, 1, function(v)
            S.sellInterval = v
        end)

        tab.Toggle("Auto Rebirth", false, function(v)
            S.autoRebirth = v
            if v then startAutoRebirth() end
        end)

        tab.Slider("Rebirth Interval (seconds)", 10, 300, S.rebirthInterval, 1, function(v)
            S.rebirthInterval = v
        end)
    end)

    -----------------------------------------------------------------
    -- TELEPORTS TAB
    -----------------------------------------------------------------
    api.Tab("Teleports", function(tab)
        tab.Section("Quick Travel")

        tab.Button("To Base", function()
            local char = LP.Character
            if not char then return end
            -- a base plot is "Plot_<name>" or similar — try common names
            for _, n in ipairs({ "Plot_"..LP.Name, "Base_"..LP.Name, "Elevator" }) do
                local p = Workspace:FindFirstChild(n, true)
                if p then
                    if p:IsA("Model") then
                        Core.teleport(p:GetPivot())
                    else
                        Core.teleport(p.CFrame + Vector3.new(0, 4, 0))
                    end
                    return
                end
            end
        end)

        tab.Button("To Sell Shop", function()
            invokeRE("SellF", "TryEnter")
            for _, trig in ipairs(CollectionService:GetTagged("ShopTrigger")) do
                if trig:IsA("BasePart") then
                    Core.teleport(trig.CFrame + Vector3.new(0, 3, 0))
                    return
                end
            end
        end)

        tab.Button("To Nearest Brainrot", function()
            local t = bestBrainrot(math.huge, false)
            if not t then return end
            local hrp = t:FindFirstChild("HumanoidRootPart")
            if hrp then Core.teleport(hrp.CFrame + Vector3.new(0, 4, 4)) end
        end)

        tab.Button("To Highest Quality Brainrot", function()
            local t = bestBrainrot(math.huge, true)
            if not t then return end
            local hrp = t:FindFirstChild("HumanoidRootPart")
            if hrp then Core.teleport(hrp.CFrame + Vector3.new(0, 4, 4)) end
        end)

        tab.Section("Boss / Event Spawns")
        tab.Button("To Celestial Spawn", function()
            for _, p in ipairs(Workspace:GetChildren()) do
                if p.Name:find("Celestial") and p:IsA("BasePart") then
                    Core.teleport(p.CFrame + Vector3.new(0, 4, 0)); return
                end
            end
            local f = Workspace:FindFirstChild("CelestialTigerSpawnPoints")
            if f then
                for _, p in ipairs(f:GetChildren()) do
                    if p:IsA("BasePart") then
                        Core.teleport(p.CFrame + Vector3.new(0, 4, 0)); return
                    end
                end
            end
        end)
    end)

    -----------------------------------------------------------------
    -- INFO TAB
    -----------------------------------------------------------------
    api.Tab("Info", function(tab)
        tab.Section("Server")
        status = tab.Status("Ranking", "fetching...", Color3.fromRGB(230, 230, 230))
        tab.Button("Refresh Ranking", refreshRanking)

        tab.Section("Utilities")
        tab.Toggle("Anti-AFK", false, function(v)
            if v then
                if not S.antiAFK then S.antiAFK = Core.AntiAFK() end
            else
                if S.antiAFK and S.antiAFK.stop then S.antiAFK.stop(); S.antiAFK = nil end
            end
        end)
    end)

    -----------------------------------------------------------------
    -- EXTRA TAB
    -----------------------------------------------------------------
    api.Tab("Extra", function(tab)
        tab.Button("Infinite Yield", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
        tab.Button("Dex Explorer", function()
            loadstring(game:HttpGet("https://github.com/BOXLEGENDARY/Dex/releases/latest/download/out.lua"))()
        end)
    end)

    -----------------------------------------------------------------
    -- CREDITS
    -----------------------------------------------------------------
    api.Tab("Credits", function(tab)
        tab.Text("LuisGamerCoolHub")
        tab.Text("Find and Snipe Brainrot module")
        tab.Text("Target: 122889506854558")
        tab.Text("Version: 1.0")
    end)
end
