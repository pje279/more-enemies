-- If already defined, return
if _bream_constants and _bream_constants.more_enemies then
  return _bream_constants
end

local bream_constants = {}

bream_constants.name = "BREAM"

bream_constants.more_enemies = true

local _bream_constants = bream_constants

return bream_constants