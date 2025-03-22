-- If already defined, return
if _commands and _commands.more_enemies then
  return _commands
end

local Initialization = require("control.initialization")
local Log = require("libs.log.log")

local Commands = {}

function Commands.init(event)
  validate_command_event(event, function (player)
    Log.info("commands.init", true)
    player.print("Initializing anew")
    Initialization.init()
    player.print("Initialization complete")
  end)
end

function Commands.reinit(event)
  validate_command_event(event, function (player)
    Log.info("commands.reinit", true)
    player.print("Reinitializing")
    Initialization.reinit()
    player.print("Reinitialization complete")
  end)
end

function Commands.print_storage(event)
  validate_command_event(event, function (player)
    Log.info("commands.print_storage", true)
    log(serpent.block(storage))
    player.print(serpent.block(storage))
  end)
end

function validate_command_event(event, fun)
  Log.info(event)
  if (event) then
    local player_index = event.player_index

    local player
    if (game and player_index > 0 and game.players) then
      player = game.players[player_index]
    end

    if (player) then
      fun(player)
    end
  end
end

commands.add_command("more_enemies.init","Initialize from scratch. Will erase existing data.", Commands.init)
commands.add_command("more_enemies.reinit","Tries to reinitialize, attempting to preserve existing data.", Commands.reinit)
commands.add_command("more_enemies.print_storage","Prints the underlying storage data.", Commands.print_storage)

Commands.more_enemies = true

local _commands = Commands

return Commands