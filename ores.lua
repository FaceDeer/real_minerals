-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

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
