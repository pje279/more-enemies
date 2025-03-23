local Constants = require("libs.constants.constants")
local Gleba_Constants = require("libs.constants.gleba-constants")
local Behemoth_Enemies_Constants = require("libs.constants.mods.behemoth-enemies-constants")
local Nauvis_Constants = require("libs.constants.nauvis-constants")
local Difficulty_Utils = require("libs.difficulty-utils")
local Log = require("libs.log.log")

local difficulty = Difficulty_Utils.get_difficulty("nauvis", true)
if (not difficulty or not difficulty.valid) then
  Log.error("nauvis not detected")
  return
end

local modifier = 1
local radius_modifier = 1
local vanilla = false

Log.debug(difficulty.selected_difficulty)

-- Determine difficulty modifier
if ( difficulty.selected_difficulty.name == Constants.difficulty.EASY.name
  or difficulty.selected_difficulty.value == Constants.difficulty.EASY.value)
then
  modifier = Constants.difficulty.EASY.value
  -- radius_modifier = 0.5 --      15
  radius_modifier = Constants.difficulty.EASY.radius_modifier
elseif (difficulty.selected_difficulty.name == Constants.difficulty.VANILLA.name
    or difficulty.selected_difficulty.value == Constants.difficulty.VANILLA.value)
then
  modifier = Constants.difficulty.VANILLA.value
  -- radius_modifier = 1 --        30
  radius_modifier = Constants.difficulty.VANILLA.radius_modifier
  vanilla = true
elseif (difficulty.selected_difficulty.name == Constants.difficulty.VANILLA_PLUS.name
    or difficulty.selected_difficulty.value == Constants.difficulty.VANILLA_PLUS.value)
then
  modifier = Constants.difficulty.VANILLA_PLUS.value
  -- radius_modifier = 1.25 --     37.5
  radius_modifier = Constants.difficulty.VANILLA_PLUS.radius_modifier
elseif (difficulty.selected_difficulty.name == Constants.difficulty.HARD.name
    or difficulty.selected_difficulty.value == Constants.difficulty.HARD.value)
then
  modifier = Constants.difficulty.HARD.value
  -- radius_modifier = 1.5625 --   46.875
  radius_modifier = Constants.difficulty.HARD.radius_modifier
elseif (difficulty.selected_difficulty.name == Constants.difficulty.INSANITY.name
    or difficulty.selected_difficulty.value == Constants.difficulty.INSANITY.value)
then
  modifier = Constants.difficulty.INSANITY.value
  -- radius_modifier = 1.953125 -- 58.59375
  radius_modifier = Constants.difficulty.INSANITY.radius_modifier
else
  Log.debug("more-enemies: map-settings -> difficulty = ")
  Log.debug(difficulty)
  Log.warn("No difficulty detected ")
  modifier = -1
end

Log.error("modifier" .. serpent.block(modifier))
Log.error("radius_modifier" .. serpent.block(radius_modifier))

if (not vanilla and modifier >= 0 and radius_modifier >= 0) then
  data.raw["map-settings"]["map-settings"].max_group_radius = Constants.DEFAULTS.unit_group.max_group_radius * radius_modifier
  -- data.raw["map-settings"]["map-settings"].min_group_radius = unit_group.min_group_radius / radius_modifier
  data.raw["map-settings"]["map-settings"].unit_group.max_unit_group_size = Constants.DEFAULTS.unit_group.max_unit_group_size * modifier

  for k,v in pairs(Nauvis_Constants.nauvis.categories) do
    log(serpent.block(v))
    data.raw["unit"][v .. "-biter"].absorptions_to_join_attack.pollution = data.raw["unit"][v .. "-biter"].absorptions_to_join_attack.pollution / modifier
    data.raw["unit"][v .. "-spitter"].absorptions_to_join_attack.pollution = data.raw["unit"][v .. "-spitter"].absorptions_to_join_attack.pollution / modifier
  end

  if (mods and mods["space-age"]) then

    if (mods and mods["behemoth-enemies"]) then
      for k,v in pairs(Behemoth_Enemies_Constants.gleba.categories) do
        log(serpent.block(v))
        data.raw["unit"][v .. "-wriggler-pentapod"].absorptions_to_join_attack.spores = data.raw["unit"][v .. "-wriggler-pentapod"].absorptions_to_join_attack.spores / modifier
        data.raw["spider-unit"][v .. "-strafer-pentapod"].absorptions_to_join_attack.spores = data.raw["spider-unit"][v .. "-strafer-pentapod"].absorptions_to_join_attack.spores / modifier
        data.raw["spider-unit"][v .. "-stomper-pentapod"].absorptions_to_join_attack.spores = data.raw["spider-unit"][v .. "-stomper-pentapod"].absorptions_to_join_attack.spores / modifier
      end
    else
      for k,v in pairs(Gleba_Constants.gleba.categories) do
        log(serpent.block(v))
        data.raw["unit"][v .. "-wriggler-pentapod"].absorptions_to_join_attack.spores = data.raw["unit"][v .. "-wriggler-pentapod"].absorptions_to_join_attack.spores / modifier
        data.raw["spider-unit"][v .. "-strafer-pentapod"].absorptions_to_join_attack.spores = data.raw["spider-unit"][v .. "-strafer-pentapod"].absorptions_to_join_attack.spores / modifier
        data.raw["spider-unit"][v .. "-stomper-pentapod"].absorptions_to_join_attack.spores = data.raw["spider-unit"][v .. "-stomper-pentapod"].absorptions_to_join_attack.spores / modifier
      end
    end
  end
end