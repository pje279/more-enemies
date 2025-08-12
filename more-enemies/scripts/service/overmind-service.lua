-- If already defined, return
if _overmind_service and _overmind_service.more_enemies then
  return _overmind_service
end

local Log = require("libs.log.log")

local overmind_service = {}

function overmind_service.on_built_entity(event)
    Log.debug("overmind_service.on_built_entity")
    Log.info(event)
end

function overmind_service.on_player_mined_entity(event)
    Log.debug("overmind_service.on_player_mined_entity")
    Log.info(event)
end

function overmind_service.on_player_mined_item(event)
    Log.debug("overmind_service.on_player_mined_item")
    Log.info(event)
end

function overmind_service.on_post_entity_died(event)
    Log.debug("overmind_service.on_post_entity_died")
    Log.info(event)
end

function overmind_service.on_robot_built_entity(event)
    Log.debug("overmind_service.on_robot_built_entity")
    Log.info(event)
end

function overmind_service.on_robot_mined_entity(event)
    Log.debug("overmind_service.on_robot_mined_entity")
    Log.info(event)
end

function overmind_service.on_rocket_launch_ordered(event)
    Log.debug("overmind_service.on_rocket_launch_ordered")
    Log.info(event)
end

overmind_service.more_enemies = true

local _overmind_service = overmind_service

return overmind_service