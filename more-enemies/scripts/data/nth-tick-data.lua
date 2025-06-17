local Data = require("scripts.data.data")
local Log = require("libs.log.log")

local nth_tick_data = Data:new()

nth_tick_data.current = true
nth_tick_data.previous = true

function nth_tick_data:new(obj)
  Log.debug("nth_tick_data:new")
  Log.info(obj)

  obj = Data:new(obj) or Data:new()

  local defaults = {
    current = self.current,
    previous = self.previous,
  }

  for k, v in pairs(defaults) do
    if (obj[k] == nil) then obj[k] = v end
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end

return nth_tick_data