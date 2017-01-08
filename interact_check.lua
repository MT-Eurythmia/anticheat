local function check(pos, player)
	if minetest.get_player_privs(player:get_player_name())["anticheat_bypass"] then
		return false
	end

	local itemdef = player:get_wielded_item():get_definition()

	-- Death check
	if player:get_hp() <= 0 then
		return true, "Interacted while dead"
	end

	-- Distance check
	local distance = vector.distance(pos, player:get_player_pos())
	local range = itemdef.range
	if distance > range then
		return true, "Interacted too far"
	end

	return false
end

minetest.register_on_dignode(function(pos, oldnode, digger)
	local b, e = check(pos, digger)
	if b then
		minetest.set_node(pos, oldnode)

		-- Take the digged from the player inventory
		local inv = digger:get_inventory()
		for i, stack in ipairs(inv:get_list("main")) do
			if stack:get_name() == oldnode.name then
				stack:take_item()
			end
		end

		anticheat.cheats(digger, e)
	end
end)

minetest.register_on_placenode(function(pos, _, placer, oldnode)
	local b, e = check(pos, placer)
	if b then
		minetest.set_node(pos, oldnode)
		anticheat.cheats(placer, e)
		return true -- Takes no item from the itemstack
	end
end)

minetest.register_on_punchnode(function(pos, node, puncher)
	local b, e = check(pos, puncher)
	if b then
		anticheat.cheats(puncher, e)
	end
end)
