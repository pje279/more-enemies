-- If already defined, return
if _settings_utils and _settings_utils.more_enemies then
  return _settings_utils
end

local BREAM_Settings_Constants = require("libs.constants.settings.mods.BREAM.BREAM-settings-constants")
local Constants = require("libs.constants.constants")
local Difficulty_Utils = require("control.utils.difficulty-utils")
local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Initialization = require("control.initialization")
local Log = require("libs.log.log")
local More_Enemies_Repository = require("control.repositories.more-enemies-repository")
local Settings_Service = require("control.service.settings-service")
local Vanilla_Difficulty_Data = require("control.data.difficulties.vanilla-difficulty-data")

settings_utils = {}

function settings_utils.is_vanilla(surface_name)
  local return_val = true

  local more_enemies_data = More_Enemies_Repository.get_more_enemies_data()

  if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end
  if (not more_enemies_data.difficulties) then Difficulty_Utils.get_difficulty(surface_name, true) end

  if ( not more_enemies_data
    or not more_enemies_data.difficulties
    or not more_enemies_data.difficulties[surface_name]
    or not more_enemies_data.difficulties[surface_name].difficulty
    or not more_enemies_data.difficulties[surface_name].difficulty.selected_difficulty
    or more_enemies_data.difficulties[surface_name].difficulty.selected_difficulty.string_val ~= Vanilla_Difficulty_Data.string_val)
  then
    return_val = false
  end

  if (return_val and Settings_Service.get_clone_unit_setting(surface_name) ~= 1) then return_val = false end
  if (return_val and Settings_Service.get_clone_unit_group_setting(surface_name) ~= 1) then return_val = false end
  if (return_val and Settings_Service.get_maximum_group_size() ~= Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_RUNTIME.default_value) then return_val = false end

  -- Mod added
  if (return_val and script and script.active_mods and (script.active_mods["BREAM"])) then
    if (return_val and Settings_Service.get_BREAM_difficulty() ~= Vanilla_Difficulty_Data.string_val) then return_val = false end
    if (return_val and Settings_Service.get_BREAM_clone_units() ~= BREAM_Settings_Constants.settings.BREAM_CLONE_UNITS.default_value) then return_val = false end
  end

  Log.debug(return_val)
  return return_val
end

settings_utils.more_enemies = true

local _settings_utils = settings_utils

return settings_utils
