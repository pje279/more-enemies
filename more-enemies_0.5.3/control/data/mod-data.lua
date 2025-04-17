local Data = require("control.data.data")
local Log = require("libs.log.log")

local mod_data = Data:new()

mod_data.clone = { count = 0 }
mod_data.staged_clones = {}

function mod_data:new(obj)
  Log.debug("mod_data:new")
  Log.info(obj)

  obj = Data:new(obj) or Data:new()

  local defaults = {
    clone = self.clone,
    staged_clones = self.staged_clones,
  }

  for k, v in pairs(defaults) do
    if (obj[k] == nil) then obj[k] = v end
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end

return mod_data