-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local stairs_mod = minetest.get_modpath("stairs")

local stone_types =
{
	{name="limestone", desc=S("Limestone"), groups={flux=1}},
	{name="limestone_light", desc=S("Limestone"), groups={flux=1}},
	{name="sandstone", desc=S("Sandstone")},
	{name="desert_sandstone", desc=S("Sandstone")},
	{name="silver_sandstone", desc=S("Sandstone")},
	{name="shale", desc=S("Shale"), dark=true, tiles={"real_minerals_shale_top.png", "real_minerals_shale_top.png", "real_minerals_shale_side.png"}},
	{name="granite", desc=S("Granite")},
	{name="basalt", desc=S("Basalt"), dark=true},
	{name="gabbro", desc=S("Gabbro")},
	{name="rhyolite", desc=S("Rhyolite")},
	{name="obsidian", desc=S("Obsidian"), dark=true},
	{name="marble", desc=S("Marble"), groups={flux=1}},
	{name="quartzite", desc=S("Quartzite")},
	{name="slate", desc=S("Slate"), tiles={"real_minerals_slate_top.png", "real_minerals_slate_top.png", "real_minerals_slate_side.png"}},
}

local register_rock = function(rock_def)

	local tiles = rock_def.tiles
	if tiles == nil then
		tiles = {"real_minerals_"..rock_def.name..".png"}
	end
	local cobble_tiles = {}
	for _, tile in ipairs(tiles) do
		table.insert(cobble_tiles, tile.."^real_minerals_overlay_cobble.png")
	end
	local brick_tiles = {}
	for _, tile in ipairs(tiles) do
		if rock_def.dark then
			table.insert(brick_tiles, tile.."^(real_minerals_overlay_brick.png^[multiply:#888)")
		else
			table.insert(brick_tiles, tile.."^real_minerals_overlay_brick.png")
		end
	end
	local block_tiles = {}
	for _, tile in ipairs(tiles) do
		if rock_def.dark then
			table.insert(block_tiles, tile.."^(real_minerals_overlay_block.png^[multiply:#888)")
		else
			table.insert(block_tiles, tile.."^real_minerals_overlay_block.png")
		end
	end
	
	local nodes = {
		{
			name = "real_minerals:"..rock_def.name,
			def = {
				description = rock_def.desc,
				tiles = tiles,
				is_ground_content = true,
				groups = {cracky=3,drop_on_dig=1,stone=1},		
				drop = {
					max_items = 1,
					items = {
						{
							items = {"real_minerals:"..rock_def.name.."_block"},  -- Items to drop.
							tools = {"real_minerals:stone_splitting_wedge"}
						},
						{
							items = {"real_minerals:"..rock_def.name.."_cobble"},  -- Items to drop.
						},
					},
				},
				sounds = default.node_sound_stone_defaults(),
			}
		},
		{
			name = "real_minerals:"..rock_def.name.."_cobble",
			def = {
				description = S("@1 Cobble", rock_def.desc),
				tiles = cobble_tiles,
				is_ground_content = true,
				groups = {cracky=3,drop_on_dig=1,stone=2},
				sounds = default.node_sound_stone_defaults(),
			}
		},
		{
			name = "real_minerals:"..rock_def.name.."_brick",
			def = {
				description = S("@1 Brick", rock_def.desc),
				tiles = brick_tiles,
				is_ground_content = true,
				groups = {cracky=2,drop_on_dig=1,stone=1},
				sounds = default.node_sound_stone_defaults(),
			}
		},
		{
			name = "real_minerals:"..rock_def.name.."_block",
			def = {
				description = S("@1 Block", rock_def.desc),
				tiles = block_tiles,
				is_ground_content = true,
				groups = {cracky=2,drop_on_dig=1,stone=1},
				sounds = default.node_sound_stone_defaults(),
			}
		},
	}
	
	if rock_def.groups then
		for _, v in ipairs(nodes) do
			for group, level in pairs(rock_def.groups) do
				v.def.groups[group] = level
			end
		end
	end

	if magma_conduits and magma_conduits.make_hot_node_def then
		local new_nodes = {}
		for k, v in ipairs(nodes) do
			local hot_name, hot_def = magma_conduits.make_hot_node_def(v.name, v.def)
			table.insert(new_nodes, v)
			table.insert(new_nodes, {name = hot_name, def = hot_def})
		end
		nodes = new_nodes
	end

	for k, v in ipairs(nodes) do
		minetest.register_node(v.name, v.def)
	end
	
	if stairs_mod then
		--stairs.register_stair_and_slab(subname, recipeitem, groups, images, desc_stair, desc_slab, sounds, worldaligntex)
		stairs.register_stair_and_slab(
			rock_def.name.."_cobble",
			"real_minerals:"..rock_def.name.."_cobble",
			{cracky = 3},
			cobble_tiles,
			S("@1 Cobble Stair", rock_def.desc),
			S("@1 Cobble Slab", rock_def.desc),
			default.node_sound_stone_defaults(),
			true)
		stairs.register_stair_and_slab(
			rock_def.name.."_brick",
			"real_minerals:"..rock_def.name.."_brick",
			{cracky = 2},
			brick_tiles,
			S("@1 Brick Stair", rock_def.desc),
			S("@1 Brick Slab", rock_def.desc),
			default.node_sound_stone_defaults(),
			false)
		stairs.register_stair_and_slab(
			rock_def.name.."_block",
			"real_minerals:"..rock_def.name.."_block",
			{cracky = 2},
			block_tiles,
			S("@1 Block Stair", rock_def.desc),
			S("@1 Block Slab", rock_def.desc),
			default.node_sound_stone_defaults(),
			true)
	end
	
	minetest.register_craft({
		type = "shapeless",
		output = "real_minerals:"..rock_def.name.."_brick",
		recipe = {"real_minerals:"..rock_def.name.."_block"}
	})
end

for _, rock in pairs(stone_types) do
	register_rock(rock) 
end

local USES = 200

minetest.register_tool("real_minerals:stone_splitting_wedge", {
	description = S("Wedge and Shim Set"),
	inventory_image = "real_minerals_splitting_wedge.png",
	stack_max = 1,
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=4.00, [2]=1.60, [3]=0.80}, uses=20, maxlevel=2},
		},
		damage_groups = {fleshy=4},
	},
	after_use = function(itemstack, user, node, digparams)
		--minetest.sound_play("vines_shears", {pos=user:getpos()})
		minetest.debug("splitter after_use params")
		minetest.debug(dump(node))
		minetest.debug(dump(digparams))
		if not minetest.settings:get_bool("creative_mode") then
			itemstack:add_wear(digparams.wear)
		end
		return itemstack
	end,
	sound = {breaks = "default_tool_breaks"},
})
