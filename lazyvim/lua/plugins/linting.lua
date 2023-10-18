return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local neovim_json = require("utils.neovim-json")
      neovim_json.load_cfg("lint", opts)

      -- local dump = require("utils.dump")
      -- print(dump.dump(opts))
    end,
  },
}
