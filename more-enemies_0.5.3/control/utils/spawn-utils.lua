-- If already defined, return
if _spawn_utils and _spawn_utils.more_enemies then
  return _spawn_utils
end

local Constants = require("libs.constants.constants")
local Behemoth_Enemies_Constants = require("libs.constants.mods.behemoth-enemies-constants")
local Entity_Validations = require("control.validations.entity-validations")
local Gleba_Constants = require("libs.constants.gleba-constants")
local Gleba_Settings_Constants = require("libs.constants.settings.gleba-settings-constants")
local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Initialization = require("control.initialization")
local Log = require("libs.log.log")
local More_Enemies_Repository = require("control.repositories.more-enemies-repository")
local Nauvis_Constants = require("libs.constants.nauvis-constants")
local Nauvis_Settings_Constants = require("libs.constants.settings.nauvis-settings-constants")
local Difficulty_Utils = require("control.utils.difficulty-utils")
local Settings_Service = require("control.service.settings-service")
local Settings_Utils = require("control.utils.settings-utils")

local spawn_utils = {}

function spawn_utils.duplicate_unit_group(group, tick)
  Log.info("spawn.duplicate_unit_group" .. serpent.block(tick))

  local more_enemies_data = More_Enemies_Repository.get_more_enemies_data()
  if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end

  if (not more_enemies_data.do_nth_tick) then return end
  if (not group or not group.valid or not group.surface or not group.surface.valid) then return end
  if (Settings_Utils.is_vanilla(group.surface.name)) then return end

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
  end
end

function spawn_utils.clone_entity(default_value, difficulty, entity, optionals)
  local more_enemies_data = More_Enemies_Repository.get_more_enemies_data()
  if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end

  if (not more_enemies_data.do_nth_tick) then return end

  Log.info(optionals)
  optionals = optionals or {
    clone_settings = {
      unit = 1,
      unit_group = 1
    },
    type = "unit",
    tick = 0,
    mod_name = nil,
    surface = nil,
  }

  local clone_settings = optionals.clone_settings
  local tick = optionals.tick

  -- Validate inputs
  if (clone_settings == nil or not default_value or not difficulty or not entity) then return end
  Log.info("past 1")
  if (not difficulty.valid or not entity.valid) then return end
  Log.info("past 2")
  if (not difficulty.selected_difficulty and optionals.surface) then
    Log.debug("clone_entity: Getting difficulty")
    difficulty = Difficulty_Utils.get_difficulty(optionals.surface.name).difficulty
    if (not difficulty or not difficulty.valid) then
      Log.warn("difficulty was nil or invalid; reindexing")
      difficulty = Difficulty_Utils.get_difficulty(optionals.surface.name, true).difficulty
    end
    if (not difficulty or not difficulty.valid) then
      Log.error("Failed to find a valid difficulty for " .. serpent.block(optionals.surface.name))
      return
    end

    if (not difficulty.selected_difficulty) then return end
  end
  Log.info("past 3")
  if (not entity.surface or not entity.surface.valid) then return end
  if (Settings_Utils.is_vanilla(entity.surface.name)) then return end
  Log.debug("past validations")

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

    if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end

    local clone = nil

    if (not more_enemies_data.do_nth_tick) then return clone end

    local max_num_clones = Settings_Service.get_maximum_number_of_clones()
    if (more_enemies_data.clone.count > max_num_clones)
    then
      if (not Entity_Validations.get_mod_name(optionals) or optionals.mod_name ~= "BREAM") then
        Log.warn("Tried to clone more than the unit limit: " .. serpent.block(max_num_clones))
        Log.warn("Currently " .. serpent.block(storage.more_enemies.clone.count) .. " clones")
        return
      end
    end

    local max_num_modded_clones = Settings_Service.get_maximum_number_of_modded_clones()
    if (  more_enemies_data.mod.clone.count > max_num_modded_clones
      and Entity_Validations.get_mod_name(optionals))
    then
      Log.warn("Tried to clone more than the mod unit limit: " .. serpent.block(max_num_clones))
      Log.warn("Currently " .. serpent.block(more_enemies_data.mod.clone.count) .. " clones")
      return
    end

    clone = entity.clone({
      -- position = entity.position,
      position = {
        -- TODO: Make configurable
        x = entity.position.x + math.random(-0.0025, 0.0025),
        y = entity.position.y + math.random(-0.0025, 0.0025)
      },
      surface = entity.surface.name,
      force = entity.force
    })

    if (Entity_Validations.get_mod_name(entity)) then info(clone) end

    Log.debug("Cloned")
    Log.info(clone)

    if (Entity_Validations.get_mod_name(optionals)) then
      more_enemies_data.mod.clone.count = more_enemies_data.mod.clone.count + 1
    else
      more_enemies_data.clone.count = more_enemies_data.clone.count + 1
    end

    Log.info(clone)
    return {
      clone = clone,
      mod_name = Entity_Validations.get_mod_name(optionals)
    }
  end

  Log.debug("at fun definition")
  local fun = function (loop_len, limit, clones, obj, difficulty, cloner, tick)
    local more_enemies_data = More_Enemies_Repository.get_more_enemies_data()
    if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end

    tick = tick or -1

    local clone_limit = Settings_Service.get_maximum_number_of_clones()
    local max_num_clones = Settings_Service.get_maximum_number_of_clones()
    local max_num_modded_clones = Settings_Service.get_maximum_number_of_modded_clones()
    for i=1, math.floor(loop_len) do
      Log.info("i = " .. serpent.block(i))
      if (not more_enemies_data.do_nth_tick) then return end

      if (  more_enemies_data.clone and more_enemies_data.clone.count
        and more_enemies_data.clone.count > max_num_clones)
      then
        if (not Entity_Validations.get_mod_name(optionals) or optionals.mod_name ~= "BREAM") then

          Log.warn("Tried to clone more than the unit limit: " .. serpent.block(max_num_clones))
          Log.warn("Currently " .. serpent.block(more_enemies_data.clone.count) .. " clones")
          return
        end
      end

      if (  more_enemies_data.mod.clone.count > max_num_modded_clones
        and Entity_Validations.get_mod_name(optionals) ~= nil)
      then
        Log.warn("Tried to clone more than the mod unit limit: " .. serpent.block(max_num_modded_clones))
        Log.warn("Currently " .. serpent.block(more_enemies_data.mod.clone.count) .. " clones")
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