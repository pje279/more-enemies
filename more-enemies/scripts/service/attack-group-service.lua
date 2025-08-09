-- If already defined, return
if _attack_group_service and _attack_group_service.more_enemies then
  return _attack_group_service
end

local Constants = require("libs.constants.constants")
local Log = require("libs.log.log")
local Settings_Service = require("scripts.service.settings-service")
local Spawn_Constants = require("libs.constants.spawn-constants")

local locals = {}

local attack_group_service = {}

attack_group_service.attack_group = {}

function attack_group_service.do_attack_group(planet)

    if (not attack_group_service.attack_group[planet.string_val]) then
        local peace_time_tick = Settings_Service.get_attack_group_peace_time(planet.string_val) * Constants.time.TICKS_PER_MINUTE
        if (type(peace_time_tick) ~= "number") then peace_time_tick = 0 end

        attack_group_service.attack_group[planet.string_val] = {
            unit_group = nil,
            tick = 0 + peace_time_tick,
            radius = 1,
            chunks = {},
            max_distance = {
                pos_x = 0,
                pos_y = 0,
                neg_x = 0,
                neg_y = 0,
            }
        }
    end

    if (attack_group_service.attack_group and attack_group_service.attack_group[planet.string_val] and attack_group_service.attack_group[planet.string_val].tick and game and game.tick >= attack_group_service.attack_group[planet.string_val].tick) then
      local surface = game.surfaces[planet.string_val]
      if (surface and surface.valid) then

        local attack_group = attack_group_service.attack_group[planet.string_val]

        -- local function get_new_chunk(chunk, depth)

        --   if (not depth or depth == nil) then depth = 1 end
        --   if (not chunk or chunk == nil) then return end

        --   if (chunk.x > 0 and chunk.x > attack_group.max_distance.pos_x) then attack_group.max_distance.pos_x = chunk.x end
        --   if (chunk.y > 0 and chunk.y > attack_group.max_distance.pos_y) then attack_group.max_distance.pos_y = chunk.y end

        --   if (chunk.x < 0 and chunk.x < attack_group.max_distance.neg_x) then attack_group.max_distance.neg_x = chunk.x end
        --   if (chunk.y < 0 and chunk.y < attack_group.max_distance.neg_y) then attack_group.max_distance.neg_y = chunk.y end


        --   local neg_x = -1

        --   if (not attack_group.max_distance.neg_x or attack_group.max_distance.neg_x == nil) then
        --     attack_group.max_distance.neg_x = -1
        --   end

        --   if (attack_group.max_distance.neg_x) then
        --     neg_x = attack_group.max_distance.neg_x
        --   end

        --   local pos_x = 1

        --   if (not attack_group.max_distance.pos_x or attack_group.max_distance.pos_x == nil) then
        --     attack_group.max_distance.pos_x = 1
        --   end

        --   if (attack_group.max_distance.pos_x) then
        --     pos_x = attack_group.max_distance.pos_x
        --   end

        --   local x = math.random(neg_x or -1, pos_x or 1)
        --   x = x - x % 1

        --   local neg_y = -1

        --   if (not attack_group.max_distance.neg_y or attack_group.max_distance.neg_y == nil) then
        --     attack_group.max_distance.neg_y = -1
        --   end

        --   if (attack_group.max_distance.neg_y) then
        --     neg_y = attack_group.max_distance.neg_y
        --   end

        --   local pos_y = 1

        --   if (not attack_group.max_distance.pos_y or attack_group.max_distance.pos_y == nil) then
        --     attack_group.max_distance.pos_y = 1
        --   end

        --   if (attack_group.max_distance.pos_y) then
        --     pos_y = attack_group.max_distance.pos_y
        --   end

        --   local y = math.random(neg_y or -1, pos_y or 1)
        --   y = y - y % 1

        --   chunk.x = x
        --   chunk.y = y

        --   local surface = game.surfaces[planet.string_val]

        --   if (surface and surface.valid and not surface.is_chunk_generated({ x, y })) then
        --     if (x > 0) then
        --       if (attack_group.max_distance.pos_x > 2) then
        --         attack_group.max_distance.pos_x = attack_group.max_distance.pos_x / 2
        --       end
        --     else
        --       if (attack_group.max_distance.neg_x > 2) then
        --         attack_group.max_distance.neg_x = attack_group.max_distance.neg_x / 2
        --       end
        --     end

        --     if (y > 0) then
        --       if (attack_group.max_distance.pos_y > 2) then
        --         attack_group.max_distance.pos_y = attack_group.max_distance.pos_y / 2
        --       end
        --     else
        --       if (attack_group.max_distance.neg_y > 2) then
        --         attack_group.max_distance.neg_y = attack_group.max_distance.neg_y / 2
        --       end
        --     end

        --     Log.error("chunk not generated - getting new chunk")
        --     return get_new_chunk(surface.get_random_chunk(), depth + 1)
        --   end

        --   if (not attack_group.chunks[x]) then
        --     attack_group.chunks[x] = {}
        --     attack_group.chunks[x][y] = {
        --       tick = game.tick + 9000,
        --       count = 1,
        --     }
        --   else
        --     if (not attack_group.chunks[x][y]) then
        --       attack_group.chunks[x][y] = {
        --         tick = game.tick + 9000,
        --         count = 1
        --       }
        --     elseif (type(attack_group.chunks[x][y].tick) == "number" and game.tick >= attack_group.chunks[x][y].tick) then
        --       if (attack_group.chunks[x][y].count > 1) then
        --         attack_group.chunks[x][y].tick = game.tick + 36000 / attack_group.chunks[x][y].count
        --       else
        --         attack_group.chunks[x][y].tick = game.tick + 36000
        --       end

        --       if (attack_group.chunks[x][y].count > 2) then
        --         attack_group.chunks[x][y].count = attack_group.chunks[x][y].count / 2
        --       end
        --     else
        --       attack_group.chunks[x][y].count = attack_group.chunks[x][y].count + 1

        --       if (depth > 12) then
        --         Log.error("could not find a new chunk")
        --         return
        --       end

        --       Log.error("getting new chunk")

        --       attack_group.max_distance.pos_x = attack_group.max_distance.pos_x + 1
        --       attack_group.max_distance.pos_y = attack_group.max_distance.pos_y + 1
        --       attack_group.max_distance.neg_x = attack_group.max_distance.neg_x + 1
        --       attack_group.max_distance.neg_y = attack_group.max_distance.neg_y + 1

        --       return get_new_chunk(surface.get_random_chunk(), depth + 1)
        --     end
        --   end

        --   return chunk
        -- end

        -- local chunk = get_new_chunk(surface.get_random_chunk())
        local chunk = locals.get_new_chunk(planet, surface.get_random_chunk())

        if (chunk) then
          Log.error(planet.string_val)
          Log.error(chunk)
          Log.error(attack_group.radius)

        --   local function get_enemy(surface, radius, depth)
        --     if (not surface or not surface.valid) then return end
        --     if (not radius or radius == nil) then radius = 1 end
        --     if (not depth or depth == nil) then depth = 1 end

        --     if (depth > 12) then
        --       Log.error("could not find an enemy")
        --       return
        --     end

        --     local enemy = surface.find_entities_filtered({
        --       position = { x = chunk.x * 32, y = chunk.y * 32 },
        --       radius = 4 * radius,
        --       name = Spawn_Constants.name,
        --       force = "enemy",
        --       limit = 1,
        --     })

        --     if (not enemy or not enemy[1]) then
        --       return get_enemy(surface, 1.1 * radius + 1, depth + 1)
        --     end

        --     return enemy
        --   end

        --   local enemy = get_enemy(attack_group.radius)
          local enemy = locals.get_enemy(surface, chunk, attack_group.radius)
          if (enemy and enemy[1] and enemy[1].valid) then
            Log.error(enemy)
            local unit_group = surface.create_unit_group({ position = enemy[1].position})
            if (unit_group and unit_group.valid) then
              enemy[1].release_from_spawner()
              enemy[1].ai_settings.allow_try_return_to_spawner = false
              enemy[1].ai_settings.join_attacks = true

              unit_group.add_member(enemy[1])

            --   local function get_target_entity(unit_group, radius, depth)
            --     if (not unit_group or not unit_group.valid) then return end
            --     if (not radius or radius == nil) then radius = 1 end
            --     if (not depth or depth == nil) then depth = 1 end

            --     if (depth > 12) then return end

            --     local targets = unit_group.surface.find_entities_filtered({
            --       position = unit_group.position,
            --       radius = 32 * radius,
            --       name = {
            --         "fire-flame",
            --         "fire-flame-on-tree",
            --       },
            --       type = {
            --         "entity-ghost",
            --         "fire",
            --       },
            --       limit = 1,
            --       force = {"enemy", "neutral"},
            --       invert = true,
            --     })

            --     if (not targets or not targets[1]) then return get_target_entity(unit_group, 1.1 * radius + 1, depth + 1) end

            --     return targets[1]
            --   end

            --   local target_entity = get_target_entity(unit_group)
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
                  Log.error("unit group released")
                else
                  Log.error("no target; destroying")
                  unit_group.destroy()
                end

                if (attack_group.radius > 2) then
                  attack_group.radius = attack_group.radius / 2
                end
              end
            end
          else

            local delay = 300

            if (attack_group.radius < delay / 2) then
              attack_group.tick = game.tick + delay - 2 * attack_group.radius
              attack_group.radius = 1.1 * attack_group.radius + 1
            end
          end
        end
      end
    end
end

function locals.get_new_chunk(planet, chunk, depth)
    if (not planet or planet == nil) then return end
    if (not chunk or chunk == nil) then return end
    if (not depth or depth == nil) then depth = 1 end

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

        Log.error("chunk not generated - getting new chunk")
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

            if (depth > 12) then
                Log.error("could not find a new chunk")
                return
            end

            Log.error("getting new chunk")

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
        Log.error("could not find an enemy")
        return
    end

    local enemy = surface.find_entities_filtered({
        position = { x = chunk.x * 32, y = chunk.y * 32 },
        radius = 4 * radius,
        name = Spawn_Constants.name,
        force = "enemy",
        limit = 1,
    })

    if (not enemy or not enemy[1]) then
        return locals.get_enemy(surface, chunk, 1.1 * radius + 1, depth + 1)
    end

    return enemy
end

function locals.get_target_entity(unit_group, radius, depth)
    if (not unit_group or not unit_group.valid) then return end
    if (not radius or radius == nil) then radius = 1 end
    if (not depth or depth == nil) then depth = 1 end

    if (depth > 12) then return end

    local targets = unit_group.surface.find_entities_filtered({
        position = unit_group.position,
        radius = 32 * radius,
        name = {
            "fire-flame",
            "fire-flame-on-tree",
        },
        type = {
            "entity-ghost",
            "fire",
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