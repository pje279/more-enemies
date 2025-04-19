local Data = require("control.data.data")
local Log = require("libs.log.log")

local hard_difficulty_data = Data:new()

hard_difficulty_data.order = nil
hard_difficulty_data.name = "HARD"
hard_difficulty_data.string_val = "Hard"
hard_difficulty_data.value = 4
hard_difficulty_data.radius = 46.875
hard_difficulty_data.radius_modifier = 1.5625

function hard_difficulty_data:new(obj)
  Log.debug("hard_difficulty_data:new")
  Log.info(obj)

  obj = Data:new(obj) or Data:new()

  local defaults = {
    order = self.order,
    name = self.name,
    string_val = self.string_val,
    value = self.value,
    radius = self.radius,
    radius_modifier = self.radius_modifier,
  }

  for k, v in pairs(defaults) do
    if (obj[k] == nil) then obj[k] = v end
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end

return hard_difficulty_data