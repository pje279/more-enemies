-- If already defined, return
if _armoured_biters_constants and _armoured_biters_constants.more_enemies then
  return _armoured_biters_constants
end

local armoured_biters_constants = {}

armoured_biters_constants.nauvis = {}
armoured_biters_constants.nauvis.biter_armoured = {}
armoured_biters_constants.nauvis.biter_armoured.MAX_COUNT_OF_OWNED_UNITS = 7
armoured_biters_constants.nauvis.biter_armoured.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = 7
armoured_biters_constants.nauvis.biter_armoured.MAX_FRIENDS_AROUND_TO_SPAWN = 5
armoured_biters_constants.nauvis.biter_armoured.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = 5

armoured_biters_constants.nauvis.biter_armoured.MAX_SPAWNING_COOLDOWN = 360
armoured_biters_constants.nauvis.biter_armoured.MIN_SPAWNING_COOLDOWN = 150

armoured_biters_constants.nauvis.categories = {
  SMALL = "small",
  MEDIUM = "medium",
  BIG = "big",
  BEHEMOTH = "behemoth",
  LEVIATHAN = "leviathan"
}

armoured_biters_constants.more_enemies = true

local _armoured_biters_constants = armoured_biters_constants

return armoured_biters_constants