local Data = require("scripts.data.data")
local Log = require("libs.log.log")
local Max_Distance_Data = require("scripts.data.max-distance-data")
local Weighted_Chunk_Data = require("scripts.data.chunk-data.weighted-chunk-data")

local overmind_data = Data:new()

overmind_data.chunks = {}
overmind_data.max_distance = Max_Distance_Data:new()
overmind_data.peace_time_tick = nil
overmind_data.surface = nil
overmind_data.surface_name = nil
overmind_data.radius = 1
overmind_data.tick = 0
overmind_data.unit_groups = {}
overmind_data.weighted_chunks = Weighted_Chunk_Data:new()

function overmind_data:new(obj)
    Log.debug("overmind_data:new")
    Log.info(obj)

    obj = Data:new(obj) or Data:new()

    local defaults = {
        chunks = {},
        max_distance = Max_Distance_Data:new(),
        peace_time_tick = nil,
        surface = nil,
        surface_name = nil,
        radius = self.radius,
        tick = self.tick,
        unit_groups = {},
        weighted_chunks = Weighted_Chunk_Data:new(),
    }

    for k, v in pairs(defaults) do
        if (obj[k] == nil) then obj[k] = v end
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end

return overmind_data