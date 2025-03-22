-- If already defined, return
if _constants and _constants.more_enemies then
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

constants.nauvis.categories = {
  SMALL = "small",
  MEDIUM = "medium",
  BIG = "big",
  BEHEMOTH = "behemoth"
}

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

if (mods and mods["space-age"]) then
  if (mods and mods["behemoth-enemies"]) then
    constants.gleba.categories = {
      SMALL = "small",
      MEDIUM = "medium",
      BIG = "big",
      BEHEMOTH = "behemoth"
    }
  else
    constants.gleba.categories = {
      SMALL = "small",
      MEDIUM = "medium",
      BIG = "big"
    }
  end

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
end

constants.difficulty = {}

constants.difficulty.EASY = {}
constants.difficulty.EASY.value = 0.1
constants.difficulty.EASY.name = "Easy"

constants.difficulty.VANILLA = {}
constants.difficulty.VANILLA.value = 1
constants.difficulty.VANILLA.name = "Vanilla"

constants.difficulty.VANILLA_PLUS = {}
constants.difficulty.VANILLA_PLUS.value = 1.75
constants.difficulty.VANILLA_PLUS.name = "Vanilla+"

constants.difficulty.HARD = {}
constants.difficulty.HARD.value = 4
constants.difficulty.HARD.name = "Hard"

constants.difficulty.INSANITY = {}
constants.difficulty.INSANITY.value = 10
constants.difficulty.INSANITY.name = "Insanity"

-- constants.difficulty = {
--   EASY = "Easy",
--   VANILLA = "Vanilla",
--   VANILLA_PLUS = "Vanilla+",
--   HARD = "Hard",
--   INSANITY = "Insanity"
-- }

constants.more_enemies = true

local _constants = constants

return constants