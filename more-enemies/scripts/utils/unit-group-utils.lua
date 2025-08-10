-- If already defined, return
if _unit_group_utils and _unit_group_utils.more_enemies then
  return _unit_group_utils
end

local Constants = require("libs.constants.constants")
local Log = require("libs.log.log")

local locals = {}

local unit_group_utils = {}

function unit_group_utils.get_spawner(group, radius, limit)
    return locals.get_spawner(group, radius, limit)
end

function locals.get_spawner(group, radius, limit, depth)
    if (not limit or limit == nil) then limit = 1 end
    if (not radius or radius == nil) then radius = 1 end
    if (not depth or depth == nil) then depth = 1 end

    if (depth > 12) then return end
    if (radius > Constants.CHUNK_SIZE * 3.5 and depth > 1) then return end

    if (not group or not group.valid or not group.surface.valid or not group.position) then return end
    local spawners = group.surface.find_entities_filtered({
        type = "unit-spawner",
        position = group.position,
        radius = radius,
        limit = limit
    })

    Log.error("at spawners")
    Log.error(spawners)
    if (not spawners or #spawners < 1) then return locals.get_spawner(group, 1.1 * radius + 1, limit, depth + 1) end

    return spawners[1]
end

unit_group_utils.more_enemies = true

local _unit_group_utils = unit_group_utils

return unit_group_utils
