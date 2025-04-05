-- If already defined, return
if (_entity_validations and _entity_validations.more_enemies) then
  return _entity_validations
end

local Log = require("libs.log.log")

local entity_validations = {}

function entity_validations.get_mod_name(entity)
  local return_val = nil

  if (pcall(check_for_mod_name, entity)) then
    return_val = entity.mod_name
  end

  return return_val
end

function check_for_mod_name(entity)
  return entity.mod_name and true or false
end

entity_validations.more_enemies = true

local _entity_validations = entity_validations
return entity_validations