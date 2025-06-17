local Data = require("scripts.data.data")
local Log = require("libs.log.log")
local Mod_Data = require("scripts.data.mod-data")
local Nth_Tick_Data = require("scripts.data.nth-tick-data")
local Version_Data = require("scripts.data.version-data")
local Overflow_Clone_Attempts_Data = require("scripts.data.overflow-clone-attempts-data")

local more_enemies_data = Data:new()

more_enemies_data.clones = {}
more_enemies_data.clone = { count = 0 }

more_enemies_data.difficulties = {}

more_enemies_data.do_nth_tick = false

more_enemies_data.groups = {}

more_enemies_data.mod = Mod_Data:new()
more_enemies_data.valid = true

more_enemies_data.nth_tick_cleanup_complete = Nth_Tick_Data:new()
more_enemies_data.nth_tick_cleanup_complete.valid = true

more_enemies_data.nth_tick_complete = Nth_Tick_Data:new()
more_enemies_data.nth_tick_complete.valid = true

more_enemies_data.overflow_clone_attempts = Overflow_Clone_Attempts_Data:new()

more_enemies_data.staged_clones = {}

more_enemies_data.version_data = Version_Data:new()

function more_enemies_data:new(obj)
  Log.debug("more_enemies_data:new")
  Log.info(obj)

  obj = Data:new(obj) or Data:new()

  local defaults = {
    clones = self.clones,
    clone = self.clone,
    difficulties = self.difficulties,
    do_nth_tick = self.do_nth_tick,
    groups = self.groups,
    nth_tick_cleanup_complete = self.nth_tick_cleanup_complete,
    nth_tick_complete = self.nth_tick_complete,
    mod = self.mod,
    overflow_clone_attempts = self.overflow_clone_attempts,
    staged_clones = self.staged_clones,
    version_data = self.version_data,
  }

  for k, v in pairs(defaults) do
    if (obj[k] == nil) then obj[k] = v end
  end

  setmetatable(obj, self)
  self.__index = self
  return obj
end

return more_enemies_data