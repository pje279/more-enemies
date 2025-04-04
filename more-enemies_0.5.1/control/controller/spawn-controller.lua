-- If already defined, return
if _spawn_controller and _spawn_controller.more_enemies then
  return _spawn_controller
end

local Armoured_Biters_Constants = require("libs.constants.mods.armoured-biters-constants")
local Constants = require("libs.constants.constants")
local Behemoth_Enemies_Constants = require("libs.constants.mods.behemoth-enemies-constants")
local Gleba_Constants = require("libs.constants.gleba-constants")
local Initialization = require("control.initialization")
local Log = require("libs.log.log")
local Nauvis_Constants = require("libs.constants.nauvis-constants")
local Spawn_Service = require("control.service.spawn-service")
local Settings_Service = require("control.service.settings-service")
local Version_Validations = require("control.validations.version-validations")

local spawn_controller = {}

spawn_controller.filter = {}

for k,v in pairs(Nauvis_Constants.nauvis.categories) do
  table.insert(spawn_controller.filter, { filter = "name", name = v .. "-biter"})
  table.insert(spawn_controller.filter, { filter = "name", name = v .. "-spitter"})
end

if (script and script.active_mods and script.active_mods["ArmouredBiters"]) then
  for k,v in pairs(Armoured_Biters_Constants.nauvis.categories) do
    table.insert(spawn_controller.filter, { filter = "name", name = v .. "-armoured-biter"})
  end
end

for k,v in pairs(Gleba_Constants.gleba.categories) do
  table.insert(spawn_controller.filter, { filter = "name", name = v .. "-wriggler-pentapod" })
  table.insert(spawn_controller.filter, { filter = "name", name = v .. "-strafer-pentapod"})
  table.insert(spawn_controller.filter, { filter = "name", name = v .. "-stomper-pentapod"})
end

if ((mods and mods["space-age"] and mods["behemoth-enemies"]) or (script and script.active_mods and script.active_mods["space-age"] and script.active_mods["behemoth-enemies"])) then
  table.insert(spawn_controller.filter, { filter = "name", name = Behemoth_Enemies_Constants.prefix .. "-wriggler-pentapod" })
  table.insert(spawn_controller.filter, { filter = "name", name = Behemoth_Enemies_Constants.prefix .. "-strafer-pentapod"})
  table.insert(spawn_controller.filter, { filter = "name", name = Behemoth_Enemies_Constants.prefix .. "-stomper-pentapod"})
end

function spawn_controller.do_tick(event)
  -- Log.info("spawn_controller.do_tick(event)")

  local tick = event.tick
  local nth_tick = Settings_Service.get_nth_tick()
  local offset = 1 + nth_tick -- Constants.time.TICKS_PER_SECOND / 2
  local tick_modulo = tick % offset

  -- Log.info("nth_tick = " .. serpent.block(nth_tick) .. " - tick_modulo = " .. serpent.block(tick_modulo))
  if (nth_tick ~= tick_modulo) then return end

  -- Check/validate the storage version
  if (not Version_Validations.validate_version()) then return end

  if (not storage or not storage.more_enemies or not storage.more_enemies.valid) then Initialization.reinit() end
  if (not storage.more_enemies.nth_tick_complete) then storage.more_enemies.nth_tick_complete = { current = false, previous = false } end
  if (not storage.more_enemies.nth_tick_cleanup_complete) then storage.more_enemies.nth_tick_cleanup_complete = { current = false, previous = false } end

  storage.more_enemies.nth_tick_complete.previous = storage.more_enemies.nth_tick_complete.current
  storage.more_enemies.nth_tick_cleanup_complete.previous = storage.more_enemies.nth_tick_cleanup_complete.current
  storage.more_enemies.nth_tick_complete.current = false
  storage.more_enemies.nth_tick_cleanup_complete.current = false


  if (storage.more_enemies and storage.more_enemies.do_nth_tick) then
    Log.info("attempt to process")
    if (storage.more_enemies.nth_tick_cleanup_complete.previous and Spawn_Service.do_nth_tick(event)) then
      Log.debug("do_nth_tick completed")
      storage.more_enemies.nth_tick_complete.current = true
    else
      Log.debug("failed to finish processing")
    end
  end

  Log.info("attempt to clean up")
  if (storage.more_enemies.nth_tick_complete.current or not storage.more_enemies.nth_tick_cleanup_complete.previous) then
    if (Spawn_Service.do_nth_tick_cleanup(event)) then
      Log.debug("do_nth_tick_cleanup completed")
      storage.more_enemies.nth_tick_cleanup_complete.current = true
    else
      Log.debug("failed to finish cleaning up")
    end
  end
end

function spawn_controller.entity_died(event)
  Log.info("spawn_controller.entity_died(event)")
  Spawn_Service.entity_died(event)
end

function spawn_controller.entity_spawned(event)
  Log.info("spawn_controller.entity_spawned(event)")
  Spawn_Service.entity_spawned(event)
end

function spawn_controller.entity_built(event)
  Log.info("spawn_controller.entity_built")
  if (not Settings_Service.get_BREAM_do_clone()) then
    Log.debug("more-enemies cloning of BREAM entities is disabled; returning")
    return
  end
  Spawn_Service.entity_built(event)
end

spawn_controller.more_enemies = true

local _spawn_controller = spawn_controller

return spawn_controller