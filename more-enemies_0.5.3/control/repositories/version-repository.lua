-- If already defined, return
if _version_repository and _version_repository.more_enemies then
  return _version_repository
end

local Log = require("libs.log.log")
local Version_Data = require("control.data.version-data")
local Bug_Fix_Data = require("control.data.versions.bug-fix-data")
local Major_Data = require("control.data.versions.major-data")
local Minor_Data = require("control.data.versions.minor-data")

local version_repository = {}

function version_repository.save_version_data(optionals)
  Log.debug("version_repository.save_version_data")
  Log.info(optionals)

  local return_val = Version_Data:new()

  if (not game) then return return_val end

  optionals = optionals or {}

  if (not storage) then return return_val end
  if (not storage.more_enemies) then storage.more_enemies = {} end
  if (not storage.more_enemies.version_data) then storage.more_enemies.version_data = return_val end

  return_val = storage.more_enemies.version_data
  return_val.created = return_val.created or game.tick
  return_val.updated = return_val.updated or game.tick

  return version_repository.update_version_data(return_val)
end

function version_repository.update_version_data(update_data, optionals)
  Log.debug("version_repository.save_version_data")
  Log.info(update_data)
  Log.info(optionals)

  local return_val = Version_Data:new()

  if (not game) then return return_val end
  if (not update_data) then return return_val end

  optionals = optionals or {}

  if (not storage) then return return_val end
  if (not storage.more_enemies) then storage.more_enemies = {} end
  if (not storage.more_enemies.version_data) then
    -- If it doesn't exist, generate it
    storage.more_enemies.version_data = return_val
    version_repository.save_version_data()
  end

  local version_data = storage.more_enemies.version_data

  for k, v in pairs(update_data) do
    version_data[k] = v
  end

  version_data.updated = game.tick

  -- Don't think this is necessary, but oh well
  storage.more_enemies.version_data = version_data

  return version_data
end

function version_repository.get_version_data(optionals)
  Log.debug("version_repository.get_version_data")
  Log.info(optionals)

  local return_val = Version_Data:new()

  if (not game) then return return_val end

  optionals = optionals or {}

  if (not storage) then return return_val end
  if (not storage.more_enemies) then storage.more_enemies = {} end
  if (not storage.more_enemies.version_data) then
    -- If it doesn't exist, generate it
    storage.more_enemies.version_data = return_val
    version_repository.save_version_data()
  end

  return storage.more_enemies.version_data
end

version_repository.more_enemies = true

local _version_repository = version_repository

return version_repository