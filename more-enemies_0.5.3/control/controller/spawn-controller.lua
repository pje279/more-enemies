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
local More_Enemies_Repository = require("control.repositories.more-enemies-repository")
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
  -- Log.debug("spawn_controller.do_tick")
  -- Log.info(event)

  local tick = event.tick
  local nth_tick = Settings_Service.get_nth_tick()
  local offset = 1 + nth_tick -- Constants.time.TICKS_PER_SECOND / 2
  local tick_modulo = tick % offset

  -- Log.info("nth_tick = " .. serpent.block(nth_tick) .. " - tick_modulo = " .. serpent.block(tick_modulo))
  if (nth_tick ~= tick_modulo) then return end

  -- Check/validate the storage version
  if (not Version_Validations.validate_version()) then return end

  local more_enemies_data = More_Enemies_Repository.get_more_enemies_data()

  if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end
  if (not more_enemies_data.nth_tick_complete) then more_enemies_data.nth_tick_complete = { current = false, previous = false } end
  if (not more_enemies_data.nth_tick_cleanup_complete) then more_enemies_data.nth_tick_cleanup_complete = { current = false, previous = false } end

  more_enemies_data.nth_tick_complete.previous = more_enemies_data.nth_tick_complete.current
  more_enemies_data.nth_tick_cleanup_complete.previous = more_enemies_data.nth_tick_cleanup_complete.current
  more_enemies_data.nth_tick_complete.current = false
  more_enemies_data.nth_tick_cleanup_complete.current = false


  if (more_enemies_data.do_nth_tick) then
    Log.info("attempt to process")
    if (more_enemies_data.nth_tick_cleanup_complete.previous and Spawn_Service.do_nth_tick(event, more_enemies_data)) then
      Log.debug("do_nth_tick completed")
      more_enemies_data.nth_tick_complete.current = true
    else
      Log.debug("failed to finish processing")
    end
  end

  Log.info("attempt to clean up")
  if (more_enemies_data.nth_tick_complete.current or not more_enemies_data.nth_tick_cleanup_complete.previous) then
    if (Spawn_Service.do_nth_tick_cleanup(event)) then
      Log.debug("do_nth_tick_cleanup completed")
      more_enemies_data.nth_tick_cleanup_complete.current = true
    else
      Log.debug("failed to finish cleaning up")
    end
  end
end

function spawn_controller.entity_died(event)
  Log.debug("spawn_controller.entity_died")
  Log.info(event)
  Spawn_Service.entity_died(event)
end

function spawn_controller.entity_spawned(event)
  Log.debug("spawn_controller.entity_spawned")
  Log.info(event)
  Spawn_Service.entity_spawned(event)
end

function spawn_controller.entity_built(event)
  Log.debug("spawn_controller.entity_built")
  Log.info(event)
  if (not Settings_Service.get_BREAM_do_clone()) then
    Log.warn("more-enemies cloning of BREAM entities is disabled; returning")
    return
  end
  Spawn_Service.entity_built(event)
end

spawn_controller.more_enemies = true

local _spawn_controller = spawn_controller

return spawn_controller