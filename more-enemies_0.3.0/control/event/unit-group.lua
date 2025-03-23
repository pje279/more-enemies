-- If already defined, return
if _unit_group and _unit_group.more_enemies then
  return _unit_group
end

local Log = require("libs.log.log")
local Difficulty_Utils = require("libs.difficulty-utils")
local Spawn = require("control.event.spawn")

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

  -- local spawner = get_spawner(group)
  -- Log.info(spawner)
  -- if (not spawner) then
  --   Log.warn("get_spawner(group) returned nil")
  --   spawner = get_spawner(group, 4)
  --   Log.info(spawner)
  --   if (not spawner) then
  --     Log.warn("get_spawner(group) returned nil")
  --     return
  --   end
  -- end

  -- if (not storage.spawners) then
  --   Log.warn("storage.spawners == nil")
  --   storage.spawners = {}
  -- end
  if (not storage.groups) then
    Log.warn("storage.groups == nil")
    storage.groups = {}
  end
  Log.debug("adding group: " .. serpent.block(group))

  -- Log.info(group.parent_group)

  -- storage.spawners[spawner.unit_number] = group
  storage.groups[group.unique_id] = {
    group = group,
    count = 1
  }
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
  Log.info(group.position)

  difficulty = Difficulty_Utils.get_difficulty(group.surface.name)
  Log.info(group.surface.name)
  Log.info(difficulty)

  if (not difficulty) then Log.warn("difficulty is nil", true) end

  local difficulty = Difficulty_Utils.get_difficulty(group.surface.name)
  if (not difficulty or not difficulty.valid) then return end

  local selected_difficulty = difficulty.selected_difficulty
  if (not selected_difficulty) then return end

  -- local loop_len = math.floor(math.sqrt(selected_difficulty.value))
  Log.warn(selected_difficulty)
  local difficulty_val = selected_difficulty.value
  local loop_len = 1

  if (difficulty_val > 1) then
    loop_len = (math.ceil(selected_difficulty.value) / 2) + 1
  else
    loop_len = math.ceil(selected_difficulty.value)
  end

  Log.debug("loop_len:" .. serpent.block(loop_len))

  for i=1, loop_len do
    if (storage.groups[group.unique_id] and storage.groups[group.unique_id].count >= loop_len) then break end
    Log.debug("duplicating unit group: " .. serpent.block(i))
    Spawn.duplicate_unit_group(group)
    Log.info(storage)
    if (storage and storage.groups and storage.groups[group.unique_id]) then
      storage.groups[group.unique_id].count = storage.groups[group.unique_id].count + 1
    end
  end

  Log.info("releasing from spawner")
  group.release_from_spawner()
  Log.info("start moving")
  group.start_moving()

  Log.debug("removing group: " .. serpent.block(group))
  storage.groups[group.unique_id] = nil
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

  Log.info("at spawners")
  Log.info(spawners)
  if (not spawners or #spawners < 1) then return end
  for i=1, #spawners do
    Log.info(spawners[i])
  end

  return spawners[1]
end

unit_group.more_enemies = true

local _unit_group = unit_group

return unit_group