-- Just an example, supposed to be placed in /lua/custom/

-- remove this if you dont use custom.init.lua at all
-- require("custom")

---@type ChadrcConfig
local M = {}

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

M.ui = {
	theme = "everforest_light",
}

M.mappings = require("custom.mappings")

M.plugins = "custom.plugins"

return M
