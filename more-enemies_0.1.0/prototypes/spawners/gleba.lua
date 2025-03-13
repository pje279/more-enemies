--
-- If each setting is valid, make appropriate change

--
-- Small spawners

local max_count_of_owned_units_small = settings.startup["more-enemies-spawner-gleba-small-max-count-of-owned-units"]
if (max_count_of_owned_units_small and max_count_of_owned_units_small.value) then
  data.raw["unit-spawner"]["gleba-spawner-small"].max_count_of_owned_units = max_count_of_owned_units_small.value
end

local max_friends_around_to_spawn_small = settings.startup["more-enemies-spawner-gleba-small-max-friends-around-to-spawn"]
if (max_friends_around_to_spawn_small and max_friends_around_to_spawn_small.value) then
  data.raw["unit-spawner"]["gleba-spawner-small"].max_friends_around_to_spawn = max_friends_around_to_spawn_small.value
end

--
-- Regular spawners

local max_count_of_owned_units = settings.startup["more-enemies-spawner-gleba-max-count-of-owned-units"]
if (max_count_of_owned_units and max_count_of_owned_units.value) then
  data.raw["unit-spawner"]["gleba-spawner"].max_count_of_owned_units = max_count_of_owned_units.value
end

local max_count_of_owned_defensive_units = settings.startup["more-enemies-spawner-gleba-max-count-of-owned-defensive-units"]
if (max_count_of_owned_defensive_units and max_count_of_owned_defensive_units.value) then
  data.raw["unit-spawner"]["gleba-spawner"].max_count_of_owned_defensive_units = max_count_of_owned_defensive_units.value
end

local max_friends_around_to_spawn = settings.startup["more-enemies-spawner-gleba-max-friends-around-to-spawn"]
if (max_friends_around_to_spawn and max_friends_around_to_spawn.value) then
  data.raw["unit-spawner"]["gleba-spawner"].max_friends_around_to_spawn = max_friends_around_to_spawn.value
end

local max_defensive_friends_around_to_spawn = settings.startup["more-enemies-spawner-gleba-max-defensive-friends-around-to-spawn"]
if (max_defensive_friends_around_to_spawn and max_defensive_friends_around_to_spawn.value) then
  data.raw["unit-spawner"]["gleba-spawner"].max_defensive_friends_around_to_spawn = max_defensive_friends_around_to_spawn.value
end

local max_spawning_cooldown_gleba = settings.startup["more-enemies-max-spawning-cooldown-gleba"]
local min_spawning_cooldown_gleba = settings.startup["more-enemies-min-spawning-cooldown-gleba"]
if (    max_spawning_cooldown_gleba
    and max_spawning_cooldown_gleba.value
    and min_spawning_cooldown_gleba
    and min_spawning_cooldown_gleba.value
  ) then
      data.raw["unit-spawner"]["gleba-spawner-small"].spawning_cooldown = {max_spawning_cooldown_gleba.value, min_spawning_cooldown_gleba.value}
      data.raw["unit-spawner"]["gleba-spawner"].spawning_cooldown = {max_spawning_cooldown_gleba.value, min_spawning_cooldown_gleba.value}
end