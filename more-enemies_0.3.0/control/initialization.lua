-- If already defined, return
if _initialization and _initialization.more_enemies then
  return _initialization
end

local initialization = {}

local Log = require("libs.log.log")

function initialization.init()
  Log.debug("Initializing More Enemies")

  initialize(true) -- from_scratch

  Log.debug("Finished initializing More Enemies")
end

function initialization.reinit()
  Log.debug("Reinitializing More Enemies")

  initialize(false) -- as is

  Log.debug("Finished reinitializing More Enemies")
end

function initialize(from_scratch)
  from_scratch = from_scratch or false

  storage.more_enemies = {}
  storage.more_enemies.valid = true

  Log.debug(storage)
end

local user_setting = nil
if (settings and settings.global and settings.global[Log_Constants.DEBUG_LEVEL.name]) then
  user_setting = settings.global[Log_Constants.DEBUG_LEVEL.name].value
  if (user_setting) then
    -- log(serpent.block(user_setting))
    Log.set_log_level(user_setting)
  else
    error("user setting DEBUG_LEVEL is  nil")
  end
elseif (not settings) then
  error("settings is nil")
elseif (not settings.global) then
  error("setting.global is nil")
elseif (not settings.global[Log_Constants.DEBUG_LEVEL.name]) then
  error("settings.global[Log_Constants.DEBUG_LEVEL.name] is nil")
end

initialization.more_enemies = true

local _initialization = initialization

return initialization