local Data = require("scripts.data.data")
local Log = require("libs.log.log")

local clone_data = Data:new()

clone_data.obj = nil
clone_data.surface = nil
clone_data.group = nil
clone_data.mod_name = nil

function clone_data:new(obj)
  Log.debug("clone_data:new")
  Log.info(obj)

  obj = obj and Data:new(obj) or Data:new()

  local defaults = {
    obj = self.obj,
    surface = self.surface,
    group = self.group,
    mod_name = self.mod_name,
  }

  for k, v in pairs(defaults) do
    if (obj[k] == nil) then obj[k] = v end
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end

return clone_data