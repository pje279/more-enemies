-- If already defined, return
if _spawn and _spawn.more_enemies then
  return _spawn
end

local Constants = require("libs.constants.constants")
local Log = require("libs.log.log")
local Difficulty_Utils = require("libs.difficulty-utils")

local spawn = {}

function spawn.entity_spawned(event)
  Log.info(event)
  local spawner = event.spawner
  local entity = event.entity

  if (not spawner) then return end
  if (not entity or not entity.surface or not entity.surface.name) then return end

  local surface_name = entity.surface.name

  local difficulty = Difficulty_Utils.get_difficulty(surface_name)
  Log.info("getting difficulty")
  if (not difficulty or not difficulty.valid) then return end
  Log.info("selected_difficulty: " .. serpent.block(difficulty.selected_difficulty))

  Log.info(entity)
  Log.info(entity.force.get_evolution_factor())
  local evolution_factor = entity.force.get_evolution_factor()

  if (  evolution_factor
    and difficulty.selected_difficulty.value * evolution_factor > 1)
  then
    for i=1, math.ceil(difficulty.selected_difficulty.value) do
      Log.debug("Cloning")
      Log.info(entity.force)
      local clone = entity.clone({
        position = entity.position,
        surface = surface_name,
        force = entity.force
      })

      Log.info(clone)
    end
  end
end

function spawn.duplicate_unit_group(group)
  if (not group or not group.valid or not group.surface) then return end

  local difficulty = Difficulty_Utils.get_difficulty(group.surface.name)
  if (not difficulty or not difficulty.valid) then return end

  local selected_difficulty = difficulty.selected_difficulty
  Log.debug("selected_difficulty: " .. serpent.block(selected_difficulty))

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

spawn.more_enemies = true

local _spawn = spawn

return spawn