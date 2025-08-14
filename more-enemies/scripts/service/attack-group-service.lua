-- If already defined, return
if _attack_group_service and _attack_group_service.more_enemies then
  return _attack_group_service
end

local Attack_Group_Repository = require("scripts.repositories.attack-group-repository")
local Attack_Group_Utils = require("scripts.utils.attack-group-utils")
local Constants = require("libs.constants.constants")
local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Log = require("libs.log.log")
local Overmind_Utils = require("scripts.utils.overmind-utils")
local Settings_Service = require("scripts.service.settings-service")
local Unit_Group_Utils = require("scripts.utils.unit-group-utils")

local attack_group_service = {}

attack_group_service.attack_group = {}

function attack_group_service.do_random_attack_group(planet)
    Log.debug("attack_group_service.do_random_attack_group")
    Log.info(planet)

    if (not game or not game.surfaces) then return end
    if (type(planet) ~= "table" or type(planet.string_val) ~= "string") then return end
    local surface = game.surfaces[planet.string_val]
    if (not surface or not surface.valid) then return end

    if (not attack_group_service.attack_group[planet.string_val]) then
        local attack_group_data = Attack_Group_Repository.get_attack_group_data(planet.string_val)
        if (not attack_group_data.peace_time_tick or attack_group_data.peace_time_tick == nil) then
            local peace_time_tick = Settings_Service.get_attack_group_peace_time(planet.string_val) * Constants.time.TICKS_PER_MINUTE
            if (type(attack_group_data.surface) == "table" and attack_group_data.surface.index == 1) then
                attack_group_data.peace_time_tick = peace_time_tick
                attack_group_data.tick = peace_time_tick
            else
                attack_group_data.peace_time_tick = peace_time_tick
                attack_group_data.tick = attack_group_data.created + peace_time_tick
            end
        end

        attack_group_service.attack_group[planet.string_val] = attack_group_data
    end

    if (attack_group_service.attack_group and attack_group_service.attack_group[planet.string_val] and attack_group_service.attack_group[planet.string_val].tick and game and game.tick >= attack_group_service.attack_group[planet.string_val].tick) then

        local surface = game.surfaces[planet.string_val]
        if (surface and surface.valid) then

            local attack_group = attack_group_service.attack_group[planet.string_val]

            local chunk = Attack_Group_Utils.get_new_chunk(attack_group, planet, surface.get_random_chunk())

            if (chunk) then
                Log.debug(planet.string_val)
                Log.debug(chunk)
                Log.debug(attack_group.radius)

                local enemies = Attack_Group_Utils.get_enemy(surface, chunk, attack_group.radius)
                if (enemies and enemies[1] and enemies[1].valid) then
                    Log.debug(enemies)

                    if (Settings_Service.get_attack_group_require_nearby_spawner(planet.string_val)) then
                        local spawner = Unit_Group_Utils.get_spawner(enemies[1], 4 * attack_group.radius, 1)

                        if (not spawner or spawner == nil) then goto finally end
                    end

                    local evolution_factor = enemies[1].force.get_evolution_factor(enemies[1].surface)

                    local rand = math.random()

                    local probability_modifier = Settings_Service.get_spawn_attack_group_probability_modifier(planet.string_val)

                    local selected_difficulty = Constants.difficulty[Constants.difficulty.difficulties[Settings_Service.get_difficulty(planet.string_val)]]

                    -- Maximum probability of an attack group spawning at 100% (1) evolution factor
                    local max_probability = 1 - (1 / selected_difficulty.value)

                    if (max_probability < 0) then max_probability = 0 end

                    max_probability = max_probability * probability_modifier

                    local threshold = max_probability * evolution_factor
                    Log.debug(threshold)
                    Log.debug(rand)

                    if (rand >= threshold) then
                        -- return
                        goto finally
                    end

                    local unit_group = surface.create_unit_group({ position = enemies[1].position})
                    if (unit_group and unit_group.valid) then

                        local limit = selected_difficulty.value + math.random(#enemies)

                        for k, v in pairs(enemies) do
                            if (v and v.valid) then
                                v.release_from_spawner()
                                v.ai_settings.allow_try_return_to_spawner = false
                                v.ai_settings.join_attacks = true
                                unit_group.add_member(v)
                            end
                            if (k >= limit) then break end
                        end

                        -- local target_entity = locals.get_target_entity(unit_group, attack_group.radius)
                        -- local target_entity = Attack_Group_Utils.get_target_entity(unit_group, attack_group.radius)
                        local target_entity = Attack_Group_Utils.get_target_entity({
                            unit_group = unit_group,
                            radius = attack_group.radius
                        })

                        if (target_entity and target_entity.valid) then

                            attack_group.chunks[chunk.x][chunk.y].tick = game.tick + 3600

                            local x = enemies[1].position.x / 32
                            x = x - x % 1

                            local y = enemies[1].position.y / 32
                            y = y - y % 1

                            if (x > 0 and x > attack_group.max_distance.pos_x) then attack_group.max_distance.pos_x = x end
                            if (y > 0 and y > attack_group.max_distance.pos_y) then attack_group.max_distance.pos_y = y end

                            if (x < 0 and x < attack_group.max_distance.neg_x) then attack_group.max_distance.neg_x = x end
                            if (y < 0 and y < attack_group.max_distance.neg_y) then attack_group.max_distance.neg_y = y end

                            if (not attack_group.chunks[x]) then attack_group.chunks[x] = {} end
                            if (not attack_group.chunks[x][y]) then attack_group.chunks[x][y] = { tick = 0, count = 1 } end
                            attack_group.chunks[x][y].tick = game.tick + 18000

                            Log.debug("target_entity")
                            Log.debug(target_entity)

                            -- Log.info(attack_group.chunks)
                            -- log(serpent.block(attack_group.chunks))

                            if (target_entity and target_entity.valid) then

                                local radius_mult = math.random() + 0.25

                                unit_group.set_command({
                                    type = defines.command.attack_area,
                                    destination = target_entity.position,
                                    -- radius = 32 * 0.25, -- TODO: Make this configurable,
                                    radius = 32 * radius_mult, -- TODO: Make this configurable,
                                    distraction = defines.distraction.by_damage,
                                })
                                unit_group.release_from_spawner()
                                unit_group.start_moving()
                                Log.debug("unit group released")
                            else
                                Log.warn("no target; destroying")
                                unit_group.destroy()
                            end

                            if (attack_group.radius > 2) then
                                attack_group.radius = attack_group.radius / 2
                            end
                        end
                    end
                end

                ::finally::

                local delay_min = Settings_Service.get_minimum_attack_group_delay()
                local delay_max = Settings_Service.get_maximum_attack_group_delay()

                if (delay_min > delay_max) then
                    delay_min = Global_Settings_Constants.settings.MINIMUM_ATTACK_GROUP_DELAY.default_value
                end

                if (delay_max < delay_min ) then
                    delay_max = Global_Settings_Constants.settings.MAXIMUM_ATTACK_GROUP_DELAY.default_value
                end

                local delay = math.random(delay_min, delay_max)
                -- log("error: delay")
                Log.debug(delay)

                local selected_difficulty = Constants.difficulty[Constants.difficulty.difficulties[Settings_Service.get_difficulty(planet.string_val)]]
                local difficulty_val = Constants.difficulty.INSANITY.value

                if (selected_difficulty and selected_difficulty.value and selected_difficulty.value > 0) then
                    delay = delay / selected_difficulty.value
                    difficulty_val = selected_difficulty.value

                    Log.debug(delay)
                end

                if (attack_group.radius < delay * difficulty_val) then
                    attack_group.radius = 1.1 * attack_group.radius + 1
                    if (attack_group.radius > Constants.CHUNK_SIZE * 8) then attack_group.radius = Constants.CHUNK_SIZE * 8 end
                end
                attack_group.tick = game.tick + delay
            end
        end
    end
end

function attack_group_service.do_attack_group(data)
    Log.debug("attack_group_service.do_attack_group")
    Log.info(data)

    if (not game or not game.surfaces) then return end
    if (type(data) ~= "table") then return end
    if (type(data.overmind) ~= "table") then return end
    local planet = data.planet
    if (type(planet) ~= "table" or type(planet.string_val) ~= "string") then return end
    local surface = game.surfaces[planet.string_val]
    if (not surface or not surface.valid) then return end

    local attack_group = attack_group_service.attack_group[planet.string_val]

    -- local chunk = Attack_Group_Utils.get_new_chunk(attack_group, planet, surface.get_random_chunk())
    local chunk = data.chunk

    if (type(chunk) == "table") then
        Log.debug(planet.string_val)
        Log.debug(chunk)
        Log.debug(attack_group.radius)

        local enemies = Attack_Group_Utils.get_enemy(surface, chunk, attack_group.radius)
        if (enemies and enemies[1] and enemies[1].valid) then
            Log.error(enemies)

            local selected_difficulty = Constants.difficulty[Constants.difficulty.difficulties[Settings_Service.get_difficulty(planet.string_val)]]
            local root = 1 / selected_difficulty.value

            if (Settings_Service.get_attack_group_require_nearby_spawner(planet.string_val)) then
                local spawner = Overmind_Utils.get_spawners({
                    x = enemies[1].position.x,
                    y = enemies[1].position.y,
                    surface = enemies[1].surface,
                    -- radius = 4 * attack_group.radius,
                    radius = attack_group.radius * selected_difficulty.radius_modifier,
                    max_depth = selected_difficulty.value
                })
                -- local spawner = Unit_Group_Utils.get_spawner(enemies[1], 4 * attack_group.radius * selected_difficulty.radius_modifier, 1)
                -- Log.error(spawner)

                if (not spawner or spawner == nil) then goto finally end
            end

            local root = 1 / selected_difficulty.value

            local evolution_factor = enemies[1].force.get_evolution_factor(enemies[1].surface)
            evolution_factor = evolution_factor ^ root
            Log.error(evolution_factor)

            local rand = math.random()
            -- rand = rand ^ root

            local probability_modifier = Settings_Service.get_spawn_attack_group_probability_modifier(planet.string_val)

            -- Maximum probability of an attack group spawning at 100% (1) evolution factor
            local max_probability = 1 - (1 / selected_difficulty.value)

            if (max_probability < 0) then max_probability = 0 end

            max_probability = max_probability * probability_modifier

            local threshold = max_probability * evolution_factor
            Log.error(threshold)
            Log.error(rand)

            if (rand >= threshold) then
                -- return
                goto finally
            end

            local unit_group = surface.create_unit_group({ position = enemies[1].position})
            if (unit_group and unit_group.valid) then

                local limit = selected_difficulty.value + math.random(#enemies)

                for k, v in pairs(enemies) do
                    if (v and v.valid) then
                        v.release_from_spawner()
                        v.ai_settings.allow_try_return_to_spawner = false
                        v.ai_settings.join_attacks = true
                        unit_group.add_member(v)
                    end
                    if (k >= limit) then break end
                end

                -- local target_entity = Attack_Group_Utils.get_target_entity(unit_group, attack_group.radius)
                local target_entity = Attack_Group_Utils.get_target_entity({
                    chunk = chunk,
                    unit_group = unit_group,
                    radius = attack_group.radius,
                })

                if (target_entity and target_entity.valid) then

                    -- attack_group.chunks[chunk.x][chunk.y].tick = game.tick + 3600
                    local overmind = data.overmind

                    local x = enemies[1].position.x / 32
                    x = x - x % 1

                    local y = enemies[1].position.y / 32
                    y = y - y % 1

                    if (x > 0 and x > overmind.max_distance.pos_x) then overmind.max_distance.pos_x = x end
                    if (y > 0 and y > overmind.max_distance.pos_y) then overmind.max_distance.pos_y = y end

                    if (x < 0 and x < overmind.max_distance.neg_x) then overmind.max_distance.neg_x = x end
                    if (y < 0 and y < overmind.max_distance.neg_y) then overmind.max_distance.neg_y = y end

                    -- if (not overmind.chunks[x]) then overmind.chunks[x] = {} end
                    if (type(overmind.chunks[x]) ~= "table") then overmind.chunks[x] = {} end
                    -- if (not overmind.chunks[x][y]) then overmind.chunks[x][y] = { tick = 0, count = 1 } end
                    -- if (not overmind.chunks[x][y]) then
                    if (type(overmind.chunks[x][y]) ~= "table") then
                        overmind.chunks[x][y] = Overmind_Utils.create_new_chunk({
                            surface = surface,
                            position = enemies[1].position,
                        })
                    end

                    if (type(overmind.chunks[x][y].tick_next) == "table" and type(overmind.chunks[x][y].tick_next.tick_next) == "number") then
                        -- overmind.chunks[x][y].tick_next = game.tick + 18000
                        overmind.chunks[x][y].tick_next = game.tick + math.random(150, 1800 / selected_difficulty.value)
                    end

                    Log.error("target_entity")
                    Log.error(target_entity)

                    -- Log.info(attack_group.chunks)
                    -- log(serpent.block(attack_group.chunks))

                    if (target_entity and target_entity.valid) then

                        local radius_mult = math.random() + 0.25

                        unit_group.set_command({
                            type = defines.command.attack_area,
                            destination = target_entity.position,
                            -- radius = 32 * 0.25, -- TODO: Make this configurable,
                            radius = 32 * radius_mult, -- TODO: Make this configurable,
                            distraction = defines.distraction.by_damage,
                        })
                        unit_group.release_from_spawner()
                        unit_group.start_moving()
                        Log.debug("unit group released")
                    else
                        Log.warn("no target; destroying")
                        unit_group.destroy()
                    end

                    if (attack_group.radius > 2) then
                        -- attack_group.radius = attack_group.radius / 2
                        attack_group.radius = attack_group.radius ^ root
                    end
                end
            end
        end

        ::finally::

        local delay_min = Settings_Service.get_minimum_attack_group_delay()
        local delay_max = Settings_Service.get_maximum_attack_group_delay()

        if (delay_min > delay_max) then
            delay_min = Global_Settings_Constants.settings.MINIMUM_ATTACK_GROUP_DELAY.default_value
        end

        if (delay_max < delay_min ) then
            delay_max = Global_Settings_Constants.settings.MAXIMUM_ATTACK_GROUP_DELAY.default_value
        end

        local delay = math.random(delay_min, delay_max)
        -- log("error: delay")
        Log.debug(delay)

        local selected_difficulty = Constants.difficulty[Constants.difficulty.difficulties[Settings_Service.get_difficulty(planet.string_val)]]
        local difficulty_val = Constants.difficulty.INSANITY.value

        if (selected_difficulty and selected_difficulty.value and selected_difficulty.value > 0) then
            delay = delay / selected_difficulty.value
            difficulty_val = selected_difficulty.value

            Log.debug(delay)
        end

        if (attack_group.radius < delay * difficulty_val) then
            attack_group.radius = 1.1 * attack_group.radius + 1
            -- if (attack_group.radius > Constants.CHUNK_SIZE * 8) then attack_group.radius = Constants.CHUNK_SIZE * 8 end
        end
        if (attack_group.radius > Constants.CHUNK_SIZE * 8) then attack_group.radius = Constants.CHUNK_SIZE * 8 end
        attack_group.tick = game.tick + delay
    end
end

attack_group_service.more_enemies = true

local _attack_group_service = attack_group_service

return attack_group_service