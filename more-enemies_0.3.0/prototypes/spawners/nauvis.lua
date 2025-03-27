local Constants = require("libs.constants.constants")
local Validations = require("libs.validations")
local Difficulty_Utils = require("control.utils.difficulty-utils")

local nauvis_difficulty = settings.startup["more-enemies-nauvis-difficulty"]
local difficulty = Difficulty_Utils.get_difficulty("nauvis", true)
if (nauvis_difficulty and nauvis_difficulty.value) then
  difficulty = Difficulty_Utils.set_difficulty("nauvis", nauvis_difficulty.value)
end

--
-- Biters

local max_count_of_owned_units_biter = settings.startup["more-enemies-spawner-nauvis-max-count-of-owned-units-biter"]
if (Validations.validate_setting_not_equal_to(max_count_of_owned_units_biter, Constants.nauvis.biter.MAX_COUNT_OF_OWNED_UNITS)) then
  data.raw["unit-spawner"]["biter-spawner"].max_count_of_owned_units = max_count_of_owned_units_biter.value
elseif (difficulty.valid) then
  data.raw["unit-spawner"]["biter-spawner"].max_count_of_owned_units = difficulty.biter.max_count_of_owned_units
end

local max_count_of_owned_defensive_units_biter = settings.startup["more-enemies-spawner-nauvis-max-count-of-owned-defensive-units-biter"]
if (Validations.validate_setting_not_equal_to(max_count_of_owned_defensive_units_biter, Constants.nauvis.biter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS)) then
  data.raw["unit-spawner"]["biter-spawner"].max_count_of_owned_defensive_units = max_count_of_owned_defensive_units_biter.value
elseif (difficulty.valid) then
  data.raw["unit-spawner"]["biter-spawner"].max_count_of_owned_defensive_units = difficulty.biter.max_count_of_owned_defensive_units
end

local max_friends_around_to_spawn_biter = settings.startup["more-enemies-spawner-nauvis-max-friends-around-to-spawn-biter"]
if (Validations.validate_setting_not_equal_to(max_friends_around_to_spawn_biter, Constants.nauvis.biter.MAX_FRIENDS_AROUND_TO_SPAWN)) then
  data.raw["unit-spawner"]["biter-spawner"].max_friends_around_to_spawn = max_friends_around_to_spawn_biter.value
elseif (difficulty.valid) then
  data.raw["unit-spawner"]["biter-spawner"].max_friends_around_to_spawn = difficulty.biter.max_friends_around_to_spawn
end

local max_defensive_friends_around_to_spawn_biter = settings.startup["more-enemies-spawner-nauvis-max-defensive-friends-around-to-spawn-biter"]
if (Validations.validate_setting_not_equal_to(max_defensive_friends_around_to_spawn_biter, Constants.nauvis.biter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN)) then
  data.raw["unit-spawner"]["biter-spawner"].max_defensive_friends_around_to_spawn = max_defensive_friends_around_to_spawn_biter.value
elseif (difficulty.valid) then
  data.raw["unit-spawner"]["biter-spawner"].max_defensive_friends_around_to_spawn = difficulty.biter.max_defensive_friends_around_to_spawn
end

-- Spawning cooldown parameters
local max_spawning_cooldown_biters = settings.startup["more-enemies-max-spawning-cooldown-biter"]
local min_spawning_cooldown_biters = settings.startup["more-enemies-min-spawning-cooldown-biter"]
if (Validations.validate_setting_not_equal_to(max_spawning_cooldown_biters, Constants.nauvis.biter.MAX_SPAWNING_COOLDOWN)
    and Validations.validate_setting_not_equal_to(min_spawning_cooldown_biters, Constants.nauvis.biter.MIN_SPAWNING_COOLDOWN)) then
  data.raw["unit-spawner"]["biter-spawner"].spawning_cooldown = {
      max_spawning_cooldown_biters.value,
      min_spawning_cooldown_biters.value
    }
elseif (difficulty.valid) then
  data.raw["unit-spawner"]["biter-spawner"].spawning_cooldown = {
      difficulty.biter.spawning_cooldown.max,
      difficulty.biter.spawning_cooldown.min
    }
end

--
-- Spitters

local max_count_of_owned_units_spitter = settings.startup["more-enemies-spawner-nauvis-max-count-of-owned-units-spitter"]
if (Validations.validate_setting_not_equal_to(max_count_of_owned_units_spitter, Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_UNITS)) then
  data.raw["unit-spawner"]["spitter-spawner"].max_count_of_owned_units = max_count_of_owned_units_spitter.value
elseif (difficulty.valid) then
  data.raw["unit-spawner"]["spitter-spawner"].max_count_of_owned_units = difficulty.spitter.max_count_of_owned_units
end

local max_count_of_owned_defensive_units_spitter = settings.startup["more-enemies-spawner-nauvis-max-count-of-owned-defensive-units-spitter"]
if (Validations.validate_setting_not_equal_to(max_count_of_owned_defensive_units_spitter, Constants.nauvis.spitter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS)) then
  data.raw["unit-spawner"]["spitter-spawner"].max_count_of_owned_defensive_units = max_count_of_owned_defensive_units_spitter.value
elseif (difficulty.valid) then
  data.raw["unit-spawner"]["spitter-spawner"].max_count_of_owned_defensive_units = difficulty.spitter.max_count_of_owned_defensive_units
end

local max_friends_around_to_spawn_spitter = settings.startup["more-enemies-spawner-nauvis-max-friends-around-to-spawn-spitter"]
if (Validations.validate_setting_not_equal_to(max_friends_around_to_spawn_spitter, Constants.nauvis.spitter.MAX_FRIENDS_AROUND_TO_SPAWN)) then
  data.raw["unit-spawner"]["spitter-spawner"].max_friends_around_to_spawn = max_friends_around_to_spawn_spitter.value
elseif (difficulty.valid) then
  data.raw["unit-spawner"]["spitter-spawner"].max_friends_around_to_spawn = difficulty.spitter.max_friends_around_to_spawn
end

local max_defensive_friends_around_to_spawn_spitter = settings.startup["more-enemies-spawner-nauvis-max-defensive-friends-around-to-spawn-spitter"]
if (Validations.validate_setting_not_equal_to(max_defensive_friends_around_to_spawn_spitter, Constants.nauvis.spitter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN)) then
  data.raw["unit-spawner"]["spitter-spawner"].max_defensive_friends_around_to_spawn = max_defensive_friends_around_to_spawn_spitter.value
elseif (difficulty.valid) then
  data.raw["unit-spawner"]["spitter-spawner"].max_defensive_friends_around_to_spawn = difficulty.spitter.max_defensive_friends_around_to_spawn
end

-- Spawning cooldown parameters
local max_spawning_cooldown_spitters = settings.startup["more-enemies-max-spawning-cooldown-spitter"]
local min_spawning_cooldown_spitters = settings.startup["more-enemies-min-spawning-cooldown-spitter"]
if (Validations.validate_setting_not_equal_to(max_spawning_cooldown_spitters, Constants.nauvis.spitter.MAX_SPAWNING_COOLDOWN)
    and Validations.validate_setting_not_equal_to(min_spawning_cooldown_spitters, Constants.nauvis.spitter.MIN_SPAWNING_COOLDOWN)) then
  data.raw["unit-spawner"]["spitter-spawner"].spawning_cooldown = {
      min_spawning_cooldown_spitters.value,
      min_spawning_cooldown_spitters.value
    }
elseif (difficulty.valid) then
  data.raw["unit-spawner"]["spitter-spawner"].spawning_cooldown = {
      difficulty.spitter.spawning_cooldown.max,
      difficulty.spitter.spawning_cooldown.min
    }
end