-- If already defined, return
if _nauvis_settings_constants and _nauvis_settings_constants.more_enemies then
  return _nauvis_settings_constants
end

local Constants = require("libs.constants.constants")

local nauvis_settings_constants = {}

nauvis_settings_constants.settings = {}

-- { Cloning } --
nauvis_settings_constants.settings.CLONE_NAUVIS_UNITS = {
  type = "double-setting",
  name = "more-enemies-clone-nauvis-units",
  setting_type = "runtime-global",
  order = "daa",
  default_value = 1,
  maximum_value = 11, -- This one goes up to eleven
  minimum_value = 0,
}

nauvis_settings_constants.settings.CLONE_NAUVIS_UNIT_GROUPS = {
  type = "double-setting",
  name = "more-enemies-clone-gleba-nauvis-groups",
  setting_type = "runtime-global",
  order = "dab",
  default_value = 1,
  maximum_value = 11, -- This one goes up to eleven
  minimum_value = 0,
}

nauvis_settings_constants.settings.MAXIMUM_NUMBER_OF_SPAWNED_CLONES_NAUVIS = {
  type = "int-setting",
  name = "more-enemies-maximum-number-of-spawned-clones-nauvis",
  setting_type = "runtime-global",
  order = "dyd",
  default_value = 400,
  maximum_value = 111111,
  minimum_value = 0,
}

nauvis_settings_constants.settings.MAXIMUM_NUMBER_OF_UNIT_GROUP_CLONES_NAUVIS = {
  type = "int-setting",
  name = "more-enemies-maximum-number-of-unit-group-clones-nauvis",
  setting_type = "runtime-global",
  order = "dye",
  default_value = 400,
  maximum_value = 111111,
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
  order = "caa",
  default_value = true,
}

nauvis_settings_constants.settings.NAUVIS_DO_ATTACK_GROUP = {
  type = "bool-setting",
  name = "more-enemies-nauvis-do-attack-group",
  setting_type = "runtime-global",
  order = "cab",
  default_value = true,
}

-- { Biters } --
nauvis_settings_constants.settings.NAUVIS_BITER_MAX_COUNT_OF_OWNED_UNITS = {
  type = "int-setting",
  name = "more-enemies-spawner-nauvis-max-count-of-owned-units-biter",
  setting_type = "startup",
  order = "caa",
  default_value = 7,
  minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_BITER_MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = {
  type = "int-setting",
  name = "more-enemies-spawner-nauvis-max-count-of-owned-defensive-units-biter",
  setting_type = "startup",
  order = "cab",
  default_value = 7,
  minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_BITER_MAX_FRIENDS_AROUND_TO_SPAWN = {
  type = "int-setting",
  name = "more-enemies-spawner-nauvis-max-friends-around-to-spawn-biter",
  setting_type = "startup",
  order = "cac",
  default_value = 5,
  minimum_value = 0,
}
nauvis_settings_constants.settings.NAUVIS_BITER_MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = {
  type = "int-setting",
  name = "more-enemies-spawner-nauvis-max-defensive-friends-around-to-spawn-biter",
  setting_type = "startup",
  order = "cad",
  default_value = 5,
  minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_BITER_MAX_SPAWNING_COOLDOWN = {
  type = "int-setting",
  name = "more-enemies-max-spawning-cooldown-biter",
  setting_type = "startup",
  order = "cae",
  default_value = 360,
  minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_BITER_MIN_SPAWNING_COOLDOWN = {
  type = "int-setting",
  name = "more-enemies-min-spawning-cooldown-biter",
  setting_type = "startup",
  order = "caf",
  default_value = 150,
  minimum_value = 0,
}

-- { Spitters } --
nauvis_settings_constants.settings.NAUVIS_SPITTER_MAX_COUNT_OF_OWNED_UNITS = {
  type = "int-setting",
  name = "more-enemies-spawner-nauvis-max-count-of-owned-units-spitter",
  setting_type = "startup",
  order = "cba",
  default_value = 7,
  minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_SPITTER_MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = {
  type = "int-setting",
  name = "more-enemies-spawner-nauvis-max-count-of-owned-defensive-units-spitter",
  setting_type = "startup",
  order = "cbb",
  default_value = 7,
  minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_SPITTER_MAX_FRIENDS_AROUND_TO_SPAWN = {
  type = "int-setting",
  name = "more-enemies-spawner-nauvis-max-friends-around-to-spawn-spitter",
  setting_type = "startup",
  order = "cbc",
  default_value = 5,
  minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_SPITTER_MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = {
  type = "int-setting",
  name = "more-enemies-spawner-nauvis-max-defensive-friends-around-to-spawn-spitter",
  setting_type = "startup",
  order = "cbd",
  default_value = 5,
  minimum_value = 0,
}

nauvis_settings_constants.settings.NAUVIS_SPITTER_MAX_SPAWNING_COOLDOWN = {
  type = "int-setting",
  name = "more-enemies-max-spawning-cooldown-spitter",
  setting_type = "startup",
  order = "cbe",
  default_value = 360,
  minimum_value = 1,
}

nauvis_settings_constants.settings.NAUVIS_SPITTER_MIN_SPAWNING_COOLDOWN = {
  type = "int-setting",
  name = "more-enemies-min-spawning-cooldown-spitter",
  setting_type = "startup",
  order = "cbf",
  default_value = 150,
  minimum_value = 1,
}

nauvis_settings_constants.more_enemies = true

local _nauvis_settings_constants = nauvis_settings_constants

return nauvis_settings_constants