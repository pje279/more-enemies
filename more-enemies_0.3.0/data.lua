log("in data")

require("prototypes.spawners.nauvis")

log("if mods")
if (mods and mods["space-age"]) then
  log("SA found")
  require("prototypes.spawners.gleba")
end

log("import map-settings")
require("prototypes.map-settings")

log("data done")