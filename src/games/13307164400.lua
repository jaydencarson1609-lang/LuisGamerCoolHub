--[[
src/games/13307164400.lua — Find the Kittens
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    local farming = false

    local function getHRP()
        local char = lp.Character or lp.CharacterAdded:Wait()
        return char:FindFirstChild("HumanoidRootPart")
    end

    local function getTargets()
        local targets = {}
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v:FindFirstChild("collectionScript") then
                table.insert(targets, v)
            end
        end

        local hrp = getHRP()
        if hrp then
            table.sort(targets, function(a, b)
                return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
            end)
        end
        return targets
    end

    local function collectPart(part)
        local hrp = getHRP()
        if not hrp then
            return
        end

        hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
        pcall(function()
            firetouchinterest(hrp, part, 0)
            task.wait(0.05)
            firetouchinterest(hrp, part, 1)
        end)
        hrp.CFrame = part.CFrame

        local prompt = part:FindFirstChildWhichIsA("ProximityPrompt")
        if prompt then
            if fireproximityprompt then
                pcall(fireproximityprompt, prompt)
            end
            pcall(function()
                prompt:InputHoldBegin()
                task.wait((prompt.HoldDuration or 0) + 0.1)
                prompt:InputHoldEnd()
            end)
        end

        task.wait(0.18)
    end

    local function startFarming()
        farming = true
        getgenv().KittenAutoFarm = true

        task.spawn(function()
            while farming and getgenv().KittenAutoFarm do
                local targets = getTargets()
                if #targets == 0 then
                    break
                end

                for _, part in ipairs(targets) do
                    if not farming or not getgenv().KittenAutoFarm then
                        break
                    end
                    pcall(collectPart, part)
                end

                task.wait(0.5)
                break
            end

            farming = false
            getgenv().KittenAutoFarm = false
        end)
    end

    local function stopFarming()
        farming = false
        getgenv().KittenAutoFarm = false
    end

    api.Tab("Main", function(tab)
        tab.Toggle("Auto Collect Kittens", false, function(state)
            if state then
                startFarming()
            else
                stopFarming()
            end
        end)
        tab.Text("If stuck at 44/45, join the group for GroupKitten")
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
