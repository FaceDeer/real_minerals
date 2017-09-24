-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local stone_types =
{
	{name="limestone", desc=S("Limestone")},
	{name="sandstone", desc=S("Sandstone")},
	{name="shale", desc=S("Shale"), tiles={"real_minerals_shale_top.png", "real_minerals_shale_side.png"}},
	{name="granite", desc=S("Granite")},
	{name="basalt", desc=S("Basalt")},
	{name="obsidian", desc=S("Obsidian")},
	{name="marble", desc=S("Marble")},
	{name="quartzite", desc=S("Quartzite")},
	{name="slate", desc=S("Slate"), tiles={"real_minerals_slate_top.png", "real_minerals_slate_side.png"}},
}

local register_rock = function(rock_def)

	local tiles = rock_def.tiles
	if tiles == nil then
		tiles = {"real_minerals_"..rock_def.name..".png"}
	end

	minetest.register_node("real_minerals:"..rock_def.name, {
		description = rock_def.desc,
		tiles = tiles,
		is_ground_content = true,
		groups = {cracky=3,drop_on_dig=1},
		sounds = default.node_sound_stone_defaults(),
	})

end

for _, rock in pairs(stone_types) do
	register_rock(rock) 
end