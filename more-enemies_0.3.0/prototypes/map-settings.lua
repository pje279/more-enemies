local Constants = require("libs.constants")
local DifficultyUtils = require("libs.difficulty-utils")

-- Settings taken from vanilla
--   -> See base/prototypes/map-settings.lua
local unit_group = {
  max_group_radius = 30.0,
  min_group_radius = 5.0,

  -- Maximum size of an attack unit group. This only affects automatically-created unit groups;
  -- manual groups created through the API are unaffected.
  max_unit_group_size = 200
}

local difficulty = DifficultyUtils.getDifficulty("nauvis")

local modifier = 1
local radius_modifier = 1
local vanilla = false

-- Determine difficulty modifier
if (difficulty.selected_difficulty == Constants.difficulty.EASY) then
  modifier = 0.1 --             Radius
  radius_modifier = 0.5 --      15
elseif (difficulty.selected_difficulty == Constants.difficulty.VANILLA) then
  modifier = 1
  radius_modifier = 1 --        30
  vanilla = true
elseif (difficulty.selected_difficulty == Constants.difficulty.VANILLA_PLUS) then
  modifier = 1.75
  radius_modifier = 1.25 --     37.5
elseif (difficulty.selected_difficulty == Constants.difficulty.HARD) then
  modifer = 4
  radius_modifier = 1.5625 --   46.875
elseif (difficulty.selected_difficulty == Constants.difficulty.INSANITY) then
  modifier = 10
  radius_modifier = 1.953125 -- 58.59375
else
  log("more-enemies: map-settings -> difficulty = ")
  log(serpent.block(difficulty, {comment=false}))
  game.print("No difficulty detected - lolhwutand")
  modifier = -1
end

-- log(serpent.block(modifier, {comment=false}))
-- log(serpent.block(radius_modifier, {comment=false}))

if (modifier >= 0 and radius_modifier >= 0) then
  data.raw["map-settings"]["map-settings"].max_group_radius = unit_group.max_group_radius * radius_modifier
  -- data.raw["map-settings"]["map-settings"].min_group_radius = unit_group.min_group_radius / radius_modifier
  data.raw["map-settings"]["map-settings"].unit_group.max_unit_group_size = unit_group.max_unit_group_size * modifier

  for k,v in pairs(Constants.nauvis.categories) do
    data.raw["unit"][v .. "-biter"].absorptions_to_join_attack.pollution = data.raw["unit"][v .. "-biter"].absorptions_to_join_attack.pollution / modifier
    data.raw["unit"][v .. "-spitter"].absorptions_to_join_attack.pollution = data.raw["unit"][v .. "-spitter"].absorptions_to_join_attack.pollution / modifier
  end

  if (mods["space-age"]) then
    for k,v in pairs(Constants.gleba.categories) do
      data.raw["unit"][v .. "-wriggler-pentapod"].absorptions_to_join_attack.spores = data.raw["unit"][v .. "-wriggler-pentapod"].absorptions_to_join_attack.spores / modifier
      -- log(serpent.block(data.raw["unit"][v .. "-strafer-pentapod"], {comment=false}))
      data.raw["spider-unit"][v .. "-strafer-pentapod"].absorptions_to_join_attack.spores = data.raw["spider-unit"][v .. "-strafer-pentapod"].absorptions_to_join_attack.spores / modifier
      data.raw["spider-unit"][v .. "-stomper-pentapod"].absorptions_to_join_attack.spores = data.raw["spider-unit"][v .. "-stomper-pentapod"].absorptions_to_join_attack.spores / modifier
    end
  end
end