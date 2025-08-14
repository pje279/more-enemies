local Data = require("scripts.data.data")
local Log = require("libs.log.log")

local pollution_data = Data:new()

pollution_data.pollution = 0
pollution_data.tick_current = 0
pollution_data.tick_next = 0
pollution_data.tick_past = 0

function pollution_data:new(obj)
    Log.debug("pollution_data:new")
    Log.info(obj)

    obj = obj and Data:new(obj) or Data:new()

    local defaults = {
        pollution = self.pollution,
        tick_current = self.tick_current,
        tick_next = self.tick_next,
        tick_past = self.tick_past,
    }

    for k, v in pairs(defaults) do
        if (obj[k] == nil) then obj[k] = v end
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end

return pollution_data