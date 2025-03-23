-- If already defined, return
if _constants and _constants.more_enemies then
  return _constants
end

local constants = {}

constants.difficulty = {}

constants.difficulty.EASY = {}
constants.difficulty.EASY.name = "Easy"
constants.difficulty.EASY.value = 0.1
constants.difficulty.EASY.radius = 15
constants.difficulty.EASY.radius_modifier = 0.5

constants.difficulty.VANILLA = {}
constants.difficulty.VANILLA.name = "Vanilla"
constants.difficulty.VANILLA.value = 1
constants.difficulty.VANILLA.radius = 30
constants.difficulty.VANILLA.radius_modifier = 1

constants.difficulty.VANILLA_PLUS = {}
constants.difficulty.VANILLA_PLUS.name = "Vanilla+"
constants.difficulty.VANILLA_PLUS.value = 1.75
constants.difficulty.VANILLA_PLUS.radius = 37.5
constants.difficulty.VANILLA_PLUS.radius_modifier = 1.25

constants.difficulty.HARD = {}
constants.difficulty.HARD.name = "Hard"
constants.difficulty.HARD.value = 4
constants.difficulty.HARD.radius = 46.875
constants.difficulty.HARD.radius_modifier = 1.5625

constants.difficulty.INSANITY = {}
constants.difficulty.INSANITY.name = "Insanity"
constants.difficulty.INSANITY.value = 10
constants.difficulty.INSANITY.radius = 58.59375
constants.difficulty.INSANITY.radius_modifier = 1.953125

constants.DEFAULTS = {}

-- Settings taken from vanilla
--   -> See base/prototypes/map-settings.lua
constants.DEFAULTS.unit_group = {
  max_group_radius = 30.0,
  min_group_radius = 5.0,

  -- Maximum size of an attack unit group. This only affects automatically-created unit groups;
  -- manual groups created through the API are unaffected.
  max_unit_group_size = 200
}

constants.more_enemies = true

local _constants = constants

return constants