-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local stairs_mod = minetest.get_modpath("stairs")
local walls_mod = minetest.get_modpath("walls")

-------------------------------------------------------
-- Ores

real_minerals.contains_ore = {}

local sedimentary = {"real_minerals:limestone", "real_minerals:limestone_light", "real_minerals:sandstone", "real_minerals:desert_sandstone", "real_minerals:silver_sandstone", "real_minerals:shale"}
local igneous = {"real_minerals:granite", "real_minerals:basalt", "real_minerals:gabbro"}
local metamorphic = {"real_minerals:marble", "real_minerals:quartzite", "real_minerals:slate"}

function jointables(t1, t2)
	local newTable = {}
	for k,v in ipairs(t1) do
		table.insert(newTable, v)
	end
	for k,v in ipairs(t2) do
		table.insert(newTable, v)
	end
	return newTable
end

function vein(stratum_rand, field, offset, width, rarity)
	return math.abs(field) < width and stratum_rand > offset and stratum_rand < offset+(rarity*4)
end
function blob(stratum_rand, field, offset, size, rarity)
	return math.abs(field) > size and stratum_rand > offset and stratum_rand < offset+(rarity*4)
end

local standard_vein_width = 0.05


minetest.register_craft({
	output = 'default:torch 4',
	recipe = {
		{'group:coal'},
		{'group:stick'},
	}
})

local ore_list = {
	{name="lignite", def={
		desc=S("Lignite"),
		wherein = sedimentary,
		lump_groups = {coal = 1},
		place = function(stratum_rand, field)
			return vein(stratum_rand, field, 0, standard_vein_width, 0.005)
		end,
		ore_rarity = 2,
	},},
--	{name="anthracite",	def={
--		desc=S("Anthracite"),
--		lump_groups = {coal = 1},
--		wherein = sedimentary,
--	},},
	{name="bituminous_coal", def={
		desc=S("Bituminous Coal"),
		wherein = sedimentary,
		lump_groups = {coal = 1},
		place = function(stratum_rand, field)
			return blob(stratum_rand, field, 0.1, 0.5, 0.01) and math.random() > 0.1
		end,
		ore_rarity = 1,
	},},
	{name="magnetite", def={
		desc=S("Magnetite"),
		product='pig_iron',
		wherein = sedimentary,
		place = function(stratum_rand, field)
			return blob(stratum_rand, field, 0.2, 0.6, 0.005)
		end,
	},},
	{name="hematite", def={
		desc=S("Hematite"),
		product='pig_iron',
		wherein = jointables(sedimentary, igneous),
		place = function(stratum_rand, field)
			return vein(stratum_rand, field, 0.3, standard_vein_width, 0.005)
		end,
	},},
	{name="limonite", def={
		desc=S("Limonite"),
		product='pig_iron',
		wherein = sedimentary,
		place = function(stratum_rand, field)
			vein(stratum_rand, field, 0.4, standard_vein_width, 0.005)
		end,
	},},
--	{name="bismuthinite", def={
--		desc=S("Bismuthinite"),
--		product='bismuth',
--		wherein={"real_minerals:granite"},
--		place = function(stratum_rand, field)
--			return blob(stratum_rand, field, 0.5, 0.75, 0.005)
--		end,
--	},},
	{name="cassiterite", def={
		desc=S("Cassiterite"),
		product='tin',
		wherein={"real_minerals:granite"},
		place = function(stratum_rand, field)
			return vein(stratum_rand, field, 0.6, standard_vein_width, 0.0025)
		end,
	},},
	{name="galena", def={
		desc=S("Galena"),
		product='lead',
		wherein=jointables(igneous, jointables(metamorphic, {"real_minerals:limestone", "real_minerals:limestone_light"})),
		place = function(stratum_rand, field)
			return vein(stratum_rand, field, 0.7, standard_vein_width, 0.0025)
		end,
	},},
	{name="garnierite", def={
		desc=S("Garnierite"),
		product='nickel',
		wherein={"real_minerals:granite"}, -- should be gabbro, granite's close enough
		place = function(stratum_rand, field)
			return vein(stratum_rand, field, 0.8, standard_vein_width, 0.0025)
		end,
	},},
	{name="malachite", def={
		desc=S("Malachite"),
		product='copper',
		wherein={"real_minerals:limestone", "real_minerals:limestone_light", "real_minerals:marble"}, 
		place = function(stratum_rand, field)
			return vein(stratum_rand, field, 0.9, standard_vein_width, 0.0075)
		end,
	},},
	{name="native_copper", def={
		desc=S("Native Copper"),
		product='copper',
		wherein_default = {"default:stone", "default:desert_stone"},
		wherein = jointables(igneous, {"real_minerals:sandstone", "real_minerals:desert_sandstone", "real_minerals:silver_sandstone"}),
		place = function(stratum_rand, field)
			return blob(stratum_rand, field, 0.05, 0.7, 0.005)
		end,
	},},
	{name="native_gold", def={
		desc=S("Native Gold"),
		product='gold',
		wherein_default = {"default:stone", "default:desert_stone"},
		wherein = igneous,
		place = function(stratum_rand, field)
			return blob(stratum_rand, field, 0.15, 0.75, 0.001)
		end,
	},},
	{name="native_silver", def={
		desc=S("Native Silver"),
		product='silver',
		wherein={"real_minerals:granite"},
		place = function(stratum_rand, field)
			return blob(stratum_rand, field, 0.25, 0.75, 0.0025)
		end,
	},},
	{name="native_platinum", def={
		desc=S("Native Platinum"),
		product='platinum',
		wherein=sedimentary, -- actually in magnetite, olivine, chromite
		place = function(stratum_rand, field)
			return blob(stratum_rand, field, 0.35, 0.85, 0.005)
		end,
	},},
	{name="sphalerite", def={
		desc=S("Sphalerite"),
		product='zinc',
		wherein=metamorphic,
		place = function(stratum_rand, field)
			return vein(stratum_rand, field, 0.45, standard_vein_width, 0.0025)
		end,
	},},
	{name="tetrahedrite", def={
		desc=S("Tetrahedrite"),
		product='copper',
		wherein=jointables(sedimentary, jointables(igneous, metamorphic)),
		place = function(stratum_rand, field)
			return vein(stratum_rand, field, 0.55, standard_vein_width, 0.0075)
		end,
	},},
--	{name="bauxite", def={
--		desc=S("Bauxite"),
--		product='aluminium',
--		wherein=sedimentary,
--		place = function(stratum_rand, field)
--			return blob(stratum_rand, field, 0.65, 0.6, 0.005)
--		end,
--	},},
--	{name="lazurite", 			def={desc=S("Lazurite"),		},},
--	{name="cinnabar", 			def={desc=S('Cinnabar'),		},},
--	{name="cryolite",			def={desc=S('Cryolite'),		},},
--	{name="graphite",			def={desc=S('Graphite'),		},},
--	{name="gypsum",				def={desc=S('Gypsum'),			},},
--	{name="jet",				def={desc=S('Jet'),				},},
--	{name="kaolinite",			def={desc=S('Kaolinite'),		},},
--	{name="kimberlite",			def={desc=S('Kimberlite'),		},},
--	{name="olivine",			def={desc=S('Olivine'),			},},
--	{name="petrified_wood",		def={desc=S('Petrified wood'),	},},
--	{name="pitchblende",		def={desc=S('Pitchblende'),		},},
--	{name="saltpeter",			def={desc=S('Saltpeter'),		},},
--	{name="satin_spar",			def={desc=S('Satin Spar'),		},},
--	{name="selenite",			def={desc=S('Selenite'),		},},
--	{name="serpentine",			def={desc=S('Serpentine'),		},},
--	{name="sylvite",			def={desc=S('Sylvite'),			},},
--	{name="tenorite",			def={desc=S('Tenorite'),		},},
}

local other_ores =
{
	{
		name = "real_minerals:obsidian",
		wherein = {"real_minerals:basalt"},
		place = function(stratum_rand, field)
			return blob(stratum_rand, field, 0, 0.5, 0.02) and math.random() > 0.05
		end,
	},
	{
		name = "default:clay",
		wherein = sedimentary,
		place = function(stratum_rand, field)
			return blob(stratum_rand, field, 0.95, 0.5, 0.01) and math.random() > 0.05
		end,
	},
}


local d_seed = 0
local function copytable(t)
	local t2 = {}
	for k,i in pairs(t) do
		if type(i) == "table" then
			t2[k] = copytable(i)
		else
			t2[k] = i
		end
	end
	return t2
end

local function register_ore(name, OreDef)

	local ore = {
		name = "real_minerals:"..name,
		description = OreDef.desc or S("Ore"),
		mineral = OreDef.mineral or "real_minerals:"..name,
		clust_scarcity = 1/(OreDef.chunks_per_volume or 1/3/3/3/2),
		clust_size = OreDef.chunk_size or 3,
		clust_num_ores = OreDef.ore_per_chunk or 10,
		y_min = OreDef.height_min or -30912,
		y_max = OreDef.height_max or 30912,
		noise_threshold = OreDef.noise_min or 1.2,
		noise_params = {offset=0, scale=1, spread={x=100, y=100, z=100}, octaves=3, persist=0.70, seed = OreDef.delta_seed or d_seed},
		generate = true
	}

	if real_minerals.config.replace_default_stone then
		ore.wherein = OreDef.wherein
	else
		ore.wherein = OreDef.wherein_default or {"default:stone"}
	end
	
	minetest.register_craftitem("real_minerals:"..name, {
		description = ore.description,
		groups = OreDef.lump_groups,
		inventory_image = "real_minerals_"..name.."_mineral.png",
	})
	
	if OreDef.product then
		if  minetest.get_modpath("simplecrafting_lib") then
			simplecrafting_lib.register("smelter", {
				input = {["real_minerals:"..name] = 1,
						["simplecrafting_lib:heat"] = 5,
				},
				output = {["real_minerals:"..OreDef.product.."_ingot"] = 1},
			})
		else
			minetest.register_craft({
				type = "cooking",
				output = "real_minerals:"..OreDef.product.."_ingot",
				recipe = "real_minerals:"..name,
				time = 5,
			})
		end
	end
	
	d_seed = d_seed + 1
	if OreDef.generate == false then
		ore.generate = false
	end
	ore.particle_image = OreDef.particle_image or ore.mineral:gsub(":","_")..".png"
	--realtest.registered_oresname = ore
	--table.insert(realtest.registered_ores_list, name)
	local name_ = "real_minerals_"..name
	for i, wherein in ipairs(ore.wherein) do
		local wherein_ = wherein:gsub(":","_")
		local wherein_textures = {}
		local wherein_node_def = minetest.registered_nodes[wherein]
		if wherein_node_def.tiles or wherein_node_def.tile_images then
			for _, texture in ipairs(wherein_node_def.tiles) do
				table.insert(wherein_textures, texture.."^"..name_.."_ore.png")
			end
		else
			wherein_textures = {name_..".png"}
		end
		
		-- Register the ore
		
		local ore_rarity = OreDef.ore_rarity or 4
		local ore_groups = copytable(wherein_node_def.groups or {})
		ore_groups.ore = 1
		ore_groups[name.."_in_"..wherein_.."_ore"] = 1
	
		local ore_node_def = {
			description = S("@1 Ore in @2", ore.description, wherein_node_def.description),
			tiles = wherein_textures,
			particle_image = {ore.particle_image},
			groups = ore_groups,
			drop = {
				max_items = 1,
				items = {
					{
						--If the player uses a splitting wedge, give them a block of ore
						items = {"real_minerals:"..name.."_in_"..wherein_.."_block"},
						tools = {"real_minerals:stone_splitting_wedge"}
					},
					{
						--Else they have a 25% chance of getting a mineral lump and a cobble block
						items = {ore.mineral, wherein.."_cobble"},
						rarity = ore_rarity
					},
					{
						--Else just give them cobble, no mineral lump
						items = {wherein.."_cobble"}
					}
				}
			},
			sounds = wherein_node_def.sounds
		}
		minetest.register_node("real_minerals:"..name.."_in_"..wherein_, ore_node_def)
		
		-- Bricks and blocks
		
		-- TODO: handle light/dark rock types
		local block_tiles = {}
		for _, wherein_texture in ipairs(wherein_textures) do
			table.insert(block_tiles, wherein_texture.."^real_minerals_overlay_block.png")
		end
		local brick_tiles = {}
		for _, wherein_texture in ipairs(wherein_textures) do
			table.insert(brick_tiles, wherein_texture.."^real_minerals_overlay_brick.png")
		end

		--Define a "block" form of this ore
		local block_groups = copytable(ore_node_def.groups)
		minetest.register_node("real_minerals:"..name.."_in_"..wherein_.."_block", {
			description = S("@1 Block", ore_node_def.description),
			tiles = block_tiles,
			is_ground_content = true,
			groups = block_groups,
			sounds = ore_node_def.sounds,
		})
		
		local brick_groups = copytable(ore_node_def.groups)
		minetest.register_node("real_minerals:"..name.."_in_"..wherein_.."_brick", {
			description = S("@1 Brick", ore_node_def.description),
			tiles = brick_tiles,
			is_ground_content = true,
			groups = brick_groups,
			sounds = ore_node_def.sounds,
		})		
		
		if stairs_mod then
			stairs.register_stair_and_slab(
				name.."_in_"..wherein_.."_brick",
				"real_minerals:"..name.."_in_"..wherein_.."_brick",
				brick_groups,
				brick_tiles,
				S("@1 Brick Stair", ore_node_def.description),
				S("@1 Brick Slab", ore_node_def.description),
				ore_node_def.sounds,
				false)
			stairs.register_stair_and_slab(
				name.."_in_"..wherein_.."_block",
				"real_minerals:"..name.."_in_"..wherein_.."_block",
				block_groups,
				block_tiles,
				S("@1 Block Stair", ore_node_def.description),
				S("@1 Block Slab", ore_node_def.description),
				ore_node_def.sounds,
				true)
		end
		
		if walls_mod then
			walls.register("real_minerals:"..name.."_in_"..wherein_.."_brick_wall", S("@1 Brick Wall", ore_node_def.description), brick_tiles,
				"real_minerals:"..name.."_in_"..wherein_.."_brick", default.node_sound_stone_defaults())
			walls.register("real_minerals:"..name.."_in_"..wherein_.."_block_wall", S("@1 Block Wall", ore_node_def.description), block_tiles,
				"real_minerals:"..name.."_in_"..wherein_.."_block", default.node_sound_stone_defaults())
		end
		
		--Allow blocks to be broken down into cobble and one mineral lump
		local recipe = {}
		for i = 1, ore_rarity do
			table.insert(recipe, "group:"..name.."_in_"..wherein_.."_ore")
		end
		local replacements = {}
		for i = 1, ore_rarity do
			table.insert(replacements, {"group:"..name.."_in_"..wherein_.."_ore", wherein.."_cobble"})
		end		
		minetest.register_craft({
			type = "shapeless",
			output = ore.mineral,
			recipe = recipe,
			replacements = replacements,
		})
		
		if ore.generate then
			local oredef = copytable(ore)
			oredef.ore = "real_minerals:"..name.."_in_"..wherein_
			oredef.ore_type = "scatter"
			oredef.wherein = wherein
			minetest.register_ore(oredef)
		end
		
		c_wherein = minetest.get_content_id(wherein)
		c_ore = minetest.get_content_id("real_minerals:"..name.."_in_"..wherein_)
		local contains_ore = real_minerals.contains_ore[c_wherein] or {}
		real_minerals.contains_ore[c_wherein] = contains_ore
		table.insert(contains_ore, {place = OreDef.place, ore = c_ore})
	end
end

for k, ore in pairs(other_ores) do
	for kk, wherein in pairs(ore.wherein) do
		c_wherein = minetest.get_content_id(wherein)
		c_ore = minetest.get_content_id(ore.name)
		local contains_ore = real_minerals.contains_ore[c_wherein] or {}
		real_minerals.contains_ore[c_wherein] = contains_ore
		table.insert(contains_ore, {place = ore.place, ore = c_ore})
	end
end

minetest.clear_registered_ores()

for _, ore in pairs(ore_list) do
	register_ore(ore.name, ore.def) 
end
