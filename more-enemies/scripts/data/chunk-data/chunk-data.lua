local Data = require("scripts.data.data")
local Log = require("libs.log.log")
local Pollution_Data = require("scripts.data.chunk-data.pollution-data")
local Recent_Death_Data = require("scripts.data.chunk-data.recent-deaths-data")

local chunk_data = Data:new()

chunk_data.above = nil
chunk_data.below = nil
chunk_data.entity_count = 0
chunk_data.deaths = 0
chunk_data.nearby_spawners = {}
chunk_data.pollution_data = Pollution_Data:new()
chunk_data.recent_deaths = Recent_Death_Data:new()
chunk_data.rocket_launches = 0
chunk_data.surface = nil
chunk_data.surface_name = nil
chunk_data.tick_current = 0
chunk_data.tick_next = 0
chunk_data.tick_past = 0
chunk_data.tick_rocket_launch_witnessed = nil
chunk_data.weight = 0
chunk_data.x = 0
chunk_data.y = 0

function chunk_data:new(obj)
    Log.debug("chunk_data:new")
    Log.info(obj)

    -- obj = obj and Data:new(obj) or Data:new()
    obj = Data:new(obj) or Data:new()

    local defaults = {
        above = self.above,
        below = self.below,
        entity_count = self.entity_count,
        deaths = self.deaths,
        nearby_spawners = {},
        pollution_data = Pollution_Data:new(),
        recent_deaths = Recent_Death_Data:new(),
        rocket_launches = self.rocket_launches,
        surface = self.surface,
        surface_name = self.surface_name,
        tick_current = self.tick_current,
        tick_next = self.tick_next,
        tick_past = self.tick_past,
        tick_rocket_launch_witnessed = self.tick_rocket_launch_witnessed,
        weight = self.weight,
        x = self.x,
        y = self.y,
    }

    for k, v in pairs(defaults) do
        if (obj[k] == nil) then obj[k] = v end
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end

return chunk_data