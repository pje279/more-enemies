-- If already defined, return
if _more_enemies_commands and _more_enemies_commands.more_enemies then
  return _more_enemies_commands
end

local Constants = require("libs.constants.constants")
local Initialization = require("control.initialization")
local Log = require("libs.log.log")

local more_enemies_commands = {}

function more_enemies_commands.init(command)
  validate_command(command, function (player)
    Log.info("commands.init")
    player.print("Initializing anew")
    Initialization.init()
    player.print("Initialization complete")
  end)
end

function more_enemies_commands.reinit(command)
  validate_command(command, function (player)
    Log.info("commands.reinit")
    player.print("Reinitializing")
    Initialization.reinit()
    player.print("Reinitialization complete")
  end)
end

function more_enemies_commands.print_storage(command)
  validate_command(command, function (player)
    Log.info("commands.print_storage", true)
    log(serpent.block(storage))
    player.print(serpent.block(storage))
  end)
end

function more_enemies_commands.print_clone_counts(command)
  validate_command(command, function (player)
    Log.info("commands.print_clone_counts", true)
    if (storage and storage.more_enemies and storage.more_enemies.valid) then
      if (not storage.more_enemies.clone) then Initialization.reinit() end

      log("storage.more_enemies.clone.count: " .. tostring(storage.more_enemies.clone.count))
      player.print("storage.more_enemies.clone.count: " .. tostring(storage.more_enemies.clone.count))
    else
      Log.error("storage is either nil or invalid")
      player.print(serpent.block("storage is either nil or invalid; command failed"))
    end
  end)
end

function more_enemies_commands.version(command)
  validate_command(command, function (player)
    Log.info("commands.version")

    if (not storage.more_enemies or not storage.more_enemies.valid) then
      log(serpent.block("storage.more_enemies is nil or invalid; could not obtain version"))
      player.print(serpent.block("storage.more_enemies is nil or invalid; could not obtain version"))
      return
    end

    local more_enemies = storage.more_enemies

    if (not more_enemies.version or not more_enemies.version.valid) then
      log(serpent.block("storage.more_enemies.version is nil or invalid; could not obtain version"))
      player.print(serpent.block("storage.more_enemies.version is nil or invalid; could not obtain version"))
      return
    end

    local version = more_enemies.version

    log(serpent.block("more_enemies mod version: " .. Constants.meta.version.string_val))
    player.print(serpent.block("more_enemies mod version: " .. Constants.meta.version.string_val))

    log(serpent.block("more_enemies storage version: " .. version.string_val))
    player.print(serpent.block("more_enemies storage version: " .. version.string_val))
  end)
end

function more_enemies_commands.set_do_nth_tick(command)
  validate_command(command, function (player)
    Log.info("commands.set_do_nth_tick", true)
    if (storage and storage.more_enemies and storage.more_enemies.valid) then
      if (command.parameter ~= nil and (command.parameter or command.parameter == "true" or command.parameter >= 1)) then
        log("Setting do_nth_tick to true")
        player.print("Setting do_nth_tick to true")
        storage.more_enemies.do_nth_tick = true
      else
        log("Setting do_nth_tick to false")
        player.print("Setting do_nth_tick to false")
        storage.more_enemies.do_nth_tick = false
      end
    else
      Log.error("storage is either nil or invalid")
      player.print(serpent.block("storage is either nil or invalid; command failed"))
    end
  end)
end

function more_enemies_commands.get_do_nth_tick(command)
  validate_command(command, function (player)
    Log.info("commands.get_do_nth_tick", true)
    if (storage and storage.more_enemies and storage.more_enemies.valid) then
        log("do_nth_tick = " .. serpent.block(storage.more_enemies.do_nth_tick))
        player.print("do_nth_tick = " .. serpent.block(storage.more_enemies.do_nth_tick))
    else
      Log.error("storage is either nil or invalid")
      player.print(serpent.block("storage is either nil or invalid; command failed"))
    end
  end)
end

function more_enemies_commands.purge(command)
  validate_command(command, function (player)
    Log.info("commands.purge", true)
    if (  storage and storage.more_enemies and storage.more_enemies.valid) then
      local original_do_nth_tick = storage.more_enemies.do_nth_tick
      storage.more_enemies.do_nth_tick = false

      Log.debug("purge clones")
      -- Purge clones
      if (storage.more_enemies.clones) then
        for k,v in pairs(storage.more_enemies.clones) do
          if (v and v.obj) then
            Log.debug("purging" .. serpent.block(v.obj))
            v.obj.destroy()
          end
        end
        storage.more_enemies.clones = {}
        storage.more_enemies.clone = { count = 0 }
      end

      Log.debug("purge staged_clones")
      -- Purge staged_clones
      if (storage.more_enemies.staged_clones) then
        for k,v in pairs(storage.more_enemies.staged_clones) do
          if (v and v.obj) then
            Log.debug("purging" .. serpent.block(v.obj))
            v.obj.destroy()
          end
        end
        storage.more_enemies.staged_clones = {}
      end

      storage.more_enemies.do_nth_tick = original_do_nth_tick
    else
      Log.error("storage is either nil or invalid")
      player.print(serpent.block("storage is either nil or invalid; command failed"))
    end
  end)
end

function validate_command(command, fun)
  Log.info(command)
  if (command) then
    local player_index = command.player_index

    local player = nil
    if (game and player_index > 0 and game.players) then
      player = game.players[player_index]
    end

    if (player) then
      fun(player)
    end
  end
end

commands.add_command("more_enemies.init", "Initialize from scratch. Will erase existing data.", more_enemies_commands.init)
commands.add_command("more_enemies.reinit", "Tries to reinitialize, attempting to preserve existing data.", more_enemies_commands.reinit)
commands.add_command("more_enemies.print_clone_counts", "Prints the clone counts.", more_enemies_commands.print_clone_counts)
commands.add_command("more_enemies.print_storage", "Prints the underlying storage data.", more_enemies_commands.print_storage)
commands.add_command("more_enemies.version", "Prints the current mod version, and the underlying storage version.", more_enemies_commands.version)
commands.add_command("more_enemies.get_do_nth_tick", "Gets the value of the underlying variable for whether to process clones or not.", more_enemies_commands.get_do_nth_tick)
commands.add_command("more_enemies.set_do_nth_tick", "Sets whether to process clones or not depending on the parameter passed.", more_enemies_commands.set_do_nth_tick)
commands.add_command("more_enemies.purge", "Clears all of the cloned enemies, and enemies staged to be cloned", more_enemies_commands.purge)

more_enemies_commands.more_enemies = true

local _more_enemies_commands = more_enemies_commands

return more_enemies_commands