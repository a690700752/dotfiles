local path_utils = require("utils.path")
local Path = require("plenary.path")

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- local neovim_json = require("utils.neovim-json")
      -- neovim_json.load_cfg("conform", opts)

      local p = path_utils.find_upwards(Path:new("."), "biome.json")
      if p then
        opts["formatters_by_ft"]["typescript"] = { "biome" }
        opts["formatters_by_ft"]["typescriptreact"] = { "biome" }
        opts["formatters_by_ft"]["javascript"] = { "biome" }
        opts["formatters_by_ft"]["javascriptreact"] = { "biome" }
      end
    end,
  },
}
