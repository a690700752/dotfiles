return {
  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    config = function() end,
    init = function()
      vim.g.codeium_disable_bindings = 1
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 2, function()
        return vim.fn["codeium#GetStatusString"]()
      end)
    end,
  },
}
