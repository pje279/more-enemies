-- If already defined, return
if _unit_group_controller and _unit_group_controller.more_enemies then
  return _unit_group_controller
end

local Log = require("libs.log.log")
local Initialization = require("control.initialization")
local Unit_Group_Service = require("control.service.unit-group-service")

local unit_group_controller = {}

function unit_group_controller.unit_group_created(event)
  Log.debug("unit_group_controller.unit_group_created")
  Log.info(event)
  Unit_Group_Service.unit_group_created(event)
end

function unit_group_controller.unit_group_finished_gathering(event)
  Log.debug("unit_group_controller.unit_group_finished_gathering")
  Log.info(event)
  Unit_Group_Service.unit_group_finished_gathering(event)
end

unit_group_controller.more_enemies = true

local _unit_group_controller = unit_group_controller

return unit_group_controller