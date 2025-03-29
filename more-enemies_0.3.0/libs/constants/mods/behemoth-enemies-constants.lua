-- If already defined, return
if _behemoth_enemies_constants and _behemoth_enemies_constants.more_enemies then
  return _behemoth_enemies_constants
end

local behemoth_enemies_constants = require("libs.constants.gleba-constants")
if (not behemoth_enemies_constants) then error('gleba_constants is nil: require("libs.constants.gleba-constants") failed') end

table.insert(behemoth_enemies_constants.gleba.categories, "behemoth")

behemoth_enemies_constants.more_enemies = true

local _behemoth_enemies_constants = behemoth_enemies_constants

return behemoth_enemies_constants