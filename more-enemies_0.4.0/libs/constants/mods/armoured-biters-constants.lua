-- If already defined, return
if _armoured_biters_constants and _armoured_biters_constants.more_enemies then
  return _armoured_biters_constants
end

local armoured_biters_constants = require("libs.constants.nauvis-constants")
if (not armoured_biters_constants) then error('armoured_biters_constants is nil: require("libs.constants.nauvis-constants") failed') end

table.insert(armoured_biters_constants.nauvis.categories, "leviathan")

armoured_biters_constants.more_enemies = true

local _armoured_biters_constants = armoured_biters_constants

return armoured_biters_constants