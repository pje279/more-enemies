-- If already defined, return
local Validations = {}
if (_validations) then
  return _validations
end

function Validations.validateNumericSetting(setting, expectedValue)
  if (setting and setting.value
      and setting.value ~= expectedValue) then
    return true
  else
    return false
  end
end

local _validations = Validations
return Validations