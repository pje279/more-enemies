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

  local version = Version_Service.validate_version()
  local validate_fun = function ()
    Log.warn("more-enemies: Invalid version detected relative to version " .. Version_Data.string_val .. "; reinitializing naively")
    Initialization.reinit()
    if (not Version_Service.validate_version().valid) then
      local return_val = false
      Log.error("more-enemies: invalid version detected relative to version " .. Version_Data.string_val .. "; naive reinitialization failed")
      if (Version_Data.string_val) then
        game.print("more-enemies: Version (" .. Version_Data.string_val ..") is invalid relative to current installed version: (" .. Version_Data.string_val .. ")")
      else
        game.print("more-enemies: Version is invalid relative to current installed version: (" .. Version_Data.string_val .. ")")
      end
      game.print("more-enemies: If this error persists, recommend executing command /more_enemies.init")
    end
    return return_val
  end -- local validate_fun = function (version)

  local version_data = Version_Repository.get_version_data()

  if ( not version.valid) then
    -- return_val = validate_fun(version)
    return_val = validate_fun()
  end

  -- if (storage.more_enemies and storage.more_enemies.version) then

  --   local print_fun = function ()
  --     if (version_data.string_val == nil) then
  --       version_data.string_val = "nil"
  --     end

  --     log("more-enemies: Inconsistent version detected ("
  --       .. Version_Data.string_val ..") with existing data ("
  --       .. version_data.string_val
  --       .. ");") -- recommend executing command /more_enemies.init")

  --     game.print("more-enemies: Inconsistent version detected ("
  --       .. Version_Data.string_val ..") with existing data ("
  --       .. version_data.string_val
  --       .. ");") -- recommend executing command /more_enemies.init")
  --   end

  --   if (not version_data.major) then version_data.major = { value = 0, warned = false } end
  --   if (not version_data.minor) then version_data.minor = { value = 0, warned = false } end
  --   if (not version_data.bug_fix) then version_data.bug_fix = { value = 0, warned = false } end

  --   if (  version_data.major.value ~= Version_Data.major.value
  --     and not version_data.major.warned) then
  --     version_data.major.warned = true
  --     print_fun()
  --   elseif (version_data.minor.value ~= Version_Data.minor.value
  --       and not version_data.major.warned
  --       and not version_data.minor.warned) then
  --     version_data.minor.warned = true
  --     print_fun()
  --   elseif (version_data.bug_fix.value ~= Version_Data.bug_fix.value
  --       and not version_data.major.warned
  --       and not version_data.minor.warned
  --       and not version_data.bug_fix.warned) then
  --     version_data.bug_fix.warned = true
  --     print_fun()
  --   end
  -- end

  return return_val
end

version_validations.more_enemies = true

local _version_validations = version_validations
return version_validations