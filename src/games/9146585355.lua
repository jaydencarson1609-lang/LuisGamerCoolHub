--[[
src/games/9146585355.lua — Find the Fridges
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    local farming = false

    local skipTokens = {
        "area",
        "tp",
        "arrow",
        "statue",
    }

    local function shouldSkip(name)
        local n = string.lower(name)
        for _, token in ipairs(skipTokens) do
            if string.find(n, token, 1, true) then
                return true
            end
        end
        return false
    end

    local function hasTouchInterest(part)
        return part:FindFirstChildWhichIsA("TouchTransmitter") ~= nil
            or part:FindFirstChild("TouchInterest") ~= nil
    end

    local function isFridgeCollectible(inst)
        if not inst:IsA("BasePart") then
            return false
        end
        local n = string.lower(inst.Name)
        if not string.find(n, "fridge", 1, true) then
            return false
        end
        if shouldSkip(inst.Name) then
            return false
        end
        return hasTouchInterest(inst)
    end

    local function getHRP()
        local char = lp.Character or lp.CharacterAdded:Wait()
        return char:FindFirstChild("HumanoidRootPart")
    end

    local function collectTargets()
        local targets = {}
        for _, v in ipairs(workspace:GetDescendants()) do
            if isFridgeCollectible(v) then
                table.insert(targets, v)
            end
        end
        return targets
    end

    local function fireTouch(hrp, part)
        firetouchinterest(hrp, part, 0)
        firetouchinterest(hrp, part, 1)
    end

    local function startFarming()
        farming = true
        getgenv().FridgeAutoTouch = true

        task.spawn(function()
            while farming and getgenv().FridgeAutoTouch do
                local hrp = getHRP()
                if hrp then
                    local targets = collectTargets()
                    for i, part in ipairs(targets) do
                        if not farming or not getgenv().FridgeAutoTouch then
                            break
                        end
                        if part.Parent then
                            pcall(fireTouch, hrp, part)
                        end
                        if i % 40 == 0 then
                            task.wait()
                        end
                    end
                end
                task.wait(0.35)
            end

            farming = false
            getgenv().FridgeAutoTouch = false
        end)
    end

    local function stopFarming()
        farming = false
        getgenv().FridgeAutoTouch = false
    end

    api.Tab("Main", function(tab)
        tab.Toggle("Auto Collect Fridges", false, function(state)
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
