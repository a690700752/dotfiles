return {
  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
    config = function()
      require("scratch").setup({
        filetypes = { "lua", "js", "sh", "ts", "json" },
      })
    end,
  },
}
