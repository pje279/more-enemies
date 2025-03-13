local prefixes = {
  "small",
  "medium",
  "big",
  "behemoth"
}

for k,v in pairs(prefixes) do
  data.raw["unit"][v .. "-biter"].ai_settings.size_in_group = 0.5
  data.raw["unit"][v .. "-spitter"].ai_settings.size_in_group = 0.5
end

--
-- If each setting is valid, make appropriate change

--
-- Biters

local max_count_of_owned_units_biter = settings.startup["more-enemies-spawner-nauvis-max-count-of-owned-units-biter"]
if (max_count_of_owned_units_biter and max_count_of_owned_units_biter.value) then
  data.raw["unit-spawner"]["biter-spawner"].max_count_of_owned_units = max_count_of_owned_units_biter.value
end

local max_count_of_owned_defensive_units_biter = settings.startup["more-enemies-spawner-nauvis-max-count-of-owned-defensive-units-biter"]
if (max_count_of_owned_defensive_units_biter and max_count_of_owned_defensive_units_biter.value) then
  data.raw["unit-spawner"]["biter-spawner"].max_count_of_owned_defensive_units = max_count_of_owned_defensive_units_biter.value
end

local max_friends_around_to_spawn_biter = settings.startup["more-enemies-spawner-nauvis-max-friends-around-to-spawn-biter"]
if (max_friends_around_to_spawn_biter and max_friends_around_to_spawn_biter.value) then
  data.raw["unit-spawner"]["biter-spawner"].max_friends_around_to_spawn = max_friends_around_to_spawn_biter.value
end

local max_defensive_friends_around_to_spawn_biter = settings.startup["more-enemies-spawner-nauvis-max-defensive-friends-around-to-spawn-biter"]
if (max_defensive_friends_around_to_spawn_biter and max_defensive_friends_around_to_spawn_biter.value) then
  data.raw["unit-spawner"]["biter-spawner"].max_defensive_friends_around_to_spawn = max_defensive_friends_around_to_spawn_biter.value
end

local max_spawning_cooldown_biters = settings.startup["more-enemies-max-spawning-cooldown-biter"]
local min_spawning_cooldown_biters = settings.startup["more-enemies-min-spawning-cooldown-biter"]
if (    max_spawning_cooldown_biters
    and max_spawning_cooldown_biters.value
    and min_spawning_cooldown_biters
    and min_spawning_cooldown_biters.value) then
      data.raw["unit-spawner"]["biter-spawner"].spawning_cooldown = {max_spawning_cooldown_biters.value, min_spawning_cooldown_biters.value}
end

--
-- Spitters

local max_count_of_owned_units_spitter = settings.startup["more-enemies-spawner-nauvis-max-count-of-owned-units-spitter"]
if (max_count_of_owned_units_spitter and max_count_of_owned_units_spitter.value) then
  data.raw["unit-spawner"]["spitter-spawner"].max_count_of_owned_units = max_count_of_owned_units_spitter.value
end

local max_count_of_owned_defensive_units_spitter = settings.startup["more-enemies-spawner-nauvis-max-count-of-owned-defensive-units-spitter"]
if (max_count_of_owned_defensive_units_spitter and max_count_of_owned_defensive_units_spitter.value) then
  data.raw["unit-spawner"]["biter-spawner"].max_count_of_owned_defensive_units = max_count_of_owned_defensive_units_spitter.value
end

local max_friends_around_to_spawn_spitter = settings.startup["more-enemies-spawner-nauvis-max-friends-around-to-spawn-spitter"]
if (max_friends_around_to_spawn_spitter and max_friends_around_to_spawn_spitter.value) then
  data.raw["unit-spawner"]["spitter-spawner"].max_friends_around_to_spawn = max_friends_around_to_spawn_biter.value
end

local max_defensive_friends_around_to_spawn_spitter = settings.startup["more-enemies-spawner-nauvis-max-defensive-friends-around-to-spawn-spitter"]
if (max_defensive_friends_around_to_spawn_spitter and max_defensive_friends_around_to_spawn_spitter.value) then
  data.raw["unit-spawner"]["biter-spawner"].max_defensive_friends_around_to_spawn = max_defensive_friends_around_to_spawn_spitter.value
end

local max_spawning_cooldown_spitters = settings.startup["more-enemies-max-spawning-cooldown-spitter"]
local min_spawning_cooldown_spitters = settings.startup["more-enemies-min-spawning-cooldown-spitter"]
if (    max_spawning_cooldown_spitters
    and max_spawning_cooldown_spitters.value
    and min_spawning_cooldown_spitters
    and min_spawning_cooldown_spitters.value
  ) then
      data.raw["unit-spawner"]["spitter-spawner"].spawning_cooldown = {max_spawning_cooldown_spitters.value, min_spawning_cooldown_spitters.value}
end