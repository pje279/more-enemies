-- If already defined, return
if _toxic_biters_constants and _toxic_biters_constants.more_enemies then
  return _toxic_biters_constants
end

local toxic_biters_constants = {}

toxic_biters_constants.nauvis = {}
toxic_biters_constants.nauvis.biter_toxic = {}
toxic_biters_constants.nauvis.biter_toxic.MAX_COUNT_OF_OWNED_UNITS = 10
toxic_biters_constants.nauvis.biter_toxic.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = 10
toxic_biters_constants.nauvis.biter_toxic.MAX_FRIENDS_AROUND_TO_SPAWN = 7
toxic_biters_constants.nauvis.biter_toxic.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = 7

toxic_biters_constants.nauvis.biter_toxic.MAX_SPAWNING_COOLDOWN = 360
toxic_biters_constants.nauvis.biter_toxic.MIN_SPAWNING_COOLDOWN = 150

toxic_biters_constants.nauvis.categories = {
  SMALL = "small",
  MEDIUM = "medium",
  BIG = "big",
  BEHEMOTH = "behemoth",
  LEVIATHAN = "leviathan"
}

toxic_biters_constants.more_enemies = true

local _toxic_biters_constants = toxic_biters_constants

return toxic_biters_constants