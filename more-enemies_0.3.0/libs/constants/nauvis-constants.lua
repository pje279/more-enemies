-- If already defined, return
if _nauvis_constants and _nauvis_constants.more_enemies then
  return _nauvis_constants
end

local nauvis_constants = require("libs.constants.constants")
if (not nauvis_constants) then error('nauvis_constants is nil: require("libs.constants.constants") failed') end

--
-- { Nauvis } --

nauvis_constants.nauvis = {}
nauvis_constants.nauvis.categories = {
  SMALL = "small",
  MEDIUM = "medium",
  BIG = "big",
  BEHEMOTH = "behemoth"
}

--
-- Biter Spawner
nauvis_constants.nauvis.biter = {}
nauvis_constants.nauvis.biter.MAX_COUNT_OF_OWNED_UNITS = 7
nauvis_constants.nauvis.biter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = 7
nauvis_constants.nauvis.biter.MAX_FRIENDS_AROUND_TO_SPAWN = 5
nauvis_constants.nauvis.biter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = 5

nauvis_constants.nauvis.biter.MAX_SPAWNING_COOLDOWN = 360
nauvis_constants.nauvis.biter.MIN_SPAWNING_COOLDOWN = 150

--
-- Spitter Spawner
nauvis_constants.nauvis.spitter = {}
nauvis_constants.nauvis.spitter.MAX_COUNT_OF_OWNED_UNITS = 7
nauvis_constants.nauvis.spitter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = 7
nauvis_constants.nauvis.spitter.MAX_FRIENDS_AROUND_TO_SPAWN = 5
nauvis_constants.nauvis.spitter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = 5

nauvis_constants.nauvis.spitter.MAX_SPAWNING_COOLDOWN = 360
nauvis_constants.nauvis.spitter.MIN_SPAWNING_COOLDOWN = 150


nauvis_constants.more_enemies = true

local _nauvis_constants = nauvis_constants

return nauvis_constants