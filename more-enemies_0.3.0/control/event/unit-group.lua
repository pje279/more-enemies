-- If already defined, return
if _unit_group and _unit_group.more_enemies then
  return _unit_group
end

local Log = require("libs.log.log")
local Difficulty_Utils = require("libs.difficulty-utils")
local Gleba_Settings_Constants = require("libs.constants.settings.gleba-settings-constants")
local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Initialization = require("control.initialization")
local Nauvis_Settings_Constants = require("libs.constants.settings.nauvis-settings-constants")
local Settings_Service = require("control.service.settings-service")
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
  if (not difficulty or not difficulty.valid) then
    Log.warn("difficulty was nil or invalid; reindexing")
    difficulty = Difficulty_Utils.get_difficulty(group.surface.name, true)
  end
  if (not difficulty or not difficulty.valid) then
    Log.error("Failed to find a valid difficulty for " .. serpent.block(group.surface.name))
    return
  end

  Log.info("Getting selected_difficulty")
  local selected_difficulty = difficulty.selected_difficulty
  if (not selected_difficulty) then return end

  if (selected_difficulty.string_val == "Vanilla" or selected_difficulty.value == 1) then
    Log.info("Difficulty is vanilla; no need to process")
    return
  end

  if (not storage.more_enemies or not storage.more_enemies.valid) then Initialization.reinit() end

  if (not storage.more_enemies.groups) then
    Log.warn("storage.more_enemies.groups == nil")
    storage.more_enemies.groups = {}
  end

  Log.debug("adding group: " .. serpent.block(group))

  Log.debug(group.surface.name)

  Log.debug("before: " .. serpent.block(storage.groups))

  if (not storage.more_enemies.groups[group.surface.name]) then
    storage.more_enemies.groups[group.surface.name] = {}
  end

  Log.debug("after: " .. serpent.block(storage.groups))

  storage.more_enemies.groups[group.surface.name][group.unique_id] = {
    group = group,
    count = 0
  }

  Log.debug(storage.more_enemies.groups[group.surface.name][group.unique_id])
end

function unit_group.unit_group_finished_gathering(event)
  Log.info(event)
  local group = event.group
  local tick = event.tick

  if (  storage.more_enemies.clone and storage.more_enemies.clone.clone_count
    and storage.more_enemies.clone.clone_count > Settings_Service.get_maximum_number_of_clones())
  then
    Log.error("Tried to clone more than the unit limit: " .. serpent.block(Settings_Service.get_maximum_number_of_clones()))
    Log.error("Currently " .. serpent.block(storage.more_enemies.clone.clone_count) .. " clones")
    return
  end

  Log.info("1")
  if (not group) then return end
  Log.info(group)
  if (not group.surface or not group.surface.name) then return end
  Log.info(group.surface)
  Log.info(group.surface.name)
  if (not group.is_unit_group) then return end
  Log.info(group.is_unit_group)
  if (not group.force) then return end
  Log.info(group.force)

  Log.info("2")

  local difficulty = Difficulty_Utils.get_difficulty(group.surface.name)
  if (not difficulty or not difficulty.valid) then
    Log.warn("difficulty was nil or invalid; reindexing")
    difficulty = Difficulty_Utils.get_difficulty(group.surface.name, true)
  end
  if (not difficulty or not difficulty.valid) then
    Log.error("Failed to find a valid difficulty for " .. serpent.block(group.surface.name))
    return
  end
  Log.info(difficulty)

  if (not difficulty) then return end

  local selected_difficulty = difficulty.selected_difficulty
  Log.debug(selected_difficulty)
  if (not selected_difficulty) then return end

  local vanilla = 1
  if (selected_difficulty.string_val == "Vanilla" or selected_difficulty.value == 1) then
    if (Settings_Service.get_clone_unit_group_setting(group.surface.name) == 1) then vanilla = vanilla + 1 end
    if (Settings_Service.get_maximum_group_size(group.surface.name) == Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_RUNTIME.default_value) then vanilla = vanilla + 1 end
    Log.info("Difficulty is vanilla; no need to process")
  end

  Log.info("vanilla: " .. serpent.block(vanilla))
  if (vanilla > 2) then return end

  Log.info("3")

  local loop_len = 1

  local use_evolution_factor = Settings_Service.get_do_evolution_factor(group.surface.name)

  local evolution_factor = 1
  if (use_evolution_factor) then
    evolution_factor = group.force.get_evolution_factor()
  end
  Log.info(evolution_factor)

  local clone_unit_group_setting = Settings_Service.get_clone_unit_group_setting(group.surface.name)

  if (selected_difficulty.value > 1) then
    loop_len = math.floor(selected_difficulty.value * evolution_factor * clone_unit_group_setting)
  else
    loop_len = math.ceil(selected_difficulty.value * evolution_factor * clone_unit_group_setting)
  end
  Log.debug("loop_len: " .. serpent.block(loop_len))

  Log.info("4")

  for i=1, loop_len do
    if (  storage.more_enemies.groups[group.surface.name][group.unique_id]
      and storage.more_enemies.groups[group.surface.name][group.unique_id].count >= loop_len
    ) then break end
    Log.debug("duplicating unit group: " .. serpent.block(i))
    Log.info("tick: " .. tick)
    Spawn.duplicate_unit_group(group, tick)

    if (  storage
      and storage.groups
      and storage.groups[group.surface.name][group.unique_id])
    then
      storage.groups[group.surface.name][group.unique_id].count = storage.groups[group.surface.name][group.unique_id].count + 1
    end
  end

  Log.info("releasing from spawner")
  group.release_from_spawner()
  Log.info("start moving")
  group.start_moving()

  Log.debug("removing group: " .. serpent.block(group))
  storage.more_enemies.groups[group.surface.name][group.unique_id] = nil
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