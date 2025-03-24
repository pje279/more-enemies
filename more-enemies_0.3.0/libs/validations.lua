-- If already defined, return
local Validations = {}
if (_validations) then
  return _validations
end

function Validations.validate_setting_not_equal_to(setting, value)
  if (setting and setting.value and setting.value ~= value) then
    return true
  else
    return false
  end
end

-- function Validations.is_number(value)
--   return tonumber(value) and true or false
-- end

-- function Validations.is_string(value)
--   return tostring(value) and not value.valid and true or false
-- end

local _validations = Validations
return Validations