local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Log = require("libs.log.log")
local Initialization = require("control.initialization")
local Spawn = require("control.event.spawn")
local Spawn_Controller = require("control.controller.spawn-controller")
local Unit_Group = require("control.event.unit-group")

--
-- Register events

Log.info("Registering events")

script.on_init(Initialization.init)

script.on_event(defines.events.on_tick, Spawn_Controller.do_tick)

script.on_event(defines.events.on_entity_spawned, Spawn.entity_spawned)
script.on_event(defines.events.on_entity_died, Spawn.entity_died, Spawn.filter)
script.on_event(defines.events.on_unit_group_created, Unit_Group.unit_group_created)
script.on_event(defines.events.on_unit_group_finished_gathering, Unit_Group.unit_group_finished_gathering)

Log.info("Finished registering events")