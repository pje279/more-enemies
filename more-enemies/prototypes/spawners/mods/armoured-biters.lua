local Armoured_Biters_Constants = require("libs.constants.mods.armoured-biters-constants")
local Armoured_Biters_Settings_Constants = require("libs.constants.settings.mods.armoured-biters.armoured-biters-settings-constants")
local Settings_Validations = require("scripts.validations.settings-validations")
local Difficulty_Utils = require("scripts.utils.difficulty-utils")

local difficulty = Difficulty_Utils.get_difficulty("nauvis", true)

--
-- Armoured Biters

local unit_spawner = "unit-spawner"
local spawner_name = "armoured-biter-spawner"

local max_count_of_owned_units_biter_armoured = settings.startup[Armoured_Biters_Settings_Constants.settings.NAUVIS_BITER_ARMOURED_MAX_COUNT_OF_OWNED_UNITS.name]
if (data and data.raw and data.raw[unit_spawner] and data.raw[unit_spawner][spawner_name]) then
  if (Settings_Validations.validate_setting_not_equal_to(max_count_of_owned_units_biter_armoured, Armoured_Biters_Constants.nauvis.biter_armoured.MAX_COUNT_OF_OWNED_UNITS)) then
    data.raw[unit_spawner][spawner_name].max_count_of_owned_units = max_count_of_owned_units_biter_armoured.value
  elseif (difficulty.valid) then
      data.raw[unit_spawner][spawner_name].max_count_of_owned_units = difficulty.biter_armoured.max_count_of_owned_units
  end

  local max_count_of_owned_defensive_units_biter_armoured = settings.startup[Armoured_Biters_Settings_Constants.settings.NAUVIS_BITER_ARMOURED_MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS.name]
  if (Settings_Validations.validate_setting_not_equal_to(max_count_of_owned_defensive_units_biter_armoured, Armoured_Biters_Constants.nauvis.biter_armoured.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS)) then
    data.raw[unit_spawner][spawner_name].max_count_of_owned_defensive_units = max_count_of_owned_defensive_units_biter_armoured.value
  elseif (difficulty.valid) then
    data.raw[unit_spawner][spawner_name].max_count_of_owned_defensive_units = difficulty.biter_armoured.max_count_of_owned_defensive_units
  end

  local max_friends_around_to_spawn_biter = settings.startup[Armoured_Biters_Settings_Constants.settings.NAUVIS_BITER_ARMOURED_MAX_FRIENDS_AROUND_TO_SPAWN.name]
  if (Settings_Validations.validate_setting_not_equal_to(max_friends_around_to_spawn_biter, Armoured_Biters_Constants.nauvis.biter_armoured.MAX_FRIENDS_AROUND_TO_SPAWN)) then
    data.raw[unit_spawner][spawner_name].max_friends_around_to_spawn = max_friends_around_to_spawn_biter.value
  elseif (difficulty.valid) then
    data.raw[unit_spawner][spawner_name].max_friends_around_to_spawn = difficulty.biter_armoured.max_friends_around_to_spawn
  end

  local max_defensive_friends_around_to_spawn_biter_armoured = settings.startup[Armoured_Biters_Settings_Constants.settings.NAUVIS_BITER_ARMOURED_MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN.name]
  if (Settings_Validations.validate_setting_not_equal_to(max_defensive_friends_around_to_spawn_biter_armoured, Armoured_Biters_Constants.nauvis.biter_armoured.NAUVIS_BITER_ARMOURED_MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN)) then
    data.raw[unit_spawner][spawner_name].max_defensive_friends_around_to_spawn = max_defensive_friends_around_to_spawn_biter_armoured.value
  elseif (difficulty.valid) then
    data.raw[unit_spawner][spawner_name].max_defensive_friends_around_to_spawn = difficulty.biter_armoured.max_defensive_friends_around_to_spawn
  end

  -- Spawning cooldown parameters
  local max_spawning_cooldown_biter_armoured = settings.startup[Armoured_Biters_Settings_Constants.settings.NAUVIS_ARMOURED_BITER_MAX_SPAWNING_COOLDOWN.name]
  local min_spawning_cooldown_biter_armoured = settings.startup[Armoured_Biters_Settings_Constants.settings.NAUVIS_ARMOURED_BITER_MIN_SPAWNING_COOLDOWN.name]

  if (Settings_Validations.validate_setting_not_equal_to(max_spawning_cooldown_biter_armoured, Armoured_Biters_Constants.nauvis.biter_armoured.MAX_SPAWNING_COOLDOWN)
      and Settings_Validations.validate_setting_not_equal_to(min_spawning_cooldown_biter_armoured, Armoured_Biters_Constants.nauvis.biter_armoured.MIN_SPAWNING_COOLDOWN)) then
    data.raw[unit_spawner][spawner_name].spawning_cooldown = {
        max_spawning_cooldown_biter_armoured.value,
        min_spawning_cooldown_biter_armoured.value
      }
  elseif (difficulty.valid) then
    data.raw[unit_spawner][spawner_name].spawning_cooldown = {
        difficulty.biter_armoured.spawning_cooldown.max,
        difficulty.biter_armoured.spawning_cooldown.min
      }
  end
end