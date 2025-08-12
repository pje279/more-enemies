-- If already defined, return
if _planet_controller and _planet_controller.more_enemies then
  return _planet_controller
end

local Log = require("libs.log.log")
local Planet_Service = require("scripts.service.planet-service")

local planet_controller = {}

function planet_controller.on_surface_created(event)
    Log.debug("planet_controller.on_surface_created")
    Log.info(event)
    Planet_Service.on_surface_created(event)
end

planet_controller.more_enemies = true

local _planet_controller = planet_controller

return planet_controller