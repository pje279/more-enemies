-- If already defined, return
if _unit_group and _unit_group.more_enemies then
  return _unit_group
end

local Log = require("libs.log.log")
local Difficulty_Utils = require("libs.difficulty-utils")

local unit_group = {}

function unit_group.unit_group_created(event)
  Log.info(event)
  local group = event.group

  if (not group) then return end
  Log.info(group)
  if (not group.surface or not group.surface.name) then return end
  Log.info(group.surface)
  Log.info(group.surface.name)
  if (not group.is_unit_group) then return end
  Log.info(group.is_unit_group)
  if (not group.position) then return end
  Log.info(group.position)

  local selected_difficulty = Difficulty_Utils.get_difficulty(group.surface.name).selected_difficulty

  local surface_name = group.surface.name

  local spawner = get_spawner(group)
  Log.info(spawner)
  if (not spawner) then return end

  if (not storage.spawners) then
    Log.warn("storage.spawners == nil")
    storage.spawners = {}
  end
  Log.debug("adding group: " .. serpent.block(group))
  storage.spawners[spawner.unit_number] = group
end

function unit_group.unit_group_finished_gathering(event)
  Log.info(event)
  local group = event.group

  if (not group) then return end
  Log.info(group)
  if (not group.surface or not group.surface.name) then return end
  Log.info(group.surface)
  Log.info(group.surface.name)
  if (not group.is_unit_group) then return end
  Log.info(group.is_unit_group)
  if (not group.position) then return end
  Log.warn(group.position)

  -- local spawner = get_spawner(group)
  -- Log.warn(spawner)
  -- if (not spawner) then return end

  if (not storage.spawners) then
    Log.warn("storage.spawners == nil")
    storage.spawners = {}
    return
  end

  for i=1, Difficulty_Utils.get_difficulty(group.surface.name).selected_difficulty.value do
    Difficulty_Utils.duplicate_unit_group(group)
  end

  Log.debug("removing group: " .. serpent.block(group))
  storage.spawners[spawner.unit_number] = nil
end

function get_spawner(group, radius, limit)
  radius = radius or 1
  limit = limit or 1

  if (not group or not group.surface or not group.position) then return end
  local spawners = group.surface.find_entities_filtered({
    type = "unit-spawner",
    position = group.position,
    radius = radius,
    limit = limit
  })

  Log.warn(spawners)
  if (not spawners or #spawners < 1) then return end
  for i=1, #spawners do
    Log.debug(spawners[i])
  end

  return spawners[1]
end

unit_group.more_enemies = true

local _unit_group = unit_group

return unit_group