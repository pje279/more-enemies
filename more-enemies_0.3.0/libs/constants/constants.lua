-- If already defined, return
if _constants and _constants.more_enemies then
  return _constants
end

local constants = {}

constants.difficulty = {}

constants.difficulty.EASY = {}
constants.difficulty.EASY.name = "EASY"
constants.difficulty.EASY.string_val = "Easy"
constants.difficulty.EASY.value = 0.1
constants.difficulty.EASY.radius = 15
constants.difficulty.EASY.radius_modifier = 0.5
constants.difficulty.EASY.valid = true

constants.difficulty.VANILLA = {}
constants.difficulty.VANILLA.name = "VANILLA"
constants.difficulty.VANILLA.string_val = "Vanilla"
constants.difficulty.VANILLA.value = 1
constants.difficulty.VANILLA.radius = 30
constants.difficulty.VANILLA.radius_modifier = 1
constants.difficulty.VANILLA.valid = true

constants.difficulty.VANILLA_PLUS = {}
constants.difficulty.VANILLA_PLUS.name = "VANILLA_PLUS"
constants.difficulty.VANILLA_PLUS.string_val = "Vanilla+"
constants.difficulty.VANILLA_PLUS.value = 1.75
constants.difficulty.VANILLA_PLUS.radius = 37.5
constants.difficulty.VANILLA_PLUS.radius_modifier = 1.25
constants.difficulty.VANILLA_PLUS.valid = true

constants.difficulty.HARD = {}
constants.difficulty.HARD.name = "HARD"
constants.difficulty.HARD.string_val = "Hard"
constants.difficulty.HARD.value = 4
constants.difficulty.HARD.radius = 46.875
constants.difficulty.HARD.radius_modifier = 1.5625
constants.difficulty.HARD.valid = true

constants.difficulty.INSANITY = {}
constants.difficulty.INSANITY.name = "INSANITY"
constants.difficulty.INSANITY.string_val = "Insanity"
constants.difficulty.INSANITY.value = 10
constants.difficulty.INSANITY.radius = 58.59375
constants.difficulty.INSANITY.radius_modifier = 1.953125
constants.difficulty.INSANITY.valid = true

constants.difficulty.difficulties = {}

for k,v in pairs(constants.difficulty) do
  if (v and v.string_val) then constants.difficulty.difficulties[v.string_val] = k end
end

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

constants.DEFAULTS.planets = {}

constants.DEFAULTS.planets.nauvis = {}
constants.DEFAULTS.planets.nauvis.string_val = "nauvis"

constants.DEFAULTS.planets.gleba = {}
constants.DEFAULTS.planets.gleba.string_val = "gleba"

constants.more_enemies = true

local _constants = constants

return constants