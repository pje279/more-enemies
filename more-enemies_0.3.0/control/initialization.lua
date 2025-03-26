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
    storage = {}
    storage.more_enemies = {}
    storage.more_enemies.clones = {}
    storage.more_enemies.clone_count = {
      count = 0
    }
  end

  if (storage.more_enemies) then
    storage.more_enemies.clone = {}
    storage.more_enemies.clone.count = 0
    storage.more_enemies.overflow_clone_attempts = {
      count = 0,
      warned = {
        none = false,
        error = false,
        warn = false,
        info = false
      },
      valid = true
    }
    storage.more_enemies.staged_clones = {}
    storage.more_enemies.transition_clones = {}
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
      local difficulty = Difficulty_Utils.get_difficulty(planet.string_val, true)
      if (storage) then
        if (not storage.more_enemies.difficulties) then storage.more_enemies.difficulties = {} end

        if (from_scratch) then
          storage.more_enemies.difficulties[planet.string_val] = {
            valid = true,
            difficulty = difficulty,
            surface = game.get_surface(planet.string_val),
            entities_spawned = 0,
          }

          if (not storage.more_enemies.groups) then storage.more_enemies.groups = {} end
          storage.more_enemies.groups[planet.string_val] = {}
        end

        if (not storage.more_enemies.difficulties[planet.string_val] or not storage.more_enemies.difficulties[planet.string_val].valid) then
          storage.more_enemies.difficulties[planet.string_val] = {
            valid = true,
            difficulty = difficulty,
            surface = game.get_surface(planet.string_val),
            entities_spawned = 0,
          }
        end

        if (not storage.more_enemies.groups) then storage.more_enemies.groups = {} end

        if (not storage.more_enemies.groups[planet.string_val]) then
          storage.more_enemies.groups[planet.string_val] = {}
        end
      end
    end

    storage.more_enemies.valid = true
  end

  Log.info(storage)
end

initialization.more_enemies = true

local _initialization = initialization

return initialization