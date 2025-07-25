-- If already defined, return
if _settings_service and _settings_service.more_enemies then
  return _settings_service
end

local BREAM_Settings_Constants = require("libs.constants.settings.mods.BREAM.BREAM-settings-constants")
local Constants = require("libs.constants.constants")
local Gleba_Settings_Constants = require("libs.constants.settings.gleba-settings-constants")
local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Log = require("libs.log.log")
local Nauvis_Settings_Constants = require("libs.constants.settings.nauvis-settings-constants")

local settings_service = {}

-- CLONE_NAUVIS_UNITS
function settings_service.get_clone_unit_setting(surface_name)
  local setting = 1

  if (  surface_name == Constants.DEFAULTS.planets.nauvis.string_val
    and settings and settings.global and settings.global[Nauvis_Settings_Constants.settings.CLONE_NAUVIS_UNITS.name])
  then
    setting = settings.global[Nauvis_Settings_Constants.settings.CLONE_NAUVIS_UNITS.name].value
  elseif (  surface_name == Constants.DEFAULTS.planets.gleba.string_val
        and settings and settings.global and settings.global[Gleba_Settings_Constants.settings.CLONE_GLEBA_UNITS.name])
  then
    setting = settings.global[Gleba_Settings_Constants.settings.CLONE_GLEBA_UNITS.name].value
  end

  return setting
end

-- CLONE_NAUVIS_UNIT_GROUPS
function settings_service.get_clone_unit_group_setting(surface_name)
  local setting = 1

  if (  surface_name == Constants.DEFAULTS.planets.nauvis.string_val
    and settings and settings.global and settings.global[Nauvis_Settings_Constants.settings.CLONE_NAUVIS_UNIT_GROUPS.name])
  then
    setting = settings.global[Nauvis_Settings_Constants.settings.CLONE_NAUVIS_UNIT_GROUPS.name].value
  elseif (  surface_name == Constants.DEFAULTS.planets.gleba.string_val
        and settings and settings.global and settings.global[Gleba_Settings_Constants.settings.CLONE_GLEBA_UNIT_GROUPS.name])
  then
    setting = settings.global[Gleba_Settings_Constants.settings.CLONE_GLEBA_UNIT_GROUPS.name].value
  end

  return setting
end

-- MAX_UNIT_GROUP_SIZE_RUNTIME
-- MAX_UNIT_GROUP_SIZE_STARTUP
function settings_service.get_maximum_group_size()

  local limit_runtime = Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_RUNTIME.default_value
  local limit_startup = Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_STARTUP.default_value

  limit_runtime = settings_service.get_max_unit_group_size_runtime()
  limit_startup = settings_service.get_max_unit_group_size_startup()

  if (limit_runtime > limit_startup) then
    limit_runtime = limit_startup
  end

  return limit_runtime
end

-- MAX_UNIT_GROUP_SIZE_RUNTIME
function settings_service.get_max_unit_group_size_runtime()

  local limit_runtime = Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_RUNTIME.default_value

  if (settings and settings.global and settings.global[Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_RUNTIME.name]) then
    limit_runtime = settings.global[Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_RUNTIME.name].value
  end

  return limit_runtime
end

-- MAX_UNIT_GROUP_SIZE_STARTUP
function settings_service.get_max_unit_group_size_startup()

  local limit_startup = Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_STARTUP.default_value

  if (settings and settings.global and settings.global[Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_STARTUP.name]) then
    limit_startup = settings.global[Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_STARTUP.name].value
  end

  return limit_startup
end

-- NTH_TICK
function settings_service.get_nth_tick()
  local setting = Global_Settings_Constants.settings.NTH_TICK.value

  if (settings and settings.global and settings.global[Global_Settings_Constants.settings.NTH_TICK.name]) then
    setting = settings.global[Global_Settings_Constants.settings.NTH_TICK.name].value
  end

  return setting
end

-- CLONES_PER_TICK
function settings_service.get_clones_per_tick()
  local setting = Global_Settings_Constants.settings.CLONES_PER_TICK.value

  if (settings and settings.global and settings.global[Global_Settings_Constants.settings.CLONES_PER_TICK.name]) then
    setting = settings.global[Global_Settings_Constants.settings.CLONES_PER_TICK.name].value
  end

  return setting
end


-- MAXIMUM_NUMBER_OF_SPAWNED_CLONES
function settings_service.get_maximum_number_of_spawned_clones(surface_name)
  local setting = 0

  if (  surface_name == Constants.DEFAULTS.planets.nauvis.string_val
    and settings and settings.global and settings.global[Nauvis_Settings_Constants.settings.MAXIMUM_NUMBER_OF_SPAWNED_CLONES_NAUVIS.name])
  then
    setting = settings.global[Nauvis_Settings_Constants.settings.MAXIMUM_NUMBER_OF_SPAWNED_CLONES_NAUVIS.name].value
  elseif (  surface_name == Constants.DEFAULTS.planets.gleba.string_val
        and settings and settings.global and settings.global[Gleba_Settings_Constants.settings.MAXIMUM_NUMBER_OF_SPAWNED_CLONES_GLEBA.name])
  then
    setting = settings.global[Gleba_Settings_Constants.settings.MAXIMUM_NUMBER_OF_SPAWNED_CLONES_GLEBA.name].value
  end

  return setting
end

-- MAXIMUM_NUMBER_OF_UNIT_GROUP_CLONES
function settings_service.get_maximum_number_of_unit_group_clones(surface_name)
  local setting = 0

  if (  surface_name == Constants.DEFAULTS.planets.nauvis.string_val
    and settings and settings.global and settings.global[Nauvis_Settings_Constants.settings.MAXIMUM_NUMBER_OF_UNIT_GROUP_CLONES_NAUVIS.name])
  then
    setting = settings.global[Nauvis_Settings_Constants.settings.MAXIMUM_NUMBER_OF_UNIT_GROUP_CLONES_NAUVIS.name].value
  elseif (  surface_name == Constants.DEFAULTS.planets.gleba.string_val
        and settings and settings.global and settings.global[Gleba_Settings_Constants.settings.MAXIMUM_NUMBER_OF_UNIT_GROUP_CLONES_GLEBA.name])
  then
    setting = settings.global[Gleba_Settings_Constants.settings.MAXIMUM_NUMBER_OF_UNIT_GROUP_CLONES_GLEBA.name].value
  end

  return setting
end

-- MAXIMUM_NUMBER_OF_MODDED_CLONES
function settings_service.get_maximum_number_of_modded_clones()
  local setting = Global_Settings_Constants.settings.MAXIMUM_NUMBER_OF_MODDED_CLONES.default_value

  if (settings and settings.global and settings.global[Global_Settings_Constants.settings.MAXIMUM_NUMBER_OF_MODDED_CLONES.name]) then
    setting = settings.global[Global_Settings_Constants.settings.MAXIMUM_NUMBER_OF_MODDED_CLONES.name].value
  end

  return setting
end

-- NAUVIS_DO_EVOLUTION_FACTOR
-- GLEBA_DO_EVOLUTION_FACTOR
function settings_service.get_do_evolution_factor(surface_name)
  local setting = false

  if (  surface_name == Constants.DEFAULTS.planets.nauvis.string_val
    and settings and settings.global and settings.global[Nauvis_Settings_Constants.settings.NAUVIS_DO_EVOLUTION_FACTOR.name])
  then
    setting = settings.global[Nauvis_Settings_Constants.settings.NAUVIS_DO_EVOLUTION_FACTOR.name].value
  elseif (  surface_name == Constants.DEFAULTS.planets.gleba.string_val
        and settings and settings.global and settings.global[Gleba_Settings_Constants.settings.GLEBA_DO_EVOLUTION_FACTOR.name]) then
    setting = settings.global[Gleba_Settings_Constants.settings.GLEBA_DO_EVOLUTION_FACTOR.name].value
  end

  return setting
end

-- NAUVIS_DIFFICULTY
-- GLEBA_DIFFICULTY
function settings_service.get_difficulty(surface_name)
  local setting = false

  if (  surface_name == Constants.DEFAULTS.planets.nauvis.string_val
    and settings and settings.startup and settings.startup[Nauvis_Settings_Constants.settings.NAUVIS_DIFFICULTY.name])
  then
    setting = settings.startup[Nauvis_Settings_Constants.settings.NAUVIS_DIFFICULTY.name].value
  elseif (  surface_name == Constants.DEFAULTS.planets.gleba.string_val
        and settings and settings.startup and settings.startup[Gleba_Settings_Constants.settings.GLEBA_DIFFICULTY.name]) then
    setting = settings.startup[Gleba_Settings_Constants.settings.GLEBA_DIFFICULTY.name].value
  end

  return setting
end

-- MAX_GATHERING_UNIT_GROUPS
function settings_service.get_max_gathering_unit_groups()
  local setting = Global_Settings_Constants.settings.MAX_GATHERING_UNIT_GROUPS.default_value

  if (settings and settings.startup and settings.startup[Global_Settings_Constants.settings.MAX_GATHERING_UNIT_GROUPS.name]) then
    setting = settings.startup[Global_Settings_Constants.settings.MAX_GATHERING_UNIT_GROUPS.name].value
  end

  return setting
end

-- MAX_CLIENTS_TO_ACCEPT_ANY_NEW_REQUEST
function settings_service.get_max_clients_to_accept_any_new_request()
  local setting = Global_Settings_Constants.settings.MAX_CLIENTS_TO_ACCEPT_ANY_NEW_REQUEST.default_value

  if (settings and settings.startup and settings.startup[Global_Settings_Constants.settings.MAX_CLIENTS_TO_ACCEPT_ANY_NEW_REQUEST.name]) then
    setting = settings.startup[Global_Settings_Constants.settings.MAX_CLIENTS_TO_ACCEPT_ANY_NEW_REQUEST.name].value
  end

  return setting
end

-- MAX_CLIENTS_TO_ACCEPT_SHORT_NEW_REQUEST
function settings_service.get_max_clients_to_accept_short_new_request()
  local setting = Global_Settings_Constants.settings.MAX_CLIENTS_TO_ACCEPT_SHORT_NEW_REQUEST.default_value

  if (settings and settings.startup and settings.startup[Global_Settings_Constants.settings.MAX_CLIENTS_TO_ACCEPT_SHORT_NEW_REQUEST.name]) then
    setting = settings.startup[Global_Settings_Constants.settings.MAX_CLIENTS_TO_ACCEPT_SHORT_NEW_REQUEST.name].value
  end

  return setting
end

-- DIRECT_DISTANCE_TO_CONSIDER_SHORT_REQUEST
function settings_service.get_direct_distance_to_consider_short_request()
  local setting = Global_Settings_Constants.settings.DIRECT_DISTANCE_TO_CONSIDER_SHORT_REQUEST.default_value

  if (settings and settings.startup and settings.startup[Global_Settings_Constants.settings.DIRECT_DISTANCE_TO_CONSIDER_SHORT_REQUEST.name]) then
    setting = settings.startup[Global_Settings_Constants.settings.DIRECT_DISTANCE_TO_CONSIDER_SHORT_REQUEST.name].value
  end

  return setting
end

-- SHORT_REQUEST_MAX_STEPS
function settings_service.get_short_request_max_steps()
  local setting = Global_Settings_Constants.settings.SHORT_REQUEST_MAX_STEPS.default_value

  if (settings and settings.startup and settings.startup[Global_Settings_Constants.settings.SHORT_REQUEST_MAX_STEPS.name]) then
    setting = settings.startup[Global_Settings_Constants.settings.SHORT_REQUEST_MAX_STEPS.name].value
  end

  return setting
end

--[[
      BREAM
  ]]

-- BREAM_DO_CLONE
function settings_service.get_BREAM_do_clone()
  local setting = BREAM_Settings_Constants.settings.BREAM_DO_CLONE.default_value

  if (settings and settings.global and settings.global[BREAM_Settings_Constants.settings.BREAM_DO_CLONE.name]) then
    setting = settings.global[BREAM_Settings_Constants.settings.BREAM_DO_CLONE.name].value
  end

  return setting
end

-- BREAM_CLONE_UNITS
function settings_service.get_BREAM_clone_units()
  local setting = BREAM_Settings_Constants.settings.BREAM_CLONE_UNITS.default_value

  if (settings and settings.global and settings.global[BREAM_Settings_Constants.settings.BREAM_CLONE_UNITS.name]) then
    setting = settings.global[BREAM_Settings_Constants.settings.BREAM_CLONE_UNITS.name].value
  end

  return setting
end

-- BREAM_DIFFICULTY
function settings_service.get_BREAM_difficulty()
  local setting = BREAM_Settings_Constants.settings.BREAM_DIFFICULTY.default_value

  if (settings and settings.startup and settings.startup[BREAM_Settings_Constants.settings.BREAM_DIFFICULTY.name]) then
    setting = settings.startup[BREAM_Settings_Constants.settings.BREAM_DIFFICULTY.name].value
  end

  return setting
end

-- BREAM_USE_EVOLUTION_FACTOR
function settings_service.get_BREAM_use_evolution_factor()
  local setting = BREAM_Settings_Constants.settings.BREAM_USE_EVOLUTION_FACTOR.default_value

  if (settings and settings.global and settings.global[BREAM_Settings_Constants.settings.BREAM_USE_EVOLUTION_FACTOR.name]) then
    setting = settings.global[BREAM_Settings_Constants.settings.BREAM_USE_EVOLUTION_FACTOR.name].value
  end

  return setting
end

settings_service.more_enemies = true

local _settings_service = settings_service

return settings_service