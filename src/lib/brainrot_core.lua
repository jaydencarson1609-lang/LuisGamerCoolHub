--[[
    src/lib/brainrot_core.lua
    LuisGamerCoolHub shared primitives for brainrot game modules.

    Usage inside a game file:
        local Core = loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/jaydencarson1609-lang/LuisGamerCoolHub/main/src/lib/brainrot_core.lua"
        ))()
        local farm = Core.FarmLoop{
            onStep = function(ctx) ... end,
            interval = 0.2,
        }
        tab.Toggle("Auto Farm", false, function(state)
            if state then farm.start() else farm.stop() end
        end)

    Every helper is pcall-wrapped at its edges: a module that uses this library
    should never crash the hub.
]]

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local TeleportService= game:GetService("TeleportService")
local HttpService    = game:GetService("HttpService")
local VirtualUser    = game:GetService("VirtualUser")
local LP             = Players.LocalPlayer

local Core = {}

-----------------------------------------------------------------------
-- character helpers
-----------------------------------------------------------------------
function Core.getChar()
    local char = LP.Character or LP.CharacterAdded:Wait()
    return char
end

function Core.getRoot(timeout)
    local char = Core.getChar()
    return char:FindFirstChild("HumanoidRootPart")
        or char:WaitForChild("HumanoidRootPart", timeout or 5)
end

function Core.getHumanoid()
    local char = Core.getChar()
    return char:FindFirstChildOfClass("Humanoid")
end

function Core.alive()
    local hum = Core.getHumanoid()
    return hum and hum.Health > 0
end

-----------------------------------------------------------------------
-- teleport: zero velocity so the character doesn't carry kinetic energy
-----------------------------------------------------------------------
function Core.teleport(cframeOrVector)
    local root = Core.getRoot()
    if not root or not cframeOrVector then return false end
    local cf = typeof(cframeOrVector) == "Vector3"
        and CFrame.new(cframeOrVector)
        or cframeOrVector
    root.AssemblyLinearVelocity  = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    root.CFrame = cf
    return true
end

function Core.teleportAbove(part, yOffset)
    if not part then return false end
    local pos = (part:IsA("Model") and part.PrimaryPart and part.PrimaryPart.Position)
        or (typeof(part.GetPivot) == "function" and part:GetPivot().Position)
        or (part.Position)
    if not pos then return false end
    return Core.teleport(CFrame.new(pos + Vector3.new(0, yOffset or 3, 0)))
end

-----------------------------------------------------------------------
-- ProximityPrompt firing (fireproximityprompt on sUNC, manual fallback)
-----------------------------------------------------------------------
function Core.firePrompt(prompt, times)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    times = times or 1

    if typeof(fireproximityprompt) == "function" then
        for _ = 1, times do
            pcall(fireproximityprompt, prompt, 0)
            task.wait(0.03)
        end
        return true
    end

    local hold = prompt.HoldDuration
    pcall(function() prompt.HoldDuration = 0 end)
    for _ = 1, times do
        pcall(function()
            prompt:InputHoldBegin()
            task.wait(0.05)
            prompt:InputHoldEnd()
        end)
        task.wait(0.03)
    end
    pcall(function() prompt.HoldDuration = hold end)
    return true
end

-----------------------------------------------------------------------
-- TouchInterest firing (collect-on-touch zones)
-----------------------------------------------------------------------
function Core.fireTouch(touchPart)
    if not touchPart or typeof(firetouchinterest) ~= "function" then return false end
    local char = Core.getChar()
    local head = char and (char:FindFirstChild("Head") or char.PrimaryPart)
    if not head then return false end
    pcall(function()
        firetouchinterest(head, touchPart, 0)
        task.wait()
        firetouchinterest(head, touchPart, 1)
    end)
    return true
end

-----------------------------------------------------------------------
-- remote invocation (safe)
-----------------------------------------------------------------------
function Core.invoke(remote, ...)
    if not remote then return false end
    local ok, ret = pcall(function(...)
        return remote:InvokeServer(...)
    end, ...)
    return ok, ret
end

function Core.fire(remote, ...)
    if not remote then return false end
    local ok = pcall(function(...)
        remote:FireServer(...)
    end, ...)
    return ok
end

-----------------------------------------------------------------------
-- remote discovery  (find by name across a container tree)
-----------------------------------------------------------------------
function Core.findRemote(root, nameOrPattern)
    if not root then return nil end
    for _, d in ipairs(root:GetDescendants()) do
        if (d:IsA("RemoteEvent") or d:IsA("RemoteFunction"))
        and d.Name:match(nameOrPattern) then
            return d
        end
    end
    return nil
end

-----------------------------------------------------------------------
-- FarmLoop:  a toggleable loop with session tokens.
-- Pass {onStep, interval, onStart, onStop}.
-- Returns { start, stop, isRunning }.
-- Stale loops die the moment a new session starts.
-----------------------------------------------------------------------
function Core.FarmLoop(opts)
    assert(type(opts) == "table" and type(opts.onStep) == "function",
        "FarmLoop needs opts.onStep")

    local state = {
        running   = false,
        session   = 0,
        anchor    = nil,  -- saved CFrame at start, restored on stop
    }
    local interval = opts.interval or 0.2

    local function start()
        if state.running then return end
        state.running = true
        state.session = state.session + 1
        local session = state.session
        local root = Core.getRoot(3)
        state.anchor = root and root.CFrame or nil
        if opts.onStart then pcall(opts.onStart) end
        task.spawn(function()
            while state.running and state.session == session do
                local ok, err = pcall(opts.onStep, {
                    stillRunning = function()
                        return state.running and state.session == session
                    end,
                })
                if not ok then warn("[brainrot_core] FarmLoop step error: "..tostring(err)) end
                task.wait(interval)
            end
            if opts.onStop then pcall(opts.onStop) end
            if state.anchor and opts.restoreOnStop ~= false then
                Core.teleport(state.anchor)
            end
        end)
    end

    local function stop()
        state.running = false
        state.session = state.session + 1
    end

    return {
        start      = start,
        stop       = stop,
        isRunning  = function() return state.running end,
        setAnchor  = function(cf) state.anchor = cf end,
        clearAnchor= function() state.anchor = nil end,
    }
end

-----------------------------------------------------------------------
-- InfiniteRange  —  pull collectible parts to the player each heartbeat.
-- Caller gives a filter(part) -> bool.  Returns {start, stop}.
-----------------------------------------------------------------------
function Core.InfiniteRange(opts)
    assert(type(opts) == "table" and type(opts.filter) == "function",
        "InfiniteRange needs opts.filter")
    local state = { running = false, conn = nil }

    local function start()
        if state.running then return end
        state.running = true
        state.conn = RunService.Heartbeat:Connect(function()
            if not state.running then return end
            local root = Core.getRoot(0)
            if not root then return end
            for _, d in ipairs(workspace:GetDescendants()) do
                if d:IsA("BasePart") and opts.filter(d) then
                    d.CFrame = root.CFrame * CFrame.new(0, 0, -2)
                end
            end
        end)
    end

    local function stop()
        state.running = false
        if state.conn then state.conn:Disconnect(); state.conn = nil end
    end

    return { start = start, stop = stop, isRunning = function() return state.running end }
end

-----------------------------------------------------------------------
-- AntiAFK  —  defeat Roblox's 20-minute idle kick.
-----------------------------------------------------------------------
function Core.AntiAFK()
    local conn
    conn = LP.Idled:Connect(function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)
    return {
        stop = function() if conn then conn:Disconnect() end end
    }
end

-----------------------------------------------------------------------
-- ServerHop / Rejoin
-----------------------------------------------------------------------
function Core.rejoin()
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
    end)
end

function Core.serverHop()
    local ok, pageJson = pcall(function()
        return game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId
            .. "/servers/Public?sortOrder=Asc&limit=100"
        )
    end)
    if not ok then return end
    local okDecode, data = pcall(HttpService.JSONDecode, HttpService, pageJson)
    if not okDecode or type(data) ~= "table" or type(data.data) ~= "table" then return end
    local candidates = {}
    for _, s in ipairs(data.data) do
        if s.id ~= game.JobId and s.playing and s.maxPlayers
        and s.playing < s.maxPlayers then
            candidates[#candidates+1] = s.id
        end
    end
    if #candidates == 0 then return end
    local pick = candidates[math.random(#candidates)]
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, pick, LP)
    end)
end

-----------------------------------------------------------------------
-- Toast  —  tiny wrapper around StarterGui:SetCore(SendNotification).
-----------------------------------------------------------------------
function Core.toast(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title    = title or "LuisGamerCoolHub",
            Text     = text or "",
            Duration = duration or 3,
        })
    end)
end

-----------------------------------------------------------------------
-- version tag
-----------------------------------------------------------------------
Core._VERSION = "brainrot_core 1.0.0"
return Core
