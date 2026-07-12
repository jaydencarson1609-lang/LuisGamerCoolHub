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

    local collectingMoney = false
    local upgrading = false

    local function getMyPlot()
        for _, plot in ipairs(workspace:GetChildren()) do
            if plot.Name:match("^Plot_") then
                for _, d in ipairs(plot:GetDescendants()) do
                    if (d:IsA("TextLabel") or d:IsA("BillboardGui")) and d.Text then
                        if d.Text:lower() == LocalPlayer.Name:lower() then
                            return plot
                        end
                    end
                end
            end
        end
        return nil
    end

    -- ================= MAIN TAB =================
    api.Tab("Main", function(tab)
        -- ================= BETTER AUTO FARM BRAINROTS =================
        local farming = false

        tab.Toggle("Auto Farm Best Brainrots", false, function(state)
            farming = state

            if state then
                task.spawn(function()
                    while farming do
                        -- Celestial
                        local celestial = workspace.ItemSpawners:FindFirstChild("Celestial")
                        if celestial then
                            for _, br in ipairs(celestial:GetChildren()) do
                                if farming and br.PrimaryPart then
                                    LocalPlayer.Character:MoveTo(br.PrimaryPart.Position)
                                    task.wait(0.5)

                                    local prompt = br.PrimaryPart:FindFirstChildOfClass("ProximityPrompt")
                                    if prompt then
                                        repeat
                                            fireproximityprompt(prompt)
                                            task.wait()
                                        until not farming or not br or br.Parent ~= celestial
                                    end

                                    task.wait(0.5)
                                    LocalPlayer.Character:MoveTo(Vector3.new(343, 2, -15))
                                    task.wait(1.5)
                                end
                            end
                        end

                        -- Secret
                        local secret = workspace.ItemSpawners:FindFirstChild("Secret")
                        if secret then
                            for _, br in ipairs(secret:GetChildren()) do
                                if farming and br.PrimaryPart then
                                    LocalPlayer.Character:MoveTo(br.PrimaryPart.Position)
                                    task.wait(0.5)

                                    local prompt = br.PrimaryPart:FindFirstChildOfClass("ProximityPrompt")
                                    if prompt then
                                        repeat
                                            fireproximityprompt(prompt)
                                            task.wait()
                                        until not farming or not br or br.Parent ~= secret
                                    end

                                    task.wait(0.5)
                                    LocalPlayer.Character:MoveTo(Vector3.new(343, 2, -15))
                                    task.wait(1.5)
                                end
                            end
                        end

                        task.wait(0.3)
                    end
                end)
            end
        end)

        -- Auto Collect Money (working method)
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
                        local myPlot = getMyPlot()
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

        -- Remove Cars
        tab.Button("Remove Cars", function()
            if workspace:FindFirstChild("CarSpawn") then
                workspace.CarSpawn:Destroy()
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
        tab.Text("Version: 2.6 - Improved Brainrot Farm + Remove Cars")
        tab.Text("Thanks for using the hub!")
    end)
end
