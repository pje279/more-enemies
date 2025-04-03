-- If already defined, return
if _global_settings_constants and _global_settings_constants.more_enemies then
  return _global_settings_constants
end

local global_settings_constants = {}

global_settings_constants.settings = {}

global_settings_constants.settings.MAX_UNIT_GROUP_SIZE_RUNTIME = {
  type = "int-setting",
  name = "more-enemies-max-unit-group-size-runtime",
  setting_type = "runtime-global",
  order = "dcc",
  default_value = 200,
  maximum_value = 1111,
  minimum_value = 0,
}

global_settings_constants.settings.MAX_UNIT_GROUP_SIZE_STARTUP = {
  type = "int-setting",
  name = "more-enemies-max-unit-group-size-startup",
  setting_type = "startup",
  order = "edd",
  default_value = 200,
  maximum_value = 1111,
  minimum_value = 0,
}

global_settings_constants.settings.TICKS_TO_TRY_CLONING = {
  type = "int-setting",
  name = "more-enemies-ticks-to-try-cloning",
  setting_type = "startup",
  order = "edd",
  default_value = 15,
  maximum_value = 111,
  minimum_value = 0,
}

global_settings_constants.settings.NTH_TICK = {}
global_settings_constants.settings.NTH_TICK.name = "more-enemies-nth-tick"
global_settings_constants.settings.NTH_TICK.value = 5
global_settings_constants.settings.NTH_TICK.setting = {
  type = "int-setting",
  name = "more-enemies-nth-tick",
  setting_type = "runtime-global",
  order = "edd",
  default_value = global_settings_constants.settings.NTH_TICK.value,
  maximum_value = 111,
  minimum_value = 0,
}

global_settings_constants.settings.CLONES_PER_TICK = {
  type = "int-setting",
  name = "more-enemies-clones-per-tick",
  setting_type = "runtime-global",
  order = "edd",
  default_value = 25,
  maximum_value = 111,
  minimum_value = 0,
}

global_settings_constants.settings.MAXIMUM_NUMBER_OF_CLONES = {
  type = "int-setting",
  name = "more-enemies-maximum-number-of-clones",
  setting_type = "runtime-global",
  order = "ddd",
  default_value = 1500,
  maximum_value = 111111,
  minimum_value = 0,
}

global_settings_constants.settings.MAXIMUM_NUMBER_OF_MODDED_CLONES = {
  type = "int-setting",
  name = "more-enemies-maximum-number-of-modded-clones",
  setting_type = "runtime-global",
  order = "ddd",
  default_value = 1000,
  maximum_value = 111111,
  minimum_value = 0,
}

global_settings_constants.more_enemies = true

local _global_settings_constants = global_settings_constants

return global_settings_constants