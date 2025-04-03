-- If already defined, return
if _gleba_settings_constants and _gleba_settings_constants.more_enemies then
  return _gleba_settings_constants
end

local Constants = require("libs.constants.constants")

gleba_settings_constants = {}

gleba_settings_constants.settings = {}

-- { Cloning } --
gleba_settings_constants.settings.CLONE_GLEBA_UNITS = {
    type = "double-setting",
    name = "more-enemies-clone-gleba-units",
    setting_type = "runtime-global",
    order = "dab",
    default_value = 1,
    maximum_value = 11, -- This one goes up to eleven
    minimum_value = 0,
}

gleba_settings_constants.settings.CLONE_GLEBA_UNIT_GROUPS = {
    type = "double-setting",
    name = "more-enemies-clone-gleba-unit-groups",
    setting_type = "runtime-global",
    order = "dac",
    default_value = 1,
    maximum_value = 11, -- This one goes up to eleven
    minimum_value = 0,
}

-- { Difficulty } --
gleba_settings_constants.settings.GLEBA_DIFFICULTY = {
    type = "string-setting",
    name = "more-enemies-gleba-difficulty",
    setting_type = "startup",
    order = "bab",
    default_value = "Vanilla",
    allowed_values = Constants.difficulty.difficulties_array
}

gleba_settings_constants.settings.GLEBA_DO_EVOLUTION_FACTOR = {
    type = "bool-setting",
    name = "more-enemies-gleba-do-evolution-factor",
    setting_type = "runtime-global",
    order = "cab",
    default_value = true,
}

-- { Small } --
gleba_settings_constants.settings.GLEBA_SMALL_MAX_COUNT_OF_OWNED_UNITS = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-small-max-count-of-owned-units",
    setting_type = "startup",
    order = "daa",
    default_value = 1,
    minimum_value = 0,
}

gleba_settings_constants.settings.GLEBA_SMALL_MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-small-max-count-of-owned-defensive-units",
    setting_type = "startup",
    order = "dab",
    default_value = 1,
    minimum_value = 0,
}

gleba_settings_constants.settings.GLEBA_SMALL_MAX_FRIENDS_AROUND_TO_SPAWN = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-small-max-friends-around-to-spawn",
    setting_type = "startup",
    order = "dac",
    default_value = 2,
    minimum_value = 0,
}

gleba_settings_constants.settings.GLEBA_SMALL_MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-small-max-defensive-friends-around-to-spawn",
    setting_type = "startup",
    order = "dad",
    default_value = 2,
    minimum_value = 0,
}

gleba_settings_constants.settings.GLEBA_SMALL_MAX_SPAWNING_COOLDOWN = {
    type = "int-setting",
    name = "more-enemies-max-spawning-cooldown-gleba-small",
    setting_type = "startup",
    order = "dae",
    default_value = 360,
    minimum_value = 1,
}

gleba_settings_constants.settings.GLEBA_SMALL_MIN_SPAWNING_COOLDOWN = {
    type = "int-setting",
    name = "more-enemies-min-spawning-cooldown-gleba-small",
    setting_type = "startup",
    order = "daf",
    default_value = 150,
    minimum_value = 1,
}

-- { Regular } --
gleba_settings_constants.settings.GLEBA_MAX_COUNT_OF_OWNED_UNITS = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-max-count-of-owned-units",
    setting_type = "startup",
    order = "dba",
    default_value = 2,
    minimum_value = 0,
}

gleba_settings_constants.settings.GLEBA_MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-max-count-of-owned-defensive-units",
    setting_type = "startup",
    order = "dbb",
    default_value = 1,
    minimum_value = 0,
}

gleba_settings_constants.settings.GLEBA_MAX_FRIENDS_AROUND_TO_SPAWN = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-max-friends-around-to-spawn",
    setting_type = "startup",
    order = "dbc",
    default_value = 3,
    minimum_value = 0,
}
gleba_settings_constants.settings.GLEBA_MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-max-defensive-friends-around-to-spawn",
    setting_type = "startup",
    order = "dbd",
    default_value = 2,
    minimum_value = 0,
}

gleba_settings_constants.settings.GLEBA_MAX_SPAWNING_COOLDOWN = {
    type = "int-setting",
    name = "more-enemies-max-spawning-cooldown-gleba",
    setting_type = "startup",
    order = "dbe",
    default_value = 360,
    minimum_value = 1,
}

gleba_settings_constants.settings.GLEBA_MIN_SPAWNING_COOLDOWN = {
    type = "int-setting",
    name = "more-enemies-min-spawning-cooldown-gleba",
    setting_type = "startup",
    order = "dbf",
    default_value = 150,
    minimum_value = 1,
}

gleba_settings_constants.more_enemies = true

local _gleba_settings_constants = gleba_settings_constants

return gleba_settings_constants