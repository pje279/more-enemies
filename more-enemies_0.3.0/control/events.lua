local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Log = require("libs.log.log")
local Initialization = require("control.initialization")
local Settings_Controller = require("control.controller.settings-controller")
local Spawn_Controller = require("control.controller.spawn-controller")
local Unit_Group_Controller = require("control.controller.unit-group-controller")

--
-- Register events

Log.info("Registering events")

script.on_init(Initialization.init)

script.on_event(defines.events.on_tick, Spawn_Controller.do_tick)

script.on_event(defines.events.on_runtime_mod_setting_changed, Settings_Controller.mod_setting_changed)
script.on_event(defines.events.on_entity_spawned, Spawn_Controller.entity_spawned)
script.on_event(defines.events.on_entity_died, Spawn_Controller.entity_died, Spawn_Controller.filter)
script.on_event(defines.events.on_unit_group_created, Unit_Group_Controller.unit_group_created)
script.on_event(defines.events.on_unit_group_finished_gathering, Unit_Group_Controller.unit_group_finished_gathering)

Log.info("Finished registering events")