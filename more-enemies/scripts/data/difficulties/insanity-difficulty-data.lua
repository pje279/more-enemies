local Data = require("scripts.data.data")
local Log = require("libs.log.log")

local insanity_difficulty_data = Data:new()

insanity_difficulty_data.order = nil
insanity_difficulty_data.name = "INSANITY"
insanity_difficulty_data.string_val = "Insanity"
insanity_difficulty_data.value = 11
insanity_difficulty_data.radius = 58.59375
insanity_difficulty_data.radius_modifier = 1.953125

function insanity_difficulty_data:new(obj)
  Log.debug("insanity_difficulty_data:new")
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

return insanity_difficulty_data