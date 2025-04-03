-- If already defined, return
if (_version_validations and _version_validations.more_enemies) then
  return _version_validations
end

local Constants = require("libs.constants.constants")
local Initialization = require("control.initialization")
local Log = require("libs.log.log")

local version_validations = {}

function version_validations.validate_version()
  local return_val = true
  local version = Constants.meta.functions.version.validate()
  local validate_fun = function ()
    Log.warn("Invalid version detected relative to version " .. Constants.meta.version.string_val .. "; reinitializing naively")
    Initialization.reinit()
    Log.warn(Constants.meta.functions.version.validate())
    if (not Constants.meta.functions.version.validate().valid) then
      local return_val = false
      Log.error("invalid version detected relative to version " .. Constants.meta.version.string_val .. "; naive reinitialization failed")
      if (storage.more_enemies and storage.more_enemies.version and storage.more_enemies.version.string_val) then
        game.print("Version (" .. storage.more_enemies.version.string_val ..") is invalid relative to current installed version: (" .. Constants.meta.version.string_val .. ")")
      else
        game.print("Version is invalid relative to current installed version: (" .. Constants.meta.version.string_val .. ")")
      end
      game.print("If this error persists, recommend executing command /more_enemies.init")
    end
    return return_val
  end -- local validate_fun = function (version)

  if ( not version.valid) then
    return_val = validate_fun(version)
  end

  if (storage.more_enemies and storage.more_enemies.version) then

    local print_fun = function ()
      if (storage.more_enemies.version.string_val == nil) then
        storage.more_enemies.version.string_val = "nil"
      end

      log("Inconsistent version detected ("
        .. Constants.meta.version.string_val ..") with existing data ("
        .. storage.more_enemies.version.string_val
        .. ");") -- recommend executing command /more_enemies.init")

      game.print("Inconsistent version detected ("
        .. Constants.meta.version.string_val ..") with existing data ("
        .. storage.more_enemies.version.string_val
        .. ");") -- recommend executing command /more_enemies.init")
    end

    if (not storage.more_enemies.version.major) then storage.more_enemies.version.major = { value = 0, warned = false } end
    if (not storage.more_enemies.version.minor) then storage.more_enemies.version.minor = { value = 0, warned = false } end
    if (not storage.more_enemies.version.bug_fix) then storage.more_enemies.version.bug_fix = { value = 0, warned = false } end

    if (  storage.more_enemies.version.major.value ~= Constants.meta.version.major.value
      and not storage.more_enemies.version.major.warned) then
      storage.more_enemies.version.major.warned = true
      print_fun()
    elseif (storage.more_enemies.version.minor.value ~= Constants.meta.version.minor.value
        and not storage.more_enemies.version.major.warned
        and not storage.more_enemies.version.minor.warned) then
      storage.more_enemies.version.minor.warned = true
      print_fun()
    elseif (storage.more_enemies.version.bug_fix.value ~= Constants.meta.version.bug_fix.value
        and not storage.more_enemies.version.major.warned
        and not storage.more_enemies.version.minor.warned
        and not storage.more_enemies.version.bug_fix.warned) then
      storage.more_enemies.version.bug_fix.warned = true
      print_fun()
    end
  end

  return return_val
end

version_validations.more_enemies = true

local _version_validations = version_validations
return version_validations