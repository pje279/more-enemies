local Data = require("scripts.data.data")
local Log = require("libs.log.log")

local recent_deaths_data = Data:new()

recent_deaths_data.average_deaths_per_second = 0
recent_deaths_data.average_deaths_per_tick = 0
recent_deaths_data.deaths = 0
recent_deaths_data.modifier = 1
recent_deaths_data.tick_current = nil
recent_deaths_data.tick_next = nil
recent_deaths_data.tick_past = nil

function recent_deaths_data:new(obj)
    Log.debug("recent_deaths_data:new")
    Log.info(obj)

    obj = obj and Data:new(obj) or Data:new()

    local defaults = {
        average_deaths_per_second = self.average_deaths_per_second,
        average_deaths_per_tick = self.average_deaths_per_tick,
        deaths = self.deaths,
        modifier = self.modifier,
        tick_current = self.tick_current or game and game.tick,
        tick_next = self.tick_next or game and game.tick,
        tick_past = self.tick_past or game and game.tick,
    }

    for k, v in pairs(defaults) do
        if (obj[k] == nil) then obj[k] = v end
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end

return recent_deaths_data