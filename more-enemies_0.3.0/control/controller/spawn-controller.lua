-- If already defined, return
if _spawn_controller and _spawn_controller.more_enemies then
  return _spawn_controller
end

local Behemoth_Enemies_Constants = require("libs.constants.mods.behemoth-enemies-constants")
local Gleba_Constants = require("libs.constants.gleba-constants")
local Initialization = require("control.initialization")
local Log = require("libs.log.log")
local Nauvis_Constants = require("libs.constants.nauvis-constants")
local Spawn_Service = require("control.service.spawn-service")
local Settings_Service = require("control.service.settings-service")

local spawn_controller = {}

spawn_controller.filter = {}

for k,v in pairs(Nauvis_Constants.nauvis.categories) do
  table.insert(spawn_controller.filter, { filter = "type", type = v .. "-biter"})
  table.insert(spawn_controller.filter, { filter = "type", type = v .. "-spitter"})
end

if (mods and mods["behemoth-enemies"]) then
  for k,v in pairs(Behemoth_Enemies_Constants.gleba.categories) do
    table.insert(spawn_controller.filter, { filter = "type", type = v .. "-wriggler-pentapod" })
    table.insert(spawn_controller.filter, { filter = "type", type = v .. "-strafer-pentapod"})
    table.insert(spawn_controller.filter, { filter = "type", type = v .. "-stomper-pentapod"})
  end
else
  for k,v in pairs(Gleba_Constants.gleba.categories) do
    table.insert(spawn_controller.filter, { filter = "type", type = v .. "-wriggler-pentapod" })
    table.insert(spawn_controller.filter, { filter = "type", type = v .. "-strafer-pentapod"})
    table.insert(spawn_controller.filter, { filter = "type", type = v .. "-stomper-pentapod"})
  end
end

function spawn_controller.do_tick(event)
  local tick = event.tick
  local nth_tick = Settings_Service.get_nth_tick()
  local offset = 1 + nth_tick -- Constants.time.TICKS_PER_SECOND / 2
  local tick_modulo = tick % offset

  Log.info("nth_tick = " .. serpent.block(nth_tick) .. " - tick_modulo = " .. serpent.block(tick_modulo))
  if (nth_tick ~= tick_modulo) then return end
  if (not storage or not storage.more_enemies or not storage.more_enemies.valid) then Initialization.reini() end
  if (not storage.more_enemies.nth_tick_complete) then storage.more_enemies.nth_tick_complete = { current = false, previous = false } end
  if (not storage.more_enemies.nth_tick_cleanup_complete) then storage.more_enemies.nth_tick_cleanup_complete = { current = false, previous = false } end

  storage.more_enemies.nth_tick_complete.previous = storage.more_enemies.nth_tick_complete.current
  storage.more_enemies.nth_tick_cleanup_complete.previous = storage.more_enemies.nth_tick_cleanup_complete.current
  storage.more_enemies.nth_tick_complete.current = false
  storage.more_enemies.nth_tick_cleanup_complete.current = false

  Log.info("attempt to process")
  if (storage.more_enemies.nth_tick_cleanup_complete.previous and Spawn_Service.do_nth_tick(event)) then
    Log.debug("do_nth_tick completed")
    storage.more_enemies.nth_tick_complete.current = true
  else
    Log.warn("failed to finish processing")
  end

  Log.info("attempt to clean up")
  if (storage.more_enemies.nth_tick_complete.current or not storage.more_enemies.nth_tick_cleanup_complete.previous) then
    if (Spawn_Service.do_nth_tick_cleanup(event)) then
      Log.debug("do_nth_tick_cleanup completed")
      storage.more_enemies.nth_tick_cleanup_complete.current = true
    else
      Log.warn("failed to finish cleaning up")
    end
  end
end

-- function do_nth_tick(event)
--   return Spawn_Service.do_nth_tick(event)
-- end

-- -- function spawn_controller.do_nth_tick_cleanup()
-- function do_nth_tick_cleanup()
--   return Spawn_service.do_nth_tick_cleanup()
-- end

function spawn_controller.entity_died(event)
  Spawn_Service.entity_died(event)
end

function spawn_controller.entity_spawned(event)
  Spawn_Service.entity_spawned(event)
end

spawn_controller.more_enemies = true

local _spawn_controller = spawn_controller

return spawn_controller