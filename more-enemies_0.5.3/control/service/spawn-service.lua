-- If already defined, return
if _spawn_service and _spawn_service.more_enemies then
  return _spawn_service
end

local BREAM_Constants = require("libs.constants.mods.BREAM-constants")
local BREAM_Settings_Constants = require("libs.constants.settings.mods.BREAM.BREAM-settings-constants")
local Clone_Data = require("control.data.clone-data")
local Constants = require("libs.constants.constants")
local Difficulty_Utils = require("control.utils.difficulty-utils")
local Entity_Validations = require("control.validations.entity-validations")
local Gleba_Settings_Constants = require("libs.constants.settings.gleba-settings-constants")
local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Initialization = require("control.initialization")
local Log = require("libs.log.log")
local Mod_Repository = require("control.repositories.mod-repository")
local More_Enemies_Repository = require("control.repositories.more-enemies-repository")
local Nauvis_Settings_Constants = require("libs.constants.settings.nauvis-settings-constants")
local Settings_Service = require("control.service.settings-service")
local Settings_Utils = require("control.utils.settings-utils")
local Spawn_Utils = require("control.utils.spawn-utils")
local Unit_Group_Data = require("control.data.unit-group-data")

local spawn_service = {}

spawn_service.BREAM = {}
spawn_service.BREAM.unit_group = nil

function spawn_service.clone_attempts()
  Log.debug("spawn_service.clone_attempts")

  local more_enemies_data = More_Enemies_Repository.get_more_enemies_data()

  -- Validate "inputs"
  if (not more_enemies_data.valid or not more_enemies_data.clones) then more_enemies_data = Initialization.reinit() end

  -- if (#more_enemies_data.clones > Settings_Service.get_maximum_number_of_clones()) then
  --   Log.none("Tried to clone more than the unit limt")
  --   more_enemies_data.overflow_clone_attempts.warned.none = true
  --   return
  -- end

  local max_num_clones = Settings_Service.get_maximum_number_of_clones()
  local num_clones = #more_enemies_data.clones

  if (not more_enemies_data.overflow_clone_attempts.warned.error
      and num_clones > max_num_clones)
  then
    Log.error("Tried to clone more than the unit limt")
    more_enemies_data.overflow_clone_attempts.warned.error = true
    return
  end

  if (not more_enemies_data.overflow_clone_attempts.warned.warn
      and num_clones > max_num_clones)
  then
    Log.warn("Tried to clone more than the unit limt")
    more_enemies_data.overflow_clone_attempts.warned.warn = true
    return
  end

  if (not more_enemies_data.overflow_clone_attempts.warned.debug
      and num_clones > max_num_clones)
  then
    Log.debug("Tried to clone more than the unit limt")
    more_enemies_data.overflow_clone_attempts.warned.debug = true
    return
  end

  if (not more_enemies_data.overflow_clone_attempts.warned.info
      and num_clones > max_num_clones)
  then
    Log.info("Tried to clone more than the unit limt")
    more_enemies_data.overflow_clone_attempts.warned.info = true
    return
  end
end

function spawn_service.do_nth_tick(event, more_enemies_data)
  -- Log.debug("spawn_service.do_nth_tick")
  -- Log.info(event)
  -- Log.info(more_enemies_data)
  local did_complete = false
  local tick = event.tick
  local more_enemies_data = more_enemies_data and more_enemies_data.valid and more_enemies_data or More_Enemies_Repository.get_more_enemies_data()

  Log.info("spawn_controller.do_nth_tick")
  if (not storage) then return false end
  Log.info("passed storage")
  if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end
  if (not more_enemies_data.do_nth_tick) then return end

  local mod_data = Mod_Repository.get_mod_data()

  Log.info("Clone attempts")
  spawn_service.clone_attempts()

  local clones = {}
  local clones_per_tick = Settings_Service.get_clones_per_tick()
  local clone_overflow = 1

  local max_num_clones = Settings_Service.get_maximum_number_of_clones()
  local max_num_modded_clones = Settings_Service.get_maximum_number_of_modded_clones()
  Log.info(max_num_clones)
  Log.info(more_enemies_data.clone.count)

  if (storage) then
    for k, planet in pairs(Constants.DEFAULTS.planets) do
      Log.info(k)
      Log.debug(planet)

      if (not Settings_Utils.is_vanilla(planet.string_val)) then
        Log.info("attempting to clone")

        if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end

        local unit_group = spawn_service.BREAM.unit_group
        local skip = false

        -- if (more_enemies_data.mod.staged_clones) then
        if (mod_data.staged_clones) then
          -- for _, _staged_clone in pairs(more_enemies_data.mod.staged_clones) do
          for _, _staged_clone in pairs(mod_data.staged_clones) do
            Log.info(_staged_clone)
            local staged_clone = _staged_clone.obj
            local mod_name = _staged_clone.mod_name

            if (not unit_group) then
              if (mod_name and mod_name == BREAM_Constants.name) then
                if (staged_clone and staged_clone.valid) then
                  if (not spawn_service.BREAM.unit_group) then
                    Log.info("creating unit group from: " .. serpent.block(staged_clone))
                    spawn_service.BREAM.unit_group = staged_clone.surface.create_unit_group({ position = staged_clone.position, force = "enemy" })
                  end
                end
              end
            end
            break
          end
        end

        unit_group = spawn_service.BREAM.unit_group
        local j = 0
        -- for i, _mod_staged_clone in pairs(more_enemies_data.mod.staged_clones) do
        for i, _mod_staged_clone in pairs(mod_data.staged_clones) do
          if (  Settings_Service.get_BREAM_difficulty() == Constants.difficulty.VANILLA.string_val
            and Settings_Service.get_BREAM_do_clone() == false
            and Settings_Service.get_BREAM_clone_units() == BREAM_Settings_Constants.settings.BREAM_CLONE_UNITS.default_value)
          then
            Log.debug("found Vanilla settings for BREAM; breaking")
            break
          end

          skip = false

          Log.info(i)
          Log.info(_mod_staged_clone)
          local mod_stage_clone = _mod_staged_clone.obj
          local unit_number = 1
          local surface_name = Constants.DEFAULTS.planets.nauvis.string_val
          local mod_name = nil

          if (j > clones_per_tick) then
            Log.warn("Tried to clone more than the clone_per_tick limit; breaking inner loop")
            clone_overflow = clone_overflow + 1
            break
          end

          if (not mod_stage_clone or not mod_stage_clone.valid or mod_stage_clone.surface.name ~= planet.string_val) then
            Log.warn("mod_stage_clone is nil, invalid, or wrong planet for clone; skipping")
            skip = true
          else
            unit_number = mod_stage_clone.unit_number
            surface_name = mod_stage_clone.surface.name
            mod_name = _mod_staged_clone.mod_name
          end

          if (not skip) then
            -- if (more_enemies_data.mod.clone.count > max_num_modded_clones) then
            if (mod_data.clone.count > max_num_modded_clones) then
              Log.warn("Tried to clone more than the unit limit: " .. serpent.block(max_num_modded_clones))
              Log.warn("Currently " .. serpent.block(more_enemies_data.clone.count) .. " clones")
              break
            end

            Log.debug(surface_name)
            local bream_clone_units_setting = Settings_Service.get_BREAM_clone_units(surface_name)
            Log.info("clone_unit_setting: " .. serpent.block(clone_unit_setting))
            Log.info("clone_unit_group_setting: " .. serpent.block(clone_unit_group_setting))

            local clone_settings = {
              unit = bream_clone_units_setting,
              unit_group = bream_clone_units_setting,
              type = unit_group and "unit-group" or "unit",
            }

            local difficulty_setting = Settings_Service.get_BREAM_difficulty()
            Log.info(difficulty_setting)
            local difficulty =
            {
              selected_difficulty = Constants.difficulty[Constants.difficulty.difficulties[difficulty_setting]],
              valid = true
            }
            Log.info(difficulty)
            Log.info(Constants.difficulty)

            clones = {}

            Log.debug("mod added: Attempting to clone entity on planet " .. surface_name)
            Log.info(clone_settings)
            if (surface_name == Constants.DEFAULTS.planets.nauvis.string_val) then
              clones = Spawn_Utils.clone_entity(
                {
                  value = Nauvis_Settings_Constants.settings.CLONE_NAUVIS_UNITS.default_value
                },
                difficulty,
                mod_stage_clone,
                {
                  clone_settings = clone_settings,
                  tick = tick,
                  mod_name = mod_name,
                  surface = surface_name,
                }
              )
            elseif (surface_name == Constants.DEFAULTS.planets.gleba.string_val) then
              clones = Spawn_Utils.clone_entity(
                {
                  value = Gleba_Settings_Constants.settings.CLONE_GLEBA_UNITS.default_value
                },
                difficulty,
                mod_stage_clone,
                {
                  clone_settings = clone_settings,
                  tick = tick,
                  mod_name = mod_name,
                  surface = surface_name,
                }
              )
            else
              Log.warn("Planet is neither nauvis nor gleba\nPlanet is unsupported; making no changes")
              return
            end

            if (clones) then
              j = j + #clones
            end

            Log.info("clones = " .. serpent.block(clones))

            -- add the new clones to storage
            if (clones and #clones > 0) then
              if (mod_name and mod_name == BREAM_Constants.name) then
                if (unit_group and unit_group.valid) then

                  Log.info("Getting selected_difficulty")
                  local selected_difficulty = difficulty.selected_difficulty
                  if (not selected_difficulty) then return end

                  local clone_unit_group_setting = Settings_Service.get_clone_unit_group_setting(unit_group.surface.name)

                  Log.info("adding unit_group: " .. serpent.block(unit_group))

                  Log.info(unit_group.surface.name)

                  Log.info("before: " .. serpent.block(more_enemies_data.groups))

                  if (not more_enemies_data.groups[unit_group.surface.name]) then
                    more_enemies_data.groups[unit_group.surface.name] = {}
                  end

                  Log.info("after: " .. serpent.block(more_enemies_data.groups))

                  local loop_len = 1
                  local use_evolution_factor = Settings_Service.get_BREAM_use_evolution_factor(unit_group.surface.name)
                  local evolution_factor = 1

                  Log.debug("use_evolution_factor  = "  .. serpent.block(use_evolution_factor))
                  if (use_evolution_factor) then
                    evolution_factor = unit_group.force.get_evolution_factor()
                  end

                  if (selected_difficulty.value > 1) then
                    loop_len = math.floor((selected_difficulty.value + clone_unit_group_setting) * evolution_factor)
                  else
                    loop_len = math.floor((selected_difficulty.value * clone_unit_group_setting) * evolution_factor)
                  end
                  Log.info("loop_len: " .. serpent.block(loop_len))

                  if (not more_enemies_data.groups[unit_group.surface.name]) then more_enemies_data.groups[unit_group.surface.name] = {} end

                  -- local unit_group_data = Unit_Group_Data:new()
                  -- unit_group_data.group = unit_group
                  -- unit_group_data.max_count = loop_len
                  -- unit_group_data.mod_name = BREAM_Constants.name
                  -- unit_group_data.valid = true

                  -- more_enemies_data.groups[unit_group.surface.name][unit_group.unique_id] = unit_group_data
                  more_enemies_data.groups[unit_group.surface.name][unit_group.unique_id] = Unit_Group_Data:new({
                    valid = true,
                    group = unit_group,
                    count = 0,
                    max_count = loop_len,
                    mod_name = BREAM_Constants.name,
                  })
                  -- more_enemies_data.groups[unit_group.surface.name][unit_group.unique_id] = {
                  --   valid = true,
                  --   group = unit_group,
                  --   count = 0,
                  --   max_count = loop_len,
                  --   mod_name = BREAM_Constants.name,
                  -- }
                end
              end

              for j=1, #clones do
                if (clones[j] and clones[j] ~= nil and clones[j].clone.valid) then
                  Log.info("adding clone: " .. serpent.block(clones[j]))
                  -- more_enemies_data.clones[clones[j].clone.unit_number] = {
                  --   obj = clones[j].clone,
                  --   type = unit_group and "unit-group" or "unit",
                  --   mod_name = clones[j].mod_name,
                  --   surface = clones[j].clone.surface,
                  --   valid = clones[j].clone.valid
                  -- }
                  more_enemies_data.clones[clones[j].clone.unit_number] = Clone_Data:new({
                    obj = clones[j].clone,
                    type = unit_group and "unit-group" or "unit",
                    mod_name = clones[j].mod_name,
                    surface = clones[j].clone.surface,
                    valid = clones[j].clone.valid
                  })
                end

                if (unit_group and unit_group.valid and unit_group.surface.name == clones[j].clone.surface.name) then
                  unit_group.add_member(clones[j].clone)
                end

                clones[j] = nil

                -- if (not more_enemies_data.mod.clone) then more_enemies_data.mod.clone = {} end
                -- if (more_enemies_data.mod.clone.count == nil) then more_enemies_data.mod.clone.count = 0 end

                -- if (more_enemies_data.mod.clone.count < 0) then more_enemies_data.mod.clone.count = 0 end
                if (mod_data.clone.count < 0) then mod_data.clone.count = 0 end

                -- more_enemies_data.mod.clone.count = more_enemies_data.mod.clone.count + 1
                mod_data.clone.count = mod_data.clone.count + 1
              end
            end

            if (unit_group and unit_group.valid) then
              local target_entity = unit_group.surface.find_nearest_enemy({
                position = unit_group.position,
                max_distance = 111111, -- TODO: Make this configurable
                force = "enemy"
              })

              Log.info(target_entity)

              if (target_entity) then
                unit_group.set_command({
                  type = defines.command.attack_area,
                  destination = target_entity.position,
                  radius = 1111, -- TODO: Make this configurable
                })
                Log.info("releasing from spawner")
                unit_group.release_from_spawner()
                Log.debug("start moving")
                unit_group.start_moving()
              else
                Log.warn("no target; destroying")
                unit_group.destroy()
              end

              if (not more_enemies_data.groups[unit_group.surface.name]) then more_enemies_data.groups[unit_group.surface.name] = {} end

              -- remove the unit_group after processing
              spawn_service.BREAM.unit_group = nil
              more_enemies_data.groups[unit_group.surface.name][unit_group.unique_id] = nil
            end
            -- remove the staged_clone after processing
            -- more_enemies_data.mod.staged_clones[unit_number] = nil
            mod_data.staged_clones[unit_number] = nil
          end
        end

        if (clone_overflow > 1) then
          if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end

          more_enemies_data.overflow_clone_attempts.count = more_enemies_data.overflow_clone_attempts.count + 1
          Log.debug("Tried to clone more than the unit limt; returning")
          return
        end

        -- j = 0
        for i, _staged_clone in pairs(more_enemies_data.staged_clones) do
          local skip = false

          Log.info(i)
          Log.info(_staged_clone)
          local staged_clone = _staged_clone.obj
          local group = _staged_clone.group
          local unit_number = 1
          local surface_name = Constants.DEFAULTS.planets.nauvis.string_val

          if (group and not group.valid) then
            Log.debug("_staged_clone.group was invalid; skipping")
            skip = true
          end

          if (j > clones_per_tick) then
            Log.debug("Tried to clone more than the clone_per_tick limt; breaking inner loop")
            clone_overflow = clone_overflow + 1
            break
          end

          if (not staged_clone or not staged_clone.valid or staged_clone.surface.name ~= planet.string_val) then
            Log.debug("staged_clone is nil, invalid, or wrong planet for clone; skipping")
            skip = true
          else
            unit_number = staged_clone.unit_number
            surface_name = staged_clone.surface.name
          end

          if (not skip) then
            if (more_enemies_data.clone.count > max_num_clones) then
              Log.warn("Tried to clone more than the unit limit: " .. serpent.block(max_num_clones))
              Log.warn("Currently " .. serpent.block(more_enemies_data.clone.count) .. " clones")
              return
            end

            Log.debug(surface_name)
            local clone_unit_setting = Settings_Service.get_clone_unit_setting(surface_name)
            local clone_unit_group_setting = Settings_Service.get_clone_unit_group_setting(surface_name)
            Log.info("clone_unit_setting: " .. serpent.block(clone_unit_setting))
            Log.info("clone_unit_group_setting: " .. serpent.block(clone_unit_group_setting))

            local clone_settings = {
              unit = clone_unit_setting,
              unit_group = clone_unit_group_setting,
              type = group and "unit-group" or "unit"
            }

            clones = {}

            Log.info("Attempting to clone entity on planet " .. surface_name)
            Log.debug(clone_settings)
            if (surface_name == Constants.DEFAULTS.planets.nauvis.string_val) then
              clones = Spawn_Utils.clone_entity(
                { value = Nauvis_Settings_Constants.settings.CLONE_NAUVIS_UNITS.default_value },
                more_enemies_data.difficulties[surface_name].difficulty,
                staged_clone,
                {
                  clone_settings = clone_settings,
                  tick = tick
                }
              )
            elseif (surface_name == Constants.DEFAULTS.planets.gleba.string_val) then
              clones = Spawn_Utils.clone_entity(
                { value = Gleba_Settings_Constants.settings.CLONE_GLEBA_UNITS.default_value },
                more_enemies_data.difficulties[surface_name].difficulty,
                staged_clone,
                {
                  clone_settings = clone_settings,
                  tick = tick
                }
              )
            else
              Log.warn("Planet is neither nauvis nor gleba\nPlanet is unsupported; making no changes")
              return
            end

            if (clones) then
              j = j + #clones
            end

            Log.debug("clones = " .. serpent.block(clones))

            -- add the new clones to storage
            if (clones and #clones > 0) then
              for j=1, #clones do
                if (clones[j] and clones[j] ~= nil and clones[j].clone.valid) then
                  Log.info("adding clone: " .. serpent.block(clones[j]))
                  -- more_enemies_data.clones[clones[j].clone.unit_number] = {
                  --   obj = clones[j].clone,
                  --   type = group and "unit-group" or "unit",
                  --   mod_name = nil,
                  -- }
                  more_enemies_data.clones[clones[j].clone.unit_number] = Clone_Data:new({
                    obj = clones[j].clone,
                    type = group and "unit-group" or "unit",
                    mod_name = nil,
                    valid = clones[j].clone.valid
                  })
                end

                if (group and group.valid) then
                  group.add_member(clones[j].clone)
                end

                clones[j] = nil

                if (more_enemies_data.clone.count < 0) then more_enemies_data.clone.count = 0 end

                more_enemies_data.clone.count = more_enemies_data.clone.count + 1
              end

              if (group and group.valid) then
                if (  more_enemies_data.groups[group.surface.name]
                  and more_enemies_data.groups[group.surface.name][group.unique_id]
                  and more_enemies_data.groups[group.surface.name][group.unique_id].count ~= nil
                  and more_enemies_data.groups[group.surface.name][group.unique_id].max_count ~= nil
                  and more_enemies_data.groups[group.surface.name][group.unique_id].count >= more_enemies_data.groups[group.surface.name][group.unique_id].max_count)
                then
                  Log.debug("removing group: " .. serpent.block(group))
                  more_enemies_data.groups[group.surface.name][group.unique_id] = nil
                end
              end
            end
          end
          -- remove the staged_clone after processing
          more_enemies_data.staged_clones[unit_number] = nil
        end
      end
    end
  end

  return true
end

function spawn_service.do_nth_tick_cleanup(event, more_enemies_data)
  Log.debug("spawn_service.do_nth_tick_cleanup")
  Log.info(event)
  Log.info(more_enemies_data)

  -- local more_enemies_data = more_enemies_data or More_Enemies_Repository.get_more_enemies_data()
  more_enemies_data = more_enemies_data or More_Enemies_Repository.get_more_enemies_data()
  if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end

  local _temp = {}
  local _invalids = {}
  local i = 1
  local limit = Global_Settings_Constants.settings.CLONES_PER_TICK.default_value

  Log.info("Starting iteration of staged_clones")
  for _, planet in pairs(Constants.DEFAULTS.planets) do
    for k,v in pairs(more_enemies_data.staged_clones) do
      Log.info(v)
      if (not v or not v.obj or not v.obj.valid or v.obj == planet.string_val) then
        Log.info("Found nil or invalid clone")
        _invalids[k] = v
      end
      i = i + 1
      if (i > limit) then
        Log.debug("breaking from initial step of cleanup")
        break
      end
    end

    i = 1
    Log.info("Starting iteration of _invalids")
    for k,v in pairs(_invalids) do
      Log.info("Removing invalids")
      table.remove(more_enemies_data.staged_clones, k)

      i = i + 1
      if (i > limit) then
        Log.info("breaking from second step of cleanup")
        break
      end
    end
  end

  return true
end

function spawn_service.entity_died(event)
  Log.debug("spawn_service.entity_died")
  Log.info(event)

  local more_enemies_data = More_Enemies_Repository.get_more_enemies_data()

  local entity = event.entity
  if (not entity or not entity.valid) then return end
  if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end

  local mod_data = Mod_Repository.get_mod_data()

  if (more_enemies_data.clone.count < 0) then more_enemies_data.clone.count = 0 end

  -- if (more_enemies_data.mod.clone.count < 0) then more_enemies_data.mod.clone.count = 0 end
  if (mod_data.clone.count < 0) then mod_data.clone.count = 0 end

  Log.info("Attempting to remove entity")
  if (more_enemies_data.clones[entity.unit_number] ~= nil) then
    Log.debug("Removing entity: " .. serpent.block(entity.unit_number))

    if (Entity_Validations.get_mod_name(more_enemies_data.clones[entity.unit_number])) then
      -- if (more_enemies_data.mod.clone.count > 0) then more_enemies_data.mod.clone.count = more_enemies_data.mod.clone.count - 1 end
      if (mod_data.clone.count > 0) then mod_data.clone.count = mod_data.clone.count - 1 end
    else
      if (more_enemies_data.clone.count > 0) then more_enemies_data.clone.count = more_enemies_data.clone.count - 1 end
    end

    more_enemies_data.clones[entity.unit_number] = nil
    return
  end

  Log.info("Attempting to remove entity again")
  if (  entity
    and more_enemies_data.clone.count > 0
    and more_enemies_data.clones[entity.unit_number])
  then
    Log.debug("removing, second try")

    if (Entity_Validations.get_mod_name(more_enemies_data.clones[entity.unit_number])) then
      -- if (more_enemies_data.mod.clone.count > 0) then more_enemies_data.mod.clone.count = more_enemies_data.mod.clone.count - 1 end
      if (mod_data.clone.count > 0) then mod_data.clone.count = mod_data.clone.count - 1 end
    else
      if (more_enemies_data.clone.count > 0) then more_enemies_data.clone.count = more_enemies_data.clone.count - 1 end
    end

    more_enemies_data.clones[entity.unit_number] = nil
    return
  end

  if (  entity
    -- and more_enemies_data.mod.clone.count > 0
    and mod_data.clone.count > 0
    and more_enemies_data.clones[entity.unit_number])
  then
    Log.debug("mod removing, second try")

    if (Entity_Validations.get_mod_name(more_enemies_data.clones[entity.unit_number])) then
      -- if (more_enemies_data.mod.clone.count > 0) then more_enemies_data.mod.clone.count = more_enemies_data.mod.clone.count - 1 end
      if (mod_data.clone.count > 0) then mod_data.clone.count = mod_data.clone.count - 1 end
    else
      if (more_enemies_data.clone.count > 0) then more_enemies_data.clone.count = more_enemies_data.clone.count - 1 end
    end

    more_enemies_data.clones[entity.unit_number] = nil
    return
  end

  Log.debug("failed to remove")
end

function spawn_service.entity_spawned(event)
  Log.debug("spawn_service.entity_spawned")
  Log.info(event)

  local more_enemies_data = More_Enemies_Repository.get_more_enemies_data()

  local spawner = event.spawner
  local entity = event.entity

  if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end
  if (not more_enemies_data.do_nth_tick) then return end
  if (not entity or not entity.valid or not entity.surface or not entity.surface.valid or Settings_Utils.is_vanilla(entity.surface.name)) then return end

  local max_num_clones = Settings_Service.get_maximum_number_of_clones()
  if (more_enemies_data.clone.count > max_num_clones) then
    Log.warn("Tried to clone more than the unit limit: " .. serpent.block(max_num_clones))
    Log.warn("Currently " .. serpent.block(more_enemies_data.clone.count) .. " clones")
    return
  end

  if (not spawner or not spawner.valid) then return end
  if (not entity or not entity.valid) then return end
  if (not entity.surface or not entity.surface.name) then return end

  Log.info("Attempting to add to staged_clones")
  if (more_enemies_data.valid) then
    Log.debug("Adding to staged_clones: " .. serpent.block(entity.unit_number))

    -- more_enemies_data.staged_clones[entity.unit_number] = {
    --   obj = entity,
    --   surface = entity.surface,
    --   group = nil,
    --   mod_name = nil,
    -- }
    more_enemies_data.staged_clones[entity.unit_number] = Clone_Data:new({
      obj = entity,
      surface = entity.surface,
      group = nil,
      mod_name = nil,
      valid = entity.valid and entity.surface.valid
    })
  end
end

function spawn_service.entity_built(event)
  Log.info(event)

  local mod_name = event.mod_name
  local entity = event.entity
  local more_enemies_data = More_Enemies_Repository.get_more_enemies_data()

  if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end
  if (not more_enemies_data.do_nth_tick) then return end
  if (not entity or not entity.valid or not entity.surface or not entity.surface.valid or Settings_Utils.is_vanilla(entity.surface.name)) then return end

  local mod_data = Mod_Repository.get_mod_data()

  local max_num_modded_clones = Settings_Service.get_maximum_number_of_modded_clones()
  -- if (more_enemies_data.mod.clone.count > max_num_modded_clones) then
  if (mod_data.clone.count > max_num_modded_clones) then
    Log.warn("Tried to clone more than the unit limit: " .. serpent.block(max_num_modded_clones))
    -- Log.warn("Currently " .. serpent.block(more_enemies_data.mod.clone.count) .. " clones")
    Log.warn("Currently " .. serpent.block(mod_data.clone.count) .. " clones")
    return
  end

  if (not entity or not entity.valid) then return end
  if (not mod_name or mod_name ~= "BREAM") then return end
  if (not entity.surface or not entity.surface.name) then return end

  if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end

  Log.info("Attempting to add to staged_clones")
  if (more_enemies_data.valid) then
    Log.debug("entity_built - Adding to mod.staged_clones: " .. serpent.block(entity.unit_number))

    -- mod_data.staged_clones[entity.unit_number] =
    -- {
    --   obj = entity,
    --   surface = entity.surface,
    --   group = nil,
    --   mod_name = mod_name
    -- }
    mod_data.staged_clones[entity.unit_number] = Clone_Data:new({
      obj = entity,
      surface = entity.surface,
      group = nil,
      mod_name = mod_name,
      valid = entity.valid and entity.surface.valid,
    })
  end
end

spawn_service.more_enemies = true

local _spawn_service = spawn_service

return spawn_service