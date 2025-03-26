-- If already defined, return
if _settings_service and _settings_service.more_enemies then
  return _settings_service
end

local Constants = require("libs.constants.constants")
local Gleba_Constants = require("libs.constants.gleba-constants")
local Gleba_Settings_Constants = require("libs.constants.settings.gleba-settings-constants")
local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Nauvis_Constants = require("libs.constants.nauvis-constants")
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

  if (settings and settings.global and settings.global[Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_RUNTIME.name]) then
    limit_runtime = settings.global[Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_RUNTIME.name].value
  end

  if (settings and settings.global and settings.global[Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_STARTUP.name]) then
    limit_startup = settings.global[Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_STARTUP.name].value
  end

  if (limit_runtime > limit_startup) then
    limit_runtime = limit_startup
  end

  return limit_runtime
end

-- CLONES_PER_TICK
function settings_service.get_clones_per_tick()
  local setting = 1

  if (settings and settings.global and settings.global[Global_Settings_Constants.settings.CLONES_PER_TICK.name]) then
    setting = settings.global[Global_Settings_Constants.settings.CLONES_PER_TICK.name].value
  end

  return setting
end

-- NTH_TICK
function settings_service.get_nth_tick()
  local setting = Global_Settings_Constants.settings.NTH_TICK.value

  if (settings and settings.global and settings.global[Global_Settings_Constants.settings.NTH_TICK.name]) then
    setting = settings.global[Global_Settings_Constants.settings.NTH_TICK.name].value
  end

  return setting
end

-- NAUVIS_DO_EVOLUTION_FACTOR
-- GLEBA_DO_EVOLUTION_FACTOR
function settings_service.get_do_evolution_factor(surface_name)
  local setting = true
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

-- CLONES_PER_TICK
function settings_service.get_clones_per_tick()
  local setting = Global_Settings_Constants.settings.CLONES_PER_TICK.value

  if (settings and settings.global and settings.global[Global_Settings_Constants.settings.CLONES_PER_TICK.name]) then
    setting = settings.global[Global_Settings_Constants.settings.CLONES_PER_TICK.name].value
  end

  return setting
end

-- MAXIMUM_NUMBER_OF_CLONES
function settings_service.get_maximum_number_of_clones()
  local setting = Global_Settings_Constants.settings.MAXIMUM_NUMBER_OF_CLONES.default_value

  if (settings and settings.global and settings.global[Global_Settings_Constants.settings.MAXIMUM_NUMBER_OF_CLONES.name]) then
    setting = settings.global[Global_Settings_Constants.settings.MAXIMUM_NUMBER_OF_CLONES.name].value
  end

  return setting
end

settings_service.more_enemies = true

local _settings_service = settings_service

return settings_service