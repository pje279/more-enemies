-- If already defined, return
if _overmind_controller and _overmind_controller.more_enemies then
  return _overmind_controller
end

local Log = require("libs.log.log")
local Overmind_Service = require("scripts.service.overmind-service")

local overmind_controller = {}

function overmind_controller.on_built_entity(event)
    Log.debug("overmind_controller.on_built_entity")
    Log.info(event)
    Overmind_Service.on_built_entity(event)
end

function overmind_controller.on_player_mined_entity(event)
    Log.debug("overmind_controller.on_player_mined_entity")
    Log.info(event)
    Overmind_Service.on_player_mined_entity(event)
end

function overmind_controller.on_player_mined_item(event)
    Log.debug("overmind_controller.on_player_mined_item")
    Log.info(event)
    Overmind_Service.on_player_mined_item(event)
end

function overmind_controller.on_post_entity_died(event)
    Log.debug("overmind_controller.on_post_entity_died")
    Log.info(event)
    Overmind_Service.on_post_entity_died(event)
end

function overmind_controller.on_robot_built_entity(event)
    Log.debug("overmind_controller.on_robot_built_entity")
    Log.info(event)
    Overmind_Service.on_robot_built_entity(event)
end

function overmind_controller.on_robot_mined_entity(event)
    Log.debug("overmind_controller.on_robot_mined_entity")
    Log.info(event)
    Overmind_Service.on_robot_mined_entity(event)
end

function overmind_controller.on_rocket_launch_ordered(event)
    Log.debug("overmind_controller.on_rocket_launch_ordered")
    Log.info(event)
    Overmind_Service.on_rocket_launch_ordered(event)
end

overmind_controller.more_enemies = true

local _overmind_controller = overmind_controller

return overmind_controller