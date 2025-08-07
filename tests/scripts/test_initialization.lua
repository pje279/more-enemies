require("package_path") -- Allows for using relative paths
local lu = require('luaunit')

local Clone_Data = require("scripts.data.clone-data")
local Constants = require(".libs.constants.constants")
local Gleba_Settings_Constants = require("libs.constants.settings.gleba-settings-constants")
local Log = require(".libs.log.log")
local Log_Constants = require(".libs.log.log-constants")
local More_Enemies_Data = require(".scripts.data.more-enemies-data")
local More_Enemies_Repository = require("scripts.repositories.more-enemies-repository")
local Nauvis_Settings_Constants = require("libs.constants.settings.nauvis-settings-constants")
local Version_Data = require(".scripts.data.version-data")

local do_log = false
local do_print = false

local sut_Initialization = require(".scripts.initialization")

local function t_print(t, d)
    if (d == nil) then d = "" end
    if (type(t) ~= "table") then
        print(t)
        if (t == nil) then return "" end
        return t
    end
    for k, v in pairs(t) do
        if (type(v) == "table") then
            print(d .. k)
            t_print(v, d .. "  ")
        else
            print(d .. k .. " = " .. tostring(v))
        end
    end

    return ""
end

Test_Init = {
    setUp = function ()
        lu.assert_not_nil(Constants)
        lu.assert_not_nil(Gleba_Settings_Constants)
        lu.assert_not_nil(Nauvis_Settings_Constants)
        lu.assert_not_nil(Log_Constants)

        lu.assert_not_nil(sut_Initialization)

        storage = {}
        storage.more_enemies = More_Enemies_Data:new()

        game = {
            print = function (...) if (do_print) then print(...) else return end end,
            get_surface = function (...) return { name = tostring(...) } end,
            tick = 42,
        }

        settings = {
            startup = {},
            global = {},
        }

        settings.startup[Nauvis_Settings_Constants.settings.NAUVIS_DIFFICULTY.name] = {
            name = Nauvis_Settings_Constants.settings.NAUVIS_DIFFICULTY.name,
            value = Nauvis_Settings_Constants.settings.NAUVIS_DIFFICULTY.default_value,
        }

        settings.startup[Gleba_Settings_Constants.settings.GLEBA_DIFFICULTY.name] = {
            name = Gleba_Settings_Constants.settings.GLEBA_DIFFICULTY.name,
            value = Gleba_Settings_Constants.settings.GLEBA_DIFFICULTY.default_value,
        }

        settings.global[Log_Constants.settings.DEBUG_LEVEL.name] = {
            name = Log_Constants.settings.DEBUG_LEVEL.name,
            value = Log_Constants.settings.DEBUG_LEVEL.value,
        }

        Log.set_log_level("None")

        log = function (...) if (do_log) then print(...) else return end end

        serpent = {
            block = function (...)
                if (type(...) == "table") then return "" end
                return tostring(...)
            end
        }
    end,
    tearDown = function ()
        do_log = false
        do_print = false
    end,
    test_version_data = function ()
        -- Given

        -- When
        local more_enemies_data = sut_Initialization.init()

        -- Then
        lu.assert_table(more_enemies_data)
        lu.assert_true(more_enemies_data.valid)

        lu.assert_table(more_enemies_data.version_data)
        lu.assert_true(more_enemies_data.version_data.valid)
        lu.assert_not_nil(more_enemies_data.version_data.string_val)
        lu.assert_equals(more_enemies_data.version_data.string_val, Version_Data:to_string())
    end,
    test_mod_data = function ()
        -- Given

        -- When
        local more_enemies_data = sut_Initialization.init()

        -- Then
        lu.assert_table(more_enemies_data)
        lu.assert_true(more_enemies_data.valid)

        lu.assert_table(more_enemies_data.mod)
        lu.assert_true(more_enemies_data.mod.valid)

        lu.assert_table(more_enemies_data.mod.staged_clone)
        lu.assert_table(more_enemies_data.mod.staged_clones)

        lu.assert_table(more_enemies_data.mod.clone)
        lu.assert_table(more_enemies_data.mod.clones)

        for _, planet in pairs(Constants.DEFAULTS.planets) do
            lu.assert_table(more_enemies_data.mod.staged_clone[planet.string_val])
            lu.assert_number(more_enemies_data.mod.staged_clone[planet.string_val].count)
            lu.assert_equals(more_enemies_data.mod.staged_clone[planet.string_val].count, 0)

            lu.assert_table(more_enemies_data.mod.staged_clones[planet.string_val])
            lu.assert_table(more_enemies_data.mod.staged_clones[planet.string_val].unit)
            lu.assert_table(more_enemies_data.mod.staged_clones[planet.string_val].unit_group)

            lu.assert_table(more_enemies_data.mod.clone[planet.string_val])
            lu.assert_number(more_enemies_data.mod.clone[planet.string_val].count)
            lu.assert_equals(more_enemies_data.mod.clone[planet.string_val].count, 0)

            lu.assert_table(more_enemies_data.mod.clones[planet.string_val])
            lu.assert_table(more_enemies_data.mod.clones[planet.string_val].unit)
            lu.assert_table(more_enemies_data.mod.clones[planet.string_val].unit_group)
        end
    end,
    test_more_enemies_data = function ()
        -- Given
        local old = storage.more_enemies
        lu.assert_not_nil(old)

        -- When
        local more_enemies_data = sut_Initialization.init()

        -- Then
        lu.assert_table(more_enemies_data)
        lu.assert_true(more_enemies_data.valid)

        lu.assert_not_is(more_enemies_data, old)

        lu.assert_true(more_enemies_data.do_nth_tick)

        lu.assert_table(more_enemies_data.staged_clone)
        lu.assert_table(more_enemies_data.staged_clones)

        lu.assert_table(more_enemies_data.clone)
        lu.assert_table(more_enemies_data.clones)

        lu.assert_table(more_enemies_data.groups)

        for _, planet in pairs(Constants.DEFAULTS.planets) do
            lu.assert_table(more_enemies_data.groups[planet.string_val])

            lu.assert_table(more_enemies_data.staged_clone[planet.string_val])
            lu.assert_number(more_enemies_data.staged_clone[planet.string_val].unit)
            lu.assert_equals(more_enemies_data.staged_clone[planet.string_val].unit, 0)
            lu.assert_number(more_enemies_data.staged_clone[planet.string_val].unit_group)
            lu.assert_equals(more_enemies_data.staged_clone[planet.string_val].unit_group, 0)

            lu.assert_table(more_enemies_data.staged_clones[planet.string_val])
            lu.assert_table(more_enemies_data.staged_clones[planet.string_val].unit)
            lu.assert_table(more_enemies_data.staged_clones[planet.string_val].unit_group)

            lu.assert_table(more_enemies_data.clone[planet.string_val])
            lu.assert_number(more_enemies_data.clone[planet.string_val].unit)
            lu.assert_equals(more_enemies_data.clone[planet.string_val].unit, 0)
            lu.assert_number(more_enemies_data.clone[planet.string_val].unit_group)
            lu.assert_equals(more_enemies_data.clone[planet.string_val].unit_group, 0)

            lu.assert_table(more_enemies_data.clones[planet.string_val])
            lu.assert_table(more_enemies_data.clones[planet.string_val].unit)
            lu.assert_table(more_enemies_data.clones[planet.string_val].unit_group)
        end
    end,
    test_nth_tick_data = function ()
        -- Given

        -- When
        local more_enemies_data = sut_Initialization.init()

        -- Then
        lu.assert_table(more_enemies_data)
        lu.assert_true(more_enemies_data.valid)

        lu.assert_table(more_enemies_data.nth_tick_complete)
        lu.assert_true(more_enemies_data.nth_tick_complete.valid)

        lu.assert_true(more_enemies_data.nth_tick_complete.current)
        lu.assert_true(more_enemies_data.nth_tick_complete.previous)

        lu.assert_table(more_enemies_data.nth_tick_cleanup_complete)
        lu.assert_true(more_enemies_data.nth_tick_cleanup_complete.valid)

        lu.assert_true(more_enemies_data.nth_tick_cleanup_complete.current)
        lu.assert_true(more_enemies_data.nth_tick_cleanup_complete.previous)
    end,
    test_difficulty = function ()
        -- Given

        -- When
        local more_enemies_data = sut_Initialization.init()

        -- Then
        lu.assert_table(more_enemies_data)
        lu.assert_true(more_enemies_data.valid)

        lu.assert_table(more_enemies_data.difficulties)

        -- t_print(more_enemies_data)

        for _, planet in pairs(Constants.DEFAULTS.planets) do
            lu.assert_table(more_enemies_data.difficulties[planet.string_val])
            lu.assert_true(more_enemies_data.difficulties[planet.string_val].valid)

            lu.assert_table(more_enemies_data.difficulties[planet.string_val].surface)
            lu.assert_string(more_enemies_data.difficulties[planet.string_val].surface.name)

            lu.assert_table(more_enemies_data.difficulties[planet.string_val].difficulty)
            lu.assert_table(more_enemies_data.difficulties[planet.string_val].difficulty.selected_difficulty)
            lu.assert_true(more_enemies_data.difficulties[planet.string_val].difficulty.selected_difficulty.valid)
            lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulty.selected_difficulty.value)
            lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulty.selected_difficulty.order)
            lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulty.selected_difficulty.radius)
            lu.assert_string(more_enemies_data.difficulties[planet.string_val].difficulty.selected_difficulty.name)
            lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulty.selected_difficulty.radius_modifier)
            lu.assert_string(more_enemies_data.difficulties[planet.string_val].difficulty.selected_difficulty.string_val)

            if (planet.string_val == "Nauvis") then
                lu.assert_true(more_enemies_data.difficulties[planet.string_val].selected_difficulty.valid)

                lu.assert_equals(   settings.startup[Nauvis_Settings_Constants.settings.NAUVIS_DIFFICULTY.name].value,
                                    more_enemies_data.difficulties[planet.string_val].selected_difficulty.string_val)

                lu.assert_table(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.biter)
                lu.assert_table(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.biter.spawning_cooldown)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.biter.max_count_of_owned_units)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.biter.max_count_of_owned_defensive_units)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.biter.max_friends_around_to_spawn)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.biter.max_defensive_friends_around_to_spawn)

                lu.assert_table(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.spitter)
                lu.assert_table(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.spitter.spawning_cooldown)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.spitter.max_count_of_owned_units)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.spitter.max_count_of_owned_defensive_units)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.spitter.max_friends_around_to_spawn)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.spitter.max_defensive_friends_around_to_spawn)
            elseif (planet.string_val == "Gleba") then
                lu.assert_true(more_enemies_data.difficulties[planet.string_val].selected_difficulty.valid)

                lu.assert_equals(   settings.startup[Gleba_Settings_Constants.settings.GLEBA_DIFFICULTY.name].value,
                                    more_enemies_data.difficulties[planet.string_val].selected_difficulty.string_val)

                lu.assert_table(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.small)
                lu.assert_table(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.small.spawning_cooldown)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.small.max_count_of_owned_units)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.small.max_count_of_owned_defensive_units)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.small.max_friends_around_to_spawn)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.small.max_defensive_friends_around_to_spawn)

                lu.assert_table(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.regular)
                lu.assert_table(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.regular.spawning_cooldown)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.regular.max_count_of_owned_units)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.regular.max_count_of_owned_defensive_units)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.regular.max_friends_around_to_spawn)
                lu.assert_number(more_enemies_data.difficulties[planet.string_val].difficulties.selected_difficulty.regular.max_defensive_friends_around_to_spawn)
            end
        end
    end,
}

Test_Reinit = {
    setUp = function ()
        lu.assert_not_nil(Constants)
        lu.assert_not_nil(Gleba_Settings_Constants)
        lu.assert_not_nil(Nauvis_Settings_Constants)
        lu.assert_not_nil(Log_Constants)

        lu.assert_not_nil(sut_Initialization)

        storage = {}
        storage.more_enemies = More_Enemies_Data:new({ valid = true })
        storage.more_enemies.version_data.valid = true

        game = {
            print = function (...) if (do_print) then print(...) else return end end,
            get_surface = function (...) return { name = tostring(...) } end,
            tick = 42,
        }

        settings = {
            startup = {},
            global = {},
        }

        settings.startup[Nauvis_Settings_Constants.settings.NAUVIS_DIFFICULTY.name] = {
            name = Nauvis_Settings_Constants.settings.NAUVIS_DIFFICULTY.name,
            value = Nauvis_Settings_Constants.settings.NAUVIS_DIFFICULTY.default_value,
        }

        settings.startup[Gleba_Settings_Constants.settings.GLEBA_DIFFICULTY.name] = {
            name = Gleba_Settings_Constants.settings.GLEBA_DIFFICULTY.name,
            value = Gleba_Settings_Constants.settings.GLEBA_DIFFICULTY.default_value,
        }

        settings.global[Log_Constants.settings.DEBUG_LEVEL.name] = {
            name = Log_Constants.settings.DEBUG_LEVEL.name,
            value = Log_Constants.settings.DEBUG_LEVEL.value,
        }

        Log.set_log_level("None")

        log = function (...) if (do_log) then print(...) else return end end

        serpent = {
            block = function (...)
                if (type(...) == "table") then return "" end
                return tostring(...)
            end
        }
    end,
    tearDown = function ()
        do_log = false
        do_print = false
    end,
    test_more_enemies_data = function ()
        -- Given
        local old = storage.more_enemies
        lu.assert_not_nil(old)

        -- When
        local more_enemies_data = sut_Initialization.reinit()

        -- Then
        lu.assert_table(more_enemies_data)
        lu.assert_true(more_enemies_data.valid)

        lu.assert_is(more_enemies_data, old)

        lu.assert_true(more_enemies_data.do_nth_tick)

        lu.assert_table(more_enemies_data.staged_clone)
        lu.assert_table(more_enemies_data.staged_clones)

        lu.assert_table(more_enemies_data.clone)
        lu.assert_table(more_enemies_data.clones)

        lu.assert_table(more_enemies_data.groups)

        for _, planet in pairs(Constants.DEFAULTS.planets) do
            lu.assert_table(more_enemies_data.groups[planet.string_val])

            lu.assert_table(more_enemies_data.staged_clone[planet.string_val])
            lu.assert_number(more_enemies_data.staged_clone[planet.string_val].unit)
            lu.assert_equals(more_enemies_data.staged_clone[planet.string_val].unit, 0)
            lu.assert_number(more_enemies_data.staged_clone[planet.string_val].unit_group)
            lu.assert_equals(more_enemies_data.staged_clone[planet.string_val].unit_group, 0)

            lu.assert_table(more_enemies_data.staged_clones[planet.string_val])
            lu.assert_table(more_enemies_data.staged_clones[planet.string_val].unit)
            lu.assert_table(more_enemies_data.staged_clones[planet.string_val].unit_group)

            lu.assert_table(more_enemies_data.clone[planet.string_val])
            lu.assert_number(more_enemies_data.clone[planet.string_val].unit)
            lu.assert_equals(more_enemies_data.clone[planet.string_val].unit, 0)
            lu.assert_number(more_enemies_data.clone[planet.string_val].unit_group)
            lu.assert_equals(more_enemies_data.clone[planet.string_val].unit_group, 0)

            lu.assert_table(more_enemies_data.clones[planet.string_val])
            lu.assert_table(more_enemies_data.clones[planet.string_val].unit)
            lu.assert_table(more_enemies_data.clones[planet.string_val].unit_group)
        end
    end,
}

Test_Purge = {
    setUp = function ()
        lu.assert_not_nil(Constants)
        lu.assert_not_nil(Gleba_Settings_Constants)
        lu.assert_not_nil(Nauvis_Settings_Constants)
        lu.assert_not_nil(Log_Constants)

        lu.assert_not_nil(sut_Initialization)

        storage = {}
        storage.more_enemies = More_Enemies_Data:new({ valid = true })
        storage.more_enemies.version_data.valid = true

        game = {
            print = function (...) if (do_print) then print(...) else return end end,
            get_surface = function (...) return { name = tostring(...) } end,
            tick = 42,
        }

        settings = {
            startup = {},
            global = {},
        }

        settings.startup[Nauvis_Settings_Constants.settings.NAUVIS_DIFFICULTY.name] = {
            name = Nauvis_Settings_Constants.settings.NAUVIS_DIFFICULTY.name,
            value = Nauvis_Settings_Constants.settings.NAUVIS_DIFFICULTY.default_value,
        }

        settings.startup[Gleba_Settings_Constants.settings.GLEBA_DIFFICULTY.name] = {
            name = Gleba_Settings_Constants.settings.GLEBA_DIFFICULTY.name,
            value = Gleba_Settings_Constants.settings.GLEBA_DIFFICULTY.default_value,
        }

        settings.global[Log_Constants.settings.DEBUG_LEVEL.name] = {
            name = Log_Constants.settings.DEBUG_LEVEL.name,
            value = Log_Constants.settings.DEBUG_LEVEL.value,
        }

        Log.set_log_level("None")

        log = function (...) if (do_log) then print(...) else return end end

        serpent = {
            block = function (...)
                if (type(...) == "table") then return "" end
                return tostring(...)
            end
        }
    end,
    tearDown = function ()
        do_log = false
        do_print = false
    end,
    test_purge = function ()
        -- Given

        -- When
        sut_Initialization.purge()

        -- Then
    end,
    test_purge_all = function ()
        -- Given

        -- When
        sut_Initialization.purge({ all = true })

        -- Then
    end,
    test_purge_clones = function ()
        -- Given

        -- When
        sut_Initialization.purge({ clones = true })

        -- Then
    end,
    test_purge_mod_added_clones = function ()
        -- Given

        -- When
        sut_Initialization.purge({ mod_added_clones = true })

        -- Then
    end,
    test_purge_exterminatus = function ()
        -- Given
        sut_Initialization.init()

        local more_enemies_data = More_Enemies_Repository.get_more_enemies_data()

        -- t_print(more_enemies_data)

        for _, planet in pairs(Constants.DEFAULTS.planets) do
            more_enemies_data.staged_clones[planet.string_val].unit = {
                Clone_Data:new({
                    obj = { name = "test-entity", valid = true },
                    surface = { name = planet.string_val, valid = true },
                    group = nil,
                    mod_name = nil,
                    valid = true
                }),
            }

            more_enemies_data.staged_clones[planet.string_val].unit_group = {
                Clone_Data:new({
                    obj = { name = "test-entity", valid = true },
                    surface = { name = planet.string_val, valid = true },
                    group = { valid = true },
                    mod_name = nil,
                    valid = true
                }),
            }

            more_enemies_data.staged_clone[planet.string_val].unit = 1
            more_enemies_data.staged_clone[planet.string_val].unit_group = 1

            lu.assert_not_nil(next(more_enemies_data.staged_clones[planet.string_val].unit), nil)
            lu.assert_not_nil(next(more_enemies_data.staged_clones[planet.string_val].unit_group), nil)
        end


        -- When
        sut_Initialization.purge({ exterminatus = true })

        -- Then
        for _, planet in pairs(Constants.DEFAULTS.planets) do
            lu.assert_equals(more_enemies_data.staged_clone[planet.string_val].unit, 0)
            lu.assert_equals(more_enemies_data.staged_clone[planet.string_val].unit_group, 0)

            lu.assert_nil(next(more_enemies_data.staged_clones[planet.string_val].unit), nil)
            lu.assert_nil(next(more_enemies_data.staged_clones[planet.string_val].unit_group), nil)
        end
    end,
}

os.exit( lu.LuaUnit.run() )