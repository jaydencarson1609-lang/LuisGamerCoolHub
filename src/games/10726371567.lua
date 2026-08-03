--[[
src/games/10726371567.lua — Find The Simpsons
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local CollectionService = game:GetService("CollectionService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local StarterPlayer = game:GetService("StarterPlayer")

    local lp = Players.LocalPlayer
    local Collect = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Collect")
    local SharedData = require(StarterPlayer.StarterPlayerScripts:WaitForChild("/ SharedData"))

    local farming = false

    local function getHRP()
        local char = lp.Character or lp.CharacterAdded:Wait()
        return char:FindFirstChild("HumanoidRootPart")
    end

    local function alreadyCollected(name)
        return table.find(SharedData.GlobalTable.Simpsons, name) ~= nil
    end

    local function markCollected(name)
        if not alreadyCollected(name) then
            table.insert(SharedData.GlobalTable.Simpsons, name)
        end
    end

    local function collectByName(name)
        if alreadyCollected(name) then
            return
        end
        Collect:FireServer(name)
        markCollected(name)
    end

    local function getIndexOnlyNames()
        local tagged = {}
        for _, inst in ipairs(CollectionService:GetTagged("Simpsons")) do
            if inst:IsA("BasePart") then
                tagged[inst.Name] = true
            end
        end

        local names = {}
        local menu = lp.PlayerGui:FindFirstChild("MainUI")
        menu = menu and menu:FindFirstChild("MainMenu")
        menu = menu and menu:FindFirstChild("Menus")
        menu = menu and menu:FindFirstChild("Menu")
        local sf = menu and menu:FindFirstChild("ScrollingFrame")
        if not sf then
            return names
        end

        for _, child in ipairs(sf:GetChildren()) do
            if child:IsA("GuiObject") and child:FindFirstChild("SimpImage") and not tagged[child.Name] then
                if not alreadyCollected(child.Name) then
                    table.insert(names, child.Name)
                end
            end
        end
        return names
    end

    local function parseTargets()
        local workspaceTargets = {}
        local remoteNames = {}

        for _, inst in ipairs(CollectionService:GetTagged("Simpsons")) do
            if not inst:IsA("BasePart") or alreadyCollected(inst.Name) then
                continue
            end

            local inWorkspace = inst:IsDescendantOf(workspace)
            local parked = inWorkspace and inst.Position.Y >= 1900
            local tpc = inst:GetAttribute("TPCFrame")

            if inWorkspace and not parked then
                table.insert(workspaceTargets, inst)
            elseif inWorkspace and parked and typeof(tpc) == "CFrame" then
                table.insert(workspaceTargets, { part = inst, tpc = tpc, parked = true })
            else
                table.insert(remoteNames, inst.Name)
            end
        end

        for _, name in ipairs(getIndexOnlyNames()) do
            table.insert(remoteNames, name)
        end

        local hrp = getHRP()
        if hrp then
            table.sort(workspaceTargets, function(a, b)
                local pa = (typeof(a) == "table" and a.part or a)
                local pb = (typeof(b) == "table" and b.part or b)
                local posA = (typeof(a) == "table" and a.tpc) and a.tpc.Position or pa.Position
                local posB = (typeof(b) == "table" and b.tpc) and b.tpc.Position or pb.Position
                return (posA - hrp.Position).Magnitude < (posB - hrp.Position).Magnitude
            end)
        end

        return workspaceTargets, remoteNames
    end

    local function collectWorld(entry)
        local part
        local tpc
        local parked = false

        if typeof(entry) == "table" then
            part = entry.part
            tpc = entry.tpc
            parked = entry.parked == true
        else
            part = entry
        end

        if alreadyCollected(part.Name) then
            return
        end

        local hrp = getHRP()
        if hrp then
            if parked and tpc then
                hrp.CFrame = tpc + Vector3.new(0, 3, 0)
                local old = part.CFrame
                part.CFrame = hrp.CFrame * CFrame.new(0, 0, -3)
                pcall(function()
                    firetouchinterest(hrp, part, 0)
                    firetouchinterest(hrp, part, 1)
                end)
                part.CFrame = old
            else
                hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                pcall(function()
                    firetouchinterest(hrp, part, 0)
                    firetouchinterest(hrp, part, 1)
                end)
            end
        end

        collectByName(part.Name)
    end

    local function startFarming()
        farming = true
        getgenv().SimpsonsAutoFarm = true

        task.spawn(function()
            while farming and getgenv().SimpsonsAutoFarm do
                local worldTargets, remoteNames = parseTargets()
                if #worldTargets == 0 and #remoteNames == 0 then
                    break
                end

                for _, entry in ipairs(worldTargets) do
                    if not farming or not getgenv().SimpsonsAutoFarm then
                        break
                    end
                    pcall(collectWorld, entry)
                    task.wait(0.08)
                end

                for i, name in ipairs(remoteNames) do
                    if not farming or not getgenv().SimpsonsAutoFarm then
                        break
                    end
                    pcall(collectByName, name)
                    if i % 8 == 0 then
                        task.wait()
                    end
                end

                task.wait(0.25)
            end

            farming = false
            getgenv().SimpsonsAutoFarm = false
        end)
    end

    local function stopFarming()
        farming = false
        getgenv().SimpsonsAutoFarm = false
    end

    api.Tab("Main", function(tab)
        tab.Toggle("Auto Collect Simpsons", false, function(state)
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
