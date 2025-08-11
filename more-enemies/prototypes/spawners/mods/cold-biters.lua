local Cold_Biters_Constants = require("libs.constants.mods.cold-biters-constants")
local Cold_Biters_Settings_Constants = require("libs.constants.settings.mods.cold-biters-settings-constants")
local Settings_Validations = require("scripts.validations.settings-validations")
local Difficulty_Utils = require("scripts.utils.difficulty-utils")

local difficulty = Difficulty_Utils.get_difficulty("nauvis", true)

local unit_spawner = "unit-spawner"
local spawner_name = "cb-cold-spawner"

if (data and data.raw and data.raw[unit_spawner] and data.raw[unit_spawner][spawner_name]) then
    local spawner = data.raw[unit_spawner][spawner_name]

    local max_count_of_owned_units_biter = settings.startup[Cold_Biters_Settings_Constants.settings.EXPLOSIVE_BITER_MAX_COUNT_OF_OWNED_UNITS]
    if (Settings_Validations.validate_setting_not_equal_to(max_count_of_owned_units_biter, Cold_Biters_Constants.nauvis.biter_cold.MAX_COUNT_OF_OWNED_UNITS)) then
        spawner.max_count_of_owned_units = max_count_of_owned_units_biter.value
    elseif (difficulty.valid) then
        log(serpent.block(difficulty))
        spawner.max_count_of_owned_units = difficulty.biter_cold.max_count_of_owned_units
    end

    local max_count_of_owned_defensive_units_biter = settings.startup[Cold_Biters_Settings_Constants.settings.EXPLOSIVE_BITER_MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS]
    if (Settings_Validations.validate_setting_not_equal_to(max_count_of_owned_defensive_units_biter, Cold_Biters_Constants.nauvis.biter_cold.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS)) then
        spawner.max_count_of_owned_defensive_units = max_count_of_owned_defensive_units_biter.value
    elseif (difficulty.valid) then
        spawner.max_count_of_owned_defensive_units = difficulty.biter_cold.max_count_of_owned_defensive_units
    end

    local max_friends_around_to_spawn_biter = settings.startup[Cold_Biters_Settings_Constants.settings.EXPLOSIVE_BITER_MAX_FRIENDS_AROUND_TO_SPAWN]
    if (Settings_Validations.validate_setting_not_equal_to(max_friends_around_to_spawn_biter, Cold_Biters_Constants.nauvis.biter_cold.MAX_FRIENDS_AROUND_TO_SPAWN)) then
        spawner.max_friends_around_to_spawn = max_friends_around_to_spawn_biter.value
    elseif (difficulty.valid) then
        spawner.max_friends_around_to_spawn = difficulty.biter_cold.max_friends_around_to_spawn
    end

    local max_defensive_friends_around_to_spawn_biter = settings.startup[Cold_Biters_Settings_Constants.settings.EXPLOSIVE_BITER_MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN]
    if (Settings_Validations.validate_setting_not_equal_to(max_defensive_friends_around_to_spawn_biter, Cold_Biters_Constants.nauvis.biter_cold.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN)) then
        spawner.max_defensive_friends_around_to_spawn = max_defensive_friends_around_to_spawn_biter.value
    elseif (difficulty.valid) then
        spawner.max_defensive_friends_around_to_spawn = difficulty.biter_cold.max_defensive_friends_around_to_spawn
    end

    -- Spawning cooldown parameters
    local max_spawning_cooldown_biters = settings.startup[Cold_Biters_Settings_Constants.settings.EXPLOSIVE_BITER_MAX_SPAWNING_COOLDOWN]
    local min_spawning_cooldown_biters = settings.startup[Cold_Biters_Settings_Constants.settings.EXPLOSIVE_BITER_MIN_SPAWNING_COOLDOWN]
    if (Settings_Validations.validate_setting_not_equal_to(max_spawning_cooldown_biters, Cold_Biters_Constants.nauvis.biter_cold.MAX_SPAWNING_COOLDOWN)
            and Settings_Validations.validate_setting_not_equal_to(min_spawning_cooldown_biters, Cold_Biters_Constants.nauvis.biter_cold.MIN_SPAWNING_COOLDOWN)) then
        spawner.spawning_cooldown = {
            max_spawning_cooldown_biters.value,
            min_spawning_cooldown_biters.value
        }
    elseif (difficulty.valid) then
        spawner.spawning_cooldown = {
            difficulty.biter_cold.spawning_cooldown.max,
            difficulty.biter_cold.spawning_cooldown.min
        }
    end
end