local M = {}

M.find = function(t, func)
  for i, v in ipairs(t) do
    if func(v, i) then
      return v
    end
  end
end

return M
