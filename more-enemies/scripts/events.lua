-- local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")
local Log = require("libs.log.log")
local Planet_Controller = require("scripts.controller.planet-controller")
-- local Initialization = require("scripts.initialization")
local Settings_Controller = require("scripts.controller.settings-controller")
local Spawn_Controller = require("scripts.controller.spawn-controller")
local Unit_Group_Controller = require("scripts.controller.unit-group-controller")

--
-- Register events

Log.info("Registering events")

-- script.on_init(Initialization.init)

script.on_event(defines.events.on_tick, Spawn_Controller.do_tick)

-- Detect entities built by other mods
--  -> Could be enemies created by other mods
script.on_event(defines.events.script_raised_built, Spawn_Controller.entity_built, Spawn_Controller.filter)

script.on_event(defines.events.on_runtime_mod_setting_changed, Settings_Controller.mod_setting_changed)
script.on_event(defines.events.on_entity_spawned, Spawn_Controller.entity_spawned)
script.on_event(defines.events.on_entity_died, Spawn_Controller.entity_died, Spawn_Controller.filter)
script.on_event(defines.events.on_unit_group_created, Unit_Group_Controller.unit_group_created)
script.on_event(defines.events.on_unit_group_finished_gathering, Unit_Group_Controller.unit_group_finished_gathering)

script.on_event(defines.events.on_surface_created, Planet_Controller.on_surface_created)

Log.info("Finished registering events")