-- If already defined, return
if _initialization and _initialization.more_enemies then
  return _initialization
end

local Constants = require("libs.constants.constants")
local Entity_Validations = require("scripts.validations.entity-validations")
local Difficulty_Data = require("scripts.data.difficulty-data")
local Difficulty_Utils = require("scripts.utils.difficulty-utils")
local Log = require("libs.log.log")
local Log_Constants = require("libs.log.log-constants")
-- local Version_Data = require("scripts.data.version-data")
local More_Enemies_Data = require("scripts.data.more-enemies-data")
local Nth_Tick_Data = require("scripts.data.nth-tick-data")
local Overflow_Clone_Attempts_Data = require("scripts.data.overflow-clone-attempts-data")
local Version_Repository = require("scripts.repositories.version-repository")
local Version_Service = require("scripts.service.version-service")

local initialization = {}

initialization.reset = nil

local locals = {}

function initialization.init()
  Log.debug("initialization.init")

  return locals.initialize(true) -- from_scratch
end

function initialization.reinit()
  Log.debug("initialization.reinit")

  return locals.initialize(false) -- as is
end

function initialization.purge(optionals)
  optionals = optionals or {
    all = true,
    clones = true,
    mod_added_clones = true,
    exterminatus = true
  }

  -- if (storage.more_enemies and storage.more_enemies.valid) then
  if (storage.more_enemies) then
    local original_do_nth_tick = storage.more_enemies.do_nth_tick
    storage.more_enemies.do_nth_tick = false

    Log.debug("purge clones")
    -- Purge clones

    Log.debug("Optionals")
    Log.info(optionals)

    if (type(optionals) == "table" and optionals.exterminatus) then
      if (game and game.forces and game.forces["enemy"]) then
        game.forces["enemy"].kill_all_units()
      end

      storage.more_enemies.clones = {}
      storage.more_enemies.clone = {}

      storage.more_enemies.staged_clones = {}
      storage.more_enemies.staged_clone = {}

      if (storage.more_enemies.mod) then
        storage.more_enemies.mod.staged_clones = {}
        storage.more_enemies.mod.staged_clone = {}
      end

      for _, planet in pairs(Constants.DEFAULTS.planets) do
        storage.more_enemies.clone[planet.string_val] = {}
        storage.more_enemies.clone[planet.string_val].unit = 0
        storage.more_enemies.clone[planet.string_val].unit_group = 0

        storage.more_enemies.clones[planet.string_val] = {}
        storage.more_enemies.clones[planet.string_val].unit = {}
        storage.more_enemies.clones[planet.string_val].unit_group = {}

        storage.more_enemies.staged_clone[planet.string_val] = {}
        storage.more_enemies.staged_clone[planet.string_val].unit = 0
        storage.more_enemies.staged_clone[planet.string_val].unit_group = 0

        storage.more_enemies.staged_clones[planet.string_val] = {}
        storage.more_enemies.staged_clones[planet.string_val].unit = {}
        storage.more_enemies.staged_clones[planet.string_val].unit_group = {}

        if (storage.more_enemies.mod) then
          storage.more_enemies.mod.staged_clone[planet.string_val] = {}
          storage.more_enemies.mod.staged_clone[planet.string_val].count = 0

          storage.more_enemies.mod.staged_clones[planet.string_val] = {}
          storage.more_enemies.mod.staged_clones[planet.string_val].unit = {}
          storage.more_enemies.mod.staged_clones[planet.string_val].unit_group = {}
        end
      end

      -- storage.more_enemies.mod.clone = { count = 0 }
    end

    if (storage.more_enemies.clones and type(optionals) == "table" and optionals.all and not optionals.exterminatus) then
      -- for _, planet_list in pairs(storage.more_enemies.clones) do
      --   for _, entity_list in pairs(planet_list) do
      --     if (type(entity_list) == "table") then
      --       for _, v in pairs(entity_list) do
      --         if (v and v.obj) then
      --           Log.debug("purging" .. serpent.block(v.obj))
      --           v.obj.destroy()
      --         end
      --       end
      --     end
      --   end
      -- end
      if (type(storage.more_enemies.clones) == "table") then
        for _, v in pairs(storage.more_enemies.clones) do
          if (v and type(v) == "table" and v.obj) then
            Log.debug("purging" .. serpent.block(v.obj))
            v.obj.destroy()
          end
        end
      end

      for _, planet in pairs(Constants.DEFAULTS.planets) do
        local planet_clones = storage.more_enemies.clones[planet.string_val]
        if (planet_clones and type(planet_clones) == "table") then
          for _, entity_list in pairs(planet_clones) do
            if (type(entity_list) == "table") then
              for _, v in pairs(entity_list) do
                if (v and type(v) == "table" and v.obj) then
                  Log.debug("purging" .. serpent.block(v.obj))
                  v.obj.destroy()
                end
              end
            end
          end
        end
      end
      storage.more_enemies.clones = {}
      storage.more_enemies.clone = {}

      for _, planet in pairs(Constants.DEFAULTS.planets) do
        storage.more_enemies.clone[planet.string_val] = {}
        storage.more_enemies.clone[planet.string_val].unit = 0
        storage.more_enemies.clone[planet.string_val].unit_group = 0

        storage.more_enemies.mod.clone[planet.string_val] = {}
        storage.more_enemies.mod.clone[planet.string_val].count = 0
      end
      -- storage.more_enemies.mod.clone = { count = 0 }
    end

    local do_purge = function (k, v, surface_name)
      if (k and v and type(v) == "table" and v.obj) then
        Log.debug("purging" .. serpent.block(v.obj))
        -- if (v.type == "unit-group") then
        --   storage.more_enemies.clones[surface_name].unit_group[k] = nil
        -- elseif (v.type == "unit") then
        --   storage.more_enemies.clones[surface_name].unit[k] = nil
        -- end
        v.obj.destroy()
      end
    end

    -- if (storage.more_enemies.clones) then
    if (storage.more_enemies.clones and type(storage.more_enemies.clones) == "table") then
      for surface_name, planet_lists in pairs(storage.more_enemies.clones) do
        for _, entity_list in pairs(planet_lists) do
          for k, v in pairs(entity_list) do
            if (v and type(v) == "table" and v.obj) then
              if (Entity_Validations.get_mod_name(v) and optionals.mod_added_clones) then
                -- if (storage.more_enemies.mod.clone.count > 0) then
                if (storage.more_enemies.mod.clone[surface_name].count > 0) then
                  -- storage.more_enemies.mod.clone.count = storage.more_enemies.mod.clone.count - 1
                  storage.more_enemies.mod.clone[surface_name].count = storage.more_enemies.mod.clone[surface_name].count - 1
                end
                do_purge(k,v, surface_name)
              elseif (optionals.clones) then
                if (v.type == "unit-group") then
                  if (storage.more_enemies.clone[surface_name].unit_group > 0) then
                    storage.more_enemies.clone[surface_name].unit_group = storage.more_enemies.clone[surface_name].unit_group - 1
                  end
                  do_purge(k, v, surface_name)
                else
                  if (storage.more_enemies.clone[surface_name].unit > 0) then
                    storage.more_enemies.clone[surface_name].unit = storage.more_enemies.clone[surface_name].unit - 1
                  end
                  do_purge(k, v, surface_name)
                end
              end
            end
          end
        end
      end

      storage.more_enemies.clones = {}
      storage.more_enemies.clone = {}

      for _, planet in pairs(Constants.DEFAULTS.planets) do
        storage.more_enemies.clone[planet.string_val] = {}
        storage.more_enemies.clone[planet.string_val].unit = 0
        storage.more_enemies.clone[planet.string_val].unit_group = 0

        storage.more_enemies.clones[planet.string_val] = {}
        storage.more_enemies.clones[planet.string_val].unit = {}
        storage.more_enemies.clones[planet.string_val].unit_group = {}
      end
    end

    Log.debug("purge staged_clones")
    -- Purge staged_clones
    -- if (storage.more_enemies.staged_clones and optionals.clones) then
    if (storage.more_enemies.staged_clones) then
      -- for k,v in pairs(storage.more_enemies.staged_clones) do
      --   if (v and v.obj) then
      --     Log.debug("purging" .. serpent.block(v.obj))
      --     v.obj.destroy()
      --   end
      -- end
      for _, planet_list in pairs(storage.more_enemies.staged_clones) do
        for _, entity_list in pairs(planet_list) do
          if (type(entity_list) == "table") then
            for _, v in pairs(entity_list) do
              if (v and type(v) == "table" and v.obj) then
                Log.debug("purging" .. serpent.block(v.obj))
                v.obj.destroy()
              end
            end
          end
        end
      end
      -- storage.more_enemies.clone = {}

      -- storage.more_enemies.clone.count = 0
      -- storage.more_enemies.clone.unit = 0
      -- storage.more_enemies.clone.unit_group = 0
      storage.more_enemies.staged_clones = {}

      for _, planet in pairs(Constants.DEFAULTS.planets) do
        -- storage.more_enemies.clone[planet.string_val] = {}
        -- storage.more_enemies.clone[planet.string_val].unit = 0
        -- storage.more_enemies.clone[planet.string_val].unit_group = 0

        storage.more_enemies.staged_clones[planet.string_val] = {}
        storage.more_enemies.staged_clones[planet.string_val].unit = {}
        storage.more_enemies.staged_clones[planet.string_val].unit_group = {}

        storage.more_enemies.staged_clone[planet.string_val] = {}
        storage.more_enemies.staged_clone[planet.string_val].unit = 0
        storage.more_enemies.staged_clone[planet.string_val].unit_group = 0
      end
    end

    Log.debug("purge mod.staged_clones")
    -- Purge mod.staged_clones
    if (storage.more_enemies.mod and storage.more_enemies.mod.staged_clones and optionals.mod_added_clones) then
      for k,v in pairs(storage.more_enemies.mod.staged_clones) do
        if (v and v.obj) then
          Log.debug("purging" .. serpent.block(v.obj))
          v.obj.destroy()
        else
          if (v and type(v) == "table") then
            for i,j in pairs(v) do
              if (j and j.obj) then
                Log.debug("purging" .. serpent.block(j.obj))
                j.obj.destroy()
              end
            end
          end
        end
      end
      storage.more_enemies.mod.clone = {}
      storage.more_enemies.mod.clones = {}
      -- storage.more_enemies.mod.clone.count = 0
      storage.more_enemies.mod.staged_clone = {}
      storage.more_enemies.mod.staged_clones = {}

      for _, planet in pairs(Constants.DEFAULTS.planets) do
        storage.more_enemies.mod.clone[planet.string_val] = {}
        storage.more_enemies.mod.clone[planet.string_val].count = 0

        storage.more_enemies.mod.clones[planet.string_val] = {}
        storage.more_enemies.mod.clones[planet.string_val].unit = {}
        storage.more_enemies.mod.clones[planet.string_val].unit_group = {}

        storage.more_enemies.mod.staged_clone[planet.string_val] = {}
        storage.more_enemies.mod.staged_clone[planet.string_val].count = 0

        storage.more_enemies.mod.staged_clones[planet.string_val] = {}
        storage.more_enemies.mod.staged_clones[planet.string_val].unit = {}
        storage.more_enemies.mod.staged_clones[planet.string_val].unit_group = {}
      end
    end

    storage.more_enemies.do_nth_tick = original_do_nth_tick
  end
end

function locals.initialize(from_scratch)
  if (not storage.more_enemies) then storage.more_enemies = More_Enemies_Data:new() end
  local more_enemies_data = storage.more_enemies

  storage.more_enemies.do_nth_tick = false

  from_scratch = from_scratch or false

  local do_purge = function ()
    if (storage and storage.more_enemies and (storage.more_enemies.clones or storage.more_enemies.staged_clones)) then
      initialization.purge()
    end
  end

  -- if (from_scratch) then
  --   log("more-enemies: Initializing anew")
  --   if (game) then game.print("more-enemies: Initializing anew") end
  --   do_purge()

  --   storage = {}
  --   more_enemies_data = More_Enemies_Data:new()
  --   storage.more_enemies = more_enemies_data

  --   local version_data = more_enemies_data.version_data
  --   version_data.valid = true

  -- else
  --   -- do_purge()

  --   if (not more_enemies_data) then
  --     storage.more_enemies = More_Enemies_Data:new()
  --     more_enemies_data = storage.more_enemies
  --   end

  --   for _, planet in pairs(Constants.DEFAULTS.planets) do
  --     if (not more_enemies_data.clones) then more_enemies_data.clones = {} end
  --     if (not more_enemies_data.clones[planet.string_val]) then more_enemies_data.clones[planet.string_val] = {} end
  --     if (not more_enemies_data.clones[planet.string_val].unit) then more_enemies_data.clones[planet.string_val].unit = {} end
  --     if (not more_enemies_data.clones[planet.string_val].unit_group) then more_enemies_data.clones[planet.string_val].unit_group = {} end
  --     if (not more_enemies_data.staged_clones) then more_enemies_data.staged_clones = More_Enemies_Data.staged_clones end
  --     if (not more_enemies_data.staged_clones[planet.string_val]) then more_enemies_data.staged_clones[planet.string_val] = {} end
  --     if (not more_enemies_data.staged_clones[planet.string_val].unit) then more_enemies_data.staged_clones[planet.string_val].unit = {} end
  --     if (not more_enemies_data.staged_clones[planet.string_val].unit_group) then more_enemies_data.staged_clones[planet.string_val].unit_group = {} end
  --     if (not more_enemies_data.clone) then more_enemies_data.clone = More_Enemies_Data.clone end
  --     if (not more_enemies_data.clone[planet.string_val]) then more_enemies_data.clone[planet.string_val] = {} end
  --     if (more_enemies_data.clone[planet.string_val].unit == nil) then more_enemies_data.clone[planet.string_val].unit = 0 end
  --     if (more_enemies_data.clone[planet.string_val].unit_group == nil) then more_enemies_data.clone[planet.string_val].unit_group = 0 end

  --     if (not more_enemies_data.mod) then more_enemies_data.mod = More_Enemies_Data.mod end
  --     if (not more_enemies_data.mod.staged_clones) then more_enemies_data.mod.staged_clones = More_Enemies_Data.mod.staged_clones end
  --     if (not more_enemies_data.mod.clone) then more_enemies_data.mod.clone = More_Enemies_Data.mod.clone end
  --     if (more_enemies_data.mod.clone.count == nil) then more_enemies_data.mod.clone.count = More_Enemies_Data.mod.clone.count end
  --   end

  -- end
  if (from_scratch) then
    log("more-enemies: Initializing anew")
    if (game) then game.print("more-enemies: Initializing anew") end
    do_purge()

    storage = {}
    more_enemies_data = More_Enemies_Data:new()
    storage.more_enemies = more_enemies_data

    local version_data = more_enemies_data.version_data
    version_data.valid = true
  end

  if (not more_enemies_data) then
    storage.more_enemies = More_Enemies_Data:new()
    more_enemies_data = storage.more_enemies
  end

  if (not more_enemies_data.mod) then more_enemies_data.mod = More_Enemies_Data.mod end
  if (not more_enemies_data.mod.staged_clones) then more_enemies_data.mod.staged_clones = More_Enemies_Data.mod.staged_clones end
  if (not more_enemies_data.mod.clone) then more_enemies_data.mod.clone = More_Enemies_Data.mod.clone end
  -- if (more_enemies_data.mod.clone.count == nil) then more_enemies_data.mod.clone.count = More_Enemies_Data.mod.clone.count end

  for _, planet in pairs(Constants.DEFAULTS.planets) do
    if (not more_enemies_data.mod.staged_clone) then more_enemies_data.mod.staged_clone = {} end
    if (not more_enemies_data.mod.staged_clone[planet.string_val]) then more_enemies_data.mod.staged_clone[planet.string_val] = {} end
    if (more_enemies_data.mod.staged_clone[planet.string_val].count == nil) then more_enemies_data.mod.staged_clone[planet.string_val].count = 0 end

    if (not more_enemies_data.mod.staged_clones[planet.string_val]) then more_enemies_data.mod.staged_clones[planet.string_val] = {} end

    if (not more_enemies_data.mod.clones) then more_enemies_data.mod.clones = {} end
    if (not more_enemies_data.mod.clones[planet.string_val]) then more_enemies_data.mod.clones[planet.string_val] = {} end
    if (not more_enemies_data.mod.clones[planet.string_val].unit) then more_enemies_data.mod.clones[planet.string_val].unit = {} end
    if (not more_enemies_data.mod.clones[planet.string_val].unit_group) then more_enemies_data.mod.clones[planet.string_val].unit_group = {} end

    if (not more_enemies_data.clones) then more_enemies_data.clones = {} end
    if (not more_enemies_data.clones[planet.string_val]) then more_enemies_data.clones[planet.string_val] = {} end
    if (not more_enemies_data.clones[planet.string_val].unit) then more_enemies_data.clones[planet.string_val].unit = {} end
    if (not more_enemies_data.clones[planet.string_val].unit_group) then more_enemies_data.clones[planet.string_val].unit_group = {} end
    if (not more_enemies_data.staged_clones) then more_enemies_data.staged_clones = More_Enemies_Data.staged_clones end
    if (not more_enemies_data.staged_clones[planet.string_val]) then more_enemies_data.staged_clones[planet.string_val] = {} end
    if (not more_enemies_data.staged_clones[planet.string_val].unit) then more_enemies_data.staged_clones[planet.string_val].unit = {} end
    if (not more_enemies_data.staged_clones[planet.string_val].unit_group) then more_enemies_data.staged_clones[planet.string_val].unit_group = {} end
    if (not more_enemies_data.clone) then more_enemies_data.clone = More_Enemies_Data.clone end
    if (not more_enemies_data.clone[planet.string_val]) then more_enemies_data.clone[planet.string_val] = {} end
    if (more_enemies_data.clone[planet.string_val].unit == nil) then more_enemies_data.clone[planet.string_val].unit = 0 end
    if (more_enemies_data.clone[planet.string_val].unit_group == nil) then more_enemies_data.clone[planet.string_val].unit_group = 0 end

  end

  if (more_enemies_data) then

    local version_data = more_enemies_data.version_data
    if (not version_data.valid) then
      return locals.initialize(true)
    else
      local version = Version_Service.validate_version()
      if (not version or not version.valid) then
        version_data.valid = false
        return more_enemies_data
      end
    end

    more_enemies_data.overflow_clone_attempts = Overflow_Clone_Attempts_Data:new({ valid = true })
    more_enemies_data.nth_tick_complete = Nth_Tick_Data:new({ valid = true })
    more_enemies_data.nth_tick_cleanup_complete = Nth_Tick_Data:new({ valid = true })
  end

  local user_setting = nil
  if (settings and settings.global and settings.global[Log_Constants.settings.DEBUG_LEVEL.name]) then
    user_setting = settings.global[Log_Constants.settings.DEBUG_LEVEL.name].value
    if (user_setting) then
      Log.info(user_setting)
      Log.set_log_level(user_setting)
    else
      Log.error("user setting DEBUG_LEVEL is  nil")
      error("user setting DEBUG_LEVEL is  nil")
    end
  elseif (not settings) then
    Log.error("settings is nil")
    error("settings is nil")
  elseif (not settings.global) then
    Log.error("setting.global is nil")
    error("setting.global is nil")
  elseif (not settings.global[Log_Constants.DEBUG_LEVEL.name]) then
    Log.error("settings.global[Log_Constants.DEBUG_LEVEL.name] is nil")
    error("settings.global[Log_Constants.DEBUG_LEVEL.name] is nil")
  end

  if (game) then
    for k, planet in pairs(Constants.DEFAULTS.planets) do
      Log.info(k)
      Log.info(planet)
      local difficulty = Difficulty_Utils.get_difficulty(planet.string_val, true)
      if (storage) then
        if (not more_enemies_data.difficulties) then more_enemies_data.difficulties = {} end

        if (from_scratch) then
          more_enemies_data.difficulties[planet.string_val] = Difficulty_Data:new({
            valid = true,
            difficulty = difficulty,
            surface = game.get_surface(planet.string_val),
            entities_spawned = 0,
          })

          if (not more_enemies_data.groups) then more_enemies_data.groups = {} end
          more_enemies_data.groups[planet.string_val] = {}
        end

        if (not more_enemies_data.difficulties[planet.string_val] or not more_enemies_data.difficulties[planet.string_val].valid) then
          more_enemies_data.difficulties[planet.string_val] = Difficulty_Data:new({
            valid = true,
            difficulty = difficulty,
            surface = game.get_surface(planet.string_val),
            entities_spawned = 0,
          })
        end

        if (not more_enemies_data.groups) then more_enemies_data.groups = {} end

        if (not more_enemies_data.groups[planet.string_val]) then
          more_enemies_data.groups[planet.string_val] = {}
        end
      end
    end

    more_enemies_data.do_nth_tick = true

    more_enemies_data.valid = true
  end

  if (from_scratch) then log("more-enemies: Initialization complete") end
  if (from_scratch and game) then game.print("more-enemies: Initialization complete") end
  Log.info(storage)

  return more_enemies_data
end

initialization.more_enemies = true

local _initialization = initialization

return initialization