-- If already defined, return
if _overmind_taget_priorities and _overmind_taget_priorities.more_enemies then
  return _overmind_taget_priorities
end

local overmind_taget_priorities = {
    ["cargo-landing-pad"] = {
        priority = 1,
        weight = 1200,
        evolution_thresholds = {
            [0.3] = 1,
            [0.5] = 1,
            [0.666] = 1,
            [0.9] = 1,
        },
    },
    ["rocket-silo"] = {
        priority = 1,
        weight = 300,
        evolution_thresholds = {
            [0.3] = 1,
            [0.5] = 1,
            [0.666] = 1,
            [0.9] = 1,
        },
    },
    ["rocket-silo-rocket"] = {
        priority = 1,
        weight = 300,
        evolution_thresholds = {
            [0.3] = 1,
            [0.5] = 1,
            [0.666] = 1,
            [0.9] = 1,
        },
    },
    ["character"] = {
        priority = 2,
        weight = 1000,
        evolution_thresholds = {
            [0.35] = 1,
            [0.65] = 1,
            [0.8] = 1,
            [0.9] = 1,
        },
    },
    ["character-corpse"] = {
        priority = 3,
        weight = 750,
    },
    ["small-electric-pole"] = {
        priority = 0,
        weight = 0,
    },
    ["medium-electric-pole"] = {
        priority = 0,
        weight = 0,
    },
    ["big-electric-pole"] = {
        priority = 0,
        weight = 0,
    },
    ["substation"] = {
        priority = 0,
        weight = 0,
    },
    ["curved-rail-a"] = {
        priority = 0,
        weight = 0,
    },
    ["curved-rail-b"] = {
        priority = 0,
        weight = 0,
    },
    ["elevated-curved-rail-a"] = {
        priority = 0,
        weight = 0,
    },
    ["elevated-curved-rail-b"] = {
        priority = 0,
        weight = 0,
    },
    ["elevated-half-diagonal-rail"] = {
        priority = 0,
        weight = 0,
    },
    ["elevated-straight-rail"] = {
        priority = 0,
        weight = 0,
    },
    ["half-diagonal-rail"] = {
        priority = 0,
        weight = 0,
    },
    ["rail-ramp"] = {
        priority = 0,
        weight = 0,
    },
    ["rail-signal"] = {
        priority = 0,
        weight = 0,
    },
    ["rail-chain-signal"] = {
        priority = 0,
        weight = 0,
    },
    ["rail-support"] = {
        priority = 0,
        weight = 0,
    },
    ["straight-rail"] = {
        priority = 0,
        weight = 0,
    },
    ["train-stop"] = {
        priority = 0,
        weight = 0,
    },
    ["artillery-wagon"] = {
        priority = 0,
        weight = 0,
    },
    ["cargo-wagon"] = {
        priority = 0,
        weight = 0,
    },
    ["fluid-wagon"] = {
        priority = 0,
        weight = 0,
    },
    ["locomotive"] = {
        priority = 0,
        weight = 0,
    },
    ["radar"] = {
        priority = 0,
        weight = 0,
    },
    ["solar-panel"] = {
        priority = 0,
        weight = 0,
    },
    ["accumulator"] = {
        priority = 0,
        weight = 0,
    },
    ["arithmetic-combinator"] = {
        priority = 0,
        weight = 0,
    },
    ["constant-combinator"] = {
        priority = 0,
        weight = 0,
    },
    ["decider-combinator"] = {
        priority = 0,
        weight = 0,
    },
    ["selector-combinator"] = {
        priority = 0,
        weight = 0,
    },
    ["small-lamp"] = {
        priority = 0,
        weight = 0,
    },
    ["power-switch"] = {
        priority = 0,
        weight = 0,
    },
    ["assembling-machine-1"] = {
        priority = 0,
        weight = 0,
    },
    ["assembling-machine-2"] = {
        priority = 0,
        weight = 0,
    },
    ["assembling-machine-3"] = {
        priority = 0,
        weight = 0,
    },
    ["chemical-plant"] = {
        priority = 0,
        weight = 0,
    },
    ["oil-refinery"] = {
        priority = 0,
        weight = 0,
    },
    ["centrifuge"] = {
        priority = 0,
        weight = 0,
    },
    ["stone-furnace"] = {
        priority = 0,
        weight = 0,
    },
    ["boiler"] = {
        priority = 0,
        weight = 0,
    },
    ["wooden-chest"] = {
        priority = 0,
        weight = 0,
    },
    ["iron-chest"] = {
        priority = 0,
        weight = 0,
    },
    ["steam-engine"] = {
        priority = 0,
        weight = 0,
    },
    ["offshore-pump"] = {
        priority = 0,
        weight = 0,
    },
    ["inserter"] = {
        priority = 0,
        weight = 0,
    },
    ["fast-inserter"] = {
        priority = 0,
        weight = 0,
    },
    ["long-handed-inserter"] = {
        priority = 0,
        weight = 0,
    },
    ["burner-inserter"] = {
        priority = 0,
        weight = 0,
    },
    ["pipe"] = {
        priority = 0,
        weight = 0,
    },
    ["pipe-to-ground"] = {
        priority = 0,
        weight = 0,
    },
    ["stone-wall"] = {
        priority = 0,
        weight = 0,
    },
    ["lab"] = {
        priority = 0,
        weight = 0,
    },
    ["car"] = {
        priority = 0,
        weight = 0,
    },
    ["electric-furnace"] = {
        priority = 0,
        weight = 0,
    },
    ["steel-furnace"] = {
        priority = 0,
        weight = 0,
    },
    ["gate"] = {
        priority = 0,
        weight = 0,
    },
    ["steel-chest"] = {
        priority = 0,
        weight = 0,
    },
    ["bulk-inserter"] = {
        priority = 0,
        weight = 0,
    },
    ["stack-inserter"] = {
        priority = 0,
        weight = 0,
    },
    ["land-mine"] = {
        priority = 0,
        weight = 0,
    },
    ["passive-provider-chest"] = {
        priority = 0,
        weight = 0,
    },
    ["active-provider-chest"] = {
        priority = 0,
        weight = 0,
    },
    ["storage-chest"] = {
        priority = 0,
        weight = 0,
    },
    ["buffer-chest"] = {
        priority = 0,
        weight = 0,
    },
    ["requester-chest"] = {
        priority = 0,
        weight = 0,
    },
    ["storage-tank"] = {
        priority = 0,
        weight = 0,
    },
    ["pump"] = {
        priority = 0,
        weight = 0,
    },
    ["beacon"] = {
        priority = 0,
        weight = 0,
    },
    ["tank"] = {
        priority = 0,
        weight = 0,
    },
    ["heat-exchanger"] = {
        priority = 0,
        weight = 0,
    },
    ["steam-turbine"] = {
        priority = 0,
        weight = 0,
    },
    ["heat-pipe"] = {
        priority = 0,
        weight = 0,
    },
    ["spidertron"] = {
        priority = 0,
        weight = 0,
    },
    ["burner-generator"] = {
        priority = 0,
        weight = 0,
    },
}

overmind_taget_priorities.more_enemies = true

local _overmind_taget_priorities = overmind_taget_priorities

return overmind_taget_priorities