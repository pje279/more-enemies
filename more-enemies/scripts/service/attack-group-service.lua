-- If already defined, return
if _attack_group_service and _attack_group_service.more_enemies then
  return _attack_group_service
end

local Attack_Group_Repository = require("scripts.repositories.attack-group-repository")
local Constants = require("libs.constants.constants")
local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Log = require("libs.log.log")
local Settings_Service = require("scripts.service.settings-service")
local Spawn_Constants = require("libs.constants.spawn-constants")
local Unit_Group_Utils = require("scripts.utils.unit-group-utils")

local locals = {}

local attack_group_service = {}

attack_group_service.attack_group = {}

function attack_group_service.do_attack_group(planet)
    Log.debug("attack_group_service.do_attack_group")
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

            local chunk = locals.get_new_chunk(planet, surface.get_random_chunk())

            if (chunk) then
                Log.error(planet.string_val)
                Log.error(chunk)
                Log.error(attack_group.radius)

                local enemy = locals.get_enemy(surface, chunk, attack_group.radius)
                if (enemy and enemy[1] and enemy[1].valid) then
                    Log.error(enemy)

                    if (Settings_Service.get_attack_group_require_nearby_spawner(planet.string_val)) then
                        local spawner = Unit_Group_Utils.get_spawner(enemy[1], 32 * attack_group.radius, 1)

                        -- if (not spawner or spawner == nil) then return end
                        if (not spawner or spawner == nil) then goto finally end
                    end

                    -- local evolution_factor = enemy[1].force.get_evolution_factor()
                    local evolution_factor = enemy[1].force.get_evolution_factor(enemy[1].surface)

                    -- local rand = math.random(0, 100)
                    -- rand = rand / 100
                    local rand = math.random()

                    local probability_modifier = Settings_Service.get_spawn_attack_group_probability_modifier(planet.string_val)

                    local selected_difficulty = Constants.difficulty[Constants.difficulty.difficulties[Settings_Service.get_difficulty(planet.string_val)]]

                    -- Maximum probability of an attack group spawning at 100% (1) evolution factor
                    local max_probability = 1 - (1 / selected_difficulty.value)

                    if (max_probability < 0) then max_probability = 0 end

                    max_probability = max_probability * probability_modifier

                    local threshold = max_probability * evolution_factor
                    Log.error(threshold)
                    Log.error(rand)

                    if (rand >= threshold) then
                        Log.error("1")
                        -- return
                        goto finally
                    else
                        Log.error("2")
                    end
                    Log.error("3")

                    local unit_group = surface.create_unit_group({ position = enemy[1].position})
                    if (unit_group and unit_group.valid) then
                        Log.error("4")
                        -- enemy[1].release_from_spawner()
                        -- enemy[1].ai_settings.allow_try_return_to_spawner = false
                        -- enemy[1].ai_settings.join_attacks = true

                        -- unit_group.add_member(enemy[1])

                        local limit = selected_difficulty.value + math.random(#enemy)

                        for k, v in pairs(enemy) do
                            v.release_from_spawner()
                            v.ai_settings.allow_try_return_to_spawner = false
                            v.ai_settings.join_attacks = true
                            unit_group.add_member(v)
                            -- if (k >= selected_difficulty.value) then break end
                            if (k >= limit) then break end
                        end

                        local target_entity = locals.get_target_entity(unit_group)

                        if (target_entity and target_entity.valid) then

                            attack_group.chunks[chunk.x][chunk.y].tick = game.tick + 3600

                            local x = enemy[1].position.x / 32
                            x = x - x % 1

                            local y = enemy[1].position.y / 32
                            y = y - y % 1

                            if (x > 0 and x > attack_group.max_distance.pos_x) then attack_group.max_distance.pos_x = x end
                            if (y > 0 and y > attack_group.max_distance.pos_y) then attack_group.max_distance.pos_y = y end

                            if (x < 0 and x < attack_group.max_distance.neg_x) then attack_group.max_distance.neg_x = x end
                            if (y < 0 and y < attack_group.max_distance.neg_y) then attack_group.max_distance.neg_y = y end

                            if (not attack_group.chunks[x]) then attack_group.chunks[x] = {} end
                            if (not attack_group.chunks[x][y]) then attack_group.chunks[x][y] = { tick = 0, count = 1 } end
                            attack_group.chunks[x][y].tick = game.tick + 18000

                            Log.error("target_entity")
                            Log.error(target_entity)

                            -- Log.error(attack_group.chunks)
                            log(serpent.block(attack_group.chunks))

                            if (target_entity and target_entity.valid) then
                                unit_group.set_command({
                                    type = defines.command.attack_area,
                                    destination = target_entity.position,
                                    radius = 32 * 0.25, -- TODO: Make this configurable,
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
                end
                attack_group.tick = game.tick + delay
            end
        end
    end
end

function locals.get_new_chunk(planet, chunk, depth)
    if (not planet or planet == nil) then return end
    if (not chunk or chunk == nil) then return end
    if (not depth or depth == nil) then depth = 1 end

    if (depth > 12) then
        Log.warn("could not find a new chunk")
        return
    end

    local attack_group = attack_group_service.attack_group[planet.string_val]
    if (not attack_group) then return end

    if (chunk.x > 0 and chunk.x > attack_group.max_distance.pos_x) then attack_group.max_distance.pos_x = chunk.x end
    if (chunk.y > 0 and chunk.y > attack_group.max_distance.pos_y) then attack_group.max_distance.pos_y = chunk.y end

    if (chunk.x < 0 and chunk.x < attack_group.max_distance.neg_x) then attack_group.max_distance.neg_x = chunk.x end
    if (chunk.y < 0 and chunk.y < attack_group.max_distance.neg_y) then attack_group.max_distance.neg_y = chunk.y end


    local neg_x = -1

    if (not attack_group.max_distance.neg_x or attack_group.max_distance.neg_x == nil) then
        attack_group.max_distance.neg_x = -1
    end

    if (attack_group.max_distance.neg_x) then
        neg_x = attack_group.max_distance.neg_x
    end

    local pos_x = 1

    if (not attack_group.max_distance.pos_x or attack_group.max_distance.pos_x == nil) then
        attack_group.max_distance.pos_x = 1
    end

    if (attack_group.max_distance.pos_x) then
        pos_x = attack_group.max_distance.pos_x
    end

    local x = math.random(neg_x or -1, pos_x or 1)
    x = x - x % 1

    local neg_y = -1

    if (not attack_group.max_distance.neg_y or attack_group.max_distance.neg_y == nil) then
        attack_group.max_distance.neg_y = -1
    end

    if (attack_group.max_distance.neg_y) then
        neg_y = attack_group.max_distance.neg_y
    end

    local pos_y = 1

    if (not attack_group.max_distance.pos_y or attack_group.max_distance.pos_y == nil) then
        attack_group.max_distance.pos_y = 1
    end

    if (attack_group.max_distance.pos_y) then
        pos_y = attack_group.max_distance.pos_y
    end

    local y = math.random(neg_y or -1, pos_y or 1)
    y = y - y % 1

    chunk.x = x
    chunk.y = y

    local surface = game.surfaces[planet.string_val]

    if (surface and surface.valid and not surface.is_chunk_generated({ x, y })) then
        if (x > 0) then
            if (attack_group.max_distance.pos_x > 2) then
            attack_group.max_distance.pos_x = attack_group.max_distance.pos_x / 2
            end
        else
            if (attack_group.max_distance.neg_x > 2) then
            attack_group.max_distance.neg_x = attack_group.max_distance.neg_x / 2
            end
        end

        if (y > 0) then
            if (attack_group.max_distance.pos_y > 2) then
            attack_group.max_distance.pos_y = attack_group.max_distance.pos_y / 2
            end
        else
            if (attack_group.max_distance.neg_y > 2) then
            attack_group.max_distance.neg_y = attack_group.max_distance.neg_y / 2
            end
        end

        Log.warn("chunk not generated - getting new chunk")
        return locals.get_new_chunk(planet, surface.get_random_chunk(), depth + 1)
    end

    if (not attack_group.chunks[x]) then
        attack_group.chunks[x] = {}
        attack_group.chunks[x][y] = {
            tick = game.tick + 9000,
            count = 1,
        }
    else
        if (not attack_group.chunks[x][y]) then
            attack_group.chunks[x][y] = {
                tick = game.tick + 9000,
                count = 1
            }
        elseif (type(attack_group.chunks[x][y].tick) == "number" and game.tick >= attack_group.chunks[x][y].tick) then
            if (attack_group.chunks[x][y].count > 1) then
                attack_group.chunks[x][y].tick = game.tick + 36000 / attack_group.chunks[x][y].count
            else
                attack_group.chunks[x][y].tick = game.tick + 36000
            end

            if (attack_group.chunks[x][y].count > 2) then
                attack_group.chunks[x][y].count = attack_group.chunks[x][y].count / 2
            end
        else
            attack_group.chunks[x][y].count = attack_group.chunks[x][y].count + 1

            Log.debug("getting new chunk")

            attack_group.max_distance.pos_x = attack_group.max_distance.pos_x + 1
            attack_group.max_distance.pos_y = attack_group.max_distance.pos_y + 1
            attack_group.max_distance.neg_x = attack_group.max_distance.neg_x + 1
            attack_group.max_distance.neg_y = attack_group.max_distance.neg_y + 1

            return locals.get_new_chunk(planet, surface.get_random_chunk(), depth + 1)
        end
    end

    return chunk
end

function locals.get_enemy(surface, chunk, radius, depth)
    if (not surface or not surface.valid) then return end
    if (not chunk or chunk == nil) then return end
    if (not radius or radius == nil) then radius = 1 end
    if (not depth or depth == nil) then depth = 1 end

    if (depth > 12) then
        Log.warn("could not find an enemy")
        return
    end

    local selected_difficulty = Constants.difficulty[Constants.difficulty.difficulties[Settings_Service.get_difficulty(surface.name)]]

    -- local limit = math.random(selected_difficulty.value * selected_difficulty.value)
    -- local limit = selected_difficulty.value + math.random(selected_difficulty.value * selected_difficulty.value)
    local limit = selected_difficulty.value + (selected_difficulty.value * selected_difficulty.value)

    local enemy = surface.find_entities_filtered({
        position = { x = chunk.x * 32, y = chunk.y * 32 },
        -- radius = 4 * radius,
        radius = 4 * radius * selected_difficulty.radius_modifier,
        name = Spawn_Constants.name,
        force = "enemy",
        -- limit = 1 * selected_difficulty.value,
        limit = limit,
    })

    if (not enemy or not enemy[1]) then
        -- return locals.get_enemy(surface, chunk, 1.1 * radius + 1, depth + 1)
        return locals.get_enemy(surface, chunk, 1.1 * radius + selected_difficulty.radius_modifier, depth + 1)
    end

    return enemy
end

function locals.get_target_entity(unit_group, radius, depth)
    if (not unit_group or not unit_group.valid) then return end
    if (not radius or radius == nil) then radius = 1 end
    if (not depth or depth == nil) then depth = 1 end

    if (depth > 12) then return end

    local names = {
        "artillery-projectile",
        "fire-flame",
        "fire-flame-on-tree",
        "fire-sticker",
        "laser-beam"
    }

    if (script and script.active_mods and script.active_mods["NAS_Fork"]) then
        table.insert(names, "artillery-projectile-nuclear")
    end

    local targets = unit_group.surface.find_entities_filtered({
        position = unit_group.position,
        radius = 32 * radius,
        name = names,
        type = {
            "entity-ghost",
            "fire",
            "projectile",
            "beam",
            "sticker",
        },
        limit = 1,
        force = { "enemy", "neutral" },
        invert = true,
    })

    if (not targets or not targets[1]) then return locals.get_target_entity(unit_group, 1.1 * radius + 1, depth + 1) end

    return targets[1]
end

attack_group_service.more_enemies = true

local _attack_group_service = attack_group_service

return attack_group_service