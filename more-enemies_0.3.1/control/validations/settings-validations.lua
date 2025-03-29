-- If already defined, return
if (_settings_validations and _settings_validations.more_enemies) then
  return _settings_validations
end

local Constants = require("libs.constants.constants")
local Initialization = require("control.initialization")
local Log = require("libs.log.log")

local settings_validations = {}

function settings_validations.validate_setting_not_equal_to(setting, value)
  if (setting and setting.value and setting.value ~= value) then
    return true
  else
    return false
  end
end

settings_validations.more_enemies = true

local _settings_validations = settings_validations
return settings_validations