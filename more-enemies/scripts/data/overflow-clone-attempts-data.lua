local Data = require("scripts.data.data")
local Log = require("libs.log.log")

local overflow_clone_attempts_data = Data:new()

overflow_clone_attempts_data.count = 0

overflow_clone_attempts_data.warned =
{
  none = false,
  error = false,
  warn = false,
  info = false,
}

function overflow_clone_attempts_data:new(obj)
  Log.debug("version_data:new")
  Log.info(obj)

  obj = Data:new(obj) or Data:new()

  local defaults = {
    count = self.count,
    warned = self.warned,
  }

  for k, v in pairs(defaults) do
    if (obj[k] == nil) then obj[k] = v end
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end

return overflow_clone_attempts_data