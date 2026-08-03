--[[
src/games/7896264844.lua — Find the Markers
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local lp = Players.LocalPlayer
    local markersFolder = ReplicatedStorage:WaitForChild("Markers")
    local farming = false
    local collected = {}

    local function getHRP()
        local char = lp.Character or lp.CharacterAdded:Wait()
        return char:FindFirstChild("HumanoidRootPart")
    end

    local function getOwnedFromTouchLogic()
        local owned = {}
        local hrp = getHRP()
        if not hrp or typeof(getconnections) ~= "function" or typeof(getupvalue) ~= "function" then
            return owned
        end

        for _, ov in ipairs(markersFolder:GetChildren()) do
            if ov:IsA("ObjectValue") and ov.Value and ov.Value:IsDescendantOf(workspace) then
                local part = ov.Value:FindFirstChild("Color 1") or ov.Value:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    for _, c in ipairs(getconnections(part.Touched)) do
                        if c.Function then
                            for i = 1, 16 do
                                local ok, val = pcall(getupvalue, c.Function, i)
                                if ok and typeof(val) == "table" and #val > 0 and typeof(val[1]) == "string" then
                                    for _, name in ipairs(val) do
                                        owned[name] = true
                                    end
                                end
                            end
                        end
                    end
                    break
                end
            end
        end
        return owned
    end

    local function collectMarker(ov)
        local model = ov.Value
        if not model or not model:IsA("Model") then
            return false
        end

        local parented = false
        if not model:IsDescendantOf(workspace) then
            model.Parent = workspace
            parented = true
        end

        local color1 = model:FindFirstChild("Color 1")
        if not color1 or not color1:IsA("BasePart") then
            if parented then
                model.Parent = ReplicatedStorage
            end
            return false
        end

        local hrp = getHRP()
        if not hrp then
            return false
        end

        local before = lp.leaderstats.Markers.Value
        lp:SetAttribute("LastCollect", 0)

        local pos = color1.Position
        for _ = 1, 20 do
            if not farming or not getgenv().MarkerAutoFarm then
                break
            end
            hrp.CFrame = CFrame.new(pos + Vector3.new(0, 1.5, 0))

            for _, p in ipairs(model:GetDescendants()) do
                if p:IsA("BasePart") then
                    pcall(firetouchinterest, hrp, p, 0)
                    if typeof(getconnections) == "function" then
                        for _, c in ipairs(getconnections(p.Touched)) do
                            pcall(function()
                                c:Fire(hrp)
                            end)
                        end
                    end
                end
            end

            task.wait(0.08)

            for _, p in ipairs(model:GetDescendants()) do
                if p:IsA("BasePart") then
                    pcall(firetouchinterest, hrp, p, 1)
                end
            end

            if lp.leaderstats.Markers.Value > before then
                collected[ov.Name] = true
                return true
            end
        end

        return lp.leaderstats.Markers.Value > before
    end

    local function startFarming()
        farming = true
        getgenv().MarkerAutoFarm = true
        collected = {}

        task.spawn(function()
            for name, _ in pairs(getOwnedFromTouchLogic()) do
                collected[name] = true
            end

            while farming and getgenv().MarkerAutoFarm do
                local targets = {}
                for _, ov in ipairs(markersFolder:GetChildren()) do
                    if ov:IsA("ObjectValue") and not collected[ov.Name] and ov.Value then
                        table.insert(targets, ov)
                    end
                end

                local hrp = getHRP()
                if hrp then
                    table.sort(targets, function(a, b)
                        local ca = a.Value and a.Value:FindFirstChild("Color 1")
                        local cb = b.Value and b.Value:FindFirstChild("Color 1")
                        if not ca then
                            return false
                        end
                        if not cb then
                            return true
                        end
                        return (ca.Position - hrp.Position).Magnitude < (cb.Position - hrp.Position).Magnitude
                    end)
                end

                if #targets == 0 then
                    break
                end

                local gained = 0
                for _, ov in ipairs(targets) do
                    if not farming or not getgenv().MarkerAutoFarm then
                        break
                    end
                    local before = lp.leaderstats.Markers.Value
                    local ok = pcall(collectMarker, ov)
                    if ok and lp.leaderstats.Markers.Value > before then
                        gained += 1
                        task.wait(0.15)
                    else
                        collected[ov.Name] = true
                    end
                end

                if gained == 0 then
                    break
                end
                task.wait(0.5)
            end

            farming = false
            getgenv().MarkerAutoFarm = false
        end)
    end

    local function stopFarming()
        farming = false
        getgenv().MarkerAutoFarm = false
    end

    api.Tab("Main", function(tab)
        tab.Toggle("Auto Collect Markers", false, function(state)
            if state then
                startFarming()
            else
                stopFarming()
            end
        end)
        tab.Text("Some markers may be puzzle/locked")
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
