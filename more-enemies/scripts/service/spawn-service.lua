-- If already defined, return
if _spawn_service and _spawn_service.more_enemies then
  return _spawn_service
end

local BREAM_Constants = require("libs.constants.mods.BREAM-constants")
local BREAM_Settings_Constants = require("libs.constants.settings.mods.BREAM.BREAM-settings-constants")
local Clone_Data = require("scripts.data.clone-data")
local Constants = require("libs.constants.constants")
local Entity_Validations = require("scripts.validations.entity-validations")
local Gleba_Settings_Constants = require("libs.constants.settings.gleba-settings-constants")
local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Initialization = require("scripts.initialization")
local Log = require("libs.log.log")
local Mod_Repository = require("scripts.repositories.mod-repository")
local More_Enemies_Repository = require("scripts.repositories.more-enemies-repository")
local Nauvis_Settings_Constants = require("libs.constants.settings.nauvis-settings-constants")
local Settings_Service = require("scripts.service.settings-service")
local Settings_Utils = require("scripts.utils.settings-utils")
local Spawn_Utils = require("scripts.utils.spawn-utils")
local Unit_Group_Data = require("scripts.data.unit-group-data")

local locals = {}

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
  -- local did_complete = false
  local tick = event.tick
  local more_enemies_data = more_enemies_data and more_enemies_data.valid and more_enemies_data or More_Enemies_Repository.get_more_enemies_data()

  Log.info("spawn_controller.do_nth_tick")
  if (not storage) then return false end
  Log.info("passed storage")
  if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end
  if (not more_enemies_data.do_nth_tick) then return end

  local mod_data = Mod_Repository.get_mod_data()

  -- Log.info("Clone attempts")
  -- spawn_service.clone_attempts()

  local clones = {}
  local clones_per_tick = Settings_Service.get_clones_per_tick()
  local clone_overflow = 1

  local j = 0

  for k, planet in pairs(Constants.DEFAULTS.planets) do
    Log.info(k)
    Log.debug(planet)

    if (not more_enemies_data.clone[planet.string_val]) then
      more_enemies_data.clone[planet.string_val] = {}
    end
    if (more_enemies_data.clone[planet.string_val].unit == nil) then
      more_enemies_data.clone[planet.string_val].unit = 0
    end
    if (more_enemies_data.clone[planet.string_val].unit_group == nil) then
      more_enemies_data.clone[planet.string_val].unit_group = 0
    end

    Log.info(more_enemies_data.clone[planet.string_val].unit)
    Log.info(more_enemies_data.clone[planet.string_val].unit_group)

    if (not Settings_Utils.is_vanilla(planet.string_val)) then
      Log.info("attempting to clone")

      if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end

      if (not more_enemies_data.staged_clones[planet.string_val]) then
        more_enemies_data.staged_clones[planet.string_val] = {}
      end
      if (not more_enemies_data.staged_clones[planet.string_val].unit) then
        more_enemies_data.staged_clones[planet.string_val].unit = {}
      end
      if (not more_enemies_data.staged_clones[planet.string_val].unit_group) then
        more_enemies_data.staged_clones[planet.string_val].unit_group = {}
      end

      -- local j = 0

      if (script and script.active_mods and script.active_mods["BREAM"]) then
        locals.do_mod_nth_tick(mod_data)
      end

      -- j = 0

      for _, entity_list in pairs(more_enemies_data.staged_clones[planet.string_val]) do
      -- end

        j = 0

      -- for i, _staged_clone in pairs(more_enemies_data.staged_clones) do
      -- for i, _staged_clone in pairs(more_enemies_data.staged_clones[planet.string_val]) do
        for i, _staged_clone in pairs(entity_list) do
          local skip = false

          Log.info(i)
          Log.info(_staged_clone)
          local staged_clone = _staged_clone.obj
          local group = _staged_clone.group
          local unit_number = 1
          local surface_name = Constants.DEFAULTS.planets.nauvis.string_val

          if (group and not group.valid) then
            Log.debug("_staged_clone.group was invalid; skipping")
            Log.debug(_staged_clone)
            skip = true
          end

          if (j > clones_per_tick) then
            Log.debug("Tried to clone more than the clone_per_tick limt; breaking inner loop")
            clone_overflow = clone_overflow + 1
            -- if (clone_overflow > clones_per_tick * 2) then
            --   return
            -- elseif (clone_overflow > clones_per_tick * 1.5) then
            --   break
            -- else
            --   goto continue
            -- end
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

            local max_num_unit_clones = Settings_Service.get_maximum_number_of_spawned_clones()
            local max_num_unit_group_clones = Settings_Service.get_maximum_number_of_unit_group_clones()

            local at_capacity = 0

            -- if (clone_settings and clone_settings.type == "unit-group") then
            --   if (more_enemies_data.clone.unit_group > max_num_unit_group_clones) then
            --     Log.warn("Tried to clone more than the unit-group limit: " .. serpent.block(max_num_unit_group_clones))
            --     Log.warn("Currently " .. serpent.block(more_enemies_data.clone.unit) .. " unit clones")
            --     Log.warn("Currently " .. serpent.block(more_enemies_data.clone.unit_group) .. " unit-group clones")
            --     return
            --   end
            -- else
            --   if (more_enemies_data.clone.unit > max_num_unit_clones) then
            --     Log.warn("Tried to clone more than the unit limit: " .. serpent.block(max_num_unit_clones))
            --     Log.warn("Currently " .. serpent.block(more_enemies_data.clone.unit) .. " unit clones")
            --     Log.warn("Currently " .. serpent.block(more_enemies_data.clone.unit_group) .. " unit-group clones")
            --     return
            --   end
            -- end

            -- if (more_enemies_data.clone.unit_group > max_num_unit_group_clones) then
            --   Log.warn("Tried to clone more than the unit-group limit: " .. serpent.block(max_num_unit_group_clones))
            --   Log.warn("Currently " .. serpent.block(more_enemies_data.clone.unit) .. " unit clones")
            --   Log.warn("Currently " .. serpent.block(more_enemies_data.clone.unit_group) .. " unit-group clones")

            --   at_capacity = at_capacity + 1
            -- end
            -- if (more_enemies_data.clone.unit > max_num_unit_clones) then
            --   Log.warn("Tried to clone more than the unit limit: " .. serpent.block(max_num_unit_clones))
            --   Log.warn("Currently " .. serpent.block(more_enemies_data.clone.unit) .. " unit clones")
            --   Log.warn("Currently " .. serpent.block(more_enemies_data.clone.unit_group) .. " unit-group clones")

            --   at_capacity = at_capacity + 1
            -- end
            for _, planet in pairs(Constants.DEFAULTS.planets) do
              if (not more_enemies_data.clone[planet.string_val]) then
                more_enemies_data.clone[planet.string_val] = {}
                more_enemies_data.clone[planet.string_val].unit = 0
                more_enemies_data.clone[planet.string_val].unit_group = 0
              end

              if (more_enemies_data.clone[planet.string_val].unit_group > max_num_unit_group_clones) then
                Log.warn("Tried to clone more than the unit-group limit: " .. serpent.block(max_num_unit_group_clones))
                Log.warn("Currently " .. serpent.block(more_enemies_data.clone[planet.string_val].unit) .. " unit clones")
                Log.warn("Currently " .. serpent.block(more_enemies_data.clone[planet.string_val].unit_group) .. " unit-group clones")

                at_capacity = at_capacity + 1
              end
              if (more_enemies_data.clone[planet.string_val].unit > max_num_unit_clones) then
                Log.warn("Tried to clone more than the unit limit: " .. serpent.block(max_num_unit_clones))
                Log.warn("Currently " .. serpent.block(more_enemies_data.clone[planet.string_val].unit) .. " unit clones")
                Log.warn("Currently " .. serpent.block(more_enemies_data.clone[planet.string_val].unit_group) .. " unit-group clones")

                at_capacity = at_capacity + 1
              end
            end

            -- if (at_capacity > 0) then
            --   if (at_capacity > 1) then
            --     more_enemies_data.do_nth_tick = false
            --     return
            --   end
            if (at_capacity > 2) then
              if (at_capacity > 3) then
                more_enemies_data.do_nth_tick = false
                return
              end

              -- if (clone_settings and clone_settings.type == "unit-group") then
              --   if (more_enemies_data.clone.unit_group > max_num_unit_group_clones) then
              --     goto continue
              --   end
              -- else
              --   if (more_enemies_data.clone.unit > max_num_unit_clones) then
              --     goto continue
              --   end
              -- end
              if (clone_settings and clone_settings.type == "unit-group") then
                if (more_enemies_data.clone[planet.string_val].unit_group > max_num_unit_group_clones) then
                  goto continue
                end
              else
                if (more_enemies_data.clone[planet.string_val].unit > max_num_unit_clones) then
                  goto continue
                end
              end
            end

            clones = {}

            Log.warn("Attempting to clone entity on planet " .. surface_name)
            Log.error(clone_settings)
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

            Log.warn("clones:")
            Log.warn(clones)

            -- add the new clones to storage
            if (clones and #clones > 0) then
              if (not more_enemies_data.clones[surface_name]) then
                more_enemies_data.clones[surface_name] = {}
                more_enemies_data.clones[surface_name].unit = {}
                more_enemies_data.clones[surface_name].unit_group = {}
              end

              local k
              for k=1, #clones do
                if (clones[k] and clones[k] ~= nil and clones[k].clone.valid) then
                  Log.info("adding clone: " .. serpent.block(clones[k]))
                  local clone_data = Clone_Data:new({
                    obj = clones[k].clone,
                    type = clone_settings.type,
                    mod_name = nil,
                    valid = clones[k].clone.valid
                  })
                  if (clone_data.type == "unit-group") then
                    more_enemies_data.clones[surface_name].unit_group[clones[k].clone.unit_number] = clone_data
                  else
                    more_enemies_data.clones[surface_name].unit[clones[k].clone.unit_number] = clone_data
                  end
                end

                -- if (more_enemies_data.clone.unit_group < 0) then more_enemies_data.clone.unit_group = 0 end
                -- if (more_enemies_data.clone.unit < 0) then more_enemies_data.clone.unit = 0 end
                if (more_enemies_data.clone[planet.string_val].unit_group < 0) then more_enemies_data.clone[planet.string_val].unit_group = 0 end
                if (more_enemies_data.clone[planet.string_val].unit < 0) then more_enemies_data.clone[planet.string_val].unit = 0 end

                -- if (group and group.valid) then
                -- if (clone_settings.type == "unit-group") then
                -- if (group and group.valid and clone_settings.type == "unit-group") then
                --   group.add_member(clones[k].clone)
                --   more_enemies_data.clone.unit_group = more_enemies_data.clone.unit_group + 1
                -- else
                --   more_enemies_data.clone.unit = more_enemies_data.clone.unit + 1
                -- end
                if (group and group.valid and clone_settings.type == "unit-group") then
                  group.add_member(clones[k].clone)
                  more_enemies_data.clone[planet.string_val].unit_group = more_enemies_data.clone[planet.string_val].unit_group + 1
                else
                  more_enemies_data.clone[planet.string_val].unit = more_enemies_data.clone[planet.string_val].unit + 1
                end

                clones[k] = nil
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
          -- more_enemies_data.staged_clones[surface_name][unit_number] = nil
          if (group and group.valid) then
            more_enemies_data.staged_clones[surface_name].unit_group[unit_number] = nil
          else
            more_enemies_data.staged_clones[surface_name].unit[unit_number] = nil
          end
          ::continue::
        end
      end
    end
  end

  return true
end

function spawn_service.do_nth_tick_cleanup(event, more_enemies_data)
  Log.warn("spawn_service.do_nth_tick_cleanup")
  Log.info(event)
  Log.info(more_enemies_data)

  more_enemies_data = more_enemies_data or More_Enemies_Repository.get_more_enemies_data()
  if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end

  -- local _temp = {}
  local _invalids = {}
  local i = 1
  -- local limit = Global_Settings_Constants.settings.CLONES_PER_TICK.default_value
  local limit = 1.5 * Global_Settings_Constants.settings.CLONES_PER_TICK.default_value

  Log.warn("Starting iteration of staged_clones")
  for _, planet in pairs(Constants.DEFAULTS.planets) do

    if (not more_enemies_data.staged_clones[planet.string_val]) then
      more_enemies_data.staged_clones[planet.string_val] = {}
    end
    if (not more_enemies_data.staged_clones[planet.string_val].unit) then
      more_enemies_data.staged_clones[planet.string_val].unit = {}
    end
    if (not more_enemies_data.staged_clones[planet.string_val].unit_group) then
      more_enemies_data.staged_clones[planet.string_val].unit_group = {}
    end
    if (not more_enemies_data.clones[planet.string_val]) then
      more_enemies_data.clones[planet.string_val] = {}
    end
    if (not more_enemies_data.clones[planet.string_val].unit) then
      more_enemies_data.clones[planet.string_val].unit = {}
    end
    if (not more_enemies_data.clones[planet.string_val].unit_group) then
      more_enemies_data.clones[planet.string_val].unit_group = {}
    end

    Log.warn("staged_clones.unit")
    i = 1
    for k,v in pairs(more_enemies_data.staged_clones[planet.string_val].unit) do
      Log.info(v)
      -- TODO: Come back to this; seems to be erroneously detecting valid objects as invalid
      if (not v or not v.obj or not v.obj.valid or v.obj == planet.string_val) then
        Log.warn("Found nil or invalid clone")
        Log.warn(v)
        _invalids[k] = v
      end
      i = i + 1
      if (i > limit) then
        Log.warn("breaking from initial step of cleanup")
        break
      end
    end

    i = 1
    Log.warn("Starting iteration of _invalids")
    for k,v in pairs(_invalids) do
      Log.warn("Removing invalids")
      table.remove(more_enemies_data.staged_clones[planet.string_val].unit, k)

      i = i + 1
      if (i > limit) then
        Log.warn("breaking from second step of cleanup")
        break
      end
    end

    Log.warn("staged_clones.unit_group")
    i = 1
    _invalids = {}
    for k,v in pairs(more_enemies_data.staged_clones[planet.string_val].unit_group) do
      Log.warn(v)
      -- TODO: Come back to this; seems to be erroneously detecting valid objects as invalid
      if (not v or not v.obj or not v.obj.valid or v.obj == planet.string_val) then
        Log.warn("Found nil or invalid clone")
        _invalids[k] = v
      end
      i = i + 1
      if (i > limit) then
        Log.warn("breaking from initial step of cleanup")
        break
      end
    end

    i = 1
    Log.warn("Starting iteration of _invalids")
    for k,v in pairs(_invalids) do
      Log.warn("Removing invalids")
      table.remove(more_enemies_data.staged_clones[planet.string_val].unit_group, k)

      i = i + 1
      if (i > limit) then
        Log.warn("breaking from second step of cleanup")
        break
      end
    end

    Log.warn("clones.unit_group")
    i = 1
    _invalids = {}
    for k,v in pairs(more_enemies_data.clones[planet.string_val].unit_group) do
      Log.warn(v)
      -- TODO: Come back to this; seems to be erroneously detecting valid objects as invalid
      -- if (not v or not v.obj or not v.obj.valid or v.obj == planet.string_val) then
      if (not v or not v.obj or not v.obj.valid) then
        Log.warn("Found nil or invalid clone")
        _invalids[k] = v
      end
      i = i + 1
      if (i > limit) then
        Log.warn("breaking from initial step of cleanup")
        break
      end
    end

    i = 1
    Log.warn("Starting iteration of _invalids")
    for k,v in pairs(_invalids) do
      Log.warn("Removing invalids")
      more_enemies_data.clones[planet.string_val].unit_group[k] = nil

      -- if (more_enemies_data.clone.unit_group > 0) then
      --   more_enemies_data.clone.unit_group = more_enemies_data.clone.unit_group - 1
      -- else
      --   more_enemies_data.clone.unit_group = 0
      -- end
      if (more_enemies_data.clone[planet.string_val].unit_group > 0) then
        more_enemies_data.clone[planet.string_val].unit_group = more_enemies_data.clone[planet.string_val].unit_group - 1
      else
        more_enemies_data.clone[planet.string_val].unit_group = 0
      end

      i = i + 1
      if (i > limit) then
        Log.warn("breaking from second step of cleanup")
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
  local surface = entity.surface
  if (not surface or not surface.valid) then return end
  if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end

  local mod_data = Mod_Repository.get_mod_data()

  -- if (more_enemies_data.clone.unit_group < 0) then more_enemies_data.clone.unit_group = 0 end
  -- if (more_enemies_data.clone.unit < 0) then more_enemies_data.clone.unit = 0 end

  if (not more_enemies_data.clone[surface.name]) then
    more_enemies_data.clone[surface.name] = {}
    more_enemies_data.clone[surface.name].unit = 0
    more_enemies_data.clone[surface.name].unit_group = 0
  end

  if (more_enemies_data.clone[surface.name].unit_group < 0) then more_enemies_data.clone[surface.name].unit_group = 0 end
  if (more_enemies_data.clone[surface.name].unit < 0) then more_enemies_data.clone[surface.name].unit = 0 end

  if (mod_data.clone.count < 0) then mod_data.clone.count = 0 end

  if (not more_enemies_data.clones[surface.name]) then
    more_enemies_data.clones[surface.name] = {}
    more_enemies_data.clones[surface.name].unit = {}
    more_enemies_data.clones[surface.name].unit_group = {}
  end

  Log.info("Attempting to remove entity")
  if (more_enemies_data.clones[surface.name].unit[entity.unit_number] ~= nil
    or more_enemies_data.clones[surface.name].unit_group[entity.unit_number] ~= nil)
  then
    Log.debug("Removing entity: " .. serpent.block(entity.unit_number))

    if (Entity_Validations.get_mod_name(more_enemies_data.clones[surface.name].unit[entity.unit_number])
      or Entity_Validations.get_mod_name(more_enemies_data.clones[surface.name].unit_group[entity.unit_number]))
    then
      if (mod_data.clone.count > 0) then mod_data.clone.count = mod_data.clone.count - 1 end
    else
      -- if (more_enemies_data.clones[surface.name].unit_group[entity.unit_number]) then
      --   if (more_enemies_data.clone.unit_group > 0) then more_enemies_data.clone.unit_group = more_enemies_data.clone.unit_group - 1 end
      -- else
      --   if (more_enemies_data.clone.unit > 0) then more_enemies_data.clone.unit = more_enemies_data.clone.unit - 1 end
      -- end
      if (more_enemies_data.clones[surface.name].unit_group[entity.unit_number]) then
        if (more_enemies_data.clone[surface.name].unit_group > 0) then more_enemies_data.clone[surface.name].unit_group = more_enemies_data.clone[surface.name].unit_group - 1 end
      else
        if (more_enemies_data.clone[surface.name].unit > 0) then more_enemies_data.clone[surface.name].unit = more_enemies_data.clone[surface.name].unit - 1 end
      end
    end

    if (more_enemies_data.clones[surface.name].unit[entity.unit_number]) then
      more_enemies_data.clones[surface.name].unit[entity.unit_number] = nil
    elseif (more_enemies_data.clones[surface.name].unit_group[entity.unit_number]) then
      more_enemies_data.clones[surface.name].unit_group[entity.unit_number] = nil
    end

    return
  end

  Log.info("Attempting to remove entity again")
  -- if (  entity
  --   and (more_enemies_data.clone.unit > 0 or more_enemies_data.clone.unit_group > 0)
  --   and (more_enemies_data.clones[surface.name].unit[entity.unit_number]
  --     or more_enemies_data.clones[surface.name].unit_group[entity.unit_number]))
  -- then
  if (  entity
    and (more_enemies_data.clone[surface.name].unit > 0 or more_enemies_data.clone[surface.name].unit_group > 0)
    and (more_enemies_data.clones[surface.name].unit[entity.unit_number]
      or more_enemies_data.clones[surface.name].unit_group[entity.unit_number]))
  then
    Log.debug("removing, second try")

    if (Entity_Validations.get_mod_name(more_enemies_data.clones[surface.name].unit[entity.unit_number])
      or Entity_Validations.get_mod_name(more_enemies_data.clones[surface.name].unit_group[entity.unit_number]))
    then
      if (mod_data.clone.count > 0) then mod_data.clone.count = mod_data.clone.count - 1 end
    else
      -- if (more_enemies_data.clones[surface.name].unit_group[entity.unit_number]) then
      --   if (more_enemies_data.clone.unit_group > 0) then more_enemies_data.clone.unit_group = more_enemies_data.clone.unit_group - 1 end
      -- else
      --   if (more_enemies_data.clone.unit > 0) then more_enemies_data.clone.unit = more_enemies_data.clone.unit - 1 end
      -- end
      if (more_enemies_data.clones[surface.name].unit_group[entity.unit_number]) then
        if (more_enemies_data.clone[surface.name].unit_group > 0) then more_enemies_data.clone[surface.name].unit_group = more_enemies_data.clone[surface.name].unit_group - 1 end
      else
        if (more_enemies_data.clone[surface.name].unit > 0) then more_enemies_data.clone[surface.name].unit = more_enemies_data.clone[surface.name].unit - 1 end
      end
    end

    if (more_enemies_data.clones[surface.name].unit[entity.unit_number]) then
      more_enemies_data.clones[surface.name].unit[entity.unit_number] = nil
    elseif (more_enemies_data.clones[surface.name].unit_group[entity.unit_number]) then
      more_enemies_data.clones[surface.name].unit_group[entity.unit_number] = nil
    end

    return
  end

  if (  entity
    and mod_data.clone.count > 0
    and (more_enemies_data.clones[surface.name].unit[entity.unit_number] ~= nil
      or more_enemies_data.clones[surface.name].unit_group[entity.unit_number] ~= nil))
  then
    Log.debug("mod removing, second try")

    if (Entity_Validations.get_mod_name(more_enemies_data.clones[surface.name].unit[entity.unit_number])
      or Entity_Validations.get_mod_name(more_enemies_data.clones[surface.name].unit_group[entity.unit_number]))
    then
      if (mod_data.clone.count > 0) then mod_data.clone.count = mod_data.clone.count - 1 end
    else
      -- if (more_enemies_data.clones[surface.name].unit_group[entity.unit_number]) then
      --   if (more_enemies_data.clone.unit_group > 0) then more_enemies_data.clone.unit_group = more_enemies_data.clone.unit_group - 1 end
      -- else
      --   if (more_enemies_data.clone.unit > 0) then more_enemies_data.clone.unit = more_enemies_data.clone.unit - 1 end
      -- end
      if (more_enemies_data.clones[surface.name].unit_group[entity.unit_number]) then
        if (more_enemies_data.clone[surface.name].unit_group > 0) then more_enemies_data.clone[surface.name].unit_group = more_enemies_data.clone[surface.name].unit_group - 1 end
      else
        if (more_enemies_data.clone[surface.name].unit > 0) then more_enemies_data.clone[surface.name].unit = more_enemies_data.clone[surface.name].unit - 1 end
      end
    end

    if (more_enemies_data.clones[surface.name].unit[entity.unit_number]) then
      more_enemies_data.clones[surface.name].unit[entity.unit_number] = nil
    elseif (more_enemies_data.clones[surface.name].unit_group[entity.unit_number]) then
      more_enemies_data.clones[surface.name].unit_group[entity.unit_number] = nil
    end

    return
  end

  Log.debug("failed to remove")
end

function spawn_service.entity_spawned(event)
  Log.debug("spawn_service.entity_spawned")
  Log.info(event)

  local more_enemies_data = More_Enemies_Repository.get_more_enemies_data()

  local spawner = event.spawner
  if (not spawner or not spawner.valid) then return end
  local entity = event.entity
  if (not entity or not entity.valid) then return end
  local surface = entity.surface
  if (not surface or not surface.valid) then return end

  if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end
  -- if (not more_enemies_data:is_valid()) then more_enemies_data = Initialization.reinit() end
  if (not more_enemies_data.do_nth_tick) then return end
  if (not entity or not entity.valid or not entity.surface or not entity.surface.valid or Settings_Utils.is_vanilla(entity.surface.name)) then return end

  -- TODO: Change this to it's own setting
  local max_num_clones = Settings_Service.get_maximum_number_of_spawned_clones()
  -- if (more_enemies_data.clone.unit > max_num_clones) then
  --   Log.warn("Tried to clone more than the unit limit: " .. serpent.block(max_num_clones))
  --   Log.warn("Currently " .. serpent.block(more_enemies_data.clone.unit) .. " unit clones")
  --   return
  -- end
  if (not more_enemies_data.clone[surface.name]) then
    more_enemies_data.clone[surface.name] = {}
    more_enemies_data.clone[surface.name].unit = 0
    more_enemies_data.clone[surface.name].unit_group = 0
  end

  if (more_enemies_data.clone[surface.name].unit > max_num_clones) then
    Log.warn("Tried to clone more than the unit limit: " .. serpent.block(max_num_clones))
    Log.warn("Currently " .. serpent.block(more_enemies_data.clone[surface.name].unit) .. " unit clones")
    return
  end

  if (not spawner or not spawner.valid) then return end
  if (not entity or not entity.valid) then return end
  if (not entity.surface or not entity.surface.name) then return end

  Log.info("Attempting to add to staged_clones")
  if (more_enemies_data.valid) then
    Log.debug("Adding to staged_clones: " .. serpent.block(entity.unit_number))

    if (not more_enemies_data.staged_clones[entity.surface.name]) then
      more_enemies_data.staged_clones[entity.surface.name] = {}
    end
    if (not more_enemies_data.staged_clones[entity.surface.name].unit) then
      more_enemies_data.staged_clones[entity.surface.name].unit = {}
    end

    more_enemies_data.staged_clones[entity.surface.name].unit[entity.unit_number] = Clone_Data:new({
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
  if (mod_data.clone.count > max_num_modded_clones) then
    Log.warn("Tried to clone more than the unit limit: " .. serpent.block(max_num_modded_clones))
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

    -- if (not mod_data.staged_clones[entity.surface.planet]) then
    --   mod_data.staged_clones[entity.surface.planet] = {}
    -- end

    mod_data.staged_clones[entity.unit_number] = Clone_Data:new({
      obj = entity,
      surface = entity.surface,
      group = nil,
      mod_name = mod_name,
      valid = entity.valid and entity.surface.valid,
    })
  end
end

locals.do_mod_nth_tick = function (mod_data)
  local unit_group = spawn_service.BREAM.unit_group
  local skip = false
  local max_num_modded_clones = Settings_Service.get_maximum_number_of_modded_clones()

  if (mod_data.staged_clones) then
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
      -- clone_overflow = clone_overflow + 1
      -- break
      return
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
      if (mod_data.clone.count > max_num_modded_clones) then
        Log.warn("Tried to clone more than the unit limit: " .. serpent.block(max_num_modded_clones))
        -- Log.warn("Currently " .. serpent.block(more_enemies_data.clone.count) .. " clones")
        -- Log.warn("Currently " .. serpent.block(more_enemies_data.clone.unit) .. " unit clones")
        Log.warn("Currently " .. serpent.block(more_enemies_data.clone[surface_name].unit) .. " unit clones")
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

            more_enemies_data.groups[unit_group.surface.name][unit_group.unique_id] = Unit_Group_Data:new({
              valid = true,
              group = unit_group,
              count = 0,
              max_count = loop_len,
              mod_name = BREAM_Constants.name,
            })
          end
        end

        local k
        for k=1, #clones do
          if (clones[k] and clones[k] ~= nil and clones[k].clone.valid) then
            Log.info("adding clone: " .. serpent.block(clones[k]))
            -- more_enemies_data.clones[clones[k].clone.unit_number] = Clone_Data:new({
            --   obj = clones[k].clone,
            --   type = unit_group and "unit-group" or "unit",
            --   mod_name = clones[k].mod_name,
            --   surface = clones[k].clone.surface,
            --   valid = clones[k].clone.valid
            -- })
            local clone_data = Clone_Data:new({
              obj = clones[k].clone,
              type = unit_group and "unit-group" or "unit",
              mod_name = clones[k].mod_name,
              surface = clones[k].clone.surface,
              valid = clones[k].clone.valid
            })
            if (unit_group) then
              more_enemies_data.clones[surface_name].unit[clones[k].clone.unit_number] = clone_data
            else
              more_enemies_data.clones[surface_name].unit_group[clones[k].clone.unit_number] = clone_data
            end
          end

          if (unit_group and unit_group.valid and unit_group.surface.name == clones[k].clone.surface.name) then
            unit_group.add_member(clones[k].clone)
          end

          clones[k] = nil

          if (mod_data.clone.count < 0) then mod_data.clone.count = 0 end

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

  -- if (clone_overflow > 1) then
  --   if (not more_enemies_data.valid) then more_enemies_data = Initialization.reinit() end

  --   more_enemies_data.overflow_clone_attempts.count = more_enemies_data.overflow_clone_attempts.count + 1
  --   Log.debug("Tried to clone more than the unit limt; returning")
  --   return
  -- end
end

spawn_service.more_enemies = true

local _spawn_service = spawn_service

return spawn_service