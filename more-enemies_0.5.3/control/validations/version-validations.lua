-- If already defined, return
if (_version_validations and _version_validations.more_enemies) then
  return _version_validations
end

local Constants = require("libs.constants.constants")
local Initialization = require("control.initialization")
local Log = require("libs.log.log")
local Version_Data = require("control.data.version-data")
local Version_Service = require("control.service.version-service")
local Version_Repository = require("control.repositories.version-repository")

local version_validations = {}

function version_validations.validate_version()
  local return_val = true
  -- local version = Constants.meta.functions.version.validate()

  local version = Version_Service.validate_version()
  local validate_fun = function ()
    -- Log.warn("more-enemies: Invalid version detected relative to version " .. Constants.meta.version.string_val .. "; reinitializing naively")
    Log.warn("more-enemies: Invalid version detected relative to version " .. Version_Data.string_val .. "; reinitializing naively")
    Initialization.reinit()
    -- Log.warn(Constants.meta.functions.version.validate())
    -- Log.warn(Version_Service.validate_version())
    -- if (not Constants.meta.functions.version.validate().valid) then
    if (not Version_Service.validate_version().valid) then
      local return_val = false
      -- Log.error("more-enemies: invalid version detected relative to version " .. Constants.meta.version.string_val .. "; naive reinitialization failed")
      Log.error("more-enemies: invalid version detected relative to version " .. Version_Data.string_val .. "; naive reinitialization failed")
      -- if (storage.more_enemies and storage.more_enemies.version and storage.more_enemies.version.string_val) then
      if (version_data.string_val) then
        -- game.print("more-enemies: Version (" .. storage.more_enemies.version.string_val ..") is invalid relative to current installed version: (" .. Constants.meta.version.string_val .. ")")
        game.print("more-enemies: Version (" .. version_data.string_val ..") is invalid relative to current installed version: (" .. Version_Data.string_val .. ")")
      else
        -- game.print("more-enemies: Version is invalid relative to current installed version: (" .. Constants.meta.version.string_val .. ")")
        game.print("more-enemies: Version is invalid relative to current installed version: (" .. Version_Data.string_val .. ")")
      end
      game.print("more-enemies: If this error persists, recommend executing command /more_enemies.init")
    end
    return return_val
  end -- local validate_fun = function (version)

  local version_data = Version_Repository.get_version_data()

  if ( not version.valid) then
    return_val = validate_fun(version)
  end

  if (storage.more_enemies and storage.more_enemies.version) then

    local print_fun = function ()
      -- if (storage.more_enemies.version.string_val == nil) then
      if (version_data.string_val == nil) then
        -- storage.more_enemies.version.string_val = "nil"
        version_data.string_val = "nil"
      end

      log("more-enemies: Inconsistent version detected ("
        -- .. Constants.meta.version.string_val ..") with existing data ("
        .. Version_Data.string_val ..") with existing data ("
        -- .. storage.more_enemies.version.string_val
        .. version_data.string_val
        .. ");") -- recommend executing command /more_enemies.init")

      game.print("more-enemies: Inconsistent version detected ("
        -- .. Constants.meta.version.string_val ..") with existing data ("
        .. Version_Data.string_val ..") with existing data ("
        -- .. storage.more_enemies.version.string_val
        .. version_data.string_val
        .. ");") -- recommend executing command /more_enemies.init")
    end

    -- if (not storage.more_enemies.version.major) then storage.more_enemies.version.major = { value = 0, warned = false } end
    -- if (not storage.more_enemies.version.minor) then storage.more_enemies.version.minor = { value = 0, warned = false } end
    -- if (not storage.more_enemies.version.bug_fix) then storage.more_enemies.version.bug_fix = { value = 0, warned = false } end

    -- if (  storage.more_enemies.version.major.value ~= Constants.meta.version.major.value
    --   and not storage.more_enemies.version.major.warned) then
    --   storage.more_enemies.version.major.warned = true
    --   print_fun()
    -- elseif (storage.more_enemies.version.minor.value ~= Constants.meta.version.minor.value
    --     and not storage.more_enemies.version.major.warned
    --     and not storage.more_enemies.version.minor.warned) then
    --   storage.more_enemies.version.minor.warned = true
    --   print_fun()
    -- elseif (storage.more_enemies.version.bug_fix.value ~= Constants.meta.version.bug_fix.value
    --     and not storage.more_enemies.version.major.warned
    --     and not storage.more_enemies.version.minor.warned
    --     and not storage.more_enemies.version.bug_fix.warned) then
    --   storage.more_enemies.version.bug_fix.warned = true
    --   print_fun()
    -- end
    if (not version_data.major) then version_data.major = { value = 0, warned = false } end
    if (not version_data.minor) then version_data.minor = { value = 0, warned = false } end
    if (not version_data.bug_fix) then version_data.bug_fix = { value = 0, warned = false } end

    if (  version_data.major.value ~= Version_Data.major.value
      and not version_data.major.warned) then
      version_data.major.warned = true
      print_fun()
    elseif (version_data.minor.value ~= Version_Data.minor.value
        and not version_data.major.warned
        and not version_data.minor.warned) then
      version_data.minor.warned = true
      print_fun()
    elseif (version_data.bug_fix.value ~= Version_Data.bug_fix.value
        and not version_data.major.warned
        and not version_data.minor.warned
        and not version_data.bug_fix.warned) then
      version_data.bug_fix.warned = true
      print_fun()
    end
  end

  return return_val
end

version_validations.more_enemies = true

local _version_validations = version_validations
return version_validations