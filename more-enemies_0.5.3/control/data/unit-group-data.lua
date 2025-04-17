local Data = require("control.data.data")
local Log = require("libs.log.log")

local unit_group_data = Data:new()

unit_group_data.group = nil
unit_group_data.count = 0
unit_group_data.max_count = 0
unit_group_data.mod_name = nil

function unit_group_data:new(obj)
  Log.debug("unit_group_data:new")
  Log.info(obj)

  obj = Data:new(obj) or Data:new()

  local defaults = {
    created = self.created,
    updated = self.updated,
    valid = self.valid,
    group = self.group,
    count = self.count,
    max_count = self.max_count,
    mod_name = self.mod_name,
  }

  for k, v in pairs(defaults) do
    if (obj[k] == nil) then obj[k] = v end
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end

return unit_group_data