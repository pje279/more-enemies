-- If already defined, return
if _gleba_settings_constants and _gleba_settings_constants.more_enemies then
  return _gleba_settings_constants
end

gleba_settings_constants = {}

gleba_settings_constants.settings = {}

-- { Cloning } --
gleba_settings_constants.settings.CLONE_GLEBA_UNITS = {
  type = "double-setting",
  name = "more-enemies-clone-gleba-units",
  setting_type = "runtime-global",
  order = "caa",
  default_value = 1,
  maximum_value = 10,
  minimum_value = 0,
}

gleba_settings_constants.settings.CLONE_GLEBA_UNIT_GROUPS = {
  type = "double-setting",
  name = "more-enemies-clone-gleba-unit-groups",
  setting_type = "runtime-global",
  order = "cab",
  default_value = 1,
  maximum_value = 10,
  minimum_value = 0,
}

-- { Difficulty } --
gleba_settings_constants.settings.GLEBA_DIFFICULTY = {
  type = "string-setting",
  name = "more-enemies-gleba-difficulty",
  setting_type = "startup",
  order = "aab",
  default_value = "Vanilla",
  allowed_values = { "Easy", "Vanilla", "Vanilla+", "Hard", "Insanity" }
}

-- { Small } --
gleba_settings_constants.settings.GLEBA_SMALL_MAX_COUNT_OF_OWNED_UNITS = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-small-max-count-of-owned-units",
    setting_type = "startup",
    order = "caa",
    default_value = 1,
    minimum_value = 0,
}

gleba_settings_constants.settings.GLEBA_SMALL_MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-small-max-count-of-owned-defensive-units",
    setting_type = "startup",
    order = "cab",
    default_value = 1,
    minimum_value = 0,
}

gleba_settings_constants.settings.GLEBA_SMALL_MAX_FRIENDS_AROUND_TO_SPAWN = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-small-max-friends-around-to-spawn",
    setting_type = "startup",
    order = "cac",
    default_value = 2,
    minimum_value = 0,
}

gleba_settings_constants.settings.GLEBA_SMALL_MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-small-max-defensive-friends-around-to-spawn",
    setting_type = "startup",
    order = "cad",
    default_value = 2,
    minimum_value = 0,
}

gleba_settings_constants.settings.GLEBA_SMALL_MAX_SPAWNING_COOLDOWN = {
    type = "int-setting",
    name = "more-enemies-max-spawning-cooldown-gleba-small",
    setting_type = "startup",
    order = "cae",
    default_value = 360,
    minimum_value = 1,
}

gleba_settings_constants.settings.GLEBA_SMALL_MIN_SPAWNING_COOLDOWN = {
    type = "int-setting",
    name = "more-enemies-min-spawning-cooldown-gleba-small",
    setting_type = "startup",
    order = "caf",
    default_value = 150,
    minimum_value = 1,
}

-- { Regular } --
gleba_settings_constants.settings.GLEBA_MAX_COUNT_OF_OWNED_UNITS = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-max-count-of-owned-units",
    setting_type = "startup",
    order = "cba",
    default_value = 2,
    minimum_value = 0,
}

gleba_settings_constants.settings.GLEBA_MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-max-count-of-owned-defensive-units",
    setting_type = "startup",
    order = "cbb",
    default_value = 1,
    minimum_value = 0,
}

gleba_settings_constants.settings.GLEBA_MAX_FRIENDS_AROUND_TO_SPAWN = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-max-friends-around-to-spawn",
    setting_type = "startup",
    order = "cbc",
    default_value = 3,
    minimum_value = 0,
}
gleba_settings_constants.settings.GLEBA_MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = {
    type = "int-setting",
    name = "more-enemies-spawner-gleba-max-defensive-friends-around-to-spawn",
    setting_type = "startup",
    order = "cbd",
    default_value = 2,
    minimum_value = 0,
}

gleba_settings_constants.settings.GLEBA_MAX_SPAWNING_COOLDOWN = {
    type = "int-setting",
    name = "more-enemies-max-spawning-cooldown-gleba",
    setting_type = "startup",
    order = "cbe",
    default_value = 360,
    minimum_value = 1,
}

gleba_settings_constants.settings.GLEBA_MIN_SPAWNING_COOLDOWN = {
    type = "int-setting",
    name = "more-enemies-min-spawning-cooldown-gleba",
    setting_type = "startup",
    order = "cbf",
    default_value = 150,
    minimum_value = 1,
}

gleba_settings_constants.more_enemies = true

local _gleba_settings_constants = gleba_settings_constants

return gleba_settings_constants