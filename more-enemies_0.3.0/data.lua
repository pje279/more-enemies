require("prototypes.map-settings")
require("prototypes.spawners.nauvis")

if (mods["space-age"]) then
  require("prototypes.spawners.gleba")
end

-- Fix the character dying in menu_simulations.nauvis_biter_base_laser_defense when difficulty is turned up
require("menu-simulations.menu-simulations")