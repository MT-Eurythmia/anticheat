anticheat = {}

minetest.register_privilege("anticheat_bypass", {
	description = "Allow to bypass anticheat checks",
	give_to_singleplayer = true
})

function anticheat.cheats(cheater, reason)
	local name = cheater:get_player_name()
	minetest.kick_player(name, reason)
	minetest.log("warning", "Detected cheat from player "..name..": "..reason)
end

dofile(minetest.get_modpath(minetest.get_current_modname()).."/interact_check.lua")
