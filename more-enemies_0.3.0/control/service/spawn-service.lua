-- If already defined, return
if _spawn_service and _spawn_service.more_enemies then
  return _spawn_service
end

local Log = require("libs.log.log")
local Initialization = require("control.initialization")
local Settings_Service = require("control.service.settings-service")

local spawn_service = {}

function spawn_service.clone_attempts()
  -- Validate "inputs"
  if (not storage or not storage.more_enemies or not storage.more_enemies.valid or not storage.more_enemies.clones) then return end
  if (not storage.more_enemies.overflow_clone_attempts or not storage.more_enemies.overflow_clone_attempts.valid) then Initialization.reinit() end

  if (#storage.more_enemies.clones > Settings_Service.get_maximum_number_of_clones()) then
    Log.none("Tried to clone more than the unit limt")
    storage.more_enemies.overflow_clone_attempts.warned.none = true
    return
  end

  if (not storage.more_enemies.overflow_clone_attempts.warned.error
      and #storage.more_enemies.clones > Settings_Service.get_maximum_number_of_clones())
  then
    Log.error("Tried to clone more than the unit limt")
    storage.more_enemies.overflow_clone_attempts.warned.error = true
    return
  end

  if (not storage.more_enemies.overflow_clone_attempts.warned.warn
      and #storage.more_enemies.clones > Settings_Service.get_maximum_number_of_clones())
  then
    Log.warn("Tried to clone more than the unit limt")
    storage.more_enemies.overflow_clone_attempts.warned.warn = true
    return
  end

  if (not storage.more_enemies.overflow_clone_attempts.warned.debug
      and #storage.more_enemies.clones > Settings_Service.get_maximum_number_of_clones())
  then
    Log.debug("Tried to clone more than the unit limt")
    storage.more_enemies.overflow_clone_attempts.warned.debug = true
    return
  end

  if (not storage.more_enemies.overflow_clone_attempts.warned.info
      and #storage.more_enemies.clones > Settings_Service.get_maximum_number_of_clones())
  then
    Log.info("Tried to clone more than the unit limt")
    storage.more_enemies.overflow_clone_attempts.warned.info = true
    return
  end
end

spawn_service.more_enemies = true

local _spawn_service = spawn_service

return spawn_service