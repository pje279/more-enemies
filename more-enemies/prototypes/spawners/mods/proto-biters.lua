local Difficulty_Utils = require("scripts.utils.difficulty-utils")
local Proto_Biters_Constants = require("libs.constants.mods.proto-biters-constants")
local Proto_Biters_Settings_Constants = require("libs.constants.settings.mods.proto-biters-settings-constants")
local Settings_Validations = require("scripts.validations.settings-validations")

local difficulty = Difficulty_Utils.get_difficulty("nauvis", true)

local unit_spawner = "unit-spawner"

--
-- Biters

local spawner_name = "old-biter-spawner"

if (data and data.raw and data.raw[unit_spawner] and data.raw[unit_spawner][spawner_name]) then
    local spawner = data.raw[unit_spawner][spawner_name]

    local max_count_of_owned_units_biter = settings.startup[Proto_Biters_Settings_Constants.settings.OLD_BITER_MAX_COUNT_OF_OWNED_UNITS]
    if (Settings_Validations.validate_setting_not_equal_to(max_count_of_owned_units_biter, Proto_Biters_Constants.nauvis.biter_old.MAX_COUNT_OF_OWNED_UNITS)) then
        spawner.max_count_of_owned_units = max_count_of_owned_units_biter.value
    elseif (difficulty.valid) then
        spawner.max_count_of_owned_units = difficulty.biter_old.max_count_of_owned_units
    end

    local max_count_of_owned_defensive_units_biter = settings.startup[Proto_Biters_Settings_Constants.settings.OLD_BITER_MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS]
    if (Settings_Validations.validate_setting_not_equal_to(max_count_of_owned_defensive_units_biter, Proto_Biters_Constants.nauvis.biter_old.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS)) then
        spawner.max_count_of_owned_defensive_units = max_count_of_owned_defensive_units_biter.value
    elseif (difficulty.valid) then
        spawner.max_count_of_owned_defensive_units = difficulty.biter_old.max_count_of_owned_defensive_units
    end

    local max_friends_around_to_spawn_biter = settings.startup[Proto_Biters_Settings_Constants.settings.OLD_BITER_MAX_FRIENDS_AROUND_TO_SPAWN]
    if (Settings_Validations.validate_setting_not_equal_to(max_friends_around_to_spawn_biter, Proto_Biters_Constants.nauvis.biter_old.MAX_FRIENDS_AROUND_TO_SPAWN)) then
        spawner.max_friends_around_to_spawn = max_friends_around_to_spawn_biter.value
    elseif (difficulty.valid) then
        spawner.max_friends_around_to_spawn = difficulty.biter_old.max_friends_around_to_spawn
    end

    local max_defensive_friends_around_to_spawn_biter = settings.startup[Proto_Biters_Settings_Constants.settings.OLD_BITER_MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN]
    if (Settings_Validations.validate_setting_not_equal_to(max_defensive_friends_around_to_spawn_biter, Proto_Biters_Constants.nauvis.biter_old.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN)) then
        spawner.max_defensive_friends_around_to_spawn = max_defensive_friends_around_to_spawn_biter.value
    elseif (difficulty.valid) then
        spawner.max_defensive_friends_around_to_spawn = difficulty.biter_old.max_defensive_friends_around_to_spawn
    end

    -- Spawning cooldown parameters
    local max_spawning_cooldown_biters = settings.startup[Proto_Biters_Settings_Constants.settings.OLD_BITER_MAX_SPAWNING_COOLDOWN]
    local min_spawning_cooldown_biters = settings.startup[Proto_Biters_Settings_Constants.settings.OLD_BITER_MIN_SPAWNING_COOLDOWN]
    if (    Settings_Validations.validate_setting_not_equal_to(max_spawning_cooldown_biters, Proto_Biters_Constants.nauvis.biter_old.MAX_SPAWNING_COOLDOWN)
        and Settings_Validations.validate_setting_not_equal_to(min_spawning_cooldown_biters, Proto_Biters_Constants.nauvis.biter_old.MIN_SPAWNING_COOLDOWN))
    then
        spawner.spawning_cooldown = {
            max_spawning_cooldown_biters.value,
            min_spawning_cooldown_biters.value
        }
    elseif (difficulty.valid) then
        spawner.spawning_cooldown = {
            difficulty.biter_old.spawning_cooldown.max,
            difficulty.biter_old.spawning_cooldown.min
        }
    end
end

--
-- Spitters

spawner_name = "old-spitter-spawner"

if (data and data.raw and data.raw[unit_spawner] and data.raw[unit_spawner][spawner_name]) then
    local spawner = data.raw[unit_spawner][spawner_name]

    local max_count_of_owned_units_spitter = settings.startup[Proto_Biters_Settings_Constants.settings.OLD_SPITTER_MAX_COUNT_OF_OWNED_UNITS]
    if (Settings_Validations.validate_setting_not_equal_to(max_count_of_owned_units_spitter, Proto_Biters_Constants.nauvis.spitter_old.MAX_COUNT_OF_OWNED_UNITS)) then
        spawner.max_count_of_owned_units = max_count_of_owned_units_spitter.value
    elseif (difficulty.valid) then
        spawner.max_count_of_owned_units = difficulty.spitter_old.max_count_of_owned_units
    end

    local max_count_of_owned_defensive_units_spitter = settings.startup[Proto_Biters_Settings_Constants.settings.OLD_SPITTER_MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS]
    if (Settings_Validations.validate_setting_not_equal_to(max_count_of_owned_defensive_units_spitter, Proto_Biters_Constants.nauvis.spitter_old.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS)) then
        spawner.max_count_of_owned_defensive_units = max_count_of_owned_defensive_units_spitter.value
    elseif (difficulty.valid) then
        spawner.max_count_of_owned_defensive_units = difficulty.spitter_old.max_count_of_owned_defensive_units
    end

    local max_friends_around_to_spawn_spitter = settings.startup[Proto_Biters_Settings_Constants.settings.OLD_SPITTER_MAX_FRIENDS_AROUND_TO_SPAWN]
    if (Settings_Validations.validate_setting_not_equal_to(max_friends_around_to_spawn_spitter, Proto_Biters_Constants.nauvis.spitter_old.MAX_FRIENDS_AROUND_TO_SPAWN)) then
        spawner.max_friends_around_to_spawn = max_friends_around_to_spawn_spitter.value
    elseif (difficulty.valid) then
        spawner.max_friends_around_to_spawn = difficulty.spitter_old.max_friends_around_to_spawn
    end

    local max_defensive_friends_around_to_spawn_spitter = settings.startup[Proto_Biters_Settings_Constants.settings.OLD_SPITTER_MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN]
    if (Settings_Validations.validate_setting_not_equal_to(max_defensive_friends_around_to_spawn_spitter, Proto_Biters_Constants.nauvis.spitter_old.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN)) then
        spawner.max_defensive_friends_around_to_spawn = max_defensive_friends_around_to_spawn_spitter.value
    elseif (difficulty.valid) then
        spawner.max_defensive_friends_around_to_spawn = difficulty.spitter_old.max_defensive_friends_around_to_spawn
    end

    -- Spawning cooldown parameters
    local max_spawning_cooldown_spitters = settings.startup[Proto_Biters_Settings_Constants.settings.OLD_SPITTER_MAX_SPAWNING_COOLDOWN]
    local min_spawning_cooldown_spitters = settings.startup[Proto_Biters_Settings_Constants.settings.OLD_SPITTER_MIN_SPAWNING_COOLDOWN]
    if (    Settings_Validations.validate_setting_not_equal_to(max_spawning_cooldown_spitters, Proto_Biters_Constants.nauvis.spitter_old.MAX_SPAWNING_COOLDOWN)
        and Settings_Validations.validate_setting_not_equal_to(min_spawning_cooldown_spitters, Proto_Biters_Constants.nauvis.spitter_old.MIN_SPAWNING_COOLDOWN))
    then
        spawner.spawning_cooldown = {
            min_spawning_cooldown_spitters.value,
            min_spawning_cooldown_spitters.value
        }
    elseif (difficulty.valid) then
        spawner.spawning_cooldown = {
            difficulty.spitter_old.spawning_cooldown.max,
            difficulty.spitter_old.spawning_cooldown.min
        }
    end
end