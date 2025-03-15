-- If already defined, return
if _constants then
  return _constants
end

local constants = {
  nauvis = {
    biter = {},
    spitter = {}
  },
  gleba = {
    small = {},
    regular = {}
  }
}

--
-- { Nauvis } --

--
-- Biter Spawner
constants.nauvis.biter.MAX_COUNT_OF_OWNED_UNITS = 7
constants.nauvis.biter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = 7
constants.nauvis.biter.MAX_FRIENDS_AROUND_TO_SPAWN = 5
constants.nauvis.biter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = 5

constants.nauvis.biter.MAX_SPAWNING_COOLDOWN = 360
constants.nauvis.biter.MIN_SPAWNING_COOLDOWN = 150

--
-- Spitter Spawner
constants.nauvis.spitter.MAX_COUNT_OF_OWNED_UNITS = 7
constants.nauvis.spitter.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = 7
constants.nauvis.spitter.MAX_FRIENDS_AROUND_TO_SPAWN = 5
constants.nauvis.spitter.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = 5

constants.nauvis.spitter.MAX_SPAWNING_COOLDOWN = 360
constants.nauvis.spitter.MIN_SPAWNING_COOLDOWN = 150

--
-- { Gleba } --

--
-- Small
constants.gleba.small.MAX_COUNT_OF_OWNED_UNITS = 1
constants.gleba.small.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = 1
constants.gleba.small.MAX_FRIENDS_AROUND_TO_SPAWN = 2
constants.gleba.small.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = 2

constants.gleba.small.MAX_SPAWNING_COOLDOWN = 360
constants.gleba.small.MIN_SPAWNING_COOLDOWN = 150

--
-- Regular
constants.gleba.regular.MAX_COUNT_OF_OWNED_UNITS = 2
constants.gleba.regular.MAX_COUNT_OF_OWNED_DEFENSIVE_UNITS = 1
constants.gleba.regular.MAX_FRIENDS_AROUND_TO_SPAWN = 3
constants.gleba.regular.MAX_DEFENSIVE_FRIENDS_AROUND_TO_SPAWN = 2

constants.gleba.regular.MAX_SPAWNING_COOLDOWN = 360
constants.gleba.regular.MIN_SPAWNING_COOLDOWN = 150

constants.difficulty = {
  EASY = "Easy",
  VANILLA = "Vanilla",
  VANILLA_PLUS = "Vanilla+",
  HARD = "Hard",
  INSANITY = "Insanity"
}

_constants = constants
return constants