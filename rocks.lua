-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local stone_types =
{
	{name="limestone", desc=S("Limestone")},
	{name="sandstone", desc=S("Sandstone")},
	{name="shale", desc=S("Shale"), dark=true, tiles={"real_minerals_shale_top.png", "real_minerals_shale_side.png"}},
	{name="granite", desc=S("Granite")},
	{name="basalt", desc=S("Basalt"), dark=true},
	{name="obsidian", desc=S("Obsidian"), dark=true},
	{name="marble", desc=S("Marble")},
	{name="quartzite", desc=S("Quartzite")},
	{name="slate", desc=S("Slate"), tiles={"real_minerals_slate_top.png", "real_minerals_slate_side.png"}},
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

	minetest.register_node("real_minerals:"..rock_def.name, {
		description = rock_def.desc,
		tiles = tiles,
		is_ground_content = true,
		groups = {cracky=3,drop_on_dig=1},
		drop = "real_minerals:"..rock_def.name.."_cobble",
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_node("real_minerals:"..rock_def.name.."_cobble", {
		description = S("@1 Cobble", rock_def.desc),
		tiles = cobble_tiles,
		is_ground_content = true,
		groups = {cracky=3,drop_on_dig=1},
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_node("real_minerals:"..rock_def.name.."_brick", {
		description = S("@1 Brick", rock_def.desc),
		tiles = brick_tiles,
		is_ground_content = true,
		groups = {cracky=3,drop_on_dig=1},
		sounds = default.node_sound_stone_defaults(),
	})
	
	minetest.register_node("real_minerals:"..rock_def.name.."_block", {
		description = S("@1 Block", rock_def.desc),
		tiles = block_tiles,
		is_ground_content = true,
		groups = {cracky=3,drop_on_dig=1},
		sounds = default.node_sound_stone_defaults(),
	})

end

for _, rock in pairs(stone_types) do
	register_rock(rock) 
end