log("log-settings started")

local Log_Constants = require("libs.log.log-constants")
local Log_Constants_Functions = require("libs.log.log-constants-functions")

log("imports done")

data:extend({
  {
    type = "string-setting",
    -- name = Log_Constants.DEBUG_LEVEL.name,
    name = "more-enemies-debug-level",
    setting_type = "runtime-global",
    order = "aba",
    default_value = Log_Constants.DEBUG_LEVEL.value,
    -- allowed_values = { "None", "Error", "Warn", "Debug", "Info" }
    allowed_values = Log_Constants_Functions.levels.get_names()
  },
  {
    type = "bool-setting",
    -- name = Log_Constants.DEBUG_LEVEL.name,
    name = "more-enemies-do-traceback",
    setting_type = "runtime-global",
    order = "abb",
    default_value = Log_Constants.DO_TRACEBACK.value,
    allowed_values = Log_Constants.DO_TRACEBACK.value
  },
})

log("added settings")