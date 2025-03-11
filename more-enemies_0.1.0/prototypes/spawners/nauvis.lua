--
-- Get the settings values

-- Biters
local max_count_of_owned_units_biter = settings.startup["more-enemies-spawner-nauvis-max-count-of-owned-units"]
local max_friends_around_to_spawn_biter = settings.startup["more-enemies-spawner-nauvis-max-friends-around-to-spawn"]

-- Spitters
local max_count_of_owned_units_spitter = settings.startup["more-enemies-spawner-nauvis-max-count-of-owned-units"]
local max_friends_around_to_spawn_spitter = settings.startup["more-enemies-spawner-nauvis-max-friends-around-to-spawn"]

--
-- If each setting is valid, make appropriate change

-- Biters
if (max_count_of_owned_units_biter and max_count_of_owned_units_biter.value) then
  data.raw["unit-spawner"]["biter-spawner"].max_count_of_owned_units = max_count_of_owned_units_biter.value
end

if (max_friends_around_to_spawn_biter and max_friends_around_to_spawn_biter.value) then
  data.raw["unit-spawner"]["biter-spawner"].max_friends_around_to_spawn = max_friends_around_to_spawn_biter.value
end

-- Spitters
if (max_count_of_owned_units_spitter and max_count_of_owned_units_spitter.value) then
  data.raw["unit-spawner"]["spitter-spawner"].max_count_of_owned_units = max_count_of_owned_units_spitter.value
end

if (max_friends_around_to_spawn_spitter and max_friends_around_to_spawn_spitter.value) then
  data.raw["unit-spawner"]["spitter-spawner"].max_friends_around_to_spawn = max_friends_around_to_spawn_biter.value
end