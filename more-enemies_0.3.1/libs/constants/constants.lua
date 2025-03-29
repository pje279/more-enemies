-- If already defined, return
if _constants and _constants.more_enemies then
  return _constants
end

local constants = {}

constants.meta = {}
constants.meta.version = {}
constants.meta.version.valid = {}

constants.meta.version.major = {}
constants.meta.version.major.value = 0
constants.meta.version.major.warned = false
constants.meta.version.major.valid = true

constants.meta.version.minor = {}
constants.meta.version.minor.value = 3
constants.meta.version.minor.warned = false
constants.meta.version.minor.valid = true

constants.meta.version.bug_fix = {}
constants.meta.version.bug_fix.value = 0
constants.meta.version.bug_fix.warned = false
constants.meta.version.bug_fix.valid = true

constants.meta.version.string_val = constants.meta.version.major.value .. "." .. constants.meta.version.minor.value .. "." .. constants.meta.version.bug_fix.value

constants.meta.functions = {}
constants.meta.functions.version = {}
constants.meta.functions.version.validate = function()
  local return_val = {
    valid = false,
    major = {
      valid = false,
      value = 0
    },
    minor = {
      valid = false,
      value = 0
    },
    bug_fix = {
      valid = false,
      value = 0
    }
  }

  -- Check that the information even exists
  if (not storage) then return return_val end
  if (not storage.more_enemies) then
    storage.more_enemies = {}
    return return_val
  end
  if (not storage.more_enemies.version) then
    storage.more_enemies.version = {}
    return return_val
  end

  -- Check the version numbers; initialize if necessary
  if (not storage.more_enemies.version.major) then storage.more_enemies.version.major = { valid = false, value = 0 } end
  if (not storage.more_enemies.version.minor) then storage.more_enemies.version.minor = { valid = false, value = 0 } end
  if (not storage.more_enemies.version.bug_fix) then storage.more_enemies.version.bug_fix = { valid = false, value = 0 } end

  -- Compare the version numbers
  if (constants.meta.version.major.value <= storage.more_enemies.version.major.value) then return_val.major.valid = true end
  if (constants.meta.version.minor.value <= storage.more_enemies.version.minor.value) then return_val.minor.valid = true end
  if (constants.meta.version.bug_fix.value <= storage.more_enemies.version.bug_fix.value) then return_val.bug_fix.valid = true end

  return_val.valid = true

  return return_val
end

constants.difficulty = {}

constants.difficulty.EASY = {}
constants.difficulty.EASY.order = 1
constants.difficulty.EASY.name = "EASY"
constants.difficulty.EASY.string_val = "Easy"
constants.difficulty.EASY.value = 0.1
constants.difficulty.EASY.radius = 15
constants.difficulty.EASY.radius_modifier = 0.5
constants.difficulty.EASY.valid = true

constants.difficulty.VANILLA = {}
constants.difficulty.VANILLA.order = constants.difficulty.EASY.order + 1
constants.difficulty.VANILLA.name = "VANILLA"
constants.difficulty.VANILLA.string_val = "Vanilla"
constants.difficulty.VANILLA.value = 1
constants.difficulty.VANILLA.radius = 30
constants.difficulty.VANILLA.radius_modifier = 1
constants.difficulty.VANILLA.valid = true

constants.difficulty.VANILLA_PLUS = {}
constants.difficulty.VANILLA_PLUS.order = constants.difficulty.VANILLA.order + 1
constants.difficulty.VANILLA_PLUS.name = "VANILLA_PLUS"
constants.difficulty.VANILLA_PLUS.string_val = "Vanilla+"
constants.difficulty.VANILLA_PLUS.value = 1.75
constants.difficulty.VANILLA_PLUS.radius = 37.5
constants.difficulty.VANILLA_PLUS.radius_modifier = 1.25
constants.difficulty.VANILLA_PLUS.valid = true

constants.difficulty.HARD = {}
constants.difficulty.HARD.order = constants.difficulty.VANILLA_PLUS.order + 1
constants.difficulty.HARD.name = "HARD"
constants.difficulty.HARD.string_val = "Hard"
constants.difficulty.HARD.value = 4
constants.difficulty.HARD.radius = 46.875
constants.difficulty.HARD.radius_modifier = 1.5625
constants.difficulty.HARD.valid = true

constants.difficulty.INSANITY = {}
constants.difficulty.INSANITY.order = constants.difficulty.HARD.order + 1
constants.difficulty.INSANITY.name = "INSANITY"
constants.difficulty.INSANITY.string_val = "Insanity"
constants.difficulty.INSANITY.value = 11
constants.difficulty.INSANITY.radius = 58.59375
constants.difficulty.INSANITY.radius_modifier = 1.953125
constants.difficulty.INSANITY.valid = true

constants.difficulty.difficulties = {}
constants.difficulty.difficulties_array = {}

for k,v in pairs(constants.difficulty) do
  if (v and v.string_val) then constants.difficulty.difficulties[v.string_val] = k end
  if (v and v.string_val) then constants.difficulty.difficulties_array[v.order] = v.string_val end
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

constants.settings = {}

constants.DEFAULTS.planets = {}

constants.DEFAULTS.planets.nauvis = {}
constants.DEFAULTS.planets.nauvis.string_val = "nauvis"

if (mods and mods["space-age"]) then
  constants.DEFAULTS.planets.gleba = {}
  constants.DEFAULTS.planets.gleba.string_val = "gleba"
end

constants.time = {}
constants.time.TICKS_PER_SECOND = 60
constants.time.SECONDS_PER_MINUTE = 60
constants.time.TICKS_PER_MINUTE = constants.time.TICKS_PER_SECOND * constants.time.SECONDS_PER_MINUTE

constants.more_enemies = true

local _constants = constants

return constants