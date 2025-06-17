-- If already defined, return
if _overflow_clone_attempts_repository and _overflow_clone_attempts_repository.more_enemies then
  return _overflow_clone_attempts_repository
end

local Log = require("libs.log.log")
local More_Enemies_Data = require("scripts.data.more-enemies-data")
local Overflow_Clone_Attempts_Data = require("scripts.data.overflow-clone-attempts-data")

local overflow_clone_attempts_repository = {}

function overflow_clone_attempts_repository.save_overflow_clone_attempts_data(optionals)
  Log.debug("overflow_clone_attempts_repository.save_overflow_clone_attempts_data")
  Log.info(optionals)

  local return_val = Overflow_Clone_Attempts_Data:new()

  if (not game) then return return_val end

  optionals = optionals or {}

  if (not storage) then return return_val end
  if (not storage.more_enemies) then storage.more_enemies = More_Enemies_Data:new() end
  if (not storage.more_enemies.overflow_clone_attempts) then storage.more_enemies.overflow_clone_attempts = return_val end

  return_val = storage.more_enemies.overflow_clone_attempts
  return_val.created = return_val.created or game.tick

  return overflow_clone_attempts_repository.update_overflow_clone_attempts_data(return_val)
end

function overflow_clone_attempts_repository.update_overflow_clone_attempts_data(update_data, optionals)
  Log.debug("overflow_clone_attempts_repository.update_overflow_clone_attempts_data")
  Log.info(update_data)
  Log.info(optionals)

  local return_val = Overflow_Clone_Attempts_Data:new()

  if (not game) then return return_val end
  if (not update_data) then return return_val end

  optionals = optionals or {}

  if (not storage) then return return_val end
  if (not storage.more_enemies) then storage.more_enemies = More_Enemies_Data:new() end
  if (not storage.more_enemies.overflow_clone_attempts) then
    -- If it doesn't exist, generate it
    storage.more_enemies.overflow_clone_attempts = return_val
    overflow_clone_attempts_repository.save_version_data()
  end

  local overflow_clone_attempts_data = storage.more_enemies.overflow_clone_attempts

  for k, v in pairs(update_data) do
    overflow_clone_attempts_data[k] = v
  end

  overflow_clone_attempts_data.updated = game.tick

  -- Don't think this is necessary, but oh well
  storage.more_enemies.overflow_clone_attempts = overflow_clone_attempts_data

  return version_data
end

function overflow_clone_attempts_repository.get_overflow_clone_attempts_data(optionals)
  Log.debug("overflow_clone_attempts_repository.get_overflow_clone_attempts_data")
  Log.info(optionals)

  local return_val = Overflow_Clone_Attempts_Data:new()

  if (not game) then return return_val end

  optionals = optionals or {}

  if (not storage) then return return_val end
  if (not storage.more_enemies) then storage.more_enemies = More_Enemies_Data:new() end
  if (not storage.more_enemies.overflow_clone_attempts) then
    -- If it doesn't exist, generate it
    storage.more_enemies.overflow_clone_attempts = return_val
    overflow_clone_attempts_repository.save_overflow_clone_attempts_data()
  end

  return storage.more_enemies.overflow_clone_attempts
end

overflow_clone_attempts_repository.more_enemies = true

local _overflow_clone_attempts_repository = overflow_clone_attempts_repository

return overflow_clone_attempts_repository