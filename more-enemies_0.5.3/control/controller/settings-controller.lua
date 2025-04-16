-- If already defined, return
if _settings_controller and _settings_controller.more_enemies then
  return _settings_controller
end

-- local Constants = require("libs.constants.constants")
local Difficulty_Utils = require("control.utils.difficulty-utils")
local Gleba_Constants = require("libs.constants.gleba-constants")
local Gleba_Settings_Constants = require("libs.constants.settings.gleba-settings-constants")
local Log = require("libs.log.log")
local Log_Constants = require("libs.log.log-constants")
local Nauvis_Constants = require("libs.constants.nauvis-constants")
local Nauvis_Settings_Constants = require("libs.constants.settings.nauvis-settings-constants")

local settings_controller = {}

function settings_controller.mod_setting_changed(event)
  if (event and event.setting) then
    if ( event.setting == Gleba_Settings_Constants.settings.CLONE_GLEBA_UNITS.name
      or event.setting == Gleba_Settings_Constants.settings.CLONE_GLEBA_UNIT_GROUPS.name)
    then
      invoke(event, Difficulty_Utils.get_difficulty, { planet = Gleba_Constants.gleba.string_val, reindex = true })
    end

    if ( event.setting == Nauvis_Settings_Constants.settings.CLONE_NAUVIS_UNITS.name
      or event.setting == Nauvis_Settings_Constants.settings.CLONE_NAUVIS_UNIT_GROUPS.name)
    then
      invoke(event, Difficulty_Utils.get_difficulty, { planet = Nauvis_Constants.nauvis.string_val, reindex = true})
    end
  end
end

function invoke(event, fun, params)
  Log.debug("Mod settings changed")
  Log.info(event)
  Log.info(params)
  fun(params.planet, params.reindex)
end

settings_controller.more_enemies = true

local _settings_controller = settings_controller

return settings_controller