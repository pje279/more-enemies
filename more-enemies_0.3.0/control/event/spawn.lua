-- If already defined, return
if _spawn and _spawn.more_enemies then
  return _spawn
end

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

  if (difficulty.selected_difficulty.value > 1) then
    for i=1, math.ceil(difficulty.selected_difficulty.value - 1) do
      Log.info("Cloning")
      Log.info(entity.force)
      local clone = entity.clone({
        position = entity.position,
        surface = surface_name,
        force = entity.force
      })

      Log.info(clone)

      Log.info("spawner: " .. serpent.block(spawner))
      Log.info("spawner.unit_number: " .. serpent.block(spawner.unit_number))
      Log.info(storage.spawners)
      if (storage.spawners and storage.spawners[spawner.unit_number]) then
        Log.info("Passed")
        local unit_group = storage.spawners[spawner.unit_number]
        if (not unit_group or not unit_group.valid) then return end
        Log.info("Adding member")
        unit_group.add_member(clone)
      end
    end
  end
end

function spawn.duplicate_unit_group(group)
  if (not group or not group.valid or not group.surface) then return end

  local selected_difficulty = Difficulty_Utils.get_difficulty(group.surface.name).selected_difficulty
  Log.warn("selected_difficulty: " .. serpent.block(selected_difficulty))

  if (selected_difficulty.value > 1) then
    for i=1, math.ceil(selected_difficulty.value - 1) do
      for k,v in pairs(group.members) do
        Log.warn("Cloning")
        Log.info(v.force)
        local clone = v.clone({
          position = v.position,
          surface = group.surface.name,
          force = v.force
        })
        Log.warn(clone)

        Log.info("Adding member")
        group.add_member(clone)
      end
    end
  end
end

spawn.more_enemies = true

local _spawn = spawn

return spawn