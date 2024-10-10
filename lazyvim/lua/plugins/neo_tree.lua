return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
      {
        "<leader>ft",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
    },
  },
}
