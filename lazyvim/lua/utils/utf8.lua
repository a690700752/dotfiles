local M = {}

local tableUtils = require("utils.table")

M.new = function(s)
  local utf8 = require("utf8")
  local utf8Idx = 0
  local arr = {}
  for i, c in utf8.codes(s) do
    table.insert(arr, {
      byteIdx = i,
      idx = utf8Idx,
      c = c,
    })
    utf8Idx = utf8Idx + 1
  end
  return arr
end

M.get = function(utf8, idx)
  local res = tableUtils.find(utf8, function(v, i)
    return v.idx == idx
  end)
  if res then
    return res.c
  end
  return nil
end

M.byteIdx2Idx = function(utf8, byteIdx)
  local res = tableUtils.find(utf8, function(v, i)
    return byteIdx >= v.byteIdx and byteIdx < v.byteIdx + #v.c
  end)
  if res then
    return res.idx
  end
  return nil
end

return M
