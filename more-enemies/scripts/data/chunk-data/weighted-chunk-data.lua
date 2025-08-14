local Data = require("scripts.data.data")
local Log = require("libs.log.log")

local weighted_chunk_data = Data:new()

weighted_chunk_data.chunks_weighted = {}
weighted_chunk_data.highest = nil
weighted_chunk_data.size = 0

function weighted_chunk_data:new(obj)
    Log.debug("weighted_chunk_data:new")
    Log.info(obj)

    -- obj = obj and Data:new(obj) or Data:new()
    obj = Data:new(obj) or Data:new()

    local defaults = {
        chunks_weighted = {},
        highest = self.highest,
        size = self.size,
    }

    for k, v in pairs(defaults) do
        if (obj[k] == nil) then obj[k] = v end
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end

return weighted_chunk_data