-- If already defined, return
if (_difficulty_utils and _difficulty_utils.more_enemies) then
  return _difficulty_utils
end

local Constants = require("libs.constants")
local Log = require("libs.log.log")
local Log_Constants_Functions = require("libs.log.log-constants-functions")
local Validations = require("libs.validations")

local difficulty_utils = {}

difficulty_utils.difficulty = {}

function difficulty_utils.init_difficulty(planet)
  local difficulty = {
    valid = false
  }

  if (not planet) then
    Log.warn("planet invalid")
    return difficulty
  end

  if (planet == "nauvis") then
    difficulty = {
      valid = true,
      selected_difficulty = Constants.difficulty.VANILLA,
      biter = {
        max_count_of_owned_units = Constants.nauvis.biter.MAX_COUNT_OF_OWNED_UNITS,
        max_count_of_owned_defensive_units = Constants.nauvis.biter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS,
        max_friends_around_to_spawn = Constants.nauvis.biter.MAX_FRIENDS_AROUND_TO_SPAWN,
        max_defensive_friends_around_to_spawn = Constants.nauvis.biter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN,
        spawning_cooldown = {
          max = 360,
          min = 150
        },
      },
      spitter = {
        max_count_of_owned_units = Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_UNITS,
        max_count_of_owned_defensive_units = Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS,
        max_friends_around_to_spawn = Constants.nauvis.spitter.MAX_FRIENDS_AROUND_TO_SPAWN,
        max_defensive_friends_around_to_spawn = Constants.nauvis.spitter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN,
        spawning_cooldown = {
          max = 360,
          min = 150
        }
      }
    }
  elseif (planet == "gleba") then
    difficulty = {
      valid = true,
      selected_difficulty = Constants.difficulty.VANILLA,
      small = {
        max_count_of_owned_units = Constants.gleba.small.MAX_COUNT_OF_OWNED_UNITS,
        max_count_of_owned_defensive_units = Constants.gleba.small.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS,
        max_friends_around_to_spawn = Constants.gleba.small.MAX_FRIENDS_AROUND_TO_SPAWN,
        max_defensive_friends_around_to_spawn = Constants.gleba.small.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN,
        spawning_cooldown = {
          max = 360,
          min = 150
        },
      },
      regular = {
        max_count_of_owned_units = Constants.gleba.regular.MAX_COUNT_OF_OWNED_UNITS,
        max_count_of_owned_defensive_units = Constants.gleba.regular.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS,
        max_friends_around_to_spawn = Constants.gleba.regular.MAX_FRIENDS_AROUND_TO_SPAWN,
        max_defensive_friends_around_to_spawn = Constants.gleba.regular.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN,
        spawning_cooldown = {
          max = 360,
          min = 150
        }
      }
    }
  end

  return difficulty
end

function difficulty_utils.set_difficulty(difficulty_setting, planet)
  local difficulty = {
    valid = false
  }

  -- Log.warn(difficulty_setting)
  -- Log.warn(planet)

  -- Validate inputs
  if (not difficulty_setting) then
    Log.warn("difficulty_setting invalid")
    return difficulty
  end
  if (not planet) then
    Log.warn("planet invalid")
    return difficulty
  end

  local modifier = 1
  local cooldown_modifier = 1
  local vanilla = false
  local selected_difficulty = nil

  -- Determine difficulty
  -- for k,v in pairs(Log_Constants_Functions.get_names())
  if (difficulty_setting == Constants.difficulty.EASY.name or difficulty_setting == Constants.difficulty.EASY.value) then
    modifier = Constants.difficulty.EASY.value
    cooldown_modifier = Constants.difficulty.EASY.value
    selected_difficulty = Constants.difficulty.EASY
  elseif (difficulty_setting == Constants.difficulty.VANILLA.name or difficulty_setting == Constants.difficulty.VANILLA.value) then
    modifier = Constants.difficulty.VANILLA.value
    cooldown_modifier = Constants.difficulty.VANILLA.value
    vanilla = true
    selected_difficulty = Constants.difficulty.VANILLA
  elseif (difficulty_setting == Constants.difficulty.VANILLA_PLUS.name or difficulty_setting == Constants.difficulty.VANILLA_PLUS.value) then
    modifier = Constants.difficulty.VANILLA_PLUS.value
    cooldown_modifier = Constants.difficulty.VANILLA_PLUS.value
    selected_difficulty = Constants.difficulty.VANILLA_PLUS
  elseif (difficulty_setting == Constants.difficulty.HARD.name or difficulty_setting == Constants.difficulty.HARD.value) then
    modifer = Constants.difficulty.HARD.value
    cooldown_modifier = Constants.difficulty.HARD.value
    selected_difficulty = Constants.difficulty.HARD
  elseif (difficulty_setting == Constants.difficulty.INSANITY.name or difficulty_setting == Constants.difficulty.INSANITY.value) then
    modifier = Constants.difficulty.INSANITY.value
    cooldown_modifier = Constants.difficulty.INSANITY.value
    selected_difficulty = Constants.difficulty.INSANITY
  else
    Log.error("No difficulty detected")
    modifier = -1
    cooldown_modifier = -1
  end

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

  Log.info(difficulty)

  return difficulty
end

function difficulty_utils.get_difficulty(planet, reindex)
  reindex = reindex or false

  if (not reindex and difficulty_utils and difficulty_utils.difficulty) then return difficulty_utils.difficulty end

  local difficulty = {
    valid = false
  }

  if (not planet or planet == "") then
    Log.warn("planet invalid", true)
    return difficulty
  end

  local planet_difficulty = settings.startup["more-enemies-" .. planet .. "-difficulty"]
  if (planet_difficulty and planet_difficulty.value) then
    difficulty = difficulty_utils.set_difficulty(planet_difficulty.value, planet)
  else
    difficulty = difficulty_utils.init_difficulty(planet)
  end

  difficulty_utils.difficulty = difficulty

  return difficulty
end

_difficulty_utils.more_enemies = true

_difficulty_utils = difficulty_utils
return difficulty_utils