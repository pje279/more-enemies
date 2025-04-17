local Data = require("control.data.data")
local Log = require("libs.log.log")

local easy_difficulty_data = Data:new()

easy_difficulty_data.order = nil
easy_difficulty_data.name = "EASY"
easy_difficulty_data.string_val = "Easy"
easy_difficulty_data.value = 0.1
easy_difficulty_data.radius = 15
easy_difficulty_data.radius_modifier = 0.5
easy_difficulty_data.valid = true

function easy_difficulty_data:new(obj)
  Log.debug("easy_difficulty_data:new")
  Log.info(obj)

  obj = Data:new(obj) or Data:new()

  local defaults = {
    order = self.order,
    name = self.name,
    string_val = self.string_val,
    value = self.value,
    radius = self.radius,
    radius_modifier = self.radius_modifier,
    valid = self.valid,
  }

  for k, v in pairs(defaults) do
    if (obj[k] == nil) then obj[k] = v end
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end

return easy_difficulty_data