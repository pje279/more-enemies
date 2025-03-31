local Armoured_Biters_Constants = require("libs.constants.mods.armoured-biters-constants")
local Constants = require("libs.constants.constants")
local Gleba_Constants = require("libs.constants.gleba-constants")
local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Behemoth_Enemies_Constants = require("libs.constants.mods.behemoth-enemies-constants")
local Nauvis_Constants = require("libs.constants.nauvis-constants")
local Difficulty_Utils = require("control.utils.difficulty-utils")
local Log = require("libs.log.log")

local difficulties = {}

for k, planet in pairs(Constants.DEFAULTS.planets) do
  if (planet) then
    difficulties[planet.string_val] = Difficulty_Utils.get_difficulty(planet.string_val, true)
  end
end

local modifier = 1
local radius_modifier = 1
local vanilla = false

for planet, difficulty in pairs(difficulties) do

  if (not planet or not difficulty or not difficulty.valid) then goto continue end

  if ( difficulty.selected_difficulty.string_val == Constants.difficulty.EASY.string_val
      or difficulty.selected_difficulty.value == Constants.difficulty.EASY.value)
  then
    modifier = Constants.difficulty.EASY.value
    -- radius_modifier = 0.5 --      15
    radius_modifier = Constants.difficulty.EASY.radius_modifier
  elseif (difficulty.selected_difficulty.string_val == Constants.difficulty.VANILLA.string_val
      or difficulty.selected_difficulty.value == Constants.difficulty.VANILLA.value)
  then
    modifier = Constants.difficulty.VANILLA.value
    -- radius_modifier = 1 --        30
    radius_modifier = Constants.difficulty.VANILLA.radius_modifier
    vanilla = true
  elseif (difficulty.selected_difficulty.string_val == Constants.difficulty.VANILLA_PLUS.string_val
      or difficulty.selected_difficulty.value == Constants.difficulty.VANILLA_PLUS.value)
  then
    modifier = Constants.difficulty.VANILLA_PLUS.value
    -- radius_modifier = 1.25 --     37.5
    radius_modifier = Constants.difficulty.VANILLA_PLUS.radius_modifier
  elseif (difficulty.selected_difficulty.string_val == Constants.difficulty.HARD.string_val
      or difficulty.selected_difficulty.value == Constants.difficulty.HARD.value)
  then
    modifier = Constants.difficulty.HARD.value
    -- radius_modifier = 1.5625 --   46.875
    radius_modifier = Constants.difficulty.HARD.radius_modifier
  elseif (difficulty.selected_difficulty.string_val == Constants.difficulty.INSANITY.string_val
      or difficulty.selected_difficulty.value == Constants.difficulty.INSANITY.value)
  then
    modifier = Constants.difficulty.INSANITY.value
    -- radius_modifier = 1.953125 -- 58.59375
    radius_modifier = Constants.difficulty.INSANITY.radius_modifier
  else
    Log.debug("more-enemies: map-settings -> difficulty = ")
    Log.info(difficulty)
    Log.warn("No difficulty detected ")
    modifier = -1
  end

  local max_unit_group_size = Constants.DEFAULTS.unit_group.max_unit_group_size
  if (settings and settings.startup and settings.startup[Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_STARTUP.name]) then
    max_unit_group_size = settings.startup[Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_STARTUP.name].value
  end

  if (not vanilla and modifier >= 0 and radius_modifier >= 0) then
    data.raw["map-settings"]["map-settings"].max_group_radius = Constants.DEFAULTS.unit_group.max_group_radius * radius_modifier
    -- data.raw["map-settings"]["map-settings"].min_group_radius = unit_group.min_group_radius / radius_modifier
    -- data.raw["map-settings"]["map-settings"].unit_group.max_unit_group_size = Constants.DEFAULTS.unit_group.max_unit_group_size * modifier
    data.raw["map-settings"]["map-settings"].unit_group.max_unit_group_size = max_unit_group_size * modifier

    if (planet == "nauvis") then
      for k,v in pairs(Nauvis_Constants.nauvis.categories) do
        data.raw["unit"][v .. "-biter"].absorptions_to_join_attack.pollution = data.raw["unit"][v .. "-biter"].absorptions_to_join_attack.pollution / modifier
        data.raw["unit"][v .. "-spitter"].absorptions_to_join_attack.pollution = data.raw["unit"][v .. "-spitter"].absorptions_to_join_attack.pollution / modifier
      end

      if (mods and mods["ArmouredBiters"]) then
        for k,v in pairs(Armoured_Biters_Constants.nauvis.categories) do
          data.raw["unit"][v .. "-armoured-biter"].absorptions_to_join_attack.pollution = data.raw["unit"][v .. "-armoured-biter"].absorptions_to_join_attack.pollution / modifier
        end
      end
    end

    if (planet == "gleba" and mods and mods["space-age"]) then
      for k,v in pairs(Gleba_Constants.gleba.categories) do
        data.raw["unit"][v .. "-wriggler-pentapod"].absorptions_to_join_attack.spores = data.raw["unit"][v .. "-wriggler-pentapod"].absorptions_to_join_attack.spores / modifier
        data.raw["spider-unit"][v .. "-strafer-pentapod"].absorptions_to_join_attack.spores = data.raw["spider-unit"][v .. "-strafer-pentapod"].absorptions_to_join_attack.spores / modifier
        data.raw["spider-unit"][v .. "-stomper-pentapod"].absorptions_to_join_attack.spores = data.raw["spider-unit"][v .. "-stomper-pentapod"].absorptions_to_join_attack.spores / modifier
      end
    end
  end
  ::continue::
end

if (modifier >= 0 and mods and mods["space-age"] and mods["behemoth-enemies"]) then
  data.raw["unit"][Behemoth_Enemies_Constants.prefix .. "-wriggler-pentapod"].absorptions_to_join_attack.spores = data.raw["unit"][Behemoth_Enemies_Constants.prefix .. "-wriggler-pentapod"].absorptions_to_join_attack.spores / modifier
  data.raw["spider-unit"][Behemoth_Enemies_Constants.prefix .. "-strafer-pentapod"].absorptions_to_join_attack.spores = data.raw["spider-unit"][Behemoth_Enemies_Constants.prefix .. "-strafer-pentapod"].absorptions_to_join_attack.spores / modifier
  data.raw["spider-unit"][Behemoth_Enemies_Constants.prefix .. "-stomper-pentapod"].absorptions_to_join_attack.spores = data.raw["spider-unit"][Behemoth_Enemies_Constants.prefix .. "-stomper-pentapod"].absorptions_to_join_attack.spores / modifier
end