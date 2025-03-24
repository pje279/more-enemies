-- If already defined, return
if _initialization and _initialization.more_enemies then
  return _initialization
end

local Constants = require("libs.constants.constants")
local Difficulty_Utils = require("libs.difficulty-utils")
local Log_Constants = require("libs.log.log-constants")

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

  if (from_scratch) then
    storage.more_enemies = {}
  end

  local user_setting = nil
  if (settings and settings.global and settings.global[Log_Constants.DEBUG_LEVEL.name]) then
    user_setting = settings.global[Log_Constants.DEBUG_LEVEL.name].value
    if (user_setting) then
      Log.info(user_setting)
      Log.set_log_level(user_setting)
    else
      Log.error("user setting DEBUG_LEVEL is  nil")
      error("user setting DEBUG_LEVEL is  nil")
    end
  elseif (not settings) then
    Log.error("settings is nil")
    error("settings is nil")
  elseif (not settings.global) then
    Log.error("setting.global is nil")
    error("setting.global is nil")
  elseif (not settings.global[Log_Constants.DEBUG_LEVEL.name]) then
    Log.error("settings.global[Log_Constants.DEBUG_LEVEL.name] is nil")
    error("settings.global[Log_Constants.DEBUG_LEVEL.name] is nil")
  end

  if (game) then
    for k, planet in pairs(Constants.DEFAULTS.planets) do
      Log.info(k)
      Log.info(planet)
      Difficulty_Utils.get_difficulty(k, true)
    end

    storage.more_enemies.valid = true
  end

  Log.debug(storage)
end

initialization.more_enemies = true

local _initialization = initialization

return initialization