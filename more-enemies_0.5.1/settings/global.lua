local BREAM_Settings_Constants = require("libs.constants.settings.mods.BREAM.BREAM-settings-constants")
local Global_Settings_Constants = require("libs.constants.settings.global-settings-constants")

data:extend({
  Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_RUNTIME,
  Global_Settings_Constants.settings.MAX_UNIT_GROUP_SIZE_STARTUP,
  Global_Settings_Constants.settings.NTH_TICK.setting,
  Global_Settings_Constants.settings.CLONES_PER_TICK,
  Global_Settings_Constants.settings.MAXIMUM_NUMBER_OF_CLONES,
})

if (mods and (mods["BREAM"])) then
  data:extend({
    Global_Settings_Constants.settings.MAXIMUM_NUMBER_OF_MODDED_CLONES,
  })

  data:extend({
    BREAM_Settings_Constants.settings.BREAM_DIFFICULTY,
    BREAM_Settings_Constants.settings.BREAM_DO_CLONE,
    BREAM_Settings_Constants.settings.BREAM_USE_EVOLUTION_FACTOR,
    BREAM_Settings_Constants.settings.BREAM_CLONE_UNITS,
  })
end