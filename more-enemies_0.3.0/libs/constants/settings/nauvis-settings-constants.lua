-- If already defined, return
if _nauvis_settings_constants and _nauvis_settings_constants.more_enemies then
  return _nauvis_settings_constants
end

local Constants = require("libs.constants.constants")

nauvis_settings_constants = {}

nauvis_settings_constants.settings = {}

-- { Cloning } --
nauvis_settings_constants.settings.CLONE_NAUVIS_UNITS = {
  type = "double-setting",
  name = "more-enemies-clone-nauvis-units",
  setting_type = "runtime-global",
  order = "bac",
  default_value = 1,
  maximum_value = 11, -- This one goes up to eleven
  minimum_value = 0,
}

nauvis_settings_constants.settings.CLONE_NAUVIS_UNIT_GROUPS = {
  type = "double-setting",
  name = "more-enemies-clone-gleba-nauvis-groups",
  setting_type = "runtime-global",
  order = "bad",
  default_value = 1,
  maximum_value = 11, -- This one goes up to eleven
  minimum_value = 0,
}

-- { Difficulty } --
nauvis_settings_constants.settings.NAUVIS_DIFFICULTY = {
  type = "string-setting",
  name = "more-enemies-nauvis-difficulty",
  setting_type = "startup",
  order = "aaa",
  default_value = "Vanilla",
  allowed_values = Constants.difficulty.difficulties_array
}

nauvis_settings_constants.settings.NAUVIS_DO_EVOLUTION_FACTOR = {
  type = "bool-setting",
  name = "more-enemies-nauvis-do-evolution-factor",
  setting_type = "runtime-global",
  order = "baa",
  default_value = true,
}

-- { Biters } --
nauvis_settings_constants.settings.NAUVIS_BITER_MAX_COUNT_OF_OWNED_UNITS = {
  type = "int-setting",
  name = "more-enemies-spawner-nauvis-max-count-of-owned-units-biter",
  setting_type = "startup",
  order = "baa",
  default_value = 7,
  minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_BITER_MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = {
  type = "int-setting",
  name = "more-enemies-spawner-nauvis-max-count-of-owned-defensive-units-biter",
  setting_type = "startup",
  order = "bab",
  default_value = 7,
  minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_BITER_MAX_FRIENDS_AROUND_TO_SPAWN = {
  type = "int-setting",
  name = "more-enemies-spawner-nauvis-max-friends-around-to-spawn-biter",
  setting_type = "startup",
  order = "bac",
  default_value = 5,
  minimum_value = 0,
}
nauvis_settings_constants.settings.NAUVIS_BITER_MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = {
  type = "int-setting",
  name = "more-enemies-spawner-nauvis-max-defensive-friends-around-to-spawn-biter",
  setting_type = "startup",
  order = "bad",
  default_value = 5,
  minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_BITER_MAX_SPAWNING_COOLDOWN = {
  type = "int-setting",
  name = "more-enemies-max-spawning-cooldown-biter",
  setting_type = "startup",
  order = "bae",
  default_value = 360,
  minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_BITER_MIN_SPAWNING_COOLDOWN = {
  type = "int-setting",
  name = "more-enemies-min-spawning-cooldown-biter",
  setting_type = "startup",
  order = "baf",
  default_value = 150,
  minimum_value = 0,
}

-- { Spitters } --
nauvis_settings_constants.settings.NAUVIS_SPITTER_MAX_COUNT_OF_OWNED_UNITS = {
    type = "int-setting",
    name = "more-enemies-spawner-nauvis-max-count-of-owned-units-spitter",
    setting_type = "startup",
    order = "bba",
    default_value = 7,
    minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_SPITTER_MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = {
    type = "int-setting",
    name = "more-enemies-spawner-nauvis-max-count-of-owned-defensive-units-spitter",
    setting_type = "startup",
    order = "bbb",
    default_value = 7,
    minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_SPITTER_MAX_FRIENDS_AROUND_TO_SPAWN = {
    type = "int-setting",
    name = "more-enemies-spawner-nauvis-max-friends-around-to-spawn-spitter",
    setting_type = "startup",
    order = "bbc",
    default_value = 5,
    minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_SPITTER_MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = {
    type = "int-setting",
    name = "more-enemies-spawner-nauvis-max-defensive-friends-around-to-spawn-spitter",
    setting_type = "startup",
    order = "bbd",
    default_value = 5,
    minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_SPITTER_MAX_SPAWNING_COOLDOWN = {
    type = "int-setting",
    name = "more-enemies-max-spawning-cooldown-spitter",
    setting_type = "startup",
    order = "bbe",
    default_value = 360,
    minimum_value = 1,
}

nauvis_settings_constants.settings.NAUVIS_SPITTER_MIN_SPAWNING_COOLDOWN = {
    type = "int-setting",
    name = "more-enemies-min-spawning-cooldown-spitter",
    setting_type = "startup",
    order = "bbf",
    default_value = 150,
    minimum_value = 1,
}

nauvis_settings_constants.more_enemies = true

local _nauvis_settings_constants = nauvis_settings_constants

return nauvis_settings_constants