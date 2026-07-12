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
    local claimingIndex = false

    local LOBBY = CFrame.new(349, 2, -19)

    local function getRootPart()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        return char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
    end

    -- All brainrots (from your list)
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

    -- All mutations
    local mutations = {"Normal", "Galaxy", "Rainbow", "Diamond", "Gold", "Lava", "Hacker"}

    -- ================= MAIN TAB =================
    api.Tab("Main", function(tab)
        -- Auto Farm Best Brainrots (old working method)
        tab.Toggle("Auto Farm Best Brainrots", false, function(state)
            farming = state
            if state then
                task.spawn(function()
                    while farming do
                        local items = {}
                        local secret = workspace.ItemSpawners:FindFirstChild("Secret")
                        if secret then
                            for _, item in ipairs(secret:GetDescendants()) do
                                if item:IsA("Model") and item.Name == "SpawnedItem" then
                                    table.insert(items, item)
                                end
                            end
                        end
                        local celestial = workspace.ItemSpawners:FindFirstChild("Celestial")
                        if celestial then
                            for _, item in ipairs(celestial:GetDescendants()) do
                                if item:IsA("Model") and item.Name == "SpawnedItem" then
                                    table.insert(items, item)
                                end
                            end
                        end
                        for _, item in ipairs(items) do
                            if not farming then break end
                            if item.PrimaryPart then
                                getRootPart().CFrame = item.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                                task.wait(0.25)
                                local prompt = item:FindFirstChildOfClass("ProximityPrompt", true)
                                if prompt then
                                    for i = 1, 10 do
                                        fireproximityprompt(prompt)
                                        task.wait(0.02)
                                    end
                                end
                                task.wait(0.35)
                                getRootPart().CFrame = LOBBY
                                task.wait(0.9)
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

        -- Remove Cars (Toggle)
        tab.Toggle("Remove Cars", false, function(state)
            if state then
                if workspace:FindFirstChild("CarSpawn") then
                    workspace.CarSpawn:Destroy()
                end
            end
        end)

        -- ================= NEW: Auto Claim Index =================
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
                                task.wait(0.08) -- small delay to avoid rate limit
                            end
                        end
                        task.wait(3) -- wait a bit before next full loop
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
        tab.Text("Version: 3.4 - Auto Claim Index Added")
        tab.Text("Thanks for using the hub!")
    end)
end
