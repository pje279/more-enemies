-- If already defined, return
if _spawn_utils and _spawn_utils.more_enemies then
  return _spawn_utils
end

local Constants = require("libs.constants.constants")
local Behemoth_Enemies_Constants = require("libs.constants.mods.behemoth-enemies-constants")
local Gleba_Constants = require("libs.constants.gleba-constants")
local Gleba_Settings_Constants = require("libs.constants.settings.gleba-settings-constants")
local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Initialization = require("control.initialization")
local Log = require("libs.log.log")
local Nauvis_Constants = require("libs.constants.nauvis-constants")
local Nauvis_Settings_Constants = require("libs.constants.settings.nauvis-settings-constants")
local Difficulty_Utils = require("control.utils.difficulty-utils")
local Settings_Service = require("control.service.settings-service")

local spawn_utils = {}

function spawn_utils.duplicate_unit_group(group, tick)
  Log.info("spawn.duplicate_unit_group" .. serpent.block(tick))

  if (storage) then
    if (not storage.more_enemies or not storage.more_enemies.valid) then Initialization.reinit() end
  end

  if (not storage.more_enemies or not storage.more_enemies.do_nth_tick) then return end
  if (not group or not group.valid or not group.surface) then return end

  Log.debug("duplicate_unit_group: Getting difficulty")
  local difficulty = Difficulty_Utils.get_difficulty(group.surface.name).difficulty
  if (not difficulty or not difficulty.valid) then
    Log.warn("difficulty was nil or invalid; reindexing")
    difficulty = Difficulty_Utils.get_difficulty(group.surface.name, true).difficulty
  end
  if (not difficulty or not difficulty.valid) then
    Log.error("Failed to find a valid difficulty for " .. serpent.block(group.surface.name))
    return
  end

  Log.info(difficulty)
  local selected_difficulty = difficulty.selected_difficulty
  Log.info("selected_difficulty: " .. serpent.block(selected_difficulty))

  -- Check for any user settings changes
  local clone_unit_setting = Settings_Service.get_clone_unit_setting(group.surface.name)
  local clone_unit_group_setting = Settings_Service.get_clone_unit_group_setting(group.surface.name)

  Log.info(clone_unit_setting)
  Log.info(clone_unit_group_setting)
  if (clone_unit_setting == 1 and clone_unit_group_setting == 1 and (selected_difficulty.string_val == "Vanilla" or selected_difficulty.value == 1)) then
    Log.debug("Difficulty is vanilla; no need to process")
    return
  end

  -- Only try to clone if the difficulty is not equal to Vanilla (1), or other unit group settings have changed
  if ((selected_difficulty and selected_difficulty.valid and selected_difficulty.value > 1) or clone_unit_group_setting ~= 1) then

    local modifier = 1 / ((Constants.difficulty.INSANITY.value - selected_difficulty.value) + 1)
    if (modifier < 0) then modifier = 0 end
    if (modifier > 1) then modifier = 1 end

    local len = math.floor(#group.members * (modifier) )

    local clones = {}

    Log.debug("len: " .. serpent.block(len))
    for i=1, len do

      local member = group.members[i]
      if (member and member.valid) then
        Log.info("adding member to staged_clones")
        storage.more_enemies.staged_clones[member.unit_number] = {
          obj = member,
          group = group
        }
      end

      ::continue::
    end
  end
end

function spawn_utils.clone_entity(default_value, difficulty, entity, optionals)
  if (storage) then
    if (not storage.more_enemies or not storage.more_enemies.valid) then Initialization.reinit() end
  end

  if (not storage.more_enemies or not storage.more_enemies.do_nth_tick) then return end

  Log.info(optionals)
  optionals = optionals or {
    clone_settings = {
      unit = 1,
      unit_group = 1
    },
    type = "unit",
    tick = 0
  }

  local clone_settings = optionals.clone_settings
  local tick = optionals.tick

  -- Validate inputs
  if (clone_settings == nil or not default_value or not difficulty or not entity) then return end
  Log.info("past 1")
  if (not difficulty.valid or not entity.valid) then return end
  Log.info("past 2")
  if (not difficulty.selected_difficulty) then return end
  Log.info("past 3")
  if (not entity.surface) then return end
  Log.info("past validations")

  local use_evolution_factor = Settings_Service.get_do_evolution_factor(entity.surface.name)

  local evolution_multiplier = 1
  local evolution_factor = 0
  if (use_evolution_factor) then
    evolution_factor = entity.force.get_evolution_factor()
  end
  evolution_multiplier = calc_evolution_multiplier(difficulty.selected_difficulty, evolution_factor)
  Log.debug(evolution_multiplier)

  local loop_len = 0
  local clone_setting = 0

  Log.info(clone_settings)
  Log.info(difficulty.selected_difficulty.value)
  Log.info(evolution_multiplier)
  local loop_len_fun = function (clone_setting, difficulty, evolution_multiplier)
    if (clone_setting >= 0 and clone_setting <= 1 ) then
      return (clone_setting * difficulty.selected_difficulty.value) * evolution_multiplier
    else
      return (clone_setting + difficulty.selected_difficulty.value) * evolution_multiplier
    end
  end

  if (clone_settings.type == "unit") then
    clone_setting = clone_settings.unit
    loop_len = loop_len_fun(clone_setting, difficulty, evolution_multiplier)
  elseif (clone_settings.type == "unit-group") then
    clone_setting = clone_settings.unit_group
    loop_len = loop_len_fun(clone_setting, difficulty, evolution_multiplier)
  else
    loop_len = difficulty.selected_difficulty.value * evolution_multiplier
  end
  Log.debug("loop_len after calcs")
  Log.info(loop_len)

  local clones = {}

  local limit_runtime = Settings_Service.get_maximum_group_size()

  Log.info("at cloner definition")
  local cloner = function (entity)
    Log.debug("Cloning")
    if (not entity.valid) then return end

    if (not storage.more_enemies or not storage.more_enemies.valid) then Initialization.reinit() end
    if (not storage.more_enemies.clones) then storage.more_enemies.clones = {} end

    local clone = nil

    if (not storage.more_enemies or not storage.more_enemies.do_nth_tick) then return clone end

    if (#storage.more_enemies.clones < Settings_Service.get_maximum_number_of_clones()) then
      clone = entity.clone({
        position = entity.position,
        -- position = {
        --   x = entity.position.x + math.random(-1, 1),
        --   y = entity.position.y + math.random(-1, 1)
        -- },
        surface = entity.surface.name,
        force = entity.force
      })

      Log.debug("Cloned")
      Log.info(clone)

      if (not storage.more_enemies.clone) then storage.more_enemies.clone = {} end
      if (not storage.more_enemies.clone.count) then storage.more_enemies.clone.count = 0 end
      storage.more_enemies.clone.count = storage.more_enemies.clone.count + 1
    else
      Log.warn("Currently at maximum number of cloned enemies")
    end

    Log.info(clone)
    return clone
  end

  Log.debug("at fun definition")
  local fun = function (loop_len, limit, clones, obj, difficulty, cloner, tick)
    tick = tick or -1

    local clone_limit = Settings_Service.get_maximum_number_of_clones()
    for i=1, math.floor(loop_len) do
      Log.info("i = " .. serpent.block(i))
      if (not storage.more_enemies or not storage.more_enemies.do_nth_tick) then return end

      if (  storage.more_enemies
        and storage.more_enemies.clone and storage.more_enemies.clone.clone_count
        and storage.more_enemies.clone.clone_count > clone_limit)
      then
        Log.warn("Tried to clone more than the unit limit: " .. serpent.block(clone_limit))
        Log.warn("Currently " .. serpent.block(storage.more_enemies.clone.clone_count) .. " clones")
        return
      end

      clones[i] = cloner(obj)
    end
  end

  if (clone_setting ~= default_value.value) then
    -- Settings are different from default
    -- -> use the user settings instead
    if (use_evolution_factor) then
      Log.debug("user settings with evolution_factor")
      Log.debug(loop_len)
      fun(loop_len, limit_runtime, clones, entity, difficulty, cloner)
    else
      Log.debug("user settings without evolution_factor")
      Log.debug(clone_setting + difficulty.selected_difficulty.value)
      fun(clone_setting + difficulty.selected_difficulty.value, limit_runtime, clones, entity, difficulty, cloner)
    end
  else
    if (use_evolution_factor) then
      Log.debug("standard settings with evolution_factor")
      Log.debug(loop_len)
      fun(loop_len, limit_runtime, clones, entity, difficulty, cloner)
    else
      Log.debug("standard settings without evolution_factor")
      -- No changes -> use selected difficulty
      Log.debug(difficulty.selected_difficulty.value)
      fun(difficulty.selected_difficulty.value, limit_runtime, clones, entity, difficulty, cloner)
    end
  end

  -- Log.info(clones)
  return clones
end

function calc_evolution_multiplier(selected_difficulty, evolution_factor)
  -- Validate inputs
  evolution_factor = evolution_factor or 0
  if (not selected_difficulty or not selected_difficulty.valid) then return evolution_factor end

  -- Calculate the evolution factor
  -- https://www.wolframalpha.com/input?i=x%5E%28y%2F%28x%5E%28y%2Fx%29%29%29+*+%28y%5Ex%29
  local value = ((selected_difficulty.value ^ (evolution_factor / (selected_difficulty.value ^ (evolution_factor / selected_difficulty.value)))) * (evolution_factor ^ selected_difficulty.value))
  Log.debug("evolution multiplier: " .. value)
  return value
end

spawn_utils.more_enemies = true

local _spawn_utils = spawn_utils

return spawn_utils