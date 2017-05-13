-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

---------------------------------------------------------------------------------------------------
-- Metals

local metals_list = {
	{name='bismuth',			level=0,	desc=S('Bismuth'),},
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
	{name='bismuth_bronze',		level=2,	desc=S('Bismuth Bronze'),	recipe={"copper","copper","bismuth","tin"},},
	{name='tumbaga',			level=2,	desc=S('Tumbaga'),			recipe={"copper","gold"},},
	{name='bronze',				level=2,	desc=S('Bronze'),			recipe={"copper","copper","copper","tin"},},
	{name='aluminium',			level=2,	desc=S('Aluminium'),},
	{name='platinum',			level=3,	desc=S('Platinum'),},
	{name='pig_iron',			level=3,	desc=S('Pig Iron'),},
	{name='wrought_iron',		level=3,	desc=S('Wrought Iron'),},
	{name='german_silver',		level=4,	desc=S('German Silver'),	recipe={"copper","copper","copper","nickel"},},
	{name='albata',				level=4,	desc=S('Albata'),			recipe={"copper","nickel","zinc","zinc"},},
	{name='nickel',				level=4,	desc=S('Nickel'),},
	{name='steel',				level=4,	desc=S('Steel'),			recipe={"wrought_iron","wrought_iron","wrought_iron","pig_iron",},},
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
			table.insert(recipe_list, "real_minerals:"..input.."_ingot")
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


-------------------------------------------------------
-- Ores

local ore_list = {
	{name="lignite",			def={desc=S("Lignite"),			},},
	{name="anthracite",			def={desc=S("Anthracite"),		},},
	{name="bituminous_coal",	def={desc=S("Bituminous Coal"),	},},
	{name="magnetite",			def={desc=S("Magnetite"),		product='pig_iron',	},},
	{name="hematite",			def={desc=S("Hematite"),		product='pig_iron',	},},
	{name="limonite",			def={desc=S("Limonite"),		product='pig_iron',	},},
	{name="bismuthinite",		def={desc=S("Bismuthinite"),	product='bismuth',	},},
	{name="cassiterite",		def={desc=S("Cassiterite"),		product='tin',		},},
	{name="galena",				def={desc=S("Galena"),			product='lead',		},},
	{name="garnierite",			def={desc=S("Garnierite"),		product='nickel',	},},
	{name="malachite",			def={desc=S("Malachite"),		product='copper',	},},
	{name="native_copper",		def={desc=S("Native Copper"),	product='copper',	wherein = {"default:stone", "default:desert_stone"},	},},
	{name="native_gold",		def={desc=S("Native Gold"),		product='gold',		wherein = {"default:stone", "default:desert_stone"},	},},
	{name="native_silver",		def={desc=S("Native Silver"),	product='silver',	},},
	{name="native_platinum",	def={desc=S("Native Platinum"),	product='platinum',	},},
	{name="sphalerite",			def={desc=S("Sphalerite"),		product='zinc',		},},
	{name="tetrahedrite",		def={desc=S("Tetrahedrite"),	product='copper',	},},
	{name="lazurite",			def={desc=S("Lazurite"),		},},
	{name="bauxite",			def={desc=S("Bauxite"),			product='aluminium',},},
	{name="cinnabar",			def={desc=S('Cinnabar'),		},},
	{name="cryolite",			def={desc=S('Cryolite'),		},},
	{name="graphite",			def={desc=S('Graphite'),		},},
	{name="gypsum",				def={desc=S('Gypsum'),			},},
	{name="jet",				def={desc=S('Jet'),				},},
	{name="kaolinite",			def={desc=S('Kaolinite'),		},},
	{name="kimberlite",			def={desc=S('Kimberlite'),		},},
	{name="olivine",			def={desc=S('Olivine'),			},},
	{name="petrified_wood",		def={desc=S('Petrified wood'),	},},
	{name="pitchblende",		def={desc=S('Pitchblende'),		},},
	{name="saltpeter",			def={desc=S('Saltpeter'),		},},
	{name="satin_spar",			def={desc=S('Satin Spar'),		},},
	{name="selenite",			def={desc=S('Selenite'),		},},
	{name="serpentine",			def={desc=S('Serpentine'),		},},
	{name="sylvite",			def={desc=S('Sylvite'),			},},
	{name="tenorite",			def={desc=S('Tenorite'),		},},
}

local d_seed = 0
local function copytable(t)
	local t2 = {}
	for k,i in pairs(t) do
		t2[k] = i
	end
	return t2
end

local function register_ore(name, OreDef)
	local ore = {
		name = "real_minerals:"..name,
		description = OreDef.desc or S("Ore"),
		mineral = OreDef.mineral or "real_minerals:"..name,
		wherein = OreDef.wherein or {"default:stone"},
		clust_scarcity = 1/(OreDef.chunks_per_volume or 1/3/3/3/2),
		clust_size = OreDef.chunk_size or 3,
		clust_num_ores = OreDef.ore_per_chunk or 10,
		y_min = OreDef.height_min or -30912,
		y_max = OreDef.height_max or 30912,
		noise_threshold = OreDef.noise_min or 1.2,
		noise_params = {offset=0, scale=1, spread={x=100, y=100, z=100}, octaves=3, persist=0.70, seed = OreDef.delta_seed or d_seed},
		generate = true
	}
	
	minetest.register_craftitem("real_minerals:"..name, {
		description = ore.description,
		inventory_image = "real_minerals_"..name.."_mineral.png",
	})
	
	if OreDef.product then
		if  minetest.get_modpath("simplecrafting_lib") then
			simplecrafting_lib.register("smelter", {
				input = {["real_minerals:"..name] = 1},
				output = {["real_minerals:"..OreDef.product.."_ingot"] = 1},
				cooktime = 5,
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
		if minetest.registered_nodes[wherein].tiles or minetest.registered_nodes[wherein].tile_images then
			for _, texture in ipairs(minetest.registered_nodes[wherein].tiles) do
				table.insert(wherein_textures, texture.."^"..name_.."_ore.png")
			end
		else
			wherein_textures = {name_..".png"}
		end
		minetest.register_node("real_minerals:"..name.."_in_"..wherein_, {
			description = S("@1 Ore", ore.description),
			tiles = wherein_textures,
			particle_image = {ore.particle_image},
			groups = {cracky=3,drop_on_dig=1,ore=1,dropping_like_stone=1},
			drop = {
				max_items = 1,
				items = {
					{
						items = {ore.mineral.." 2"},
						rarity = 2
					},
					{
						items = {ore.mineral}
					}
				}
			},
			sounds = default.node_sound_stone_defaults()
		})
		if ore.generate then
			local oredef = copytable(ore)
			oredef.ore = "real_minerals:"..name.."_in_"..wherein_
			oredef.ore_type = "scatter"
			oredef.wherein = wherein
			minetest.register_ore(oredef)
		end
	end
end

for _, ore in pairs(ore_list) do
	register_ore(ore.name, ore.def) 
end

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

