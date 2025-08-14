-- If already defined, return
if _overmind_service and _overmind_service.more_enemies then
  return _overmind_service
end

local Constants = require("libs.constants.constants")
local Log = require("libs.log.log")
local Overmind_Repository = require("scripts.repositories.overmind-repository")
local Overmind_Utils = require("scripts.utils.overmind-utils")
local Recent_Death_Data = require("scripts.data.chunk-data.recent-deaths-data")
local Settings_Service = require("scripts.service.settings-service")

local cache = {}

local overmind_service = {}

function overmind_service.on_built_entity(event)
    Log.debug("overmind_service.on_built_entity")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end

end

function overmind_service.on_cargo_pod_finished_descending(event)
    Log.debug("overmind_service.on_cargo_pod_finished_descending")
    Log.info(event)

    if (not event) then return end
    if (not event.tick or not event.cargo_pod or event.launched_by_rocket) then return end

end

function overmind_service.on_player_mined_entity(event)
    Log.debug("overmind_service.on_player_mined_entity")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end

end

function overmind_service.on_player_mined_item(event)
    Log.debug("overmind_service.on_player_mined_item")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end

end

function overmind_service.on_entity_died(event)
    Log.debug("overmind_service.on_entity_died")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end
    if (not event.name or not event.name ==  defines.events.on_entity_died) then return end

    local entity = event.entity
    if (not entity or not entity.valid) then return end
    local surface = entity.surface
    if (not surface or not surface.valid or not surface.name) then return end

    local valid_planet = false
    for _, planet in pairs(Constants.DEFAULTS.planets) do
        if (planet.string_val == surface.name) then
            valid_planet = true
            break
        end
    end

    if (not valid_planet) then return end

    local position = entity.position
    if (not position or not position.x or not position.y) then return end

    local overmind = cache[surface.name]

    if (type(overmind) ~= "table") then
        local overmind_data = Overmind_Repository.get_overmind_data(surface.name)
        if (type(overmind_data) ~= "table") then return end

        cache[surface.name] = overmind_data
        overmind = overmind_data
    end

    local x = position.x / Constants.CHUNK_SIZE
    x = x - x % 1

    local y = position.y / Constants.CHUNK_SIZE
    y = y - y % 1

    -- if (not overmind.chunks[x]) then overmind.chunks[x] = {} end
    if (type(overmind.chunks[x]) ~= "table") then overmind.chunks[x] = {} end
    -- if (not overmind.chunks[x][y]) then
    if (type(overmind.chunks[x][y]) ~= "table" or not overmind.chunks[x][y].valid) then
        overmind.chunks[x][y] = Overmind_Utils.create_new_chunk({
            surface = surface,
            position = position,
        })
    end

    local chunk = overmind.chunks[x][y]
    if (type(chunk) ~= "table" or not chunk.valid) then return end

    -- Log.error(chunk)
    if (type(chunk.deaths) ~= "number" or chunk.deaths < 0) then chunk.deaths = 0 end
    if (type(chunk.recent_deaths) ~= "table") then chunk.recent_deaths = Recent_Death_Data:new() end
    if (type(chunk.recent_deaths.deaths) ~= "number" or chunk.recent_deaths.deaths < 0) then chunk.deaths = 0 end

    chunk.deaths = chunk.deaths + 1
    chunk.recent_deaths.deaths = chunk.recent_deaths.deaths + 1

    chunk.recent_deaths.tick_past = chunk.recent_deaths.tick_current
    chunk.recent_deaths.tick_current = game.tick

    local selected_difficulty = Constants.difficulty[Constants.difficulty.difficulties[Settings_Service.get_difficulty(surface.name)]]

    local weight = Overmind_Utils.process_chunk({
        event_name = defines.events.on_entity_died,
        cause = event.cause,
        chunk = chunk,
        surface = surface,
        entity = entity,
        radius = 1 + selected_difficulty.value,
    })

    local weight_index_old = chunk.weight

    if (type(weight) ~= "number") then weight = 0 end

    chunk.weight = chunk.weight + weight
    if (chunk.weight < 0) then chunk.weight = 0 end

    local weighted_chunks = overmind.weighted_chunks
    local weight_index_new = math.floor(chunk.weight)

    if (weight_index_old > 0) then
        weighted_chunks.chunks_weighted[weight_index_old] = nil
        if (weighted_chunks.size > 0) then weighted_chunks.size = weighted_chunks.size - 1 end
    end

    if (weight_index_new > 0) then
        if (weighted_chunks.highest ~= nil) then
            if (weighted_chunks.highest.weight < chunk.weight) then
                weighted_chunks.highest = chunk
            end
        else
            weighted_chunks.highest = chunk
        end

        weighted_chunks.chunks_weighted[weight_index_new] = chunk
        weighted_chunks.size = weighted_chunks.size + 1
    end
end

function overmind_service.on_robot_built_entity(event)
    Log.debug("overmind_service.on_robot_built_entity")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end

end

function overmind_service.on_robot_exploded_cliff(event)
    Log.debug("overmind_service.on_robot_exploded_cliff")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end

end

function overmind_service.on_robot_mined_entity(event)
    Log.debug("overmind_service.on_robot_mined_entity")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end

end

function overmind_service.on_rocket_launch_ordered(event)
    Log.error("overmind_service.on_rocket_launch_ordered")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end
    if (not event.name or not event.name == defines.events.on_rocket_launch_ordered) then return end
    if (not event.rocket_silo or not event.rocket_silo.valid) then return end

    local rocket_silo = event.rocket_silo
    if (not rocket_silo.valid) then return end

    local surface = rocket_silo.surface
    if (not surface or not surface.valid) then return end

    local position = rocket_silo.position
    if (not position or not position.x or not position.y) then return end

    local overmind = cache[surface.name]

    if (type(overmind) ~= "table") then
        local overmind_data = Overmind_Repository.get_overmind_data(surface.name)
        if (type(overmind_data) ~= "table") then return end

        cache[surface.name] = overmind_data
        overmind = overmind_data
    end

    local x = position.x / Constants.CHUNK_SIZE
    x = x - x % 1

    local y = position.y / Constants.CHUNK_SIZE
    y = y - y % 1

    if (not overmind.chunks[x]) then overmind.chunks[x] = {} end
    if (not overmind.chunks[x][y]) then
        overmind.chunks[x][y] = Overmind_Utils.create_new_chunk({
            surface = surface,
            position = position,
        })
    end

    local chunk = overmind.chunks[x][y]
    if (type(chunk) ~= "table") then return end

    Log.error("rocket_launches += 1")
    chunk.rocket_launches = chunk.rocket_launches + 1

    local selected_difficulty = Constants.difficulty[Constants.difficulty.difficulties[Settings_Service.get_difficulty(surface.name)]]

    local weight, chunk_distance = Overmind_Utils.process_chunk({
        event_name = defines.events.on_rocket_launch_ordered,
        chunk = chunk,
        surface = surface,
        entity = rocket_silo,
        radius = 1 + 12 * selected_difficulty.radius_modifier,
    })

    if (type(chunk.weight) ~= "number" or chunk.weight < 0) then chunk.weight = 0 end
    if (type(weight) ~= "number" or weight < 0) then weight = 0 end
    if (type(chunk_distance) ~= "number" or chunk_distance < 0) then chunk_distance = math.huge end

    local weight_index_old = math.floor(chunk.weight)

    -- if (distance < Constants.CHUNK_SIZE * Settings_Service.get_rocket_witness_chunk_distance(surface.name)) then
    if (chunk_distance < 24) then
        chunk.tick_rocket_launch_witnessed = game.tick
        chunk.weight = chunk.weight + weight
    end

    -- if (distance < Constants.CHUNK_SIZE * Settings_Service.get_rocket_hear_chunk_distance(surface.name)) then
    if (chunk_distance < 16) then
        chunk.tick_rocket_heard = game.tick
        chunk.weight = chunk.weight + weight
    end

    -- if (distance < Constants.CHUNK_SIZE * Settings_Service.get_rocket_feel_chunk_distance(surface.name)) then
    if (chunk_distance < 8) then
        chunk.tick_rocket_felt = game.tick
        chunk.weight = chunk.weight + weight
    end

    local weighted_chunks = overmind.weighted_chunks
    local weight_index_new = math.floor(chunk.weight)

    if (weight_index_old > 0) then
        weighted_chunks.chunks_weighted[weight_index_old] = nil
        if (weighted_chunks.size > 0) then weighted_chunks.size = weighted_chunks.size - 1 end
    end

    if (weight_index_new > 0) then
        if (weighted_chunks.highest ~= nil) then
            if (weighted_chunks.highest.weight < chunk.weight) then
                weighted_chunks.highest = chunk
            end
        else
            weighted_chunks.highest = chunk
        end

        weighted_chunks.chunks_weighted[weight_index_new] = chunk
        weighted_chunks.size = weighted_chunks.size + 1
    end
end

overmind_service.more_enemies = true

local _overmind_service = overmind_service

return overmind_service