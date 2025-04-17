local Data = require("control.data.data")
local Log = require("libs.log.log")
local Vanilla_Difficulty_Data = require("control.data.difficulties.vanilla-difficulty-data")

local difficulty_data = Data:new()

difficulty_data.difficulty = Vanilla_Difficulty_Data:new()
difficulty_data.surface = nil
difficulty_data.entities_spawned = 0

function difficulty_data:new(obj)
  Log.debug("difficulty_data:new")
  Log.info(obj)

  obj = Data:new(obj) or Data:new()

  local defaults = {
    difficulty = self.difficulty,
    surface = self.surface,
    entities_spawned = self.entities_spawned,
  }

  for k, v in pairs(defaults) do
    if (obj[k] == nil) then obj[k] = v end
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end

return difficulty_data