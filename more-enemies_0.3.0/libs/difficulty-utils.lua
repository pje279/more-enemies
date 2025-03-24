-- If already defined, return
if (_difficulty_utils and _difficulty_utils.more_enemies) then
  return _difficulty_utils
end

local Constants = require("libs.constants.constants")
local Gleba_Constants = require("libs.constants.gleba-constants")
local Log = require("libs.log.log")
local Log_Constants_Functions = require("libs.log.log-constants-functions")
local Nauvis_Constants = require("libs.constants.nauvis-constants")
local Validations = require("libs.validations")

local difficulty_utils = {}

function difficulty_utils.init_difficulty(planet, difficulty_setting)
  difficulty_setting = difficulty_setting or Constants.difficulty.VANILLA
  planet = planet or "nauvis"

  local difficulty = {
    valid = false
  }

  if (not planet) then
    Log.warn("planet invalid")
    return difficulty
  end

  difficulty = create_difficulty(planet, difficulty_setting)

  if (storage) then
    if (not storage.difficulty) then storage.difficulty = {} end
    storage.difficulty[planet] = difficulty
  end

  return difficulty
end

function difficulty_utils.set_difficulty(planet, difficulty_setting)
  difficulty_setting = difficulty_setting or Constants.difficulty.VANILLA
  planet = planet or "nauvis"

  local difficulty = {
    valid = false
  }

  local modifier = 1
  local cooldown_modifier = 1
  local vanilla = false
  local selected_difficulty = nil

  -- Determine difficulty
  if (difficulty_setting == Constants.difficulty.EASY.string_val or difficulty_setting == Constants.difficulty.EASY.value) then
    modifier = Constants.difficulty.EASY.value
    cooldown_modifier = Constants.difficulty.EASY.value
    selected_difficulty = Constants.difficulty.EASY
  elseif (difficulty_setting == Constants.difficulty.VANILLA.string_val or difficulty_setting == Constants.difficulty.VANILLA.value) then
    modifier = Constants.difficulty.VANILLA.value
    cooldown_modifier = Constants.difficulty.VANILLA.value
    vanilla = true
    selected_difficulty = Constants.difficulty.VANILLA
  elseif (difficulty_setting == Constants.difficulty.VANILLA_PLUS.string_val or difficulty_setting == Constants.difficulty.VANILLA_PLUS.value) then
    modifier = Constants.difficulty.VANILLA_PLUS.value
    cooldown_modifier = Constants.difficulty.VANILLA_PLUS.value
    selected_difficulty = Constants.difficulty.VANILLA_PLUS
  elseif (difficulty_setting == Constants.difficulty.HARD.string_val or difficulty_setting == Constants.difficulty.HARD.value) then
    modifer = Constants.difficulty.HARD.value
    cooldown_modifier = Constants.difficulty.HARD.value
    selected_difficulty = Constants.difficulty.HARD
  elseif (difficulty_setting == Constants.difficulty.INSANITY.string_val or difficulty_setting == Constants.difficulty.INSANITY.value) then
    modifier = Constants.difficulty.INSANITY.value
    cooldown_modifier = Constants.difficulty.INSANITY.value
    selected_difficulty = Constants.difficulty.INSANITY
  else
    Log.error("No difficulty detected")
    modifier = -1
    cooldown_modifier = -1
  end

  difficulty = create_difficulty(planet, selected_difficulty, modifier, cooldown_modifier)

  if (storage) then
    if (not storage.difficulty) then storage.difficulty = {} end
    storage.difficulty[planet] = difficulty
  end

  Log.info(difficulty)

  return difficulty
end

function difficulty_utils.get_difficulty(planet, reindex)
  reindex = reindex or false

  if (  not reindex
    and planet
    and storage
    and storage.difficulty
    and storage.difficulty[planet] ~= nil
    and storage.difficulty.valid)
  then return storage.difficulty[planet] end

  local difficulty = {
    valid = false
  }

  Log.warn(planet)
  if (not planet or planet == "") then
    Log.warn("planet invalid", true)
    return difficulty
  end

  local planet_difficulty = settings.startup["more-enemies-" .. planet .. "-difficulty"]

  if (planet_difficulty and planet_difficulty.value) then
    if (reindex) then
      difficulty = difficulty_utils.init_difficulty(planet, planet_difficulty.value)
    else
      difficulty = difficulty_utils.set_difficulty(planet, planet_difficulty.value)
    end
  else
    difficulty = difficulty_utils.init_difficulty(planet)
  end

  Log.warn(difficulty)

  if (storage) then storage.difficulty[planet] = difficulty end

  return difficulty
end

function create_difficulty(planet, selected_difficulty, modifier, cooldown_modifier)
  modifier = modifier or 1
  cooldown_modifier = cooldown_modifier or 1

  local difficulty = {
    valid = false
  }

  if (selected_difficulty and modifier >= 0 and cooldown_modifier >= 0) then
    if (planet == "nauvis") then
      difficulty = {
        valid = true,
        selected_difficulty = selected_difficulty,
        biter = {
          max_count_of_owned_units = vanilla and Constants.nauvis.biter.MAX_COUNT_OF_OWNED_UNITS or (Constants.nauvis.biter.MAX_COUNT_OF_OWNED_UNITS * modifier) + 1,
          max_count_of_owned_defensive_units = vanilla and Constants.nauvis.biter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS or (Constants.nauvis.biter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS * modifier) + 1,
          max_friends_around_to_spawn = vanilla and Constants.nauvis.biter.MAX_FRIENDS_AROUND_TO_SPAWN or (Constants.nauvis.biter.MAX_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
          max_defensive_friends_around_to_spawn = vanilla and Constants.nauvis.biter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN or (Constants.nauvis.biter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
          spawning_cooldown = {
            max = 360 / (cooldown_modifier + 1),
            min = 150 / (cooldown_modifier + 1)
          },
        },
        spitter = {
          max_count_of_owned_units = vanilla and Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_UNITS or (Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_UNITS * modifier) + 1,
          max_count_of_owned_defensive_units = vanilla and Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS or (Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS * modifier) + 1,
          max_friends_around_to_spawn = vanilla and Constants.nauvis.spitter.MAX_FRIENDS_AROUND_TO_SPAWN or (Constants.nauvis.spitter.MAX_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
          max_defensive_friends_around_to_spawn = vanilla and Constants.nauvis.spitter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN or (Constants.nauvis.spitter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
          spawning_cooldown = {
            max = 360 / (cooldown_modifier + 1),
            min = 150 / (cooldown_modifier + 1)
          }
        }
      }
    elseif (planet == "gleba") then
      difficulty = {
        valid = true,
        selected_difficulty = selected_difficulty,
        small = {
          max_count_of_owned_units = vanilla and Constants.gleba.small.MAX_COUNT_OF_OWNED_UNITS or (Constants.gleba.small.MAX_COUNT_OF_OWNED_UNITS * modifier) + 1,
          max_count_of_owned_defensive_units = vanilla and Constants.gleba.small.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS or (Constants.gleba.small.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS * modifier) + 1,
          max_friends_around_to_spawn = vanilla and Constants.gleba.small.MAX_FRIENDS_AROUND_TO_SPAWN or (Constants.gleba.small.MAX_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
          max_defensive_friends_around_to_spawn = vanilla and Constants.gleba.small.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN or (Constants.gleba.small.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
          spawning_cooldown = {
            max = 360 / (cooldown_modifier + 1),
            min = 150 / (cooldown_modifier + 1)
          },
        },
        regular = {
          max_count_of_owned_units = vanilla and Constants.gleba.regular.MAX_COUNT_OF_OWNED_UNITS or (Constants.gleba.regular.MAX_COUNT_OF_OWNED_UNITS * modifier) + 1,
          max_count_of_owned_defensive_units = vanilla and Constants.gleba.regular.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS or (Constants.gleba.regular.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS * modifier) + 1,
          max_friends_around_to_spawn = vanilla and Constants.gleba.regular.MAX_FRIENDS_AROUND_TO_SPAWN or (Constants.gleba.regular.MAX_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
          max_defensive_friends_around_to_spawn = vanilla and Constants.gleba.regular.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN or (Constants.gleba.regular.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
          spawning_cooldown = {
            max = 360 / (cooldown_modifier + 1),
            min = 150 / (cooldown_modifier + 1)
          }
        }
      }
    end
  end

  Log.info("returning difficulty: " .. serpent.block(difficulty))
  return difficulty
end

difficulty_utils.more_enemies = true

_difficulty_utils = difficulty_utils
return difficulty_utils