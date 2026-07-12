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

    local LOAD_CFRAME = CFrame.new(360, 2, 2076)
    local SECRET_LOAD = CFrame.new(383, 2, 2093)
    local LOBBY_CFRAME = CFrame.new(349, 2, -19)

    local farming = false
    local farmSession = 0
    local startCFrame = nil

    local collectingMoney = false
    local upgrading = false
    local claimingIndex = false
    local spinning = false

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

    local function activatePrompt(prompt)
        if not prompt or not prompt:IsA("ProximityPrompt") then return end

        if typeof(fireproximityprompt) == "function" then
            pcall(function() fireproximityprompt(prompt, 0) end)
            return
        end

        local old = prompt.HoldDuration
        pcall(function()
            prompt.HoldDuration = 0
            prompt:InputHoldBegin()
            task.wait(0.1)
            prompt:InputHoldEnd()
        end)
        pcall(function() prompt.HoldDuration = old end)
    end

    local function isBestBrainrot(item)
        local name = item.Name:lower()
        if name:find("legendary") or name:find("mythical") then
            return false
        end
        local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt and prompt.ObjectText then
            local text = prompt.ObjectText:lower()
            if text:find("legendary") or text:find("mythical") then
                return false
            end
        end
        return true
    end

    local function getTargetSpawnedItems()
        local items = {}
        local spawners = workspace:FindFirstChild("ItemSpawners")
        if not spawners then return items end

        -- SECRET
        local secret = spawners:FindFirstChild("Secret")
        if secret then
            local root = getRootPart()
            if root then
                teleport(root, SECRET_LOAD)
                task.wait(1.0)
            end

            for _, item in ipairs(secret:GetChildren()) do
                if item:IsA("Model") and item.Name == "SpawnedItem" and isBestBrainrot(item) then
                    table.insert(items, item)
                end
            end
        end

        -- CELESTIAL
        local celestial = spawners:FindFirstChild("Celestial")
        if celestial then
            for _, item in ipairs(celestial:GetChildren()) do
                if item:IsA("Model") and item.Name == "SpawnedItem" and isBestBrainrot(item) then
                    table.insert(items, item)
                end
            end
        end

        return items
    end

    local function startFarming()
        local root = getRootPart()
        if not root then return end

        startCFrame = root.CFrame
        farming = true
        farmSession += 1
        local session = farmSession

        task.spawn(function()
            teleport(root, LOAD_CFRAME)
            task.wait(0.8)

            while farming and farmSession == session do
                local items = getTargetSpawnedItems()

                for _, item in ipairs(items) do
                    if not farming or farmSession ~= session then break end

                    local pos = item.PrimaryPart and item.PrimaryPart.Position or item:GetPivot().Position
                    teleport(root, CFrame.new(pos + Vector3.new(0, 3, 0)))
                    task.wait(0.15)

                    local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then
                        for i = 1, 5 do
                            activatePrompt(prompt)
                            task.wait(0.03)
                        end
                    end

                    task.wait(0.2)
                    teleport(root, LOBBY_CFRAME)
                    task.wait(0.6)
                end

                task.wait(0.3)
            end

            if startCFrame then
                teleport(root, startCFrame)
            end
        end)
    end

    local function stopFarming()
        farming = false
        farmSession += 1
        local root = getRootPart()
        if root and startCFrame then
            teleport(root, startCFrame)
        end
    end

    -- All brainrots for Auto Claim Index
    local allBrainrots = {
        "NoobiniPizzanini", "LiriliLarila", "TimCheese", "BonecaAmbalabu", "FluriFlura",
        "PipeMan", "CactoHipopotamo", "MelonOtter", "Sushi", "Cookie", "Sushi Pingu",
        "Snowman", "Tres Turkes", "Tres Tralala Chirsallaa", "SickPenguin", "TrippiTroppi",
        "KiwiPipi", "Los TalpaDiFerro", "BanditoBobritto", "BambiniCrostini", "TrulimeroTruli",
        "TalpaDiFerro", "GangsterFootera", "Rhino Toasterino", "Karkirkurkarkarkar Blue",
        "Nuclear", "Cocofanto Elefanto", "TuTuTuSahur", "Octopus", "TungTungTungSahur",
        "KiwiBird", "TricTracBaraboom", "BrBrBatabim", "Slice", "Guest 666",
        "GorilloWatermelondrillo", "CappoccinoAssassino", "Turkey", "LioneliCactusini",
        "LaVacaSaturno", "Brri BrriBicus", "Garamararamararaman", "Dolphinita",
        "GlorboFruittoDrillo", "OrangutiniAnanasini", "Thumbs Down", "Flying Taco",
        "Pencile", "Chef Crabracadabra", "TV", "Ballerina Cappuccina", "AvocadiniAntilopini",
        "Cactus Pingu", "CameloniMeleloni", "Chimpanzini Bananini", "FrigoCamelo",
        "Nooo My Hotspot", "L", "Los Tacos", "Madung", "Pepper", "Thumbs Up",
        "UdinDinDinDun", "1x1x1x1", "Grinch", "JobApplication", "La Vacca Saturno Saturnita",
        "Los LaVaccaSaturnoSaturnita", "W", "Chicleteira Bicicleteira", "Torrtuginni Dragonfrutini",
        "Swag Soda", "Smurf Cat", "BananaCat", "Pot Hotspot", "Yes My Examine",
        "Noo My Examine", "Esok Sekolah", "Ketupat Kepat", "Tictac Sahur",
        "Ketchuru And Musturu", "Dragon Cannelloni", "Meowl", "Trollface",
        "StrawberryElefant", "OrangeElefant", "GrapeElefant", "GreenAppleElefant",
        "MangoElefant", "CoconutElefant", "PineappleElefant", "BananaElefant",
        "WatermelonElefant", "67 Zeuss", "Trollface Zeuss", "Meowl Zeuss",
        "Dragon Cannelloni Zeuss", "StrawberryElefant Zeuss", "67", "67 USA",
        "Spider Sammy", "Speed"
    }

    local mutations = {"Normal", "Galaxy", "Rainbow", "Diamond", "Gold", "Lava", "Hacker"}

    -- ================= MAIN TAB =================
    api.Tab("Main", function(tab)
        -- Auto Farm Best Brainrots (old working version)
        tab.Toggle("Auto Farm Best Brainrots", false, function(state)
            if state then
                if not farming then startFarming() end
            else
                stopFarming()
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

        -- Remove Cars (Toggle)
        tab.Toggle("Remove Cars", false, function(state)
            if state then
                if workspace:FindFirstChild("CarSpawn") then
                    workspace.CarSpawn:Destroy()
                end
            end
        end)

        -- Auto Claim Index (fast)
        tab.Toggle("Auto Claim Index", false, function(state)
            claimingIndex = state
            if state then
                task.spawn(function()
                    while claimingIndex do
                        for _, brainrot in ipairs(allBrainrots) do
                            if not claimingIndex then break end
                            for _, mutation in ipairs(mutations) do
                                if not claimingIndex then break end
                                pcall(function()
                                    game:GetService("ReplicatedStorage").Events.ClaimIndexReward:InvokeServer(mutation, brainrot)
                                end)
                                task.wait(0.01)
                            end
                        end
                        task.wait(0.3)
                    end
                end)
            end
        end)

        -- ================= NEW: Auto Spin =================
        tab.Toggle("Auto Spin", false, function(state)
            if state then
                task.spawn(function()
                    while state do
                        pcall(function()
                            game:GetService("ReplicatedStorage").Remotes.Functions.SpinWheel:InvokeServer()
                        end)
                        task.wait(0.6) -- wait for spin animation

                        pcall(function()
                            game:GetService("ReplicatedStorage").Remotes.GiveSpinPrize:FireServer()
                        end)
                        task.wait(1.2) -- wait before next spin
                    end
                end)
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
        tab.Text("Version: 3.7 - Auto Spin Added")
        tab.Text("Thanks for using the hub!")
    end)
end
