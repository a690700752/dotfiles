return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local neovim_json = require("utils.neovim-json")
      neovim_json.load_cfg("conform", opts)
    end,
  },
}
