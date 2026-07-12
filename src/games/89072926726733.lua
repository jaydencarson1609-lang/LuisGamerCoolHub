--[[
src/games/89072926726733.lua — Cross the Road for Brainrot
LuisGamerCoolHub
]]

-- Notification on execute
pcall(function()
    local Event = game:GetService("ReplicatedStorage").Events.ShowNotification
    firesignal(Event.OnClientEvent, "LuisGamerCoolHub loaded Successfully", "Success")
end)

return function(_, api)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local farming = false
    local collectingMoney = false
    local upgrading = false

    local function getRootPart()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        return char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
    end

    local function teleport(root, cframe)
        if root and cframe then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = cframe
        end
    end

    -- ================= MAIN TAB =================
    api.Tab("Main", function(tab)
        -- Auto Farm Best Brainrots (working version)
        tab.Toggle("Auto Farm Best Brainrots", false, function(state)
            farming = state

            if state then
                task.spawn(function()
                    while farming do
                        local items = {}

                        -- Get SpawnedItems from Secret
                        local secret = workspace.ItemSpawners:FindFirstChild("Secret")
                        if secret then
                            for _, item in ipairs(secret:GetChildren()) do
                                if item:IsA("Model") and item.Name == "SpawnedItem" then
                                    table.insert(items, item)
                                end
                            end
                        end

                        -- Get SpawnedItems from Celestial
                        local celestial = workspace.ItemSpawners:FindFirstChild("Celestial")
                        if celestial then
                            for _, item in ipairs(celestial:GetChildren()) do
                                if item:IsA("Model") and item.Name == "SpawnedItem" then
                                    table.insert(items, item)
                                end
                            end
                        end

                        for _, item in ipairs(items) do
                            if not farming then break end

                            if item.PrimaryPart then
                                teleport(getRootPart(), item.PrimaryPart.CFrame + Vector3.new(0, 3, 0))
                                task.wait(0.2)

                                local prompt = item:FindFirstChildOfClass("ProximityPrompt", true)
                                if prompt then
                                    for i = 1, 6 do
                                        fireproximityprompt(prompt)
                                        task.wait(0.04)
                                    end
                                end

                                task.wait(0.3)
                                teleport(getRootPart(), CFrame.new(349, 2, -19))
                                task.wait(0.8)
                            end
                        end

                        task.wait(0.4)
                    end
                end)
            end
        end)

        -- Auto Collect Money
        tab.Toggle("Auto Collect Money", false, function(state)
            collectingMoney = state

            if state then
                task.spawn(function()
                    while collectingMoney do
                        local plotName = "Plot_" .. LocalPlayer.Name
                        local myPlot = workspace:FindFirstChild(plotName)

                        if myPlot then
                            for i = 1, 3 do
                                local floor = myPlot:FindFirstChild("Floor" .. i)
                                if floor then
                                    local slots = floor:FindFirstChild("Slots")
                                    if slots then
                                        for _, slot in ipairs(slots:GetChildren()) do
                                            local collectTouch = slot:FindFirstChild("CollectTouch")
                                            if collectTouch then
                                                firetouchinterest(LocalPlayer.Character.Head, collectTouch, true)
                                                task.wait()
                                                firetouchinterest(LocalPlayer.Character.Head, collectTouch, false)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(0.15)
                    end
                end)
            end
        end)

        -- Auto Upgrade
        tab.Toggle("Auto Upgrade", false, function(state)
            upgrading = state

            if state then
                task.spawn(function()
                    while upgrading do
                        local myPlot = workspace:FindFirstChild("Plot_" .. LocalPlayer.Name)
                        if myPlot then
                            for _, floor in ipairs(myPlot:GetChildren()) do
                                if floor.Name:match("^Floor") then
                                    local slots = floor:FindFirstChild("Slots")
                                    if slots then
                                        for _, slot in ipairs(slots:GetChildren()) do
                                            if slot.Name:match("^Slot") then
                                                local upgradePart = slot:FindFirstChild("UpgradePart")
                                                if upgradePart then
                                                    local gui = upgradePart:FindFirstChild("UpgradeGUI", true)
                                                    local button = gui and gui:FindFirstChild("UpgradeButton")
                                                    if button and button:IsA("TextButton") then
                                                        pcall(function()
                                                            firesignal(button.MouseButton1Click)
                                                        end)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(1.5)
                    end
                end)
            end
        end)

        -- Remove Cars (as toggle)
        tab.Toggle("Remove Cars", false, function(state)
            if state then
                if workspace:FindFirstChild("CarSpawn") then
                    workspace.CarSpawn:Destroy()
                end
            end
        end)
    end)

    -- ================= EXTRA TAB =================
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

    -- ================= CREDITS TAB =================
    api.Tab("Credits", function(tab)
        tab.Text("LuisGamerCoolHub")
        tab.Text("Created by LuisGamerCool")
        tab.Text("Version: 2.7 - Stable Version")
        tab.Text("Thanks for using the hub!")
    end)
end
