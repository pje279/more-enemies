-- If already defined, return
if _attack_group_constants and _attack_group_constants.more_enemies then
  return _attack_group_constants
end

local attack_group_constants = {}

attack_group_constants.type_blacklist = {
    "arrow",
    "artillery-flare",
    "artillery-projectile",
    "beam",
    "cargo-pod",
    "character-corpse",
    "cliff",
    "deconstructible-tile-proxy",
    "electric-energy-interface",
    "entity-ghost",
    "explosion",
    "fire",
    "fish",
    "heat-interface",
    "highlight-box",
    "infinity-cargo-wagon",
    "infinity-container",
    "infinity-pipe",
    "item-request-proxy",
    "lightning",
    "particle-source",
    "player-port",
    "projectile",
    "proxy-container",
    "resource",
    "rocket-silo-rocket",
    "rocket-silo-rocket-shadow",
    "segment",
    "segmented-unit",
    "smoke-with-trigger",
    "speech-bubble",
    "sticker",
    "stream",
    "temporary-container",
    "tile-ghost",
}

attack_group_constants.more_enemies = true

local _attack_group_constants = attack_group_constants

return attack_group_constants