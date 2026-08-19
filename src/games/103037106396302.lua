--[[
src/games/103037106396302.lua — TROLL Hug Tower
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local lp = Players.LocalPlayer
    local HugRemotes = ReplicatedStorage:WaitForChild("HugRemotes")
    local HugRequest = HugRemotes:WaitForChild("HugRequest")
    local HugState = HugRemotes:WaitForChild("HugState")

    local TROLL_POS = Vector3.new(-2, -2, 83)

    local throwAll = false
    local selectedName = ""
    local holding = false

    HugState.OnClientEvent:Connect(function(state)
        if state == "started" then
            holding = true
        elseif state == "ended" or state == "hugEnded" or state == "rejected" then
            holding = false
        end
    end)

    local function getHRP()
        local char = lp.Character
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    local function getHumanoid()
        local char = lp.Character
        return char and char:FindFirstChildOfClass("Humanoid")
    end

    local function freeSelf()
        local hum = getHumanoid()
        if not hum then
            return
        end

        hum.PlatformStand = false
        hum.Sit = false
        pcall(function()
            hum:UnequipTools()
        end)
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
    end

    local function warpTo(cf)
        local hrp = getHRP()
        if not hrp then
            return false
        end

        freeSelf()
        local untilTime = os.clock() + 0.28
        while os.clock() < untilTime do
            hrp = getHRP()
            local hum = getHumanoid()
            if not hrp then
                return false
            end
            if hum then
                hum.PlatformStand = false
                hum.Sit = false
            end
            hrp.CFrame = cf
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            task.wait()
        end
        return true
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

    local function canThrow(plr)
        if not plr or plr == lp then
            return false
        end
        local char = plr.Character
        if not char then
            return false
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then
            return false
        end
        if plr:GetAttribute("IsHugged") == true then
            return false
        end
        if char:FindFirstChildWhichIsA("ForceField", true) or plr:FindFirstChildWhichIsA("ForceField", true) then
            return false
        end
        return true
    end

    local function standNear(root)
        if not root then
            return false
        end

        local pos = root.Position
        local offset = Vector3.new(0, 0, 2.2)
        local look = CFrame.lookAt(pos + offset, pos)
        return warpTo(look)
    end

    local function waitForHold(timeout)
        local deadline = os.clock() + (timeout or 2)
        while not holding and os.clock() < deadline do
            task.wait()
        end
        return holding
    end

    local function throwPlayer(plr)
        if not canThrow(plr) then
            return false
        end

        local char = plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not root then
            return false
        end

        if holding then
            HugRequest:FireServer("throw")
            task.wait(0.8)
        end

        freeSelf()
        if not standNear(root) then
            return false
        end

        holding = false
        HugRequest:FireServer("tryGrab", char)

        if not waitForHold(2.5) then
            return false
        end

        if not warpTo(CFrame.new(TROLL_POS)) then
            return false
        end
        HugRequest:FireServer("throw")
        task.wait(1.1)
        return true
    end

    api.Tab("Main", function(tab)
        tab.Section("Throw")

        tab.Toggle("Throw All People", false, function(state)
            throwAll = state == true
            if not throwAll then
                return
            end

            task.spawn(function()
                while throwAll do
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if not throwAll then
                            break
                        end
                        throwPlayer(plr)
                    end
                    task.wait(0.25)
                end
            end)
        end)

        tab.Input("Username", "Type a username...", "", function(text)
            selectedName = text or ""
        end)

        tab.Button("Throw a selected player", function()
            local victim = findPlayer(selectedName)
            if victim then
                task.spawn(throwPlayer, victim)
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
