-- If already defined, return
if _constants and _constants.more_enemies then
  return _constants
end

local Log = require("libs.log.log")
local Easy_Difficulty_Data = require("scripts.data.difficulties.easy-difficulty-data")
local Hard_Difficulty_Data = require("scripts.data.difficulties.hard-difficulty-data")
local Insanity_Difficulty_Data = require("scripts.data.difficulties.insanity-difficulty-data")
local Vanilla_Plus_Difficulty_Data = require("scripts.data.difficulties.vanilla-plus-difficulty-data")
local Vanilla_Difficulty_Data = require("scripts.data.difficulties.vanilla-difficulty-data")

local constants = {}

constants.difficulty = {}

constants.difficulty.EASY = Easy_Difficulty_Data:new()
constants.difficulty.EASY.order = 1
constants.difficulty.EASY.valid = true

constants.difficulty.VANILLA = Vanilla_Difficulty_Data:new()
constants.difficulty.VANILLA.order = constants.difficulty.EASY.order + 1
constants.difficulty.VANILLA.valid = true

constants.difficulty.VANILLA_PLUS = Vanilla_Plus_Difficulty_Data:new()
constants.difficulty.VANILLA_PLUS.order = constants.difficulty.VANILLA.order + 1
constants.difficulty.VANILLA_PLUS.valid = true

constants.difficulty.HARD = Hard_Difficulty_Data:new()
constants.difficulty.HARD.order = constants.difficulty.VANILLA_PLUS.order + 1
constants.difficulty.HARD.valid = true

constants.difficulty.INSANITY = Insanity_Difficulty_Data:new()
constants.difficulty.INSANITY.order = constants.difficulty.HARD.order + 1
constants.difficulty.INSANITY.valid = true

local difficulties = {}
local difficulties_array = {}

for k,v in pairs(constants.difficulty) do
  if (v and v.string_val) then difficulties[v.string_val] = k end
  if (v and v.string_val) then difficulties_array[v.order] = v.string_val end
end

constants.difficulty.difficulties = difficulties
constants.difficulty.difficulties_array = difficulties_array

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

constants.DEFAULTS.planets.gleba = {}
constants.DEFAULTS.planets.gleba.string_val = "gleba"

constants.time = {}
constants.time.TICKS_PER_SECOND = 60
constants.time.SECONDS_PER_MINUTE = 60
constants.time.TICKS_PER_MINUTE = constants.time.TICKS_PER_SECOND * constants.time.SECONDS_PER_MINUTE

constants.CHUNK_SIZE = 32

constants.more_enemies = true

local _constants = constants

return constants