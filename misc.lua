-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

-----------------------------------------------------------------------------------
-- Miscellaney

local mineral_list= {
	{name='sulfur', desc=S('Sulfur'), },
	{name='charcoal', desc=S('Charcoal') },
	{name='flux', desc=S('Flux') },
	{name='borax', desc=S('Borax') },
}

for i, mineral in pairs(mineral_list) do
	minetest.register_craftitem("real_minerals:"..mineral.name, {
		description = mineral.desc,
		inventory_image = "real_minerals_"..mineral.name.."_mineral.png",
	})
end

minetest.register_node("real_minerals:sulfur_in_stone", {
	description = S('Sulfur'),
	tiles = {"default_stone.png^real_minerals_sulfur_ore.png"},
	particle_image = {"real_minerals_sulfur_ore.png"},
	paramtype = "light",
	groups = {cracky=3,drop_on_dig=1,dig_immediate=2},
	drop = {
		max_items = 1,
		items = {
			{
				items = {"minerals:sulfur 3"},
				rarity = 15,
			},
			{
				items = {"minerals:sulfur 2"},
			}
		}
	},
})

minetest.register_node("real_minerals:peat", {
	description = S("Peat"),
	tiles = {"real_minerals_peat_ore.png"},
	particle_image = {"real_minerals_peat_ore.png"},
	groups = {crumbly=3,drop_on_dig=1,falling_node=1},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_ore({
	ore_type	   = "scatter",
	ore			= "real_minerals:peat",
	wherein		= "default:dirt",
	clust_scarcity = 20*20*20,
	clust_num_ores = 343,
	clust_size	 = 7,
	y_min	 = -31000,
	y_max	 = 0,
})

-------------------------------------------------
-- Fuels

minetest.register_craft({
	type = "fuel",
	recipe = "real_minerals:charcoal",
	burntime = 20,
})

minetest.register_craft({
	type = "fuel",
	recipe = "real_minerals:graphite",
	burntime = 20,
})

minetest.register_craft({
	type = "fuel",
	recipe = "real_minerals:lignite",
	burntime = 25,
})

minetest.register_craft({
	type = "fuel",
	recipe = "real_minerals:bituminous_coal",
	burntime = 35,
})

minetest.register_craft({
	type = "fuel",
	recipe = "real_minerals:anthracite",
	burntime = 50,
})

minetest.register_craft({
	type = "fuel",
	recipe = "real_minerals:peat",
	burntime = 15
})
