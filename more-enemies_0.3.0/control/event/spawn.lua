-- If already defined, return
if _spawn and _spawn.more_enemies then
  return _spawn
end

local Constants = require("libs.constants.constants")
local Gleba_Settings_Constants = require("libs.constants.settings.gleba-settings-constants")
local Log = require("libs.log.log")
local Nauvis_Settings_Constants = require("libs.constants.settings.nauvis-settings-constants")
local Difficulty_Utils = require("libs.difficulty-utils")

local spawn = {}

function spawn.entity_spawned(event)
  Log.info(event)
  local spawner = event.spawner
  local entity = event.entity

  if (not spawner) then return end
  if (not entity or not entity.surface or not entity.surface.name) then return end

  local surface_name = entity.surface.name

  Log.info("Getting difficulty")
  local difficulty = Difficulty_Utils.get_difficulty(entity.surface.name)
  if (not difficulty or not difficulty.valid) then return end

  Log.info("Getting selected_difficulty")
  local selected_difficulty = difficulty.selected_difficulty
  if (not selected_difficulty) then return end

  if (selected_difficulty.string_val == "Vanilla" or selected_difficulty.value == 1) then
    Log.debug("Difficulty is vanilla; no need to process")
    return
  end

  local use_evolution_factor = false
  if (  entity.surface.name == "nauvis"
    and settings and settings.global and settings.global[Nauvis_Settings_Constants.settings.NAUVIS_DO_EVOLUTION_FACTOR.name])
  then
    Log.info("Found 'nauvis' for entity" .. serpent.block(entity))
    use_evolution_factor = settings.global[Nauvis_Settings_Constants.settings.NAUVIS_DO_EVOLUTION_FACTOR.name].value
  elseif (  entity.surface.name == "gleba"
        and settings and settings.global and settings.global[Gleba_Settings_Constants.settings.GLEBA_DO_EVOLUTION_FACTOR.name])
  then
    Log.info("Found 'gleba' for entity" .. serpent.block(entity))
    use_evolution_factor = settings.global[Gleba_Settings_Constants.settings.GLEBA_DO_EVOLUTION_FACTOR.name].value
  else
    Log.warn("Found 'unknown'surface for entity" .. serpent.block(entity))
  end

  local evolution_factor = 1
  if (use_evolution_factor) then
    Log.debug("Using evolution factor")
    evolution_factor = entity.force.get_evolution_factor()
  end
  Log.info(evolution_factor)

  if (  evolution_factor
    and difficulty
    and difficulty.selected_difficulty
    and difficulty.selected_difficulty.value
    and difficulty.selected_difficulty.value > 0
    and difficulty.selected_difficulty.value * evolution_factor > 1)
  then
    local setting = 1

    Log.debug("Checking for user settings")
    if (  entity.surface.name == Constants.DEFAULTS.planets.nauvis.string_val
      and settings and settings.global and settings.global[Nauvis_Settings_Constants.settings.CLONE_NAUVIS_UNITS.name])
    then
      setting = settings.global[Nauvis_Settings_Constants.settings.CLONE_NAUVIS_UNITS.name].value
    elseif (  entity.surface.name == Constants.DEFAULTS.planets.gleba.string_val
          and settings and settings.global and settings.global[Gleba_Settings_Constants.settings.CLONE_GLEBA_UNITS.name])
        then
      setting = settings.global[Gleba_Settings_Constants.settings.CLONE_GLEBA_UNITS.name].value
    end

    Log.debug("Attempting to clone entity on planet " .. entity.surface.name)
    if (  entity.surface.name == Constants.DEFAULTS.planets.nauvis.string_val) then
      clone_entity(setting, Nauvis_Settings_Constants.settings.CLONE_NAUVIS_UNITS.default_value, difficulty, entity)
    elseif (  entity.surface.name == Constants.DEFAULTS.planets.gleba.string_val) then
      clone_entity(setting, Gleba_Settings_Constants.settings.CLONE_GLEBA_UNITS.default_value, difficulty, entity)
    else
      Log.warn("Planet is neither nauvis nor gleba\nPlanet is unsupported; making no changes")
    end
  end
end

function spawn.duplicate_unit_group(group)
  if (not group or not group.valid or not group.surface) then return end

  local difficulty = Difficulty_Utils.get_difficulty(group.surface.name)
  if (not difficulty or not difficulty.valid) then return end

  local selected_difficulty = difficulty.selected_difficulty
  Log.info("selected_difficulty: " .. serpent.block(selected_difficulty))

  if (selected_difficulty.value > 1) then

    local len = #group.members
    Log.debug("len:" .. serpent.block(len))

    local clones = {}

    for i=1, len do
      local v = group.members[i]
      Log.info(i)
      Log.info(v)
      local clone = nil
        Log.debug("Cloning")
        clone = v.clone({
          position = v.position,
          surface = group.surface.name,
          force = v.force
        })
        Log.info(clone)
      -- end

      clones[i] = clone

      -- This shouldn't be necessary, but just in case
      if (i > math.sqrt(selected_difficulty.value * Constants.DEFAULTS.unit_group.max_unit_group_size)) then break end
    end

    for i=1, #clones do
      Log.info("Adding member")
      group.add_member(clones[i])
    end
  end
end

function clone_entity(setting, default_value, difficulty, entity)
  -- Validate inputs
  if (not setting or not default_value or not difficulty or not entity) then return end
  if (not difficulty.valid or not entity.valid) then return end
  if (not difficulty.selected_difficulty or not entity.surface) then return end

  if (setting ~= default_value) then
    -- Settings are different from default
    -- -> use the user settings instead
    for i=1, math.ceil(setting) do
      Log.debug("Cloning")
      Log.info(entity.force)
      local clone = entity.clone({
        position = entity.position,
        surface = surface_name,
        force = entity.force
      })

      Log.info(clone)
    end
  else
    -- No changes -> use selected difficulty
    for i=1, math.ceil(difficulty.selected_difficulty.value) do
      Log.debug("Cloning")
      Log.info(entity.force)
      local clone = entity.clone({
        position = entity.position,
        surface = entity.surface.name,
        force = entity.force
      })

      Log.info(clone)
    end
  end
end

spawn.more_enemies = true

local _spawn = spawn

return spawn