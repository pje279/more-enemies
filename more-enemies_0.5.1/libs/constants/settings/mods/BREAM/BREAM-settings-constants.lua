-- If already defined, return
if _BREAM_settings_constants and _BREAM_settings_constants.more_enemies then
  return _BREAM_settings_constants
end

local BREAM_Constants = require("libs.constants.mods.BREAM-constants")

BREAM_settings_constants = {}

BREAM_settings_constants.settings = {}

BREAM_settings_constants.settings.BREAM_DO_CLONE = {
  type = "bool-setting",
  name = "more-enemies-BREAM-do-clone",
  setting_type = "runtime-global",
  order = "eeb",
  default_value = BREAM_Constants.do_clone,
}


BREAM_settings_constants.more_enemies = true

local _BREAM_settings_constants = BREAM_settings_constants

return BREAM_settings_constants