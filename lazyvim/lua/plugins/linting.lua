return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local neovim_json = require("utils.neovim-json")
      local dump = require("utils.dump")
      neovim_json.load_cfg("lint", opts)
      -- print(dump.dump(opts))
    end,
  },
}
