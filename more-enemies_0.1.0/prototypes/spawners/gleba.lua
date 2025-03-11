--
-- Get the settings values

-- small spawners
local max_count_of_owned_units_small = settings.startup["more-enemies-spawner-gleba-small-max-count-of-owned-units"]
local max_friends_around_to_spawn_small = settings.startup["more-enemies-spawner-gleba-small-max-friends-around-to-spawn"]

-- regular spawners
local max_count_of_owned_units = settings.startup["more-enemies-spawner-gleba-max-count-of-owned-units"]
local max_count_of_owned_defensive_units = settings.startup["more-enemies-spawner-gleba-max-count-of-owned-defensive-units"]
local max_friends_around_to_spawn = settings.startup["more-enemies-spawner-gleba-max-friends-around-to-spawn"]
local max_defensive_friends_around_to_spawn = settings.startup["more-enemies-spawner-gleba-max-defensive-friends-around-to-spawn"]

--
-- If each setting is valid, make appropriate change

-- Small spawners
if (max_count_of_owned_units_small and max_count_of_owned_units_small.value) then
  data.raw["unit-spawner"]["gleba-spawner-small"].max_count_of_owned_units = max_count_of_owned_units_small.value
end

if (max_friends_around_to_spawn_small and max_friends_around_to_spawn_small.value) then
  data.raw["unit-spawner"]["gleba-spawner-small"].max_friends_around_to_spawn = max_friends_around_to_spawn_small.value
end

-- Regular spawners
if (max_count_of_owned_units and max_count_of_owned_units.value) then
  data.raw["unit-spawner"]["gleba-spawner"].max_count_of_owned_units = max_count_of_owned_units.value
end

if (max_count_of_owned_defensive_units and max_count_of_owned_defensive_units.value) then
  data.raw["unit-spawner"]["gleba-spawner"].max_count_of_owned_defensive_units = max_count_of_owned_defensive_units.value
end

if (max_friends_around_to_spawn and max_friends_around_to_spawn.value) then
  data.raw["unit-spawner"]["gleba-spawner"].max_friends_around_to_spawn = max_friends_around_to_spawn.value
end

if (max_defensive_friends_around_to_spawn and max_defensive_friends_around_to_spawn.value) then
  data.raw["unit-spawner"]["gleba-spawner"].max_defensive_friends_around_to_spawn = max_defensive_friends_around_to_spawn.value
end