local Path = require("plenary.path")

local M = {}

M.find_upwards = function(path, filename)
  local folder = Path:new(path)
  local root = Path.path.root(folder:absolute())

  while true do
    local p = folder:joinpath(filename)
    if p:exists() then
      return p
    end
    if folder:absolute() == root then
      break
    end
    folder = folder:parent()
  end

  return nil
end

return M
