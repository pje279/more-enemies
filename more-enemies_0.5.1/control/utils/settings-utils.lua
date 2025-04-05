-- If already defined, return
if _settings_utils and _settings_utils.more_enemies then
  return _settings_utils
end

local BREAM_Settings_Constants = require("libs.constants.settings.mods.BREAM.BREAM-settings-constants")
local Constants = require("libs.constants.constants")
local Difficulty_Utils = require("control.utils.difficulty-utils")
local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Log = require("libs.log.log")
local Settings_Service = require("control.service.settings-service")

settings_utils = {}

function settings_utils.is_vanilla(surface_name)
  local return_val = true

  if (storage and not storage.more_enemies) then storage.more_enemies = {} end
  if (storage and not storage.more_enemies.difficulties) then Difficulty_Utils.get_difficulty(surface_name, true) end

  if ( not storage
    or not storage.more_enemies
    or not storage.more_enemies.difficulties
    or not storage.more_enemies.difficulties[surface_name]
    or not storage.more_enemies.difficulties[surface_name].difficulty
    or not storage.more_enemies.difficulties[surface_name].difficulty.selected_difficulty
    or storage.more_enemies.difficulties[surface_name].difficulty.selected_difficulty.string_val ~= Constants.difficulty.VANILLA.string_val)
  then
    return_val = false
  end

  if (return_val and Settings_Service.get_clone_unit_setting(surface_name) ~= 1) then return_val = false end
  if (return_val and Settings_Service.get_clone_unit_group_setting(surface_name) ~= 1) then return_val = false end
  if (return_val and Settings_Service.get_maximum_group_size() ~= Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_RUNTIME.default_value) then return_val = false end

  -- Mod added
  if (return_val and script and script.active_mods and (script.active_mods["BREAM"])) then
    if (return_val and Settings_Service.get_BREAM_difficulty() ~= Constants.difficulty.VANILLA.string_val) then return_val = false end
    if (return_val and Settings_Service.get_BREAM_clone_units() ~= BREAM_Settings_Constants.settings.BREAM_CLONE_UNITS.default_value) then return_val = false end
  end

  Log.debug(return_val)
  return return_val
end

settings_utils.more_enemies = true

local _settings_utils = settings_utils

return settings_utils
