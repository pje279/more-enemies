-- If already defined, return
if _overmind_utils and _overmind_utils.more_enemies then
  return _overmind_utils
end

local Chunk_Data = require("scripts.data.chunk-data.chunk-data")
local Constants = require("libs.constants.constants")
local Log = require("libs.log.log")
local Overmind_Target_Priorities = require("libs.constants.overmind.overmind-target-priorities")
local Pollution_Data = require("scripts.data.chunk-data.pollution-data")
local Recent_Death_Data = require("scripts.data.chunk-data.recent-deaths-data")
local Settings_Service = require("scripts.service.settings-service")
local Spawn_Constants = require("libs.constants.spawn-constants")

local overmind_utils = {}

function overmind_utils.process_chunk(data)
    Log.debug("overmind_utils.process_chunk")
    Log.info(data)

    if (not game or type(data) ~= "table") then return end
    if (type(data.chunk) ~= "table" or not data.chunk.valid) then return end
    if (not data.surface or not data.surface.valid) then return end
    if (not data.entity or not data.entity.valid) then return end
    if (type(data.radius) ~= "number" or data.radius) then data.radius = 1 end
    if (type(data.spawners_required) ~= "boolean") then data.spawners_required = false end

    local chunk = data.chunk
    local surface = data.surface
    local entity = data.entity
    local radius = data.radius
    local event_name = data.event_name

    local previous_pollution_level = chunk.pollution_data and chunk.pollution_data.pollution
    -- local current_pollution_level = surface.get_pollution(entity.position)
    local current_pollution_level = 0

    -- if (type(chunk.tick_next) ~= "number" or chunk.tick_next >= game.tick) then return end
    if (type(chunk.tick_next) ~= "number") then return end

    local selected_difficulty = Constants.difficulty[Constants.difficulty.difficulties[Settings_Service.get_difficulty(surface.name)]]

    local last_pollution_check_proportion_average = 0
    local average_pollution_delta = 0

    if  (chunk.pollution_data.tick_next < game.tick) then
        current_pollution_level = surface.get_pollution(entity.position)
        -- log(serpent.block(chunk))
        chunk.pollution_data.pollution = current_pollution_level

        local tick_past_prev = chunk.pollution_data.tick_past
        chunk.pollution_data.tick_past = chunk.pollution_data.tick_current
        chunk.pollution_data.tick_current = game.tick
        chunk.pollution_data.tick_next = chunk.pollution_data.tick_current + Constants.time.TICKS_PER_SECOND


        local time_since_last_pollution_check = chunk.pollution_data.tick_current - chunk.pollution_data.tick_past
        local time_since_pollution_detection = chunk.pollution_data.tick_current - chunk.pollution_data.created

        if (time_since_last_pollution_check < 1) then time_since_last_pollution_check = 1 end
        if (time_since_pollution_detection < 1) then time_since_pollution_detection = 1 end

        local average_pollution_delta_per_tick = current_pollution_level / time_since_pollution_detection

        if (time_since_pollution_detection < Constants.time.TICKS_PER_SECOND) then time_since_pollution_detection = Constants.time.TICKS_PER_SECOND end
        local average_pollution_delta_per_second = current_pollution_level / (time_since_pollution_detection / Constants.time.TICKS_PER_SECOND)

        if (time_since_pollution_detection < Constants.time.TICKS_PER_MINUTE) then time_since_pollution_detection = Constants.time.TICKS_PER_MINUTE end
        local average_pollution_delta_per_minute = current_pollution_level / (time_since_pollution_detection / Constants.time.TICKS_PER_MINUTE)

        if (time_since_pollution_detection < Constants.time.TICKS_PER_HOUR) then time_since_pollution_detection = Constants.time.TICKS_PER_HOUR end
        local average_pollution_delta_per_hour = current_pollution_level / (time_since_pollution_detection / Constants.time.TICKS_PER_HOUR)

        -- local average_pollution_delta = (average_pollution_delta_per_tick + average_pollution_delta_per_second + average_pollution_delta_per_minute + average_pollution_delta_per_hour) / 4
        average_pollution_delta = (average_pollution_delta_per_tick + average_pollution_delta_per_second + average_pollution_delta_per_minute + average_pollution_delta_per_hour) / 4

        Log.error("pollution data")
        -- Log.error(average_pollution_delta)

        local last_pollution_check_proportion_creation = time_since_last_pollution_check / time_since_pollution_detection
        local last_pollution_check_proportion_seconds = time_since_last_pollution_check / (Constants.time.TICKS_PER_SECOND / selected_difficulty.value)
        local last_pollution_check_proportion_minutes = time_since_last_pollution_check / (Constants.time.TICKS_PER_MINUTE / selected_difficulty.value)
        local last_pollution_check_proportion_hour = time_since_last_pollution_check / (Constants.time.TICKS_PER_HOUR / selected_difficulty.value)
        -- local last_pollution_check_proportion_average = (last_pollution_check_proportion_creation + last_pollution_check_proportion_seconds + last_pollution_check_proportion_minutes + last_pollution_check_proportion_hour) / 5
        last_pollution_check_proportion_average = (last_pollution_check_proportion_creation + last_pollution_check_proportion_seconds + last_pollution_check_proportion_minutes + last_pollution_check_proportion_hour) / 5

        -- Log.error(last_pollution_check_proportion_average)
        -- Log.error(average_pollution_delta * last_pollution_check_proportion_average)


        if (    type (current_pollution_level) == "number"
            and type(previous_pollution_level) == "number"
            and current_pollution_level > previous_pollution_level)
        then
            -- Pollution went up
            local diff = current_pollution_level - previous_pollution_level
        else
            -- Pollution went down
            local diff = previous_pollution_level - current_pollution_level
        end
    end

    -- Log.error(chunk.tick_next)
    -- Log.error(game.tick)
    -- if (type(chunk.tick_next) ~= "number" or chunk.tick_next >= game.tick) then return end
    if (type(chunk.tick_next) ~= "number") then return end

    chunk.tick_past = chunk.tick_current
    chunk.tick_current = game.tick
    -- chunk.tick_next = Settings_Service.get_overmind_chunk_tick_step(surface.name)
    chunk.pollution_data.tick_next = chunk.pollution_data.tick_current + 150
    chunk.pollution_data.tick_next = chunk.pollution_data.tick_current + math.random(150, 900 / selected_difficulty.value)

    -- Look for any nearby enemy units

    -- Look for any nearby spawners
    local root = 1 / selected_difficulty.value
    local evolution_factor = game.forces["enemy"].get_evolution_factor(surface)
    evolution_factor = evolution_factor ^ root
    local spawner_limit = 1 + (selected_difficulty.value ^ (selected_difficulty.radius_modifier ^ 2))
    spawner_limit = math.random(spawner_limit)
    spawner_limit = math.ceil(spawner_limit * evolution_factor)

    -- Log.error("1")

    local max_depth = nil
    if (type(event_name) == "string" and #event_name > 0) then
        if (event_name == defines.events.on_entity_died) then
            max_depth = 2 * (selected_difficulty.value / selected_difficulty.radius_modifier)
        elseif (event_name == defines.events.on_rocket_launch_ordered) then
            max_depth = 12 * selected_difficulty.radius_modifier
        end
    end

    local target_position = nil

    if (data.spawners_required) then
        local spawners, return_data = overmind_utils.get_spawners({
            x = entity.position.x,
            y = entity.position.y,
            spawner_limit = spawner_limit,
            -- radius = 12,
            radius = radius,
            radius_limit = radius_limit,
            surface = surface,
            max_depth = max_depth,
        })

        -- Log.error(spawners)
        -- Log.error(return_data)

        if (not spawners or #spawners < 1) then
            return
        end

        target_position = spawners[1].position
    else
        if (data.cause and data.cause.valid) then
            target_position = data.cause.position
        end
    end
    -- Log.error("2")

    -- Spawners were found

    -- local spawner_position = spawners[1].position
    -- local distance = math.sqrt((entity.position.x - spawner_position.x) ^ 2 + (entity.position.y - spawner_position.y) ^ 2)

    if  (target_position == nil) then
        target_position = entity.position
    end

    local distance = math.sqrt((entity.position.x - target_position.x) ^ 2 + (entity.position.y - target_position.y) ^ 2)
    if (distance <= 0) then distance = 32 end
    local chunk_distance = distance / Constants.CHUNK_SIZE
    -- local proportional_distance = chunk_distance * evolution_factor
    local proportional_distance = chunk_distance * (1 - evolution_factor)

    local distance_modifier = chunk_distance - proportional_distance
    -- local distance_modifier = (chunk_distance - proportional_distance) / chunk_distance
    local distance_ratio = 1
    -- if (chunk_distance > 0) then distance_ratio = distance_modifier / chunk_distance end
    if (chunk_distance > 0) then distance_ratio = (chunk_distance + (distance_modifier ^ 0.5)) / chunk_distance end

    if (distance_modifier < 0) then distance_modifier = 0 end

    if (distance_ratio < 0.25) then distance_ratio = 0.25 end

    -- Multiplier of the pollution in a chunk based on distance to spawners
    local pollution_distance_modifier = chunk_distance / distance_ratio
    -- Log.error("pollution_distance_modifier")
    -- Log.error(pollution_distance_modifier)

    -- local weight = 0 + (current_pollution_level / (Constants.CHUNK_SIZE / selected_difficulty.value)) * pollution_distance_modifier
    local weight = 0 + ((current_pollution_level / (Constants.CHUNK_SIZE / selected_difficulty.value)) * pollution_distance_modifier) * (average_pollution_delta * last_pollution_check_proportion_average)

    -- Log.error(weight)

    local time_since_last_death = chunk.recent_deaths.tick_current - chunk.recent_deaths.tick_past
    local time_since_creation = chunk.recent_deaths.tick_current - chunk.recent_deaths.created

    if (time_since_last_death < 1) then time_since_last_death = 1 end
    if (time_since_creation < 1) then time_since_creation = 1 end

    local average_deaths_per_tick = chunk.deaths / time_since_creation

    if (time_since_creation < Constants.time.TICKS_PER_SECOND) then time_since_creation = Constants.time.TICKS_PER_SECOND end
    local average_deaths_per_second = chunk.deaths / (time_since_creation / Constants.time.TICKS_PER_SECOND)

    local last_death_time_proportion_creation = time_since_last_death / time_since_creation
    local last_death_time_proportion_seconds = time_since_last_death / (Constants.time.TICKS_PER_SECOND / selected_difficulty.value)
    local last_death_time_proportion_minutes = time_since_last_death / (Constants.time.TICKS_PER_MINUTE / selected_difficulty.value)
    local last_death_time_proportion_hour = time_since_last_death / (Constants.time.TICKS_PER_HOUR / selected_difficulty.value)
    local last_death_time_proportion_average = (last_death_time_proportion_creation + last_death_time_proportion_seconds + last_death_time_proportion_minutes + last_death_time_proportion_hour) / 5

    -- Log.error("last_death_time_proportions")
    -- Log.error(last_death_time_proportion_creation)
    -- Log.error(last_death_time_proportion_seconds)
    -- Log.error(last_death_time_proportion_minutes)
    -- Log.error(last_death_time_proportion_hour)
    -- Log.error(last_death_time_proportion_average)
    -- Log.error(last_death_time_proportion_average ^ (1 / selected_difficulty.value))

    if (chunk.recent_deaths.average_deaths_per_tick < average_deaths_per_tick) then
        -- average going up
        -- attack probably starting
        -- reduce the weight of deaths?
        if (chunk.recent_deaths.modifier < 0) then chunk.recent_deaths.modifier = 1 end
        -- if (chunk.recent_deaths.modifier > 1) then
        --     chunk.recent_deaths.modifier = chunk.recent_deaths.modifier * .9
        -- else
        --     chunk.recent_deaths.modifier = chunk.recent_deaths.modifier * 0.95
        -- end
    else
        -- average staying steady or going down
        -- attack ending?
        -- increase the weight of deaths?
        if (chunk.recent_deaths.modifier < 0) then chunk.recent_deaths.modifier = 1 end
        -- if (chunk.recent_deaths.modifier > 1) then
        --     chunk.recent_deaths.modifier = chunk.recent_deaths.modifier * 1.05
        -- else
        --     chunk.recent_deaths.modifier = chunk.recent_deaths.modifier * 1.1
        -- end
    end

    chunk.recent_deaths.average_deaths_per_tick = average_deaths_per_tick
    chunk.recent_deaths.average_deaths_per_second = average_deaths_per_second

    if (type(event_name) == "string" and #event_name > 0) then
        if (event_name == defines.events.on_entity_died) then
            if (entity.type == "unit" and entity.force.name == "enemy") then
                local entry = Spawn_Constants.name_table[entity.name]
                local entity_weight = 0
                if (type(entry) == "number") then
                    entity_weight = entry
                end

                -- weight = weight - (((entity_weight * selected_difficulty.radius_modifier) * chunk.recent_deaths.modifier) * evolution_factor)
                -- weight = weight - (((entity_weight * selected_difficulty.radius_modifier) * last_death_time_proportion_average) * evolution_factor)
                -- weight = weight - (((entity_weight * selected_difficulty.radius_modifier) * (last_death_time_proportion_average ^ 0.25)) * (evolution_factor ^ 0.25))

                local root = 1 / selected_difficulty.value
                weight = weight - (((entity_weight * selected_difficulty.radius_modifier) * (last_death_time_proportion_average ^ root)) * (evolution_factor ^ root))
            end
        elseif (event_name == defines.events.on_rocket_launch_ordered) then
            if (Overmind_Target_Priorities[entity.name]) then
                weight = weight + Overmind_Target_Priorities[entity.name].weight

                -- local level = 0
                -- for k, _ in pairs(Overmind_Target_Priorities[entity.name].evolution_thresholds) do
                --     if (k > evolution_factor) then break end
                --     level = k
                -- end

                weight = weight * evolution_factor - distance_modifier
                if (weight < 0) then weight = 0 end
            end
        end
    end

    -- Log.error(weight)
    -- Log.error(chunk)
    -- Log.error(chunk.recent_deaths)

    return weight, chunk_distance
end

function overmind_utils.get_spawners(data)
    Log.debug("overmind_utils.get_spawner")
    Log.info(data)

    if (not type(data) == "table") then return end
    if (not data.x or data.x == nil) then return end
    if (not data.y or data.y == nil) then return end
    if (not data.spawner_limit or data.spawner_limit == nil) then data.spawner_limit = 1 end
    if (not data.surface or not data.surface.valid) then return end
    if (not data.radius_limit or data.radius_limit == nil) then
        local selected_difficulty = Constants.difficulty[Constants.difficulty.difficulties[Settings_Service.get_difficulty(data.surface.name)]]
        local root = 1 / selected_difficulty.value
        -- local modifier = ((selected_difficulty.value ^ (selected_difficulty.radius_modifier ^ selected_difficulty.radius_modifier)) ^ 0.5) * selected_difficulty.value
        -- local modifier = ((selected_difficulty.value ^ (selected_difficulty.radius_modifier ^ 2)) ^ root) * selected_difficulty.value
        data.radius_limit = ((selected_difficulty.value ^ (selected_difficulty.radius_modifier ^ 2)) ^ root) * selected_difficulty.value
    end
    if (not data.radius or data.radius == nil) then data.radius = 1 end
    if (not data.depth or data.depth == nil) then data.depth = 1 end
    if (not data.max_depth or data.max_depth == nil) then data.max_depth = 1 end

    if (data.depth > data.max_depth) then return end
    -- if (data.radius > Constants.CHUNK_SIZE * 3.5 and data.depth > 1) then return end
    -- if (data.radius > Constants.CHUNK_SIZE * 12 and data.depth > 1) then return end
    -- if (data.radius > Constants.CHUNK_SIZE * 16 and data.depth > 1) then return end
    -- if (data.radius > Constants.CHUNK_SIZE * 32 and data.depth > 1) then return end
    if (data.radius > Constants.CHUNK_SIZE * (1 + data.radius_limit) and data.depth > 1) then return end

    local spawners = data.surface.find_entities_filtered({
        type = "unit-spawner",
        position = { x = data.x, y = data.y },
        limit = data.spawner_limit,
        radius = 32 * data.radius,
    })

    if (not spawners or #spawners < 1) then
        data.radius = 1.1 * data.radius + 1
        data.depth = data.depth + 1

        return overmind_utils.get_spawners(data)
    end

    return spawners, data
end

function overmind_utils.create_new_chunk(data)
    Log.debug("overmind_utils.create_new_chunk")
    Log.info(data)

    if (type(data) ~= "table") then return end
    if (not data.surface or not data.surface.valid) then return end
    if (not data.position or not data.position.x or not data.position.y) then return end

    local surface = data.surface
    local position = data.position

    local x = position.x / Constants.CHUNK_SIZE
    x = x - x % 1

    local y = position.y / Constants.CHUNK_SIZE
    y = y - y % 1

    return Chunk_Data:new({
        pollution_data = Pollution_Data:new({
            pollution = surface.get_pollution(position),
            tick_current = game.tick,
            tick_next = game.tick,
            tick_past = game.tick,
        }),
        recent_deaths = Recent_Death_Data:new(),
        rocket_launches = 0,
        surface = surface,
        surface_name = surface.name,
        tick_current = game.tick,
        tick_next = game.tick,
        tick_past = game.tick,
        x = x,
        y = y,
        valid = surface.valid,
    })
end

overmind_utils.more_enemies = true

local _overmind_utils = overmind_utils

return overmind_utils
