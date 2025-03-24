-- If already defined, return
if _unit_group and _unit_group.more_enemies then
  return _unit_group
end

local Log = require("libs.log.log")
local Difficulty_Utils = require("libs.difficulty-utils")
local Gleba_Settings_Constants = require("libs.constants.settings.gleba-settings-constants")
local Nauvis_Settings_Constants = require("libs.constants.settings.nauvis-settings-constants")
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

  Log.info("Getting difficulty")
  local difficulty = Difficulty_Utils.get_difficulty(group.surface.name)
  if (not difficulty or not difficulty.valid) then return end

  Log.info("Getting selected_difficulty")
  local selected_difficulty = difficulty.selected_difficulty
  if (not selected_difficulty) then return end

  if (selected_difficulty.string_val == "Vanilla" or selected_difficulty.value == 1) then
    Log.info("Difficulty is vanilla; no need to process")
    return
  end

  if (not storage.groups) then
    Log.warn("storage.groups == nil")
    storage.groups = {}
  end
  Log.debug("adding group: " .. serpent.block(group))

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
  if (not group.force) then return end
  Log.info(group.force)

  difficulty = Difficulty_Utils.get_difficulty(group.surface.name)
  Log.info(group.surface.name)
  Log.info(difficulty)

  if (not difficulty) then Log.warn("difficulty is nil", true) end

  local difficulty = Difficulty_Utils.get_difficulty(group.surface.name)
  if (not difficulty or not difficulty.valid) then return end

  local selected_difficulty = difficulty.selected_difficulty
  if (not selected_difficulty) then return end

  Log.info(selected_difficulty)
  if (selected_difficulty.string_val == "Vanilla" or selected_difficulty.value == 1) then
    Log.info("Difficulty is vanilla; no need to process")
    return
  end

  local difficulty_val = selected_difficulty.value
  local loop_len = 1

  local use_evolution_factor = false
  if (  group.surface.name == "nauvis"
    and settings and settings.global and settings.global[Nauvis_Settings_Constants.settings.NAUVIS_DO_EVOLUTION_FACTOR.name])
  then
    use_evolution_factor = settings.global[Nauvis_Settings_Constants.settings.NAUVIS_DO_EVOLUTION_FACTOR.name].value
  elseif (  group.surface.name == "gleba"
  and settings and settings.global and settings.global[Nauvis_Settings_Constants.settings.GLEBA_DO_EVOLUTION_FACTOR.name]) then
    use_evolution_factor = settings.global[Gleba_Settings_Constants.settings.Gleba_DO_EVOLUTION_FACTOR.name].value
  end

  local evolution_factor = 1
  if (use_evolution_factor) then evolution_factor = group.force.get_evolution_factor() end
  Log.info(evolution_factor)

  if (difficulty_val > 1) then
    loop_len = (math.ceil(selected_difficulty.value * evolution_factor) / 2) + 1
  else
    loop_len = math.ceil(selected_difficulty.value * evolution_factor)
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