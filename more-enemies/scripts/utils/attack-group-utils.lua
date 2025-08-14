-- If already defined, return
if _attack_group_utils and _attack_group_utils.more_enemies then
  return _attack_group_utils
end

local Attack_Group_Constants = require("libs.constants.attack-group-constants")
local Constants = require("libs.constants.constants")
local Log = require("libs.log.log")
local Settings_Service = require("scripts.service.settings-service")
local Settings_Utils = require("scripts.utils.settings-utils")
local Spawn_Constants = require("libs.constants.spawn-constants")

local attack_group_utils = {}

function attack_group_utils.get_new_chunk(attack_group, planet, chunk, depth)
    Log.debug("attack_group_utils.get_new_chunk")
    Log.info(attack_group)
    Log.info(planet)
    Log.info(chunk)
    Log.info(depth)

    if (not type(attack_group) == "table") then return end
    if (not planet or planet == nil) then return end
    if (not chunk or chunk == nil) then return end
    if (not depth or depth == nil) then depth = 1 end

    if (depth > 12) then
        Log.warn("could not find a new chunk")
        return
    end

    -- local attack_group = attack_group_service.attack_group[planet.string_val]
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
        return attack_group_utils.get_new_chunk(attack_group, planet, surface.get_random_chunk(), depth + 1)
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

            return attack_group_utils.get_new_chunk(attack_group, planet, surface.get_random_chunk(), depth + 1)
        end
    end

    return chunk
end

function attack_group_utils.get_enemy(surface, chunk, radius, depth)
    Log.debug("attack_group_utils.get_enemy")
    Log.info(surface)
    Log.info(chunk)
    Log.info(radius)
    Log.info(depth)

    if (not surface or not surface.valid) then return end
    if (not chunk or chunk == nil) then return end
    if (not radius or radius == nil) then radius = 1 end
    if (not depth or depth == nil) then depth = 1 end

    if (depth > 12) then
        Log.warn("could not find an enemy")
        return
    end

    local selected_difficulty = Constants.difficulty[Constants.difficulty.difficulties[Settings_Service.get_difficulty(surface.name)]]

    local limit = selected_difficulty.value + (selected_difficulty.value * selected_difficulty.value)

    local enemies = surface.find_entities_filtered({
        position = { x = chunk.x * 32, y = chunk.y * 32 },
        radius = 4 * radius * selected_difficulty.radius_modifier,
        name = Spawn_Constants.name,
        force = "enemy",
        limit = limit,
    })

    if (not enemies or not enemies[1]) then
        return attack_group_utils.get_enemy(surface, chunk, 1.1 * radius + selected_difficulty.radius_modifier, depth + 1)
    end

    return enemies
end

-- function attack_group_utils.get_target_entity(unit_group, radius, depth)
function attack_group_utils.get_target_entity(data)
    Log.debug("attack_group_utils.get_target_entity")
    Log.info(data)
    -- Log.info(unit_group)
    -- Log.info(radius)
    -- Log.info(depth)

    if (type(data) ~= "table") then return end
    if (not data.unit_group or not data.unit_group.valid) then return end
    if (not data.unit_group.surface or not data.unit_group.surface.valid) then return end
    if (type(data.radius) ~= "number") then data.radius = 1 end
    if (type(data.depth) ~= "number") then data.depth = 1 end

    local radius = data.radius
    local depth = data.depth
    local unit_group = data.unit_group

    if (depth > 12) then return end
    if (radius > Constants.CHUNK_SIZE * 16 and depth > 1) then return end

    local names = {}
    local blacklist_names = Settings_Utils.get_attack_group_blacklist_names()

    if (blacklist_names) then
        for _, v in pairs(blacklist_names) do
            table.insert(names, v)
        end
    end

    if (next(names, nil) == nil) then names = nil end

    local selected_difficulty = Constants.difficulty[Constants.difficulty.difficulties[Settings_Service.get_difficulty(unit_group.surface.name)]]

    local position = unit_group.position
    local chunk = data.chunk

    if (type(chunk) == "table" and type(chunk.x) == "number" and type(chunk.y) == "number") then
        Log.error("targeted attack")
        -- Log.error(chunk)
        position = {
            x = chunk.x * 32,
            y = chunk.y * 32
        }
    end

    local targets = unit_group.surface.find_entities_filtered({
        -- position = unit_group.position,
        position = position,
        radius = 16 * radius * selected_difficulty.radius_modifier + depth,
        name = names,
        type = Attack_Group_Constants.type_blacklist,
        limit = 1,
        force = { "enemy", "neutral" },
        invert = true,
    })

    -- if (not targets or not targets[1]) then return attack_group_utils.get_target_entity(unit_group, 1.1 * radius + selected_difficulty.radius_modifier, depth + 1) end
    data.radius = 1.1 * radius + selected_difficulty.radius_modifier
    data.depth = depth + 1
    if (not targets or not targets[1]) then return attack_group_utils.get_target_entity(data) end

    Log.debug("found 'em")
    return targets[1]
end

attack_group_utils.more_enemies = true

local _attack_group_utils = attack_group_utils

return attack_group_utils
