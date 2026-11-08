--[[
    src/games/122889506854558.lua  —  Find and Snipe Brainrot
    LuisGamerCoolHub  //  v2.0

    Tabs:
      Combat    : Auto Snipe · Kill Bullet · Loop Nuke All · One-Click
                  Nuke button · Shots-per-target · Range · Interval
      Farm      : Auto Upgrade Floor · Auto Sell All · Auto Rebirth ·
                  Auto Collect Money · intervals
      Player    : Walk Speed · Jump Power · Infinite Jump
      Auto      : Auto Daily · Auto Spin · Auto Quest Claim · Auto Use Items
      Teleports : Base · Sell Shop · Nearest · Highest Quality · Celestial
      Info      : Live ranking · Cash · Server info · Anti-AFK
      Extra     : Infinite Yield · Dex Explorer
      Credits

    Remotes (decomp-verified):
      ShootEvent:FireServer(muzzleWorldPos, directionUnit)
      shared.RE:Get("Player"):FireServer("SetKillBulletOn", bool)
      shared.RE:Get("Floor"):FireServer("UpgradeFloor")
      shared.RE:Get("Rebirth"):FireServer("Rebirth")
      shared.RE:Get("SellF"):InvokeServer("SellAll" | "TryEnter")
      shared.RE:Get("Daily"):FireServer("OnClaimReward", index)
      shared.RE:Get("Spin"):FireServer("PlayerSpin")
      shared.RE:Get("Quest"):FireServer("ClaimQuest", a, b)
      shared.RE:Get("Item"):FireServer("UseItem", id, count)
      shared.RE:Get("Speed"):FireServer("UpgradeSpeed", slot)
      shared.RE:Get("RankF"):InvokeServer("OnGetCurrRanking")
]]

pcall(function()
    local Event = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
    if Event and Event:FindFirstChild("ShowNotification") and typeof(firesignal) == "function" then
        firesignal(Event.ShowNotification.OnClientEvent, "LuisGamerCoolHub v2", "Success")
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
    -- shared primitives (with inline fallback)
    -----------------------------------------------------------------
    local Core
    do
        local sources = {
            "https://cdn.jsdelivr.net/gh/jaydencarson1609-lang/LuisGamerCoolHub@main/src/lib/brainrot_core.lua",
            "https://raw.githubusercontent.com/jaydencarson1609-lang/LuisGamerCoolHub/main/src/lib/brainrot_core.lua?cache=" .. tostring(os.time()),
        }
        for _, url in ipairs(sources) do
            local ok, src = pcall(function() return game:HttpGet(url) end)
            if ok and type(src) == "string" and #src > 100 then
                local fn = loadstring(src)
                if fn then
                    local ok2, lib = pcall(fn)
                    if ok2 and type(lib) == "table" then Core = lib; break end
                end
            end
        end
        if not Core then
            Core = {}
            function Core.getChar()   return LP.Character or LP.CharacterAdded:Wait() end
            function Core.getRoot()
                local c = Core.getChar()
                return c:FindFirstChild("HumanoidRootPart") or c:WaitForChild("HumanoidRootPart", 5)
            end
            function Core.teleport(cf)
                local r = Core.getRoot(); if not r or not cf then return end
                r.AssemblyLinearVelocity  = Vector3.zero
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
    -- shared.RE resolver
    -----------------------------------------------------------------
    local function getSharedRE(name)
        if shared and shared.RE and typeof(shared.RE.Get) == "function" then
            local ok, r = pcall(shared.RE.Get, shared.RE, name)
            if ok and r then return r end
        end
        local folder = ReplicatedStorage:FindFirstChild("Remote")
        return folder and folder:FindFirstChild(name)
    end

    local function fireRE(name, ...)
        local r = getSharedRE(name); if not r or not r.FireServer then return false end
        local args = { ... }
        return pcall(function() r:FireServer(unpack(args)) end)
    end

    local function invokeRE(name, ...)
        local r = getSharedRE(name); if not r or not r.InvokeServer then return false end
        local args = { ... }
        local ok, ret = pcall(function() return r:InvokeServer(unpack(args)) end)
        if ok then return true, ret end
        return false
    end

    -----------------------------------------------------------------
    -- ShootEvent
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

    local function pickBrainrot(maxRange, bestOnly)
        local root = Core.getRoot(0); if not root then return nil end
        local best, bestScore
        for _, m in ipairs(listBrainrots()) do
            local hrp = m:FindFirstChild("HumanoidRootPart") or m:FindFirstChild("ScopeHitbox")
            if hrp then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist <= maxRange then
                    local score = qualityWeight(m) * 10000 - dist
                    if not bestScore or score > bestScore then best, bestScore = m, score end
                end
            end
            if bestOnly and best and qualityWeight(best) >= 6 then return best end
        end
        return best
    end

    -----------------------------------------------------------------
    -- Muzzle (falls back to head if no tool)
    -----------------------------------------------------------------
    local function equippedTool()
        local c = LP.Character
        return c and c:FindFirstChildOfClass("Tool")
    end

    local function muzzlePosition()
        local tool = equippedTool()
        if tool then
            for _, d in ipairs(tool:GetDescendants()) do
                if d.Name == "Muzzle" then
                    if d:IsA("Attachment") then return d.WorldPosition end
                    if d:IsA("BasePart")  then return d.Position end
                end
            end
            local h = tool:FindFirstChild("Handle")
            if h then return h.Position end
        end
        local c = LP.Character
        local head = c and (c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart"))
        return head and head.Position or nil
    end

    local function hitPart(target)
        return target:FindFirstChild("ScopeHitbox")
            or target:FindFirstChild("HumanoidRootPart")
            or target:FindFirstChildWhichIsA("BasePart")
    end

    -----------------------------------------------------------------
    -- fire one bullet at a target
    -----------------------------------------------------------------
    local function fireAt(target)
        if not ShootEvent then return false end
        local part = hitPart(target); if not part then return false end
        local muzzle = muzzlePosition(); if not muzzle then return false end
        local dir = (part.Position - muzzle).Unit
        pcall(function() ShootEvent:FireServer(muzzle, dir) end)
        return true
    end

    -----------------------------------------------------------------
    -- NUKE: fire SHOTS_PER_TARGET at every brainrot in one tick
    -----------------------------------------------------------------
    local function nukeAll(shotsPerTarget, maxRange)
        if not ShootEvent then return 0 end
        shotsPerTarget = shotsPerTarget or 25
        maxRange = maxRange or math.huge
        local muzzle = muzzlePosition(); if not muzzle then return 0 end
        local root   = Core.getRoot(0);   if not root   then return 0 end
        local fired = 0
        for _, m in ipairs(listBrainrots()) do
            local part = hitPart(m); if part then
                local dist = (part.Position - root.Position).Magnitude
                if dist <= maxRange then
                    local dir = (part.Position - muzzle).Unit
                    for _ = 1, shotsPerTarget do
                        pcall(function() ShootEvent:FireServer(muzzle, dir) end)
                        fired = fired + 1
                    end
                end
            end
        end
        return fired
    end

    -----------------------------------------------------------------
    -- state
    -----------------------------------------------------------------
    local S = {
        -- combat
        autoShoot        = false,
        autoShootRange   = 2000,
        autoShootRate    = 0.05,
        bestQualityOnly  = false,
        killBullet       = false,
        loopNuke         = false,
        nukeInterval     = 0.25,
        shotsPerTarget   = 25,
        -- farm
        autoCollect      = false,
        autoUpgrade      = false,
        upgradeInterval  = 1.5,
        autoSell         = false,
        sellInterval     = 8,
        autoRebirth      = false,
        rebirthInterval  = 30,
        -- player
        walkSpeed        = 16,
        walkSpeedForce   = false,
        jumpPower        = 50,
        jumpPowerForce   = false,
        infJump          = false,
        infJumpConn      = nil,
        speedConn        = nil,
        -- auto
        autoDaily        = false,
        autoSpin         = false,
        autoQuest        = false,
        -- utility
        antiAFK          = nil,
    }

    -----------------------------------------------------------------
    -- status label refresher
    -----------------------------------------------------------------
    local status
    local function refreshRanking()
        if not status then return end
        local ok, data = invokeRE("RankF", "OnGetCurrRanking")
        if ok and type(data) == "table" and data.cash then
            status.setText(string.format("Cash: %s · Rank: #%s",
                tostring(data.cash),
                tostring(data.rank or "?")))
        end
    end
    task.spawn(function()
        while true do
            pcall(refreshRanking)
            task.wait(4)
        end
    end)

    -----------------------------------------------------------------
    -- loops
    -----------------------------------------------------------------
    local function startAutoShoot()
        task.spawn(function()
            while S.autoShoot do
                task.wait(S.autoShootRate)
                local t = pickBrainrot(S.autoShootRange, S.bestQualityOnly)
                if t then
                    for _ = 1, 3 do fireAt(t) end -- 3 shots per target for guaranteed kill
                end
            end
        end)
    end

    local function startLoopNuke()
        task.spawn(function()
            while S.loopNuke do
                nukeAll(S.shotsPerTarget, S.autoShootRange)
                task.wait(S.nukeInterval)
            end
        end)
    end

    local function startAutoCollect()
        task.spawn(function()
            while S.autoCollect do
                for _, trig in ipairs(CollectionService:GetTagged("MoneyTrigger")) do
                    if trig:IsA("BasePart") and typeof(firetouchinterest) == "function" then
                        local c = LP.Character
                        local head = c and (c:FindFirstChild("Head") or c.PrimaryPart)
                        if head then
                            pcall(firetouchinterest, head, trig, 0)
                            pcall(firetouchinterest, head, trig, 1)
                        end
                    end
                end
                task.wait(0.5)
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

    local function startAutoDaily()
        task.spawn(function()
            while S.autoDaily do
                for i = 1, 7 do fireRE("Daily", "OnClaimReward", i) end
                task.wait(60)
            end
        end)
    end

    local function startAutoSpin()
        task.spawn(function()
            while S.autoSpin do
                fireRE("Spin", "PlayerSpin")
                task.wait(2.5)
            end
        end)
    end

    local function startAutoQuest()
        task.spawn(function()
            while S.autoQuest do
                for i = 1, 20 do fireRE("Quest", "ClaimQuest", i, 1); fireRE("Quest", "ClaimQuest", i, 2) end
                task.wait(10)
            end
        end)
    end

    -- walk-speed enforcer: client has a guard that resets WalkSpeed to 18,
    -- so we race it every heartbeat.
    local function enforceSpeedJump()
        if S.speedConn then return end
        S.speedConn = RunService.Heartbeat:Connect(function()
            local c = LP.Character; if not c then return end
            local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end
            if S.walkSpeedForce and hum.WalkSpeed ~= S.walkSpeed then
                hum.WalkSpeed = S.walkSpeed
            end
            if S.jumpPowerForce then
                if hum.UseJumpPower and hum.JumpPower ~= S.jumpPower then
                    hum.JumpPower = S.jumpPower
                end
            end
        end)
    end
    local function stopEnforceIfIdle()
        if not S.walkSpeedForce and not S.jumpPowerForce and S.speedConn then
            S.speedConn:Disconnect(); S.speedConn = nil
        end
    end

    local function startInfJump()
        if S.infJumpConn then return end
        local UIS = game:GetService("UserInputService")
        S.infJumpConn = UIS.JumpRequest:Connect(function()
            if not S.infJump then return end
            local c = LP.Character
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
    local function stopInfJump()
        if S.infJumpConn then S.infJumpConn:Disconnect(); S.infJumpConn = nil end
    end

    -----------------------------------------------------------------
    -- COMBAT TAB
    -----------------------------------------------------------------
    api.Tab("Combat", function(tab)
        tab.Section("Instant Kill")
        tab.Button("ONE-CLICK NUKE (all brainrots)", function()
            local fired = nukeAll(S.shotsPerTarget, math.huge)
            print(string.format("[LGCH] Nuke fired %d shots", fired))
        end)
        tab.Toggle("LOOP NUKE (continuous)", false, function(v)
            S.loopNuke = v
            if v then
                S.killBullet = true
                fireRE("Player", "SetKillBulletOn", true)
                startLoopNuke()
            end
        end)
        tab.Slider("Shots per Target", 1, 100, S.shotsPerTarget, 1, function(v) S.shotsPerTarget = v end)
        tab.Slider("Nuke Interval (seconds)", 0.05, 2, S.nukeInterval, 100, function(v) S.nukeInterval = v end)

        tab.Section("Auto Snipe")
        tab.Toggle("Auto Snipe Brainrots", false, function(v)
            S.autoShoot = v
            if v then startAutoShoot() end
        end)
        tab.Toggle("Kill Bullet (one-shot normal bullets)", false, function(v)
            S.killBullet = v
            fireRE("Player", "SetKillBulletOn", v)
        end)
        tab.Toggle("Best Quality Only (Secret/Celestial/Divine)", false, function(v) S.bestQualityOnly = v end)
        tab.Slider("Range (studs)", 50, 5000, S.autoShootRange, 1, function(v) S.autoShootRange = v end)
        tab.Slider("Shot Interval (seconds)", 0.01, 1, S.autoShootRate, 100, function(v) S.autoShootRate = v end)
    end)

    -----------------------------------------------------------------
    -- FARM TAB
    -----------------------------------------------------------------
    api.Tab("Farm", function(tab)
        tab.Section("Money & Base")
        tab.Toggle("Auto Collect Money", false, function(v)
            S.autoCollect = v
            if v then startAutoCollect() end
        end)
        tab.Toggle("Auto Upgrade Floor", false, function(v)
            S.autoUpgrade = v
            if v then startAutoUpgrade() end
        end)
        tab.Slider("Upgrade Interval (s)", 0.3, 10, S.upgradeInterval, 10, function(v) S.upgradeInterval = v end)
        tab.Toggle("Auto Sell All", false, function(v)
            S.autoSell = v
            if v then startAutoSell() end
        end)
        tab.Slider("Sell Interval (s)", 2, 60, S.sellInterval, 1, function(v) S.sellInterval = v end)
        tab.Toggle("Auto Rebirth", false, function(v)
            S.autoRebirth = v
            if v then startAutoRebirth() end
        end)
        tab.Slider("Rebirth Interval (s)", 5, 300, S.rebirthInterval, 1, function(v) S.rebirthInterval = v end)

        tab.Section("Quick Actions")
        tab.Button("Sell All Now", function() invokeRE("SellF", "TryEnter"); invokeRE("SellF", "SellAll") end)
        tab.Button("Rebirth Now",  function() fireRE("Rebirth", "Rebirth") end)
        tab.Button("Upgrade Floor Now", function() fireRE("Floor", "UpgradeFloor") end)
    end)

    -----------------------------------------------------------------
    -- PLAYER TAB
    -----------------------------------------------------------------
    api.Tab("Player", function(tab)
        tab.Section("Movement")
        tab.Toggle("Force Walk Speed", false, function(v)
            S.walkSpeedForce = v
            if v then enforceSpeedJump() else stopEnforceIfIdle() end
        end)
        tab.Slider("Walk Speed", 16, 300, S.walkSpeed, 1, function(v) S.walkSpeed = v end)

        tab.Toggle("Force Jump Power", false, function(v)
            S.jumpPowerForce = v
            if v then enforceSpeedJump() else stopEnforceIfIdle() end
        end)
        tab.Slider("Jump Power", 50, 500, S.jumpPower, 1, function(v) S.jumpPower = v end)

        tab.Toggle("Infinite Jump", false, function(v)
            S.infJump = v
            if v then startInfJump() else stopInfJump() end
        end)
    end)

    -----------------------------------------------------------------
    -- AUTO TAB
    -----------------------------------------------------------------
    api.Tab("Auto", function(tab)
        tab.Section("Claims")
        tab.Toggle("Auto Daily Reward", false, function(v)
            S.autoDaily = v
            if v then startAutoDaily() end
        end)
        tab.Toggle("Auto Spin Wheel", false, function(v)
            S.autoSpin = v
            if v then startAutoSpin() end
        end)
        tab.Toggle("Auto Claim All Quests", false, function(v)
            S.autoQuest = v
            if v then startAutoQuest() end
        end)

        tab.Section("One-Shot")
        tab.Button("Claim Daily Now", function()
            for i = 1, 7 do fireRE("Daily", "OnClaimReward", i) end
        end)
        tab.Button("Spin Once", function() fireRE("Spin", "PlayerSpin") end)
        tab.Button("Claim All Quests Now", function()
            for i = 1, 20 do fireRE("Quest", "ClaimQuest", i, 1); fireRE("Quest", "ClaimQuest", i, 2) end
        end)
    end)

    -----------------------------------------------------------------
    -- TELEPORTS TAB
    -----------------------------------------------------------------
    api.Tab("Teleports", function(tab)
        tab.Section("Quick Travel")
        tab.Button("To Base", function()
            for _, n in ipairs({ "Plot_"..LP.Name, "Base_"..LP.Name }) do
                local p = Workspace:FindFirstChild(n, true)
                if p then
                    if p:IsA("Model") then Core.teleport(p:GetPivot())
                    elseif p:IsA("BasePart") then Core.teleport(p.CFrame + Vector3.new(0,4,0)) end
                    return
                end
            end
        end)
        tab.Button("To Sell Shop", function()
            invokeRE("SellF", "TryEnter")
            for _, trig in ipairs(CollectionService:GetTagged("ShopTrigger")) do
                if trig:IsA("BasePart") then Core.teleport(trig.CFrame + Vector3.new(0,3,0)); return end
            end
        end)
        tab.Button("To Nearest Brainrot", function()
            local t = pickBrainrot(math.huge, false); if not t then return end
            local hrp = hitPart(t); if hrp then Core.teleport(hrp.CFrame + Vector3.new(0,4,4)) end
        end)
        tab.Button("To Highest Quality Brainrot", function()
            local t = pickBrainrot(math.huge, true); if not t then return end
            local hrp = hitPart(t); if hrp then Core.teleport(hrp.CFrame + Vector3.new(0,4,4)) end
        end)

        tab.Section("Boss / Event")
        tab.Button("To Celestial Spawn", function()
            local f = Workspace:FindFirstChild("CelestialTigerSpawnPoints")
            if f then
                for _, p in ipairs(f:GetChildren()) do
                    if p:IsA("BasePart") then Core.teleport(p.CFrame + Vector3.new(0,4,0)); return end
                end
            end
        end)
    end)

    -----------------------------------------------------------------
    -- INFO TAB
    -----------------------------------------------------------------
    api.Tab("Info", function(tab)
        tab.Section("Live Server Status")
        status = tab.Status("Ranking", "fetching...", Color3.fromRGB(230,230,230))
        tab.Button("Refresh Now", refreshRanking)

        tab.Section("Utilities")
        tab.Toggle("Anti-AFK", false, function(v)
            if v then
                if not S.antiAFK then S.antiAFK = Core.AntiAFK() end
            else
                if S.antiAFK and S.antiAFK.stop then S.antiAFK.stop(); S.antiAFK = nil end
            end
        end)
        tab.Button("Rejoin Server", function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
        end)
    end)

    -----------------------------------------------------------------
    -- EXTRA TAB
    -----------------------------------------------------------------
    api.Tab("Extra", function(tab)
        tab.Section("Explorers")
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
        tab.Text("Find and Snipe Brainrot — v2.0")
        tab.Text("Target PlaceId: 122889506854558")
        tab.Text("Nuke · Auto-everything · Player mods")
    end)
end
