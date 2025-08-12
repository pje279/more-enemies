-- local Attack_Group_Data = require("scripts.data.attack-group-data")
local Data = require("scripts.data.data")
local Log = require("libs.log.log")
local Mod_Data = require("scripts.data.mod-data")
local Nth_Tick_Data = require("scripts.data.nth-tick-data")
local Version_Data = require("scripts.data.version-data")

local more_enemies_data = Data:new()

more_enemies_data.attack_group = {}

more_enemies_data.clones = {}
more_enemies_data.clone = {}

more_enemies_data.difficulties = {}

more_enemies_data.do_nth_tick = false

more_enemies_data.groups = {}

more_enemies_data.mod = Mod_Data:new()

more_enemies_data.nth_tick_cleanup_complete = Nth_Tick_Data:new()
more_enemies_data.nth_tick_cleanup_complete.valid = true

more_enemies_data.nth_tick_complete = Nth_Tick_Data:new()
more_enemies_data.nth_tick_complete.valid = true

more_enemies_data.overmind = {}

more_enemies_data.staged_clone = {}
more_enemies_data.staged_clones = {}

more_enemies_data.valid = true

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
    staged_clone = self.staged_clone,
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

function more_enemies_data:is_valid()
  Log.debug("more_enemies_data:is_valid")

  if (not self.valid) then return false end
  if (self.version_data:to_string() ~= (Version_Data:new()):to_string()) then return false end

  return true
end

return more_enemies_data