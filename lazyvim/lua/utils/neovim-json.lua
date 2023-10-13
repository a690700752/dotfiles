local M = {}
local path_utils = require("utils.path")
local Path = require("plenary.path")
local object_path = require("utils.object-path")

M.load_cfg = function(plugin_name, opts)
  local p = path_utils.find_upwards(Path:new("."), ".neovim.json")
  if not p then
    return
  end
  local conf = vim.json.decode(p:read())
  if not conf then
    return
  end
  local tmp = {
    [plugin_name] = opts,
  }

  local prefix = plugin_name .. "."
  for k, v in pairs(conf) do
    if string.sub(k, 1, #prefix) == prefix then
      object_path.set(tmp, k, v)
    end
  end
end

return M
