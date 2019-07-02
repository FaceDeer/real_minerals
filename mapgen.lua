local global_multiplier = 10

mapgen_helper.register_perlin("real_minerals:metamorphic_boundary", {
	offset = 0,
	scale = 1,
	spread = {x=256*global_multiplier, y=256*global_multiplier, z=256*global_multiplier},
	seed = -400090,
	octaves = 3,
	persist = 0.67
})

mapgen_helper.register_perlin("real_minerals:igneous_boundary", {
	offset = 0,
	scale = 1,
	spread = {x=256*global_multiplier, y=256*global_multiplier, z=256*global_multiplier},
	seed = 105510,
	octaves = 3,
	persist = 0.67
})

mapgen_helper.register_perlin("real_minerals:sedimentary_strata", {
	offset = 0,
	scale = 1,
	spread = {x=256*global_multiplier, y=256*global_multiplier, z=256*global_multiplier},
	seed = -10510,
	octaves = 3,
	persist = 0.67
})

mapgen_helper.register_perlin("real_minerals:metamorphic_type", {
	offset = 0,
	scale = 1,
	spread = {x=256*global_multiplier, y=128*global_multiplier, z=256*global_multiplier},
	seed = 399523,
	octaves = 3,
	persist = 0.67
})

mapgen_helper.register_perlin("real_minerals:igneous_type", {
	offset = 0,
	scale = 1,
	spread = {x=256*global_multiplier, y=128*global_multiplier, z=256*global_multiplier},
	seed = -7722345,
	octaves = 3,
	persist = 0.67
})

mapgen_helper.register_perlin("real_minerals:sedimentary_type", {
	offset = 0,
	scale = 1,
	spread = {x=256*global_multiplier, y=128*global_multiplier, z=256*global_multiplier},
	seed = 9955553,
	octaves = 3,
	persist = 0.67
})

local ore_field_perlin = {
	offset = 0,
	scale = 1,
	spread = {x=256, y=256, z=256},
	seed = 9531,
	octaves = 3,
	persist = 0.67
}
mapgen_helper.register_perlin("real_minerals:ore_field", ore_field_perlin)

local metamorphic_scale = 100*global_multiplier
local strata_scale = 100*global_multiplier

local igneous_scale = 100*global_multiplier
local igneous_displace = -100*global_multiplier

--local water_level = tonumber(minetest.get_mapgen_setting("water_level"))

local c_stone = minetest.get_content_id("default:stone")
local c_default_sandstone = minetest.get_content_id("default:sandstone")
local c_desertstone = minetest.get_content_id("default:desert_stone")
local base_stone = {[c_stone] = true, [c_default_sandstone] = true, [c_desertstone] = true}

local c_air = minetest.get_content_id("air")

local c_limestone = minetest.get_content_id("real_minerals:limestone")
local c_sandstone_1 = minetest.get_content_id("real_minerals:sandstone")
local c_sandstone_2 = minetest.get_content_id("real_minerals:desert_sandstone")
local c_sandstone_3 = minetest.get_content_id("real_minerals:silver_sandstone")
local c_shale = minetest.get_content_id("real_minerals:shale")

local c_marble = minetest.get_content_id("real_minerals:marble")
local c_quartzite = minetest.get_content_id("real_minerals:quartzite")
local c_slate = minetest.get_content_id("real_minerals:slate")

local c_basalt = minetest.get_content_id("real_minerals:basalt")
local c_granite = minetest.get_content_id("real_minerals:granite")
local c_obsidian = minetest.get_content_id("real_minerals:obsidian")

local c_glass = minetest.get_content_id("default:glass") -- for ore testing

local generated_nodes = {}

local debug_slice = false

minetest.register_on_generated(function(minp, maxp, seed)
	local met_bound = mapgen_helper.perlin2d("real_minerals:metamorphic_boundary", minp, maxp)
	local ign_bound = mapgen_helper.perlin2d("real_minerals:igneous_boundary", minp, maxp)
	local sed_strata = mapgen_helper.perlin2d("real_minerals:sedimentary_strata", minp, maxp)

	local met_type, met_area = mapgen_helper.perlin3d("real_minerals:metamorphic_type", minp, maxp)
	local ign_type = mapgen_helper.perlin3d("real_minerals:igneous_type", minp, maxp)
	local sed_type = mapgen_helper.perlin3d("real_minerals:sedimentary_type", minp, maxp)

	local ore_field = mapgen_helper.perlin3d("real_minerals:ore_field", minp, maxp)

	local vm, data, area = mapgen_helper.mapgen_vm_data()
	
	local noise_iterator = met_area:iterp_xyz(minp, maxp)

	for vi, x, y, z in area:iterp_xyz(minp, maxp) do
		local vi3d = noise_iterator() -- for use with noise data
		local vi2d = mapgen_helper.index2d(minp, maxp, x, z)
		
		local met_bound_value = met_bound[vi2d] * metamorphic_scale
		local ign_bound_value = ign_bound[vi2d] * igneous_scale + igneous_displace
		
		local met_type_value = met_type[vi3d]
		local ign_type_value = ign_type[vi3d]
		local sed_type_value = sed_type[vi3d]
		
		local ore_field_value = ore_field[vi3d]
		local stratum = sed_strata[vi2d] * strata_scale + y

		local next_seed = math.random()
		math.randomseed(math.floor(stratum))
		local sed_strata_value = math.random()
		math.randomseed(next_seed)
		
		if debug_slice and math.floor(x/100) % 2 == 0 then
			data[vi] = c_air		
		elseif base_stone[data[vi]] then
			if y < ign_bound_value then
				if ign_type_value < 0 then
					data[vi] = c_basalt
				else
					data[vi] = c_granite
				end
			elseif y < ign_bound_value + met_bound_value then
				if met_type_value < -0.25 then
					data[vi] = c_marble
				elseif met_type_value < 0.25 then
					data[vi] = c_quartzite
				else
					data[vi] = c_slate
				end				
			else
				if sed_type_value < -0.25 then
					data[vi] = c_limestone
				elseif sed_type_value < 0.25 then
					if sed_strata_value < 1/3 then
						data[vi] = c_sandstone_1
					elseif sed_strata_value < 2/3 then
						data[vi] = c_sandstone_2
					else
						data[vi] = c_sandstone_3
					end
				else
					data[vi] = c_shale
				end			
			end
			
			local ore_list = real_minerals.contains_ore[data[vi]]
			if ore_list ~= nil then
				for k, ore_placement in pairs(ore_list) do
					if ore_placement.place(sed_strata_value, ore_field_value) then
						data[vi] = ore_placement.ore
						break
					end
				end
			end

		end		
	end

	--vm:get_data(data)
	for vi in area:iterp(minp, maxp) do
		local name = minetest.get_name_from_content_id(data[vi])
		generated_nodes[name] = (generated_nodes[name] or 0) + 1
	end

	--send data back to voxelmanip
	vm:set_data(data)
	--calc lighting
	vm:set_lighting({day = 0, night = 0})
	vm:calc_lighting()
	vm:update_liquids()
	--write it to world
	
	vm:write_to_map()

end)

minetest.register_craftitem("real_minerals:prospector", {
	description = "Prospector",
	inventory_image = "real_minerals_prospector.png",
	stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
		if user and user:is_player() then
			local pos = minetest.get_pointed_thing_position(pointed_thing)
			if pos == nil then
				pos = user:get_pos()
			end
			
			local perlin = minetest.get_perlin(ore_field_perlin)
			minetest.chat_send_player(user:get_player_name(), "Ore field value: " .. perlin:get_3d(pos))
		end
		
		return nil
	end,
	sound = {breaks = "default_tool_breaks"},
})


minetest.register_on_shutdown(function() minetest.debug(dump(generated_nodes)) end)