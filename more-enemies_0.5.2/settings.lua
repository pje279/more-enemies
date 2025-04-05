require("libs.log.log-settings")
require("settings.nauvis.nauvis")
require("settings.global")

if (mods) then
  if (mods["space-age"]) then require("settings.gleba.gleba") end
  if (mods["ArmouredBiters"]) then require("settings.mods.armoured-biters.armoured-biters-planet") end
end