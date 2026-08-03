--[[
src/games/6447798030.lua — Funky Friday
LuisGamerCoolHub
]]

return function(_, api)
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    local actor = lp.PlayerScripts:WaitForChild("ClientActor")

    local function stopAutoplayer()
        getgenv().FF_Auto = false
        pcall(function()
            run_on_actor(actor, [[
                getgenv().FF_Auto = false
                getgenv().autoplayer = false
            ]])
        end)
        if getgenv()._FF_ChildConn then
            pcall(function()
                getgenv()._FF_ChildConn:Disconnect()
            end)
            getgenv()._FF_ChildConn = nil
        end
        if getgenv()._FF_GuiConn then
            pcall(function()
                getgenv()._FF_GuiConn:Disconnect()
            end)
            getgenv()._FF_GuiConn = nil
        end
    end

    local function arm()
        if typeof(run_on_actor) ~= "function" then
            warn("[FF] need run_on_actor (Opiumware/high UNC)")
            return
        end

        run_on_actor(actor, [=[
            local RunService = game:GetService("RunService")
            local VIM = game:GetService("VirtualInputManager")

            getgenv().FF_Auto = true
            getgenv().autoplayer = true
            getgenv().hitmethod = getgenv().hitmethod or "firefunc"
            getgenv().perfectOnly = true

            local keyMap = {}
            for _, enum in next, Enum.KeyCode:GetEnumItems() do
                keyMap[enum.Value] = enum
            end

            local function findFramework()
                if getgenv().framework and typeof(getgenv().framework) == "table" then
                    return getgenv().framework
                end
                for _, obj in pairs(getgc(true)) do
                    if type(obj) == "table"
                        and type(rawget(obj, "VSRG")) == "table"
                        and type(rawget(obj, "Songs")) == "table"
                        and type(rawget(obj, "IsStudio")) == "boolean"
                    then
                        getgenv().framework = obj
                        return obj
                    end
                end
                return nil
            end

            local framework = findFramework()
            if not framework then
                warn("[FF] framework not found yet — retrying when match starts")
            end

            getgenv().keybindtbl = getgenv().keybindtbl or {}

            local function updateKeybinds(mode)
                local fw = findFramework()
                if not (fw and fw.VSRG and fw.VSRG.Arrows and fw.VSRG.Arrows[mode]) then
                    return
                end
                table.clear(getgenv().keybindtbl)
                for i, arrowData in pairs(fw.VSRG.Arrows[mode].Arrows) do
                    local dir = tonumber(i) + 1
                    local kb = arrowData.Keybinds and arrowData.Keybinds.Keyboard and arrowData.Keybinds.Keyboard[1]
                    if kb then
                        getgenv().keybindtbl[dir] = keyMap[kb]
                    end
                end
            end

            pcall(updateKeybinds, "4Key")

            local function press(lane, state)
                local fw = findFramework()
                local method = getgenv().hitmethod or "firefunc"
                if method == "firefunc" and fw and fw.VSRG and fw.VSRG.GameHandler and fw.VSRG.GameHandler.Field then
                    local field = fw.VSRG.GameHandler.Field
                    if typeof(field.HitLane) == "function" then
                        field.HitLane(field, lane, state, nil)
                        return
                    end
                end
                local key = getgenv().keybindtbl[lane]
                if key then
                    VIM:SendKeyEvent(state, key, false, nil)
                end
            end

            if getgenv()._FF_Conn then
                pcall(function()
                    getgenv()._FF_Conn:Disconnect()
                end)
            end

            getgenv()._FF_Conn = RunService.RenderStepped:Connect(function()
                if not getgenv().FF_Auto or not getgenv().autoplayer then
                    return
                end

                local fw = findFramework()
                if not fw then
                    return
                end

                local field = fw.VSRG and fw.VSRG.GameHandler and fw.VSRG.GameHandler.Field
                if not field or not field.Game then
                    return
                end

                local timepos = field.Game.TimePosition
                if typeof(timepos) ~= "number" then
                    return
                end

                local playback = field.Game.AdjustedPlayback or 1
                if playback == 0 then
                    playback = 1
                end

                local count = 4
                pcall(function()
                    count = fw.VSRG.GameHandler:GetKeyCount() or 4
                end)
                pcall(updateKeybinds, tostring(count) .. "Key")

                local cache = field.NoteCache
                if typeof(cache) ~= "table" then
                    return
                end

                for _, arrow in next, cache do
                    if type(arrow) ~= "table" then
                        continue
                    end
                    if arrow.Marked then
                        continue
                    end
                    if arrow.Field and field.Side and arrow.Field ~= field.Side then
                        continue
                    end
                    if arrow.NoteData and arrow.NoteData.Type then
                        continue
                    end
                    if arrow.NoteDataConfigs and arrow.NoteDataConfigs.Type then
                        local t = arrow.NoteDataConfigs.Type
                        if t == "Death" or t == "Mechanic" or t == "Poison" then
                            continue
                        end
                    end

                    local arrowtime = tonumber(arrow.Time)
                    if not arrowtime then
                        continue
                    end

                    local diff = (arrowtime - timepos) / playback
                    if diff > -0.04 and diff < 0.85 then
                        arrow.Marked = true
                        local lane = arrow.Direction or arrow.Lane
                        local len = (tonumber(arrow.Length) or 0.03) / playback
                        task.delay(math.max(diff, 0), function()
                            if not getgenv().FF_Auto then
                                return
                            end
                            press(lane, true)
                            task.delay(math.max(len, 0.03), function()
                                press(lane, false)
                            end)
                        end)
                    end
                end
            end)

            pcall(function()
                local fw = findFramework()
                if fw and fw.SettingsHandler then
                    fw.SettingsHandler:Set("BotPlay", true)
                    fw.SettingsHandler:Set("BotPlayAccuracy", 100)
                end
            end)

            warn("[FF] actor autoplayer armed (perfect timing)")
        ]=])
    end

    local function startAutoplayer()
        if typeof(run_on_actor) ~= "function" then
            warn("[FF] need run_on_actor (Opiumware/high UNC)")
            return
        end

        getgenv().FF_Auto = true
        arm()

        if getgenv()._FF_ChildConn then
            pcall(function()
                getgenv()._FF_ChildConn:Disconnect()
            end)
        end

        getgenv()._FF_ChildConn = lp.PlayerGui.ChildAdded:Connect(function(child)
            if not getgenv().FF_Auto then
                return
            end
            if child.Name == "Window" then
                task.wait(0.35)
                arm()
            end
        end)

        pcall(function()
            local gg = lp.PlayerGui:FindFirstChild("GameGui")
            if gg then
                if getgenv()._FF_GuiConn then
                    pcall(function()
                        getgenv()._FF_GuiConn:Disconnect()
                    end)
                end
                getgenv()._FF_GuiConn = gg.DescendantAdded:Connect(function(d)
                    if not getgenv().FF_Auto then
                        return
                    end
                    if d.Name == "Window" or d.Name == "PlayingField" then
                        task.wait(0.4)
                        arm()
                    end
                end)
            end
        end)
    end

    api.Tab("Main", function(tab)
        tab.Toggle("Perfect Autoplayer", false, function(state)
            if state then
                startAutoplayer()
            else
                stopAutoplayer()
            end
        end)
        tab.Text("Join/start a match for perfect hits")
        tab.Text("Needs run_on_actor (Opiumware)")
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
