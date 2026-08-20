--[[
src/games/103037106396302.lua — TROLL Hug Tower
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local lp = Players.LocalPlayer
    local HugRequest = ReplicatedStorage:WaitForChild("HugRemotes"):WaitForChild("HugRequest")

    local throwAll = false
    local selectedName = ""
    local stayAtLava = false
    local stayConn

    local function getLavaCFrame()
        local lava = workspace:WaitForChild("Map"):WaitForChild("Lava")
        if lava:IsA("BasePart") then
            return lava.CFrame + Vector3.new(0, lava.Size.Y / 2 + 4, 0)
        end
        local part = lava:FindFirstChildWhichIsA("BasePart", true)
        if part then
            return part.CFrame + Vector3.new(0, part.Size.Y / 2 + 4, 0)
        end
        return CFrame.new(34, -46, 217)
    end

    local function getHRP()
        local char = lp.Character
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    local function holdLavaPos()
        local hrp = getHRP()
        if not hrp then
            return
        end
        hrp.CFrame = getLavaCFrame()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end

    local function setStayAtLava(on)
        stayAtLava = on == true
        if stayConn then
            stayConn:Disconnect()
            stayConn = nil
        end
        if not stayAtLava then
            return
        end
        holdLavaPos()
        stayConn = RunService.Heartbeat:Connect(function()
            if stayAtLava then
                holdLavaPos()
            end
        end)
    end

    local function findPlayer(query)
        if type(query) ~= "string" or query == "" then
            return nil
        end
        local q = string.lower(query)
        for _, plr in ipairs(Players:GetPlayers()) do
            if string.find(string.lower(plr.Name), q, 1, true) then
                return plr
            end
        end
        return nil
    end

    local function throwWithRemotes(plr)
        if not plr or plr == lp then
            return
        end

        local target = workspace:FindFirstChild(plr.Name)
        if not (target and target:IsA("Model")) then
            return
        end

        HugRequest:FireServer("tryGrab", target)
        HugRequest:FireServer("throw")
    end

    api.Tab("Main", function(tab)
        tab.Section("Throw")

        tab.Toggle("Throw All People", false, function(state)
            throwAll = state == true
            setStayAtLava(throwAll)
            if not throwAll then
                return
            end

            task.spawn(function()
                while throwAll do
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if not throwAll then
                            break
                        end
                        throwWithRemotes(plr)
                    end
                    task.wait()
                end
            end)
        end)

        tab.Input("Username", "Type a username...", "", function(text)
            selectedName = text or ""
        end)

        tab.Button("Throw a selected player", function()
            local victim = findPlayer(selectedName)
            if not victim then
                return
            end
            task.spawn(function()
                setStayAtLava(true)
                throwWithRemotes(victim)
                task.wait(0.15)
                if not throwAll then
                    setStayAtLava(false)
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
        tab.Text("Version: 1.3 - Fast lava throws")
        tab.Text("Thanks for using the hub!")
    end)
end
