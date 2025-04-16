-- If already defined, return
if _unit_group_service and _unit_group_service.more_enemies then
  return _unit_group_service
end

local Constants = require("libs.constants.constants")
local Difficulty_Utils = require("control.utils.difficulty-utils")
local Gleba_Settings_Constants = require("libs.constants.settings.gleba-settings-constants")
local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Initialization = require("control.initialization")
local Log = require("libs.log.log")
local More_Enemies_Repository = require("control.repositories.more-enemies-repository")
local Nauvis_Settings_Constants = require("libs.constants.settings.nauvis-settings-constants")
local Settings_Service = require("control.service.settings-service")
local Settings_Utils = require("control.utils.settings-utils")
local Spawn_Utils = require("control.utils.spawn-utils")
local Unit_Group_Utils = require("control.utils.unit-group-utils")

local unit_group_service = {}

function unit_group_service.unit_group_created(event)
  local more_enemies_data = More_Enemies_Repository.get_more_enemies_data()
  if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end
  if (not more_enemies_data.do_nth_tick) then return end

  local group = event.group

  if (not group) then return end
  Log.info(group)
  if (not group.valid) then return end
  Log.info(group.valid)
  if (not group.surface or not group.surface.valid or not group.surface.name) then return end
  Log.info(group.surface)
  Log.info(group.surface.name)

  if (Settings_Utils.is_vanilla(group.surface.name)) then return end

  if (not group.is_unit_group) then return end
  Log.info(group.is_unit_group)
  if (not group.position) then return end
  Log.info(group.position)

  if (  more_enemies_data
    and more_enemies_data.groups
    and more_enemies_data.groups[group.surface.name]
    and more_enemies_data.groups[group.surface.name][group.unique_id]
    and more_enemies_data.groups[group.surface.name][group.unique_id].valid)
  then
    Log.warn("group already exists; returning")
    return
  end

  Log.info("Getting difficulty")
  local difficulty = Difficulty_Utils.get_difficulty(group.surface.name).difficulty
  if (not difficulty or not difficulty.valid) then
    Log.warn("difficulty was nil or invalid; reindexing")
    difficulty = Difficulty_Utils.get_difficulty(group.surface.name, true).difficulty
  end
  if (not difficulty or not difficulty.valid) then
    Log.error("Failed to find a valid difficulty for " .. serpent.block(group.surface.name))
    return
  end

  Log.info("Getting selected_difficulty")
  local selected_difficulty = difficulty.selected_difficulty
  if (not selected_difficulty) then return end

  local clone_unit_group_setting = Settings_Service.get_clone_unit_group_setting(group.surface.name)

  if (not more_enemies_data.groups) then storage.more_enemies.groups = {} end

  Log.info("adding group: " .. serpent.block(group))

  Log.info(group.surface.name)

  Log.info("before: " .. serpent.block(more_enemies_data.groups))

  if (not more_enemies_data.groups[group.surface.name]) then
    more_enemies_data.groups[group.surface.name] = {}
  end

  Log.info("after: " .. serpent.block(more_enemies_data.groups))

  local loop_len = 1
  local use_evolution_factor = Settings_Service.get_do_evolution_factor(group.surface.name)
  local evolution_factor = 1

  Log.debug("use_evolution_factor  = "  .. serpent.block(use_evolution_factor))
  if (use_evolution_factor) then
    evolution_factor = group.force.get_evolution_factor()
  end

  if (selected_difficulty.value > 1) then
    loop_len = math.floor((selected_difficulty.value + clone_unit_group_setting) * evolution_factor)
  else
    loop_len = math.floor((selected_difficulty.value * clone_unit_group_setting) * evolution_factor)
  end
  Log.info("loop_len: " .. serpent.block(loop_len))

  more_enemies_data.groups[group.surface.name][group.unique_id] = {
    valid = true,
    group = group,
    count = 0,
    max_count = loop_len,
    mod_name = nil,
  }

  Log.debug(more_enemies_data.groups[group.surface.name][group.unique_id])
end

--[[
    unit_group_service.unit_group_finished_gathering
--]]

function unit_group_service.unit_group_finished_gathering(event)
  local more_enemies_data = More_Enemies_Repository.get_more_enemies_data()

  local group = event.group
  local tick = event.tick

  Log.info(event.group)

  if (not group or not group.valid or not group.surface or not group.surface.valid or Settings_Utils.is_vanilla(group.surface.name)) then return end

  local max_num_clones = Settings_Service.get_maximum_number_of_clones()

  if (  more_enemies_data.clone and more_enemies_data.clone.count
    and more_enemies_data.clone.count > max_num_clones)
  then
    Log.debug("Tried to clone more than the unit limit: " .. serpent.block(max_num_clones))
    Log.debug("Currently " .. serpent.block(more_enemies_data.clone.count) .. " clones")
    return
  end

  Log.info("1")
  if (not group) then return end
  if (not group.valid) then return end
  if (not group.surface or not group.surface.name) then return end
  if (not group.is_unit_group) then return end
  if (not group.force) then return end

  Log.info("2")

  local difficulty = Difficulty_Utils.get_difficulty(group.surface.name).difficulty
  if (not difficulty or not difficulty.valid) then
    Log.warn("difficulty was nil or invalid; reindexing")
    difficulty = Difficulty_Utils.get_difficulty(group.surface.name, true).difficulty
  end
  if (not difficulty or not difficulty.valid) then
    Log.error("Failed to find a valid difficulty for " .. serpent.block(group.surface.name))
    return
  end
  Log.debug(difficulty)

  if (not difficulty) then return end

  local selected_difficulty = difficulty.selected_difficulty
  Log.debug(selected_difficulty)
  if (not selected_difficulty) then return end

  local vanilla = 1
  if (selected_difficulty.string_val == "Vanilla" or selected_difficulty.value == 1) then
    if (    (group.surface.name == Constants.DEFAULTS.planets.gleba.string_val
        and Settings_Service.get_clone_unit_group_setting(group.surface.name) == Gleba_Settings_Constants.settings.CLONE_GLEBA_UNIT_GROUPS.default_value)
      or
            (group.surface.name == Constants.DEFAULTS.planets.nauvis.string_val
        and Settings_Service.get_clone_unit_group_setting(group.surface.name) == Nauvis_Settings_Constants.settings.CLONE_NAUVIS_UNIT_GROUPS.default_value))
    then
      vanilla = vanilla + 1
    end
    if (Settings_Service.get_maximum_group_size(group.surface.name) == Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_STARTUP.default_value) then vanilla = vanilla + 1 end
  end

  Log.debug("vanilla: " .. serpent.block(vanilla))
  if (vanilla > 2) then return end

  Log.info("3")

  local loop_len = 1

  local use_evolution_factor = Settings_Service.get_do_evolution_factor(group.surface.name)

  local evolution_factor = 1
  Log.debug("use_evolution_factor = "  .. serpent.block(use_evolution_factor))
  if (use_evolution_factor) then
    evolution_factor = group.force.get_evolution_factor()
  end

  local clone_unit_group_setting = Settings_Service.get_clone_unit_group_setting(group.surface.name)

  Log.info(clone_unit_group_setting)
  Log.info(selected_difficulty.value)
  Log.info(evolution_factor)

  loop_len = math.floor((selected_difficulty.value * clone_unit_group_setting) * evolution_factor)
  Log.info("loop_len: " .. serpent.block(loop_len))

  Log.info("4")

  more_enemies_group = { valid = false }
  if (    more_enemies_data
      and more_enemies_data.groups
      and more_enemies_data.groups[group.surface.name]
      and more_enemies_data.groups[group.surface.name][group.unique_id] ~= nil)
  then
    more_enemies_group = more_enemies_data.groups[group.surface.name][group.unique_id]
  end

  if (not more_enemies_group or not more_enemies_group.valid) then
    Log.debug("returning", true)
    return
  end

  for i=1, loop_len do
    if (more_enemies_group and more_enemies_group.valid and more_enemies_group.count >= more_enemies_group.max_count) then
      Log.debug("breaking", true)
      break
    end

    Log.debug("attempting to duplicate unit group")
    if (more_enemies_group and more_enemies_group.valid and more_enemies_group.count < more_enemies_group.max_count) then
      Log.debug("duplicating unit group: " .. serpent.block(i))
      Log.info("tick: " .. tick)
      Spawn_Utils.duplicate_unit_group(group, tick)
    end

    if (more_enemies_group and more_enemies_group.valid) then
      more_enemies_group.count = more_enemies_group.count + 1
    end
  end

  Log.info("5")

  if (more_enemies_group and not more_enemies_group.mod_name) then
    Log.debug("releasing from spawner")
    group.release_from_spawner()
    Log.debug("start moving")
    group.start_moving()
  end

end

unit_group_service.more_enemies = true

local _unit_group_service = unit_group_service

return unit_group_service