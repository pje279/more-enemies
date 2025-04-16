local Data = require("control.data.data")
local Log = require("libs.log.log")

local vanilla_plus_difficulty_data = Data:new()

vanilla_plus_difficulty_data.order = nil
vanilla_plus_difficulty_data.name = "VANILLA_PLUS"
vanilla_plus_difficulty_data.string_val = "Vanilla+"
vanilla_plus_difficulty_data.value = 1.75
vanilla_plus_difficulty_data.radius = 37.5
vanilla_plus_difficulty_data.radius_modifier = 1.25
vanilla_plus_difficulty_data.valid = true

function vanilla_plus_difficulty_data:new (obj)
  Log.debug("vanilla_plus_difficulty_data:new")
  Log.info(obj)

  obj = obj or Data:new()

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

return vanilla_plus_difficulty_data