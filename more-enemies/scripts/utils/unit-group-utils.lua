-- If already defined, return
if _unit_group_utils and _unit_group_utils.more_enemies then
  return _unit_group_utils
end

local unit_group_utils = {}

function unit_group_utils.get_spawner(group, radius, limit)
  radius = radius or 1
  limit = limit or 1

  if (not group or not group.surface or not group.position) then return end
  local spawners = group.surface.find_entities_filtered({
    type = "unit-spawner",
    position = group.position,
    radius = radius,
    limit = limit
  })

  Log.info("at spawners")
  Log.info(spawners)
  if (not spawners or #spawners < 1) then return end
  for i=1, #spawners do
    Log.info(spawners[i])
  end

  return spawners[1]
end

unit_group_utils.more_enemies = true

local _unit_group_utils = unit_group_utils

return unit_group_utils
