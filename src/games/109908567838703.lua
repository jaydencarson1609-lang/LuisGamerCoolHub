--[[
	src/games/<PlaceId>.lua — per-game script template

	HOW TO ADD A NEW GAME
	----------------------
	1. Find the game's PlaceId (the number in the game's URL, e.g.
	   roblox.com/games/109908567838703/... -> PlaceId is 109908567838703).
	2. Copy this file to src/games/<PlaceId>.lua  (just the number, .lua extension).
	3. Add a matching entry to src/gameslist.json so it shows up in the
	   "Supported games" list even when the player isn't in it yet:
	       { "game": "Your Game Name", "id": "<PlaceId>", "status": "🟢" }
	4. Push to GitHub. Nothing in ui.lua needs to change — the Games tab
	   fetches this file by PlaceId automatically the next time someone
	   opens the hub in that game.

	WHAT YOU GET
	------------
	ui.lua calls this file as:  gameModule(container, api)

	container — the ContentHolder frame your elements get parented to
	            (you don't need this directly, just pass it through if
	            you ever call Element.* yourself instead of api.*)

	api       — three helpers wired to the hub's existing Home/Settings
	            builders, so this file doesn't need to loadstring
	            elements.lua itself:
	                api.Text(message)
	                api.Button(text, callback)
	                api.Toggle(text, defaultBool, callback)

	Return a single function — that's the whole contract.
]]

return function(container, api)
	local Players = game:GetService("Players")
	local plr = Players.LocalPlayer

	api.Text("Loaded script for this game.")

	-- Example toggle-driven loop. Swap the body for your real logic
	-- (fireproximityprompt, teleporting, remote calls, etc).
	local running = false

	api.Toggle("Auto Farm", false, function(state)
		running = state

		if state then
			task.spawn(function()
				while running do
					-- your farm loop here
					task.wait(1)
				end
			end)
		end
	end)

	api.Button("One-off Action", function()
		print("Button pressed for PlaceId " .. tostring(game.PlaceId))
	end)
end
