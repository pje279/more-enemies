-- If already defined, return
if _initialization and _initialization.more_enemies then
  return _initialization
end

local Attack_Group_Repository = require("scripts.repositories.attack-group-repository")
local Constants = require("libs.constants.constants")
local Entity_Validations = require("scripts.validations.entity-validations")
local Difficulty_Data = require("scripts.data.difficulty-data")
local Difficulty_Utils = require("scripts.utils.difficulty-utils")
local Log = require("libs.log.log")
local Log_Constants = require("libs.log.log-constants")
local Mod_Data = require("scripts.data.mod-data")
local More_Enemies_Data = require("scripts.data.more-enemies-data")
local Nth_Tick_Data = require("scripts.data.nth-tick-data")
local Version_Service = require("scripts.service.version-service")

local initialization = {}

initialization.last_version_result = nil

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
    end

    if (storage.more_enemies.clones and type(optionals) == "table" and optionals.all and not optionals.exterminatus) then
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
    end

    local do_purge = function (k, v, surface_name)
      if (k and v and type(v) == "table" and v.obj) then
        Log.debug("purging" .. serpent.block(v.obj))
        v.obj.destroy()
      end
    end

    if (storage.more_enemies.clones and type(storage.more_enemies.clones) == "table") then
      for surface_name, planet_lists in pairs(storage.more_enemies.clones) do
        for _, entity_list in pairs(planet_lists) do
          for k, v in pairs(entity_list) do
            if (v and type(v) == "table" and v.obj) then
              if (Entity_Validations.get_mod_name(v) and optionals.mod_added_clones) then
                if (storage.more_enemies.mod.clone[surface_name].count > 0) then
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
    if (storage.more_enemies.staged_clones) then
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
      storage.more_enemies.staged_clones = {}

      for _, planet in pairs(Constants.DEFAULTS.planets) do
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

function locals.initialize(from_scratch, maintain_existing_peace)
  if (not storage.more_enemies) then storage.more_enemies = More_Enemies_Data:new() end
  local more_enemies_data = storage.more_enemies

  storage.more_enemies.do_nth_tick = false

  from_scratch = from_scratch or false
  maintain_existing_peace = maintain_existing_peace or false

  local do_purge = function ()
    if (storage and storage.more_enemies and (storage.more_enemies.clones or storage.more_enemies.staged_clones)) then
      initialization.purge()
    end
  end

  if (not from_scratch) then
    -- Version check
    local version_data = more_enemies_data.version_data
    if (version_data and not version_data.valid) then
      local version = initialization.last_version_result
      if (not version) then goto initialize end
      if (not version.major or not version.minor or not version.bug_fix) then goto initialize end
      if (not version.major.valid) then goto initialize end
      if (not version.minor.valid or not version.bug_fix.valid) then
        return locals.initialize(true, true)
      end

      ::initialize::
      return locals.initialize(true)
    else
      local version = Version_Service.validate_version()
      initialization.last_version_result = version
      if (not version or not version.valid) then
        version_data.valid = false
        return more_enemies_data
      end
    end
  end

  if (from_scratch) then
    log("more-enemies: Initializing anew")
    if (game) then game.print("more-enemies: Initializing anew") end
    do_purge()

    local _storage = storage
    _storage.storage_old = nil

    storage = {}
    more_enemies_data = More_Enemies_Data:new()
    storage.more_enemies = more_enemies_data

    storage.storage_old = _storage

    -- do migrations
    locals.migrate(maintain_existing_peace)

    local version_data = more_enemies_data.version_data
    version_data.valid = true
  end

  if (not more_enemies_data) then
    storage.more_enemies = More_Enemies_Data:new()
    more_enemies_data = storage.more_enemies
  end

  if (not more_enemies_data.mod) then more_enemies_data.mod = Mod_Data:new({ valid = true}) end
  if (not more_enemies_data.mod.staged_clone) then more_enemies_data.mod.staged_clone = {} end
  if (not more_enemies_data.mod.staged_clones) then more_enemies_data.mod.staged_clones = {} end
  if (not more_enemies_data.mod.clone) then more_enemies_data.mod.clone = {} end
  if (not more_enemies_data.mod.clones) then more_enemies_data.mod.clones = {} end

  for _, planet in pairs(Constants.DEFAULTS.planets) do
    if (not more_enemies_data.mod.staged_clone[planet.string_val]) then more_enemies_data.mod.staged_clone[planet.string_val] = {} end
    if (more_enemies_data.mod.staged_clone[planet.string_val].count == nil) then more_enemies_data.mod.staged_clone[planet.string_val].count = 0 end

    if (not more_enemies_data.mod.staged_clones[planet.string_val]) then more_enemies_data.mod.staged_clones[planet.string_val] = {} end
    if (not more_enemies_data.mod.staged_clones[planet.string_val].unit) then more_enemies_data.mod.staged_clones[planet.string_val].unit = {} end
    if (not more_enemies_data.mod.staged_clones[planet.string_val].unit_group) then more_enemies_data.mod.staged_clones[planet.string_val].unit_group = {} end

    if (not more_enemies_data.mod.clone[planet.string_val]) then more_enemies_data.mod.clone[planet.string_val] = {} end
    if (more_enemies_data.mod.clone[planet.string_val].count == nil) then more_enemies_data.mod.clone[planet.string_val].count = 0 end

    if (not more_enemies_data.mod.clones[planet.string_val]) then more_enemies_data.mod.clones[planet.string_val] = {} end
    if (not more_enemies_data.mod.clones[planet.string_val].unit) then more_enemies_data.mod.clones[planet.string_val].unit = {} end
    if (not more_enemies_data.mod.clones[planet.string_val].unit_group) then more_enemies_data.mod.clones[planet.string_val].unit_group = {} end

    if (not more_enemies_data.staged_clone) then more_enemies_data.staged_clone = {} end
    if (not more_enemies_data.staged_clone[planet.string_val]) then more_enemies_data.staged_clone[planet.string_val] = {} end
    if (more_enemies_data.staged_clone[planet.string_val].unit == nil) then more_enemies_data.staged_clone[planet.string_val].unit = 0 end
    if (more_enemies_data.staged_clone[planet.string_val].unit_group == nil) then more_enemies_data.staged_clone[planet.string_val].unit_group = 0 end

    if (not more_enemies_data.staged_clones) then more_enemies_data.staged_clones = More_Enemies_Data.staged_clones end
    if (not more_enemies_data.staged_clones[planet.string_val]) then more_enemies_data.staged_clones[planet.string_val] = {} end
    if (not more_enemies_data.staged_clones[planet.string_val].unit) then more_enemies_data.staged_clones[planet.string_val].unit = {} end
    if (not more_enemies_data.staged_clones[planet.string_val].unit_group) then more_enemies_data.staged_clones[planet.string_val].unit_group = {} end

    if (not more_enemies_data.clone) then more_enemies_data.clone = More_Enemies_Data.clone end
    if (not more_enemies_data.clone[planet.string_val]) then more_enemies_data.clone[planet.string_val] = {} end
    if (more_enemies_data.clone[planet.string_val].unit == nil) then more_enemies_data.clone[planet.string_val].unit = 0 end
    if (more_enemies_data.clone[planet.string_val].unit_group == nil) then more_enemies_data.clone[planet.string_val].unit_group = 0 end

    if (not more_enemies_data.clones) then more_enemies_data.clones = {} end
    if (not more_enemies_data.clones[planet.string_val]) then more_enemies_data.clones[planet.string_val] = {} end
    if (not more_enemies_data.clones[planet.string_val].unit) then more_enemies_data.clones[planet.string_val].unit = {} end
    if (not more_enemies_data.clones[planet.string_val].unit_group) then more_enemies_data.clones[planet.string_val].unit_group = {} end
  end

  more_enemies_data.mod.valid = true

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

    -- more_enemies_data.overflow_clone_attempts = Overflow_Clone_Attempts_Data:new({ valid = true })
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
  -- elseif (not settings.global[Log_Constants.DEBUG_LEVEL.name]) then
  elseif (not settings.global[Log_Constants.settings.DEBUG_LEVEL.name]) then
    Log.error("settings.global[Log_Constants.settings.DEBUG_LEVEL.name] is nil")
    error("settings.global[Log_Constants.settings.DEBUG_LEVEL.name] is nil")
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

function locals.migrate(maintain_existing_peace)
    Log.debug("migrate")
    Log.info(maintain_existing_peace)

    if (maintain_existing_peace) then
        local storage_old = storage.storage_old
        if (not type(storage_old) == "table") then return end


        for _, planet in pairs(Constants.DEFAULTS.planets) do
            if (game and game.surfaces and game.surfaces[planet.string_val] and game.surfaces[planet.string_val].valid) then
                -- local attack_group_data = Attack_Group_Repository.get_attack_group_data(planet.string_val)

                if (storage_old.more_enemies.attack_group and storage_old.more_enemies.attack_group[planet.string_val]) then
                    local attack_group_data_old = storage_old.more_enemies.attack_group[planet.string_val]

                    if (type(attack_group_data_old) == "table" and attack_group_data_old.surface and attack_group_data_old.surface.valid) then
                        Attack_Group_Repository.update_attack_group_data(attack_group_data_old)
                    end

                    storage_old.more_enemies.attack_group[planet.string_val] = nil
                end
            end
        end
    end
end

initialization.more_enemies = true

local _initialization = initialization

return initialization