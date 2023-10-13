local M = {}

local function split_path(path)
  local keys = {}
  for key in string.gmatch(path, "[^%.]+") do
    table.insert(keys, key)
  end
  return keys
end

local function set_value(obj, keys, value)
  local key = table.remove(keys, 1)
  if #keys == 0 then
    obj[key] = value
  else
    if not obj[key] then
      obj[key] = {}
    end
    set_value(obj[key], keys, value)
  end
end

M.set = function(obj, path, value)
  local keys = split_path(path)
  set_value(obj, keys, value)
end

return M
