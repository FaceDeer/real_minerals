-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())

real_minerals = {}

dofile(MP.."/config.lua")

dofile(MP.."/rocks.lua")
dofile(MP.."/metals.lua")
dofile(MP.."/ores.lua")
dofile(MP.."/misc.lua")

if real_minerals.config.replace_default_stone then
	dofile(MP.."/mapgen.lua")
end