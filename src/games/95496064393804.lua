--[[
src/games/95496064393804.lua — Find the Chameleons
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local CollectionService = game:GetService("CollectionService")
    local ReplicatedFirst = game:GetService("ReplicatedFirst")

    local lp = Players.LocalPlayer
    local IndexUpdate = require(ReplicatedFirst:WaitForChild("Modules"):WaitForChild("Utility"):WaitForChild("IndexUpdate"))
    local farming = false

    local function getHRP()
        local char = lp.Character or lp.CharacterAdded:Wait()
        return char:FindFirstChild("HumanoidRootPart")
    end

    local function equipShotgun()
        local char = lp.Character
        if not char then
            return nil
        end
        local gun = char:FindFirstChild("Shotgun") or lp.Backpack:FindFirstChild("Shotgun")
        if gun and gun.Parent == lp.Backpack then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:EquipTool(gun)
            end
        end
        return char:FindFirstChild("Shotgun")
    end

    local function isUnfound(part)
        local info = IndexUpdate.getData()[part.Name]
        if info then
            return not info.IsFound
        end
        return part:FindFirstChild("ShotSignal") ~= nil and part.CanTouch
    end

    local function getTargets()
        local targets = {}
        for _, inst in ipairs(CollectionService:GetTagged("collectible")) do
            if inst:IsA("BasePart") and inst:IsDescendantOf(workspace) and isUnfound(inst) then
                table.insert(targets, inst)
            end
        end
        table.sort(targets, function(a, b)
            local hrp = getHRP()
            if not hrp then
                return false
            end
            return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
        end)
        return targets
    end

    local function teleportTo(part)
        local hrp = getHRP()
        if not hrp then
            return
        end
        hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 4, 0))
    end

    local function shootChameleon(part)
        local gun = equipShotgun()
        local hrp = getHRP()
        if hrp then
            hrp.CFrame = CFrame.lookAt(hrp.Position, part.Position)
        end

        local shot = part:FindFirstChild("ShotSignal")
        if shot and shot:IsA("BindableEvent") then
            shot:Fire()
        end

        if gun then
            pcall(function()
                gun:Activate()
            end)
        end
    end

    local function startFarming()
        farming = true
        getgenv().ChameleonAutoFarm = true

        task.spawn(function()
            while farming and getgenv().ChameleonAutoFarm do
                local targets = getTargets()
                if #targets == 0 then
                    break
                end

                for _, part in ipairs(targets) do
                    if not farming or not getgenv().ChameleonAutoFarm then
                        break
                    end
                    if part.Parent and isUnfound(part) then
                        teleportTo(part)
                        task.wait(0.08)
                        shootChameleon(part)
                        task.wait(0.12)
                    end
                end
                task.wait(0.25)
            end

            farming = false
            getgenv().ChameleonAutoFarm = false
        end)
    end

    local function stopFarming()
        farming = false
        getgenv().ChameleonAutoFarm = false
    end

    api.Tab("Main", function(tab)
        tab.Toggle("Auto Collect Chameleons", false, function(state)
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
