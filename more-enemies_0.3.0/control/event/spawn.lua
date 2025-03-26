-- If already defined, return
if _spawn and _spawn.more_enemies then
  return _spawn
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
local Difficulty_Utils = require("libs.difficulty-utils")
local Settings_Service = require("control.service.settings-service")

local spawn = {}

spawn.filter = {}

for k,v in pairs(Nauvis_Constants.nauvis.categories) do
  table.insert(spawn.filter, { filter = "type", type = v .. "-biter"})
  table.insert(spawn.filter, { filter = "type", type = v .. "-spitter"})
end

if (mods and mods["behemoth-enemies"]) then
  for k,v in pairs(Behemoth_Enemies_Constants.gleba.categories) do
    table.insert(spawn.filter, { filter = "type", type = v .. "-wriggler-pentapod" })
    table.insert(spawn.filter, { filter = "type", type = v .. "-strafer-pentapod"})
    table.insert(spawn.filter, { filter = "type", type = v .. "-stomper-pentapod"})
  end
else
  for k,v in pairs(Gleba_Constants.gleba.categories) do
    table.insert(spawn.filter, { filter = "type", type = v .. "-wriggler-pentapod" })
    table.insert(spawn.filter, { filter = "type", type = v .. "-strafer-pentapod"})
    table.insert(spawn.filter, { filter = "type", type = v .. "-stomper-pentapod"})
  end
end

log(serpent.block(spawn.filter))

function spawn.entity_died(event)
  Log.info(event)
  local entity = event.entity
  if (not entity or not entity.valid) then return end
  if (not entity.surface or not entity.name) then return end
  if (not storage.more_enemies or not storage.more_enemies.valid) then Initialization.reinit() end

  Log.info("Attempting to reemove entity")
  if (storage.more_enemies.clones and storage.more_enemies.clones[entity.unit_number] ~= nil) then
    Log.debug("Removing entity: " .. serpent.block(entity.unit_number))
    storage.more_enemies.clones[entity.unit_number] = nil
  end

  if (not storage.more_enemies.clone) then storage.more_enemies.clone = {} end
  if (not storage.more_enemies.clone.count) then storage.more_enemies.clone.count = 0 end
  if (  entity
    and entity.valid
    and storage.more_enemies.clone.count > 0
    and storage.more_enemies.clones[entity.unit_number])
  then
    storage.more_enemies.clone.count = storage.more_enemies.clone.count - 1
  end
end

function spawn.entity_spawned(event)
  Log.info(event)
  local spawner = event.spawner
  local entity = event.entity

  if (not storage.more_enemies or not storage.more_enemies.valid) then Initialization.reinit() end

  if (  storage.more_enemies.clone and storage.more_enemies.clone.clone_count
    and storage.more_enemies.clone.clone_count > Settings_Service.get_maximum_number_of_clones())
  then
    Log.error("Tried to clone more than the unit limit: " .. serpent.block(Settings_Service.get_maximum_number_of_clones()))
    Log.error("Currently " .. serpent.block(#storage.more_enemies.clones) .. " clones")
    return
  end

  if (not spawner or not spawner.valid) then return end
  if (not entity or not entity.valid) then return end
  if (not entity.surface or not entity.surface.name) then return end

  Log.info("Attempting to add to staged_clones")
  if (storage and storage.more_enemies and storage.more_enemies.valid) then
    Log.debug("Adding to staged_clones: " .. serpent.block(entity.unit_number))
    if (not storage.more_enemies.staged_clones) then storage.more_enemies.staged_clones = {} end
    storage.more_enemies.staged_clones[entity.unit_number] = entity
  end
end

function spawn.duplicate_unit_group(group, tick)
  Log.info("spawn.duplicate_unit_group" .. serpent.block(tick))

  if (storage) then
    if (not storage.more_enemies or not storage.more_enemies.valid) then Initialization.reinit() end
  end

  if (not group or not group.valid or not group.surface) then return end

  Log.debug("duplicate_unit_group: Getting difficulty")
  local difficulty = Difficulty_Utils.get_difficulty(group.surface.name)
  if (not difficulty or not difficulty.valid) then
    Log.warn("difficulty was nil or invalid; reindexing")
    difficulty = Difficulty_Utils.get_difficulty(group.surface.name, true)
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

  local use_evolution_factor = Settings_Service.get_do_evolution_factor(group.surface.name)

  -- Only try to clone if the difficulty is greater than Vanilla (1)
  if ((selected_difficulty and selected_difficulty.valid and selected_difficulty.value > 1) or clone_setting ~= 1) then
    local len = #group.members
    Log.debug("len:" .. serpent.block(len))

    local clones = {}

    Log.info("len: " .. serpent.block(len))
    for i=1, len do

      local v = group.members[i]

      local member = group.members[i]
      if (member and member.valid) then
        Log.debug("adding member to staged_clones")
        storage.more_enemies.staged_clones[member.unit_number] = member
      end

      ::continue::
    end
  end
end

function spawn.clone_entity(default_value, difficulty, entity, optionals)
  if (storage) then
    if (not storage.more_enemies or not storage.more_enemies.valid) then Initialization.reinit() end
  end

  Log.info(optionals)
  optionals = optionals or {
    clone_setting = 1,
    tick = 0
  }

  local clone_setting = optionals.clone_setting
  local tick = optionals.tick

  -- Validate inputs
  if (clone_setting == nil or not default_value or not difficulty or not entity) then return end
  if (not difficulty.valid or not entity.valid) then return end
  if (not difficulty.selected_difficulty or not entity.surface) then return end

  local use_evolution_factor = false
  if (  entity.surface.name == "nauvis"
    and settings and settings.global and settings.global[Nauvis_Settings_Constants.settings.NAUVIS_DO_EVOLUTION_FACTOR.name])
  then
    use_evolution_factor = settings.global[Nauvis_Settings_Constants.settings.NAUVIS_DO_EVOLUTION_FACTOR.name].value
  elseif (  entity.surface.name == "gleba"
        and settings and settings.global and settings.global[Nauvis_Settings_Constants.settings.GLEBA_DO_EVOLUTION_FACTOR.name]) then
    use_evolution_factor = settings.global[Gleba_Settings_Constants.settings.Gleba_DO_EVOLUTION_FACTOR.name].value
  end

  local evolution_multiplier = 1
  local evolution_factor = 0
  if (use_evolution_factor) then
    evolution_factor = entity.force.get_evolution_factor()
  end
  evolution_multiplier = calc_evolution_multiplier(difficulty.selected_difficulty, evolution_factor)
  Log.debug(evolution_multiplier)

  local loop_len = 0

  if (use_evolution_factor and evolution_multiplier > 0) then
    Log.info(clone_setting)
    Log.info(difficulty.selected_difficulty.value)
    Log.info(evolution_multiplier)
    loop_len = clone_setting * difficulty.selected_difficulty.value * evolution_multiplier
  end
  Log.debug(loop_len)

  local clones = {}

  local limit_runtime = Settings_Service.get_maximum_group_size()

  local cloner = function (entity)
    Log.info("Cloning")
    if (not entity.valid) then return end

    if (not storage.more_enemies or not storage.more_enemies.valid) then Initialization.reinit() end
    if (not storage.more_enemies.clones) then storage.more_enemies.clones = {} end

    local clone = nil
    -- if (#storage.more_enemies.clones < difficulty.selected_difficulty.value * Settings_Service.get_maximum_number_of_clones())
    if (#storage.more_enemies.clones < Settings_Service.get_maximum_number_of_clones()) then
      clone = entity.clone({
        position = entity.position,
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

    if (  entity
      and entity.valid
      and entity.surface
      and entity.surface.name
      and entity.unit_number)
    then
      storage.more_enemies.clones[entity.unit_number] = entity.surface.name
      Log.debug(entity.unit_number)
    end
    if (  clone
    and clone.valid
    and clone.surface
    and clone.surface.name
    and clone.unit_number)
    then
      storage.more_enemies.clones[clone.unit_number] = clone.surface.name
      Log.debug(clone.unit_number)
    end

    Log.info(clone)
    return clone
  end

  local fun = function (loop_len, limit, clones, obj, difficulty, cloner, tick)
    tick = tick or -1

    local clone_limit = Settings_Service.get_maximum_number_of_clones()
    for i=1, math.ceil(loop_len) do
      -- Log.error("i = " .. serpent.block(i))
      if (tick > 0 and game and game.tick > tick + Constants.settings.TICKS_TO_TRY_CLONING.maximum_value) then
        Log.error("Too much time pass since starting to clone; breaking out of loop"
          .. "\nStarted: " .. serpent.block(tick)
          .. "\nCurrent: " .. serpent.block(game.tick)
        )
        break
      end
      if (  storage.more_enemies.clone and storage.more_enemies.clone.clone_count
        and storage.more_enemies.clone.clone_count > Settings_Service.get_maximum_number_of_clones())
      then
        Log.error("Tried to clone more than the unit limit: " .. serpent.block(clone_limit))
        Log.error("Currently " .. serpent.block(storage.more_enemies.clone.clone_count) .. " clones")
        return
      end
      clones[i] = cloner(obj)
    end
  end

  if (clone_setting ~= default_value) then
    -- Settings are different from default
    -- -> use the user settings instead
    if (use_evolution_factor) then
      Log.debug("user settings with evolution_factor")
      Log.debug(math.ceil(loop_len))
      fun(math.ceil(loop_len), limit_runtime, clones, entity, difficulty, cloner)
    else
      Log.debug("user settings without evolution_factor")
      Log.debug(math.ceil(clone_setting * difficulty.selected_difficulty.value))
      fun(math.ceil(clone_setting * difficulty.selected_difficulty.value), limit_runtime, clones, entity, difficulty, cloner)
    end
  else
    if (use_evolution_factor) then
      Log.debug("standard settings with evolution_factor")
      Log.debug(math.ceil(loop_len))
      fun(math.ceil(loop_len), limit_runtime, clones, entity, difficulty, cloner)
    else
      Log.debug("standard settings without evolution_factor")
      -- No changes -> use selected difficulty
      Log.debug(math.ceil(difficulty.selected_difficulty.value))
      fun(math.ceil(difficulty.selected_difficulty.value), limit_runtime, clones, entity, difficulty, cloner)
    end
  end

  -- Log.error(clones)
  return clones
end

function calc_evolution_multiplier(selected_difficulty, evolution_factor)
  -- Validate inputs
  evolution_factor = evolution_factor or 0
  if (not selected_difficulty or not selected_difficulty.valid) then return evolution_factor end

  -- Calculate the evolution factor
  -- local value = ((selected_difficulty.value ^ (evolution_factor / (selected_difficulty.value ^ (evolution_factor / selected_difficulty.value)))) * (evolution_factor ^ 2)) * selected_difficulty.value
  local value = ((selected_difficulty.value ^ (evolution_factor / (selected_difficulty.value ^ (evolution_factor / selected_difficulty.value)))) * (evolution_factor ^ 2))-- * selected_difficulty.value
  Log.debug("evolution multiplier: " .. value)
  return value
end

spawn.more_enemies = true

local _spawn = spawn

return spawn