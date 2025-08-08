-- If already defined, return
if _spawn_constants and _spawn_constants.more_enemies then
  return _spawn_constants
end

local Armoured_Biters_Constants = require("libs.constants.mods.armoured-biters-constants")
local Behemoth_Enemies_Constants = require("libs.constants.mods.behemoth-enemies-constants")
local Gleba_Constants = require("libs.constants.gleba-constants")
local Nauvis_Constants = require("libs.constants.nauvis-constants")

local spawn_constants = {}

spawn_constants.name = {}

-- for k,v in pairs(Nauvis_Constants.nauvis.categories) do
--   table.insert(spawn_constants.filter, { filter = "name", name = v .. "-biter"})
--   table.insert(spawn_constants.filter, { filter = "name", name = v .. "-spitter"})
-- end

-- if (script and script.active_mods and script.active_mods["ArmouredBiters"]) then
--   for k,v in pairs(Armoured_Biters_Constants.nauvis.categories) do
--     table.insert(spawn_constants.filter, { filter = "name", name = v .. "-armoured-biter"})
--   end
-- end

-- for k,v in pairs(Gleba_Constants.gleba.categories) do
--   table.insert(spawn_constants.filter, { filter = "name", name = v .. "-wriggler-pentapod" })
--   table.insert(spawn_constants.filter, { filter = "name", name = v .. "-strafer-pentapod"})
--   table.insert(spawn_constants.filter, { filter = "name", name = v .. "-stomper-pentapod"})
-- end

-- if ((mods and mods["space-age"] and mods["behemoth-enemies"]) or (script and script.active_mods and script.active_mods["space-age"] and script.active_mods["behemoth-enemies"])) then
--   table.insert(spawn_constants.filter, { filter = "name", name = Behemoth_Enemies_Constants.prefix .. "-wriggler-pentapod" })
--   table.insert(spawn_constants.filter, { filter = "name", name = Behemoth_Enemies_Constants.prefix .. "-strafer-pentapod"})
--   table.insert(spawn_constants.filter, { filter = "name", name = Behemoth_Enemies_Constants.prefix .. "-stomper-pentapod"})
-- end

-- for k,v in pairs(Nauvis_Constants.nauvis.categories) do
--   table.insert(spawn_constants.name, { v .. "-biter"})
--   table.insert(spawn_constants.name, { v .. "-spitter"})
-- end

-- if (script and script.active_mods and script.active_mods["ArmouredBiters"]) then
--   for k,v in pairs(Armoured_Biters_Constants.nauvis.categories) do
--     table.insert(spawn_constants.name, { v .. "-armoured-biter"})
--   end
-- end

-- for k,v in pairs(Gleba_Constants.gleba.categories) do
--   table.insert(spawn_constants.name, { v .. "-wriggler-pentapod" })
--   table.insert(spawn_constants.name, { v .. "-strafer-pentapod"})
--   table.insert(spawn_constants.name, { v .. "-stomper-pentapod"})
-- end

-- if ((mods and mods["space-age"] and mods["behemoth-enemies"]) or (script and script.active_mods and script.active_mods["space-age"] and script.active_mods["behemoth-enemies"])) then
--   table.insert(spawn_constants.name, { Behemoth_Enemies_Constants.prefix .. "-wriggler-pentapod" })
--   table.insert(spawn_constants.name, { Behemoth_Enemies_Constants.prefix .. "-strafer-pentapod"})
--   table.insert(spawn_constants.name, { Behemoth_Enemies_Constants.prefix .. "-stomper-pentapod"})
-- end
for k,v in pairs(Nauvis_Constants.nauvis.categories) do
  table.insert(spawn_constants.name, v .. "-biter")
  table.insert(spawn_constants.name, v .. "-spitter")
end

if (script and script.active_mods and script.active_mods["ArmouredBiters"]) then
  for k,v in pairs(Armoured_Biters_Constants.nauvis.categories) do
    table.insert(spawn_constants.name, v .. "-armoured-biter")
  end
end

for k,v in pairs(Gleba_Constants.gleba.categories) do
  table.insert(spawn_constants.name, v .. "-wriggler-pentapod")
  table.insert(spawn_constants.name, v .. "-strafer-pentapod")
  table.insert(spawn_constants.name, v .. "-stomper-pentapod")
end

if ((mods and mods["space-age"] and mods["behemoth-enemies"]) or (script and script.active_mods and script.active_mods["space-age"] and script.active_mods["behemoth-enemies"])) then
  table.insert(spawn_constants.name, Behemoth_Enemies_Constants.prefix .. "-wriggler-pentapod")
  table.insert(spawn_constants.name, Behemoth_Enemies_Constants.prefix .. "-strafer-pentapod")
  table.insert(spawn_constants.name, Behemoth_Enemies_Constants.prefix .. "-stomper-pentapod")
end

spawn_constants.more_enemies = true

local _spawn_constants = spawn_constants

return spawn_constants