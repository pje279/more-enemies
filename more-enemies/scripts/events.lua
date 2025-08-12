local Log = require("libs.log.log")
local Overmind_Controller = require("scripts.controller.overmind-controller")
local Planet_Controller = require("scripts.controller.planet-controller")
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

script.on_event(defines.events.on_built_entity, Overmind_Controller.on_built_entity)
script.on_event(defines.events.on_player_mined_entity, Overmind_Controller.on_player_mined_entity)
script.on_event(defines.events.on_player_mined_item, Overmind_Controller.on_player_mined_item)
script.on_event(defines.events.on_post_entity_died, Overmind_Controller.on_post_entity_died)
script.on_event(defines.events.on_robot_built_entity, Overmind_Controller.on_robot_built_entity)
script.on_event(defines.events.on_robot_mined_entity, Overmind_Controller.on_robot_mined_entity)
script.on_event(defines.events.on_rocket_launch_ordered, Overmind_Controller.on_rocket_launch_ordered)

Log.info("Finished registering events")