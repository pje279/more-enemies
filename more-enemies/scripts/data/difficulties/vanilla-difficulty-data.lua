local Data = require("scripts.data.data")
local Log = require("libs.log.log")

local vanilla_difficulty_data = Data:new()

vanilla_difficulty_data.order = nil
vanilla_difficulty_data.name = "VANILLA"
vanilla_difficulty_data.string_val = "Vanilla"
vanilla_difficulty_data.value = 1
vanilla_difficulty_data.radius = 30
vanilla_difficulty_data.radius_modifier = 1

function vanilla_difficulty_data:new(obj)
  Log.debug("vanilla_difficulty_data:new")
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

return vanilla_difficulty_data