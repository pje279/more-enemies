-- If already defined, return
local DifficultyUtils = {}
if (_DifficultyUtils) then
  return _DifficultyUtils
end

local Constants = require("libs.constants")
local Validations = require("libs.validations")

function DifficultyUtils.initDifficulty(planet)
  local difficulty = {
    valid = false
  }

  if (not planet) then
    game.print("planet invalid")
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

function DifficultyUtils.setDifficulty(difficulty_setting, planet)
  local difficulty = {
    valid = false
  }

  -- Validate inputs
  if (not difficulty_setting) then
    game.print("difficulty_setting invalid")
    return difficulty
  end
  if (not planet) then
    game.print("planet invalid")
    return difficulty
  end

  local modifier = 1
  local cooldown_modifier = 1
  local vanilla = false
  local selected_difficulty = nil

  -- Determine difficulty
  if (difficulty_setting == Constants.difficulty.EASY) then
    modifier = 0.1
    cooldown_modifier = 0.1
    selected_difficulty = Constants.difficulty.EASY
  elseif (difficulty_setting == Constants.difficulty.VANILLA) then
    modifier = 1
    cooldown_modifier = 1
    vanilla = true
    selected_difficulty = Constants.difficulty.VANILLA
  elseif (difficulty_setting == Constants.difficulty.VANILLA_PLUS) then
    modifier = 1.75
    cooldown_modifier = 1.75
    selected_difficulty = Constants.difficulty.VANILLA_PLUS
  elseif (difficulty_setting == Constants.difficulty.HARD) then
    modifer = 4
    cooldown_modifier = 4
    selected_difficulty = Constants.difficulty.HARD
  elseif (difficulty_setting == Constants.difficulty.INSANITY) then
    modifier = 10
    cooldown_modifier = 10
    selected_difficulty = Constants.difficulty.INSANITY
  else
    game.print("No difficulty detected - lolhwutand")
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
    else
      game.print("")
    end
  end

  return difficulty
end

function DifficultyUtils.getDifficulty(planet)
  local difficulty = {
    valid = false
  }

  if (not planet or planet == "") then
    game.print("planet invalid")
    return difficulty
  end

  local planet_difficulty = settings.startup["more-enemies-" .. planet .. "-difficulty"]
  if (planet_difficulty and planet_difficulty.value) then
    difficulty = DifficultyUtils.setDifficulty(planet_difficulty.value, planet)
  else
    difficulty = DifficultyUtils.initDifficulty(planet)
  end

  return difficulty
end

_DifficultyUtils = DifficultyUtils
return DifficultyUtils