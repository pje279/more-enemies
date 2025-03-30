-- If already defined, return
if (_difficulty_utils and _difficulty_utils.more_enemies) then
  return _difficulty_utils
end

local Armoured_Biters_Constants = require("libs.constants.mods.armoured-biters-constants")
local Constants = require("libs.constants.constants")
local Gleba_Constants = require("libs.constants.gleba-constants")
local Log = require("libs.log.log")
local Log_Constants_Functions = require("libs.log.log-constants-functions")
local Nauvis_Constants = require("libs.constants.nauvis-constants")

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
    if (not storage.more_enemies.difficulties) then storage.more_enemies.difficulties = {} end
    if (not storage.more_enemies.difficulties[planet]) then storage.more_enemies.difficulties[planet] = {} end
    storage.more_enemies.difficulties[planet].difficulty = difficulty
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
    if (not storage.more_enemies.difficulties) then storage.more_enemies.difficulties = {} end
    if (not storage.more_enemies.difficulties[planet]) then storage.more_enemies.difficulties[planet] = {} end
    storage.more_enemies.difficulties[planet].difficulty = difficulty
  end

  Log.info(difficulty)

  return difficulty
end

function difficulty_utils.get_difficulty(planet, reindex)
  reindex = reindex or false

  Log.debug(reindex)
  if (storage) then Log.info(storage.more_enemies.difficulties) end

  if (  not reindex
    and planet
    and storage
    and storage.more_enemies
    and storage.more_enemies.difficulties
    and storage.more_enemies.difficulties[planet].valid)
  then
    -- While it may exist, check if it's still valid
    Log.info(storage.more_enemies.difficulties)
    Log.info(planet)
    if (storage.more_enemies.difficulties[planet].selected_difficulty and not storage.more_enemies.difficulties[planet].selected_difficulty.valid) then
      return difficulty_utils.get_difficulty(planet, true)
    else
      return storage.more_enemies.difficulties[planet]
    end
  end

  local difficulty = {
    valid = false
  }

  if (  planet == "gleba"
    and ((mods and not mods["space-age"]) or (script and script.active_mods and not script.active_mods["space-age"])))
  then
    Log.warn("planet invalid")
    return difficulty
  end


  if (storage and not storage.more_enemies) then storage.more_enemies = {} end
  if (storage and storage.more_enemies and not storage.more_enemies.difficulties) then storage.more_enemies.difficulties = {} end

  Log.info(planet)
  if (not planet or planet == "") then
    Log.warn("planet invalid")
    return difficulty
  end

  if (storage and storage.more_enemies and storage.more_enemies.difficulties and not storage.more_enemies.difficulties[planet]) then storage.more_enemies.difficulties[planet] = difficulty end

  local planet_difficulty = settings.startup["more-enemies-" .. planet .. "-difficulty"]

  local selected_difficulty = Constants.difficulty[Constants.difficulty.difficulties[planet_difficulty.value]]

  if (selected_difficulty and selected_difficulty.valid) then
    if (reindex) then
      difficulty = difficulty_utils.init_difficulty(planet, selected_difficulty)
    else
      difficulty = difficulty_utils.set_difficulty(planet, selected_difficulty)
    end
  else
    difficulty = difficulty_utils.init_difficulty(planet)
  end

  Log.info(difficulty)

  -- If storage difficulty for the planet is invalid, replace it
  if (  storage
    and storage.more_enemies
    and storage.more_enemies.difficulties
    and storage.more_enemies.difficulties[planet]
    and not storage.more_enemies.difficulties[planet].valid)
  then
    storage.more_enemies.difficulties[planet] = difficulty
  end

  return difficulty
end

function create_difficulty(planet, selected_difficulty, modifier, cooldown_modifier)
  modifier = modifier or 1
  cooldown_modifier = cooldown_modifier or 1

  local difficulty = {
    valid = false
  }

  if (selected_difficulty and selected_difficulty.valid and modifier >= 0 and cooldown_modifier >= 0) then
    if (planet == Constants.DEFAULTS.planets.nauvis.string_val) then

      if ( (script and script.active_mods and script.active_mods["ArmouredBiters"])
        or (mods and mods["ArmouredBiters"]))
      then
        difficulty = {
          valid = true,
          selected_difficulty = selected_difficulty,
          biter = {
            max_count_of_owned_units = vanilla and Nauvis_Constants.nauvis.biter.MAX_COUNT_OF_OWNED_UNITS or (Nauvis_Constants.nauvis.biter.MAX_COUNT_OF_OWNED_UNITS * modifier) + 1,
            max_count_of_owned_defensive_units = vanilla and Nauvis_Constants.nauvis.biter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS or (Nauvis_Constants.nauvis.biter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS * modifier) + 1,
            max_friends_around_to_spawn = vanilla and Nauvis_Constants.nauvis.biter.MAX_FRIENDS_AROUND_TO_SPAWN or (Nauvis_Constants.nauvis.biter.MAX_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
            max_defensive_friends_around_to_spawn = vanilla and Nauvis_Constants.nauvis.biter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN or (Nauvis_Constants.nauvis.biter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
            spawning_cooldown = {
              max = 360 / (cooldown_modifier + 1),
              min = 150 / (cooldown_modifier + 1)
            },
          },
          spitter = {
            max_count_of_owned_units = vanilla and Nauvis_Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_UNITS or (Nauvis_Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_UNITS * modifier) + 1,
            max_count_of_owned_defensive_units = vanilla and Nauvis_Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS or (Nauvis_Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS * modifier) + 1,
            max_friends_around_to_spawn = vanilla and Nauvis_Constants.nauvis.spitter.MAX_FRIENDS_AROUND_TO_SPAWN or (Nauvis_Constants.nauvis.spitter.MAX_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
            max_defensive_friends_around_to_spawn = vanilla and Nauvis_Constants.nauvis.spitter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN or (Nauvis_Constants.nauvis.spitter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
            spawning_cooldown = {
              max = 360 / (cooldown_modifier + 1),
              min = 150 / (cooldown_modifier + 1)
            }
          },
          biter_armoured = {
            max_count_of_owned_units = vanilla and Armoured_Biters_Constants.nauvis.biter_armoured.MAX_COUNT_OF_OWNED_UNITS or (Armoured_Biters_Constants.nauvis.biter_armoured.MAX_COUNT_OF_OWNED_UNITS * modifier) + 1,
            max_count_of_owned_defensive_units = vanilla and Armoured_Biters_Constants.nauvis.biter_armoured.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS or (Armoured_Biters_Constants.nauvis.biter_armoured.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS * modifier) + 1,
            max_friends_around_to_spawn = vanilla and Armoured_Biters_Constants.nauvis.biter_armoured.MAX_FRIENDS_AROUND_TO_SPAWN or (Constants.nauvis.biter_armoured.MAX_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
            max_defensive_friends_around_to_spawn = vanilla and Armoured_Biters_Constants.nauvis.biter_armoured.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN or (Armoured_Biters_Constants.nauvis.biter_armoured.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
            spawning_cooldown = {
              max = 360 / (cooldown_modifier + 1),
              min = 150 / (cooldown_modifier + 1)
            },
          }
        }
      else
        difficulty = {
          valid = true,
          selected_difficulty = selected_difficulty,
          biter = {
            max_count_of_owned_units = vanilla and Nauvis_Constants.nauvis.biter.MAX_COUNT_OF_OWNED_UNITS or (Nauvis_Constants.nauvis.biter.MAX_COUNT_OF_OWNED_UNITS * modifier) + 1,
            max_count_of_owned_defensive_units = vanilla and Nauvis_Constants.nauvis.biter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS or (Nauvis_Constants.nauvis.biter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS * modifier) + 1,
            max_friends_around_to_spawn = vanilla and Nauvis_Constants.nauvis.biter.MAX_FRIENDS_AROUND_TO_SPAWN or (Nauvis_Constants.nauvis.biter.MAX_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
            max_defensive_friends_around_to_spawn = vanilla and Nauvis_Constants.nauvis.biter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN or (Nauvis_Constants.nauvis.biter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
            spawning_cooldown = {
              max = 360 / (cooldown_modifier + 1),
              min = 150 / (cooldown_modifier + 1)
            },
          },
          spitter = {
            max_count_of_owned_units = vanilla and Nauvis_Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_UNITS or (Nauvis_Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_UNITS * modifier) + 1,
            max_count_of_owned_defensive_units = vanilla and Nauvis_Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS or (Nauvis_Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS * modifier) + 1,
            max_friends_around_to_spawn = vanilla and Nauvis_Constants.nauvis.spitter.MAX_FRIENDS_AROUND_TO_SPAWN or (Nauvis_Constants.nauvis.spitter.MAX_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
            max_defensive_friends_around_to_spawn = vanilla and Nauvis_Constants.nauvis.spitter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN or (Nauvis_Constants.nauvis.spitter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
            spawning_cooldown = {
              max = 360 / (cooldown_modifier + 1),
              min = 150 / (cooldown_modifier + 1)
            }
          }
        }
      end

    elseif (planet == Constants.DEFAULTS.planets.gleba.string_val) then
      difficulty = {
        valid = true,
        selected_difficulty = selected_difficulty,
        small = {
          max_count_of_owned_units = vanilla and Gleba_Constants.gleba.small.MAX_COUNT_OF_OWNED_UNITS or (Gleba_Constants.gleba.small.MAX_COUNT_OF_OWNED_UNITS * modifier) + 1,
          max_count_of_owned_defensive_units = vanilla and Gleba_Constants.gleba.small.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS or (Gleba_Constants.gleba.small.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS * modifier) + 1,
          max_friends_around_to_spawn = vanilla and Gleba_Constants.gleba.small.MAX_FRIENDS_AROUND_TO_SPAWN or (Gleba_Constants.gleba.small.MAX_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
          max_defensive_friends_around_to_spawn = vanilla and Gleba_Constants.gleba.small.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN or (Gleba_Constants.gleba.small.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
          spawning_cooldown = {
            max = 360 / (cooldown_modifier + 1),
            min = 150 / (cooldown_modifier + 1)
          },
        },
        regular = {
          max_count_of_owned_units = vanilla and Gleba_Constants.gleba.regular.MAX_COUNT_OF_OWNED_UNITS or (Gleba_Constants.gleba.regular.MAX_COUNT_OF_OWNED_UNITS * modifier) + 1,
          max_count_of_owned_defensive_units = vanilla and Gleba_Constants.gleba.regular.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS or (Gleba_Constants.gleba.regular.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS * modifier) + 1,
          max_friends_around_to_spawn = vanilla and Gleba_Constants.gleba.regular.MAX_FRIENDS_AROUND_TO_SPAWN or (Gleba_Constants.gleba.regular.MAX_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
          max_defensive_friends_around_to_spawn = vanilla and Gleba_Constants.gleba.regular.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN or (Gleba_Constants.gleba.regular.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN * modifier) + 1,
          spawning_cooldown = {
            max = 360 / (cooldown_modifier + 1),
            min = 150 / (cooldown_modifier + 1)
          }
        }
      }
    end
  elseif (not selected_difficulty) then
    Log.error("selected difficulty is nil")
    Log.error("defaulting to vanilla")
    difficulty.selected_difficulty = Constants.difficulty.VANILLA
  elseif (not selected_difficulty.valid) then
    Log.warn("selected_difficulty is not valid")
    -- If (attempt fixes)
    Log.error("defaulting to vanilla")
    difficulty.selected_difficulty = Constants.difficulty.VANILLA
  end

  Log.info("returning difficulty: " .. serpent.block(difficulty))
  return difficulty
end

difficulty_utils.more_enemies = true

_difficulty_utils = difficulty_utils
return difficulty_utils