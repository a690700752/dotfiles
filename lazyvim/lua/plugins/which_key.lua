return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.defaults["<leader><tab>"] = nil
    end,
  },
}
