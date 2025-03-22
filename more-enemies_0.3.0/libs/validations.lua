-- If already defined, return
local Validations = {}
if (_validations) then
  return _validations
end

function Validations.validateSettingNotEqualTo(setting, value)
  if (setting and setting.value and setting.value ~= value) then
    return true
  else
    return false
  end
end

function Validations.is_number(value)
  return tonumber(value) and true or false
end

local _validations = Validations
return Validations