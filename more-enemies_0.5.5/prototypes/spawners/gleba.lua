
local Gleba_Constants = require("libs.constants.gleba-constants")
local Difficulty_Utils = require("control.utils.difficulty-utils")
local Settings_Validations = require("control.validations.settings-validations")

local gleba_difficulty = settings.startup["more-enemies-gleba-difficulty"]
local difficulty = Difficulty_Utils.get_difficulty("gleba", true)

local unit_spawner = "unit-spawner"

--
-- Small spawners

local spawner_name = "gleba-spawner-small"

if (data and data.raw and data.raw[unit_spawner] and data.raw[unit_spawner][spawner_name]) then
  local spawner = data.raw[unit_spawner][spawner_name]

  local max_count_of_owned_units_small = settings.startup["more-enemies-spawner-gleba-small-max-count-of-owned-units"]
  if (Settings_Validations.validate_setting_not_equal_to(max_count_of_owned_units_small, Gleba_Constants.gleba.small.MAX_COUNT_OF_OWNED_UNITS)) then
    spawner.max_count_of_owned_units = max_count_of_owned_units_small.value
  elseif (difficulty.valid) then
    spawner.max_count_of_owned_units = difficulty.small.max_count_of_owned_units
  end

  local max_count_of_owned_defensive_units_small = settings.startup["more-enemies-spawner-gleba-small-max-count-of-owned-defensive-units"]
  if (Settings_Validations.validate_setting_not_equal_to(max_count_of_owned_defensive_units_small, Gleba_Constants.gleba.small.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS)) then
    spawner.max_count_of_owned_defensive_units = max_count_of_owned_defensive_units_small.value
  elseif (difficulty.valid) then
    spawner.max_count_of_owned_defensive_units = difficulty.small.max_count_of_owned_defensive_units
  end

  local max_friends_around_to_spawn_small = settings.startup["more-enemies-spawner-gleba-small-max-friends-around-to-spawn"]
  if (Settings_Validations.validate_setting_not_equal_to(max_friends_around_to_spawn_small, Gleba_Constants.gleba.small.MAX_FRIENDS_AROUND_TO_SPAWN)) then
    spawner.max_friends_around_to_spawn = max_friends_around_to_spawn_small.value
  elseif (difficulty.valid) then
    spawner.max_friends_around_to_spawn = difficulty.small.max_friends_around_to_spawn
  end

  local max_defensive_friends_around_to_spawn_small = settings.startup["more-enemies-spawner-gleba-small-max-defensive-friends-around-to-spawn"]
  if (Settings_Validations.validate_setting_not_equal_to(max_defensive_friends_around_to_spawn_small, Gleba_Constants.gleba.small.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN)) then
    spawner.max_defensive_friends_around_to_spawn = max_defensive_friends_around_to_spawn_small.value
  elseif (difficulty.valid) then
    spawner.max_defensive_friends_around_to_spawn = difficulty.small.max_defensive_friends_around_to_spawn
  end

  -- spawner_cooldown
  local max_spawning_cooldown_gleba_small = settings.startup["more-enemies-max-spawning-cooldown-gleba-small"]
  local min_spawning_cooldown_gleba_small = settings.startup["more-enemies-min-spawning-cooldown-gleba-small"]
  if (Settings_Validations.validate_setting_not_equal_to(max_spawning_cooldown_gleba_small, Gleba_Constants.gleba.regular.MAX_SPAWNING_COOLDOWN)
      and Settings_Validations.validate_setting_not_equal_to(max_spawning_cooldown_gleba_small, Gleba_Constants.gleba.regular.MIN_SPAWNING_COOLDOWN)) then
    spawner.spawning_cooldown = {
      max_spawning_cooldown_gleba_small.value,
      min_spawning_cooldown_gleba_small.value
    }
  elseif (difficulty.valid) then
    spawner.spawning_cooldown = {
        difficulty.small.spawning_cooldown.max,
        difficulty.small.spawning_cooldown.min
      }
  end
end

--
-- Regular spawners

spawner_name = "gleba-spawner"

if (data and data.raw and data.raw[unit_spawner] and data.raw[unit_spawner][spawner_name]) then
  local spawner = data.raw[unit_spawner][spawner_name]

  local max_count_of_owned_units = settings.startup["more-enemies-spawner-gleba-max-count-of-owned-units"]
  if (Settings_Validations.validate_setting_not_equal_to(max_count_of_owned_units, Gleba_Constants.gleba.regular.MAX_COUNT_OF_OWNED_UNITS)) then
    spawner.max_count_of_owned_units = max_count_of_owned_units.value
  elseif (difficulty.valid) then
    spawner.max_count_of_owned_units = difficulty.regular.max_count_of_owned_units
  end

  local max_count_of_owned_defensive_units = settings.startup["more-enemies-spawner-gleba-max-count-of-owned-defensive-units"]
  if (Settings_Validations.validate_setting_not_equal_to(max_count_of_owned_defensive_units, Gleba_Constants.gleba.regular.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS)) then
    spawner.max_count_of_owned_defensive_units = max_count_of_owned_defensive_units.value
  elseif (difficulty.valid) then
    spawner.max_count_of_owned_defensive_units = difficulty.regular.max_count_of_owned_defensive_units
  end

  local max_friends_around_to_spawn = settings.startup["more-enemies-spawner-gleba-max-friends-around-to-spawn"]
  if (Settings_Validations.validate_setting_not_equal_to(max_friends_around_to_spawn, Gleba_Constants.gleba.regular.MAX_FRIENDS_AROUND_TO_SPAWN)) then
    spawner.max_friends_around_to_spawn = max_friends_around_to_spawn.value
  elseif (difficulty.valid) then
    spawner.max_friends_around_to_spawn = difficulty.regular.max_friends_around_to_spawn
  end

  local max_defensive_friends_around_to_spawn = settings.startup["more-enemies-spawner-gleba-max-defensive-friends-around-to-spawn"]
  if (Settings_Validations.validate_setting_not_equal_to(max_defensive_friends_around_to_spawn, Gleba_Constants.gleba.regular.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN)) then
    spawner.max_defensive_friends_around_to_spawn = max_defensive_friends_around_to_spawn.value
  elseif (difficulty.valid) then
    spawner.max_defensive_friends_around_to_spawn = difficulty.regular.max_defensive_friends_around_to_spawn
  end

  -- spawner_cooldown
  local max_spawning_cooldown_gleba = settings.startup["more-enemies-max-spawning-cooldown-gleba"]
  local min_spawning_cooldown_gleba = settings.startup["more-enemies-min-spawning-cooldown-gleba"]
  if (Settings_Validations.validate_setting_not_equal_to(max_spawning_cooldown_gleba, Gleba_Constants.gleba.regular.MAX_SPAWNING_COOLDOWN)
      and Settings_Validations.validate_setting_not_equal_to(min_spawning_cooldown_gleba, Gleba_Constants.gleba.regular.MIN_SPAWNING_COOLDOWN)) then
    spawner.spawning_cooldown = {
      max_spawning_cooldown_gleba.value,
      min_spawning_cooldown_gleba.value
    }
  elseif (difficulty.valid) then
    spawner.spawning_cooldown = {
        difficulty.regular.spawning_cooldown.max,
        difficulty.regular.spawning_cooldown.min
      }
  end
end