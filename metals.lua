-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())

local S = minetest.get_translator(minetest.get_current_modname())

local stairs_mod = minetest.get_modpath("stairs")
local walls_mod = minetest.get_modpath("walls")

---------------------------------------------------------------------------------------------------
-- Metals

local metals_list = {
--	{name='bismuth',			level=0,	desc=S('Bismuth'),},
	{name='zinc',				level=0,	desc=S('Zinc'),},
	{name='tin',				level=0,	desc=S('Tin'),},
	{name='copper',				level=1,	desc=S('Copper'),},
	{name='lead',				level=2,	desc=S('Lead'),},
	{name='silver',				level=2,	desc=S('Silver'),},
	{name='gold',				level=2,	desc=S('Gold'),},
	{name='brass',				level=2,	desc=S('Brass'),			recipe={"copper","copper","copper","zinc"},},
	{name='sterling_silver',	level=2,	desc=S('Sterling Silver'),	recipe={"silver","silver","silver","copper"},},
	{name='rose_gold',			level=2,	desc=S('Rose Gold'),		recipe={"gold","gold","gold","brass"},},
	{name='oroide',				level=2,	desc=S('Oroide'),			recipe={"copper","copper","tin","zinc"},},
	{name='black_bronze',		level=2,	desc=S('Black Bronze'),		recipe={"copper","copper","gold","silver"},},
--	{name='bismuth_bronze',		level=2,	desc=S('Bismuth Bronze'),	recipe={"copper","copper","bismuth","tin"},},
	{name='tumbaga',			level=2,	desc=S('Tumbaga'),			recipe={"copper","gold"},},
	{name='bronze',				level=2,	desc=S('Bronze'),			recipe={"copper","copper","copper","tin"},},
--	{name='aluminium',			level=2,	desc=S('Aluminium'),},
	{name='platinum',			level=3,	desc=S('Platinum'),},
--	{name='pig_iron',			level=3,	desc=S('Pig Iron'),},
	{name='wrought_iron',		level=3,	desc=S('Iron'),},
	{name='german_silver',		level=4,	desc=S('German Silver'),	recipe={"copper","copper","copper","nickel"},},
	{name='albata',				level=4,	desc=S('Albata'),			recipe={"copper","nickel","zinc","zinc"},},
	{name='nickel',				level=4,	desc=S('Nickel'),},
	{name='steel',				level=4,	desc=S('Steel'),			recipe={"wrought_iron","group:flux","group:coal"},},
	{name='monel',				level=4,	desc=S('Monel'),			recipe={"nickel","nickel","nickel","copper"},},
	{name='black_steel',		level=5,	desc=S('Black Steel'),		recipe={"steel","steel","nickel","black_bronze"},},
}

for i, metal in pairs(metals_list) do
	--
	-- Craftitems
	--
		
	minetest.register_craftitem("real_minerals:"..metal.name.."_ingot", {
		description = S('@1 Ingot', metal.desc),
		groups = {metal_ingot = 1},
		inventory_image = "real_minerals_metal_"..metal.name.."_ingot.png",
	})

	if metal.recipe then
	--
	-- Alloy
	--
		local quantity = #metal.recipe
		local recipe_list = {}
		for _, input in pairs(metal.recipe) do
			if input:find(":") == nil then
				table.insert(recipe_list, "real_minerals:"..input.."_ingot")
			else
				table.insert(recipe_list, input)
				quantity = quantity - 1
			end
		end
				
		if  minetest.get_modpath("simplecrafting_lib") then
			
			local input = {}
			for _, item in pairs(metal.recipe) do
				input["real_minerals:"..item.."_ingot"] = (input["real_minerals:"..item.."_ingot"] or 0) + 1
			end
			
			simplecrafting_lib.register("smelter", {
				input = input,
				output = {["real_minerals:"..metal.name.."_ingot"] = quantity},
				cooktime = 3.0,
			})
		else
			minetest.register_craft({
				type = "shapeless",
				output = "real_minerals:"..metal.name.."_ingot "..tostring(quantity),
				recipe = recipe_list,
			})
		end
	end
	
	
--	minetest.register_craftitem("real_minerals:"..metal.."_lock", {
--		description = metals.desc_list[i].." Lock",
--		inventory_image = "metals_"..metal.."_lock.png",
--		groups = {lock=1}
--	})

	--
	-- Nodes
	--
	
	minetest.register_node("real_minerals:"..metal.name.."_block", {
		description = S("Block of @1", metal.desc),
		tiles = {"real_minerals_metal_"..metal.name.."_block.png"},
		particle_image = {"real_minerals_metal_"..metal.name.."_block.png"},
		is_ground_content = true,
		groups = {snappy=1,bendy=2,cracky=2,melty=2,level=metal.level,drop_on_dig=1},
		sounds = default.node_sound_metal_defaults(),
	})
	
	if stairs_mod then
		stairs.register_stair_and_slab(
			metal.name.."_block",
			"real_minerals:"..metal.name.."_block",
			{snappy=1,bendy=2,cracky=2,melty=2,level=metal.level,drop_on_dig=1},
			{"real_minerals_metal_"..metal.name.."_block.png"},
			S("@1 Block Stair", metal.desc),
			S("@1 Block Slab", metal.desc),
			default.node_sound_metal_defaults(),
			true)
	end
	
	if walls_mod then
		walls.register("real_minerals:"..metal.name.."_block_wall", S("@1 Block Wall", metal.desc), {"real_minerals_metal_"..metal.name.."_block.png"},
			"real_minerals:"..metal.name.."_block", default.node_sound_metal_defaults())
	end

	
	minetest.register_craft({
		output = "real_minerals:"..metal.name.."_block",
		recipe = {
			{"real_minerals:"..metal.name.."_ingot", "real_minerals:"..metal.name.."_ingot", "real_minerals:"..metal.name.."_ingot",},
			{"real_minerals:"..metal.name.."_ingot", "real_minerals:"..metal.name.."_ingot", "real_minerals:"..metal.name.."_ingot",},
			{"real_minerals:"..metal.name.."_ingot", "real_minerals:"..metal.name.."_ingot", "real_minerals:"..metal.name.."_ingot",},
		}
	})
	
end

--
-- Smelting
--
--
--minetest.register_craftitem("real_minerals:molding_sand_lump", {
--	description = S("Molding Sand"),
--	inventory_image = "metals_molding_sand.png"
--})
--
--minetest.register_craft({
--	type = "shapeless",
--	output = "real_minerals:molding_sand_lump 5",
--	recipe = {"grounds:clay_lump", "default:sand", "default:desert_sand"}
--})
--
--minetest.register_craftitem("real_minerals:molding_sand_mold", {
--	description = S("Molding Sand Mold"),
--	inventory_image = "metals_molding_sand_mold.png",
--})
--
--minetest.register_craftitem("real_minerals:clay_mold", {
--	description = S("Clay Mold"),
--	inventory_image = "metals_clay_mold.png",
--})
--
--minetest.register_craftitem("real_minerals:ceramic_mold", {
--	description = S("Ceramic mold"),
--	inventory_image = "metals_ceramic_mold.png",
--})
--
--minetest.register_craft({
--	output = "real_minerals:molding_sand_mold 5",
--	recipe = {
--		{"real_minerals:molding_sand_lump", "",						 "real_minerals:molding_sand_lump"},
--		{"real_minerals:molding_sand_lump", "real_minerals:molding_sand_lump", "real_minerals:molding_sand_lump"},
--	}
--})
--
--minetest.register_craft({
--	output = "real_minerals:clay_mold 5",
--	recipe = {
--		{"grounds:clay_lump", "",				  "grounds:clay_lump"},
--		{"grounds:clay_lump", "grounds:clay_lump", "grounds:clay_lump"},
--	}
--})
--
--minetest.register_craft({
--	type = "cooking",
--	output = "real_minerals:ceramic_mold",
--	recipe = "real_minerals:clay_mold",
--	cooktime = 5,
--})
--
--minetest.register_craft({
--	type = "cooking",
--	output = "real_minerals:ceramic_mold",
--	recipe = "real_minerals:molding_sand_mold",
--})

