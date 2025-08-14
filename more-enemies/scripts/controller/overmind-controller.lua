-- If already defined, return
if _overmind_controller and _overmind_controller.more_enemies then
  return _overmind_controller
end

local Attack_Group_Service = require("scripts.service.attack-group-service")
local Constants = require("libs.constants.constants")
local Log = require("libs.log.log")
local More_Enemies_Repository = require("scripts.repositories.more-enemies-repository")
local Overmind_Service = require("scripts.service.overmind-service")
local Overmind_Repository = require("scripts.repositories.overmind-repository")
local Settings_Service = require("scripts.service.settings-service")
local Version_Validations = require("scripts.validations.version-validations")

local cache = {}

local overmind_controller = {}

function overmind_controller.do_tick(event)
    Log.debug("overmind_controller.do_tick")
    Log.info(event)

    local tick = event.tick
    local nth_tick = Settings_Service.get_nth_tick()
    local offset = 1 + nth_tick -- Constants.time.TICKS_PER_SECOND / 2
    local tick_modulo = tick % offset

    if (nth_tick ~= tick_modulo) then return end

    -- Check/validate the storage version
    if (not Version_Validations.validate_version()) then return end

    local more_enemies_data = More_Enemies_Repository.get_more_enemies_data()

    if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end

    for _, planet in pairs(Constants.DEFAULTS.planets) do
        Log.debug(planet)

        if (not game or not game.surfaces or not game.surfaces[planet.string_val] or not game.surfaces[planet.string_val].valid) then goto continue end

        if (Settings_Service.get_do_attack_group(planet.string_val)) then
            Attack_Group_Service.do_random_attack_group(planet)
        end

        local surface = game.surfaces[planet.string_val]

        local overmind = cache[surface.name]

        if (type(overmind) ~= "table") then
            local overmind_data = Overmind_Repository.get_overmind_data(surface.name)
            if (type(overmind_data) ~= "table") then return end

            cache[surface.name] = overmind_data
            overmind = overmind_data
        end

        if (overmind and overmind.weighted_chunks and overmind.weighted_chunks.highest) then
            -- Log.error("Found highest chunk")
            -- Log.error(overmind.weighted_chunks.highest)
            -- Log.error(overmind.weighted_chunks.highest.weight)

            local chunk = overmind.weighted_chunks.highest
            if (type(chunk.tick_next) ~= "number" or chunk.tick_next >= game.tick) then goto continue end
            chunk.tick_past = chunk.tick_current
            chunk.tick_current = game.tick
            -- chunk.tick_next = Settings_Service.get_overmind_chunk_tick_step(surface.name)
            local selected_difficulty = Constants.difficulty[Constants.difficulty.difficulties[Settings_Service.get_difficulty(surface.name)]]
            local root = 1 / selected_difficulty.value
            chunk.tick_next = chunk.tick_current + math.random(150, 1800 / ((selected_difficulty.radius_modifier ^ 2) * selected_difficulty.radius_modifier))
            Log.error(chunk.tick_next)
            Log.error(game.tick)

            if (Settings_Service.get_do_attack_group(planet.string_val)) then

                Attack_Group_Service.do_attack_group({
                    overmind = overmind,
                    planet = planet,
                    chunk = overmind.weighted_chunks.highest
                })

                if (chunk.weight < 0) then chunk.weight = 0 end

                local weighted_chunks = overmind.weighted_chunks
                local weight_index_old = math.floor(chunk.weight)
                -- local weight_index_new = math.floor(chunk.weight / 2)
                chunk.weight = chunk.weight ^ root
                local weight_index_new = math.floor(chunk.weight)

                if (weight_index_old > 0) then
                    weighted_chunks.chunks_weighted[weight_index_old] = nil
                    if (weighted_chunks.size > 0) then weighted_chunks.size = weighted_chunks.size - 1 end
                end

                if (weight_index_new > 0) then
                    if (weighted_chunks.highest ~= nil) then
                        if (weighted_chunks.highest.weight < chunk.weight) then
                            local prev_highest = weighted_chunks.highest
                            prev_highest.above = chunk
                            chunk.below = prev_highest
                            weighted_chunks.highest = chunk
                        end
                    else
                        weighted_chunks.highest = chunk
                    end

                    weighted_chunks.chunks_weighted[weight_index_new] = chunk
                    weighted_chunks.size = weighted_chunks.size + 1
                end
            end
        end

        ::continue::
    end
end

function overmind_controller.on_built_entity(event)
    Log.debug("overmind_controller.on_built_entity")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end

    Overmind_Service.on_built_entity(event)
end

function overmind_controller.on_cargo_pod_finished_descending(event)
    Log.debug("overmind_controller.on_cargo_pod_finished_descending")
    Log.info(event)

    if (not event) then return end
    if (not event.tick or not event.cargo_pod or event.launched_by_rocket) then return end

    Overmind_Service.on_cargo_pod_finished_descending(event)
end

function overmind_controller.on_player_mined_entity(event)
    Log.debug("overmind_controller.on_player_mined_entity")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end

    Overmind_Service.on_player_mined_entity(event)
end

function overmind_controller.on_player_mined_item(event)
    Log.debug("overmind_controller.on_player_mined_item")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end

    Overmind_Service.on_player_mined_item(event)
end

function overmind_controller.on_entity_died(event)
    Log.debug("overmind_controller.on_entity_died")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end
    if (not event.name or not event.name ==  defines.events.on_entity_died) then return end

    -- Overmind_Service.on_post_entity_died(event)
    Overmind_Service.on_entity_died(event)
end

function overmind_controller.on_robot_built_entity(event)
    Log.debug("overmind_controller.on_robot_built_entity")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end

    Overmind_Service.on_robot_built_entity(event)
end

function overmind_controller.on_robot_exploded_cliff(event)
    Log.debug("overmind_controller.on_robot_exploded_cliff")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end

    Overmind_Service.on_robot_exploded_cliff(event)
end

function overmind_controller.on_robot_mined_entity(event)
    Log.debug("overmind_controller.on_robot_mined_entity")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end

    Overmind_Service.on_robot_mined_entity(event)
end

function overmind_controller.on_rocket_launch_ordered(event)
    Log.debug("overmind_controller.on_rocket_launch_ordered")
    Log.info(event)

    if (not event) then return end
    if (not event.tick) then return end
    if (not event.name or not event.name == defines.events.on_rocket_launch_ordered) then return end
    if (not event.rocket_silo or not not event.rocket_silo.valid) then return end

    Overmind_Service.on_rocket_launch_ordered(event)
end

overmind_controller.more_enemies = true

local _overmind_controller = overmind_controller

return overmind_controller