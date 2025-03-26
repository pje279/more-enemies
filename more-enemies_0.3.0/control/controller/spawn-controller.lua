-- If already defined, return
if _spawn_controller and _spawn_controller.more_enemies then
  return _spawn_controller
end

local Constants = require("libs.constants.constants")
local Gleba_Settings_Constants = require("libs.constants.settings.gleba-settings-constants")
local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Initialization = require("control.initialization")
local Log = require("libs.log.log")
local Nauvis_Settings_Constants = require("libs.constants.settings.nauvis-settings-constants")
local Spawn = require("control.event.spawn")
local Spawn_Service = require("control.service.spawn-service")
local Settings_Service = require("control.service.settings-service")

local spawn_controller = {}

function spawn_controller.do_tick(event)
  local tick = event.tick
  local nth_tick = Settings_Service.get_nth_tick()
  local offset = 1 + nth_tick -- Constants.time.TICKS_PER_SECOND / 2
  local tick_modulo = tick % offset

  Log.info("nth_tick = " .. serpent.block(nth_tick) .. " - tick_modulo = " .. serpent.block(tick_modulo))
  if (nth_tick ~= tick_modulo) then return end
  if (not storage or not storage.more_enemies or not storage.more_enemies.valid) then Initialization.reini() end
  if (not storage.more_enemies.nth_tick_complete) then storage.more_enemies.nth_tick_complete = { current = false, previous = false } end
  if (not storage.more_enemies.nth_tick_cleanup_complete) then storage.more_enemies.nth_tick_cleanup_complete = { current = false, previous = false } end

  storage.more_enemies.nth_tick_complete.previous = storage.more_enemies.nth_tick_complete.current
  storage.more_enemies.nth_tick_cleanup_complete.previous = storage.more_enemies.nth_tick_cleanup_complete.current
  storage.more_enemies.nth_tick_complete.current = false
  storage.more_enemies.nth_tick_cleanup_complete.current = false

  Log.info("attempt to process")
  if (storage.more_enemies.nth_tick_cleanup_complete.previous and do_nth_tick(event)) then
    Log.debug("do_nth_tick completed")
    storage.more_enemies.nth_tick_complete.current = true
  else
    Log.warn("failed to finish processing")
  end

  Log.info("attempt to clean up")
  if (storage.more_enemies.nth_tick_complete.current or not storage.more_enemies.nth_tick_cleanup_complete.previous) then
    if (do_nth_tick_cleanup(event)) then
      Log.debug("do_nth_tick_cleanup completed")
      storage.more_enemies.nth_tick_cleanup_complete.current = true
    else
      Log.warn("failed to finish cleaning up")
      -- storage.more_enemies.nth_tick_cleanup_complete.previous = false
    end
  end
end

function do_nth_tick(event)
  local did_complete = false
  local tick = event.tick

  Log.debug("spawn_controller.do_nth_tick")
  if (not storage) then return is_success end
  Log.info("passed storage")
  if (not storage.more_enemies or not storage.more_enemies.valid) then Initialization.reinit() end
  if (not storage.more_enemies.clones) then storage.more_enemies.clones = {} end
  if (not storage.more_enemies.staged_clones) then storage.more_enemies.staged_clones = {} end
  if (not storage.more_enemies.clone_count) then storage.more_enemies.clone_count = { count = 0 } end
  if (not storage.more_enemies.difficulties) then Initialization.reinit() end

  Log.info("Clone attempts")
  Spawn_Service.clone_attempts()

  -- Make this a configurable setting
  local clones_per_tick = Settings_Service.get_clones_per_tick()
  local clone_overflow = 0

  if (storage) then
    for k, planet in pairs(Constants.DEFAULTS.planets) do
      Log.info(k)
      Log.info(planet)
      if (storage.more_enemies.difficulties[planet.string_val].selected_difficulty.string_val == Constants.difficulty.VANILLA.string_val) then
        if (Settings_Service.get_clone_unit_setting(planet.string_val) ~= 1) then goto attempt_clone end
        if (Settings_Service.get_clone_unit_group_setting(planet.string_val) ~= 1) then goto attempt_clone end
        if (Settings_Service.get_maximum_group_size(planet.string_val) ~= Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_RUNTIME.default_value) then goto attempt_clone end

        Log.warn("Vanilla detected for " .. planet.string_val .. "; skipping")
        break
        ::attempt_clone::
      end

      if (clone_overflow > 1) then
        Log.error("Tried to clone more than the unit limt; returning")
        return
      end

      local j = 0
      for i, staged_clone in pairs(storage.more_enemies.staged_clones) do
        Log.info(i)
        Log.info(stage_clone)

        if (j > clones_per_tick) then
          Log.warn("Tried to clone more than the clone_per_tick limt; breaking inner loop")
          clone_overflow = clone_overflow + 1
          break
        end

        -- if (staged_clone and staged_clone.valid) then
        --   limit = Settings_Service.get_clones_per_tick()
        -- else
        if (not staged_clone or not staged_clone.valid) then
          Log.warn("staged_clone is nil or invalid; skipping")
          goto continue_tick
        end

        Log.error(Settings_Service.get_maximum_number_of_clones())
        Log.error(storage.more_enemies.clone.count)


        if (  storage.more_enemies.clone
          and storage.more_enemies.clone.count > Settings_Service.get_maximum_number_of_clones())
        then
          Log.error("Tried to clone more than the unit limit: " .. serpent.block(Settings_Service.get_maximum_number_of_clones()))
          Log.error("Currently " .. serpent.block(storage.more_enemies.clone.count) .. " clones")
          return
        end

        local clone_unit_setting = Settings_Service.get_clone_unit_setting(planet.string_val)
        local clone_unit_group_setting = Settings_Service.get_clone_unit_group_setting(planet.string_val)
        Log.info("clone_unit_setting: " .. serpent.block(clone_unit_setting))
        Log.info("clone_unit_group_setting: " .. serpent.block(clone_unit_group_setting))

        -- May be a bit much/simplistic
        -- TODO: revisit maybe?
        local clone_setting = clone_unit_setting * clone_unit_group_setting

        Log.info("Attempting to clone entity on planet " .. staged_clone.surface.name)
        if (staged_clone.surface.name == Constants.DEFAULTS.planets.nauvis.string_val) then
          clones = Spawn.clone_entity(Nauvis_Settings_Constants.settings.CLONE_NAUVIS_UNITS.default_value, storage.more_enemies.difficulties[planet.string_val], staged_clone, { clone_setting = clone_setting, tick = tick })
        elseif (staged_clone.surface.name == Constants.DEFAULTS.planets.gleba.string_val) then
          clones = Spawn.clone_entity(Gleba_Settings_Constants.settings.CLONE_GLEBA_UNITS.default_value, storage.more_enemies.difficulties[planet.string_val], staged_clone, { clone_setting = clone_setting, tick = tick })
        else
          Log.warn("Planet is neither nauvis nor gleba\nPlanet is unsupported; making no changes")
          return
        end

        j = j + #clones

        Log.info("clone = " .. serpent.block(clone))

        -- add the new clones to storage
        if (clones and #clones > 0) then
          for j=1, #clones do
            if (clones[j] and clones[j].valid) then
              Log.debug("adding clone: " .. serpent.block(clones[j]))
              storage.more_enemies.clones[clones[j].unit_number] = clones[j]
            end
            clones[j] = nil

            if (not storage.more_enemies.clone) then storage.more_enemies.clone = {} end
            if (not storage.more_enemies.clone.count) then storage.more_enemies.clone.count = 0 end

            -- if (storage.more_enemies.clone.count > 0) then storage.more_enemies.clone.count = storage.more_enemies.clone.count - 1 end
            if (storage.more_enemies.clone.count < 0) then storage.more_enemies.clone.count = 0 end

            storage.more_enemies.clone.count = storage.more_enemies.clone.count + 1
          end

          -- remove the stage_clone after processing
          storage.more_enemies.staged_clones[staged_clone.unit_number] = nil

        end
        ::continue_tick::
      end
    end
  end

  return true
end

-- function spawn_controller.do_nth_tick_cleanup()
function do_nth_tick_cleanup()
  if (not storage) then return end
  if (not storage.more_enemies or not storage.more_enemies.valid) then Initialization.reinit() end
  if (not storage.more_enemies.staged_clones) then
    storage.more_enemies.staged_clones = {}
    return
  end

  local _temp = {}
  local _invalids = {}
  local i = 1
  local limit = Global_Settings_Constants.settings.CLONES_PER_TICK.default_value

  Log.info("Starting iteration of staged_clones")
  for _, planet in pairs(Constants.DEFAULTS.planets) do
    for k,v in pairs(storage.more_enemies.staged_clones) do
      if (not v or not v.valid or v == planet.string_val) then
        Log.info("Found nil or invalid clone")
        _invalids[k] = v
      end
      i = i + 1
      if (i > limit) then
        Log.warn("breaking from initial step of cleanup")
        break
      end
    end

    i = 1
    Log.info("Starting iteration of _invalids")
    for k,v in pairs(_invalids) do
      Log.info("Removing invalids")
      table.remove(storage.more_enemies.staged_clones, k)

      i = i + 1
      if (i > limit) then
        Log.warn("breaking from second step of cleanup")
        break
      end
    end
  end

  return true
end

spawn_controller.more_enemies = true

local _spawn_controller = spawn_controller

return spawn_controller