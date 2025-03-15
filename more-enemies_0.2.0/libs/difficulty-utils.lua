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

  if (planet and planet == "nauvis") then
    difficulty = {
      valid = true,
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
  elseif (planet and planet == "gleba") then
    difficulty = {
      valid = true,
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
    -- game.print("difficulty_setting invalid")
    return difficulty
  end
  if (not planet) then
    -- game.print("planet invalid")
    return difficulty
  end

  local modifier = 1
  local cooldown_modifier = 1
  local vanilla = false

  -- Determine difficulty
  if (difficulty_setting == Constants.difficulty.EASY) then
    modifier = 0.1
    cooldown_modifier = 0.1
  elseif (difficulty_setting == Constants.difficulty.VANILLA) then
    modifier = 1
    cooldown_modifier = 1
    vanilla = true
  elseif (difficulty_setting == Constants.difficulty.VANILLA_PLUS) then
    modifier = 1.75
    cooldown_modifier = 1.75
  elseif (difficulty_setting == Constants.difficulty.HARD) then
    modifer = 4
    cooldown_modifier = 4
  elseif (difficulty_setting == Constants.difficulty.INSANITY) then
    modifier = 10
    cooldown_modifier = 10
  else
    game.print("No difficulty detected - lolhwutand")
    modifier = -1
    cooldown_modifier = -1
  end

  if (modifier >= 0 and cooldown_modifier >= 0) then
    if (planet == "nauvis") then
      difficulty = {
        valid = true,
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


_DifficultyUtils = DifficultyUtils
return DifficultyUtils