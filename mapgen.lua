local data = {}

local nvals_metamorph_buffer = {}

local perlin_metamorph = {
	offset = 0,
	scale = 1,
	spread = {x=256, y=256, z=256},
	seed = -400090,
	octaves = 3,
	persist = 0.67
}

local nobj_metamorph = nil

minetest.register_on_generated(function(minp, maxp, seed)
	--if too far from water level, abort. Caverns are on their own.
	if minp.y > 512 or maxp.y < water_level then
		return
	end
		
	--easy reference to commonly used values
	local t_start = os.clock()
	local x_max = maxp.x
	local y_max = maxp.y
	local z_max = maxp.z
	local x_min = minp.x
	local y_min = minp.y
	local z_min = minp.z
		
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	vm:get_data(data)
	
	
	--mandatory values
	local sidelen = x_max - x_min + 1 --length of a mapblock
	local chunk_lengths = {x = sidelen, y = sidelen, z = sidelen} --table of chunk edges
	local chunk_lengths2D = {x = sidelen, y = sidelen, z = 1}
	local minposxyz = {x = x_min, y = y_min, z = z_min} --bottom corner
	local minposxz = {x = x_min, y = z_min} --2D bottom corner
	
	nobj_metamorph = nobj_metamorph or minetest.get_perlin_map(perlin_metamorph, chunk_lengths)
	local nvals_metamorph = nobj_cave:get3dMap_flat(minposxyz, nvals_metamorph_buffer)

	local index_3d = 1 --3D node index
	local index_2d = 1 --2D node index
	
	for z = z_min, z_max do -- for each xy plane progressing northwards
		--structure loop, hollows out the cavern
		for y = y_min, y_max do -- for each x row progressing upwards
			if y > water_level then
				local vi = area:index(x_min, y, z) --current node index
				for x = x_min, x_max do -- for each node do
					
					--nvals_metamorph[index_3d]
					
					index_3d = index_3d + 1
					index_2d = index_2d + 1
					vi = vi + 1
				end
				index_2d = index_2d - sidelen --shift the 2D index back
			end
			index_2d = index_2d + sidelen --shift the 2D index up a layer
		end
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