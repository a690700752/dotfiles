return {
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    dependencies = {
      -- "nvim-telescope/telescope.nvim", -- optional
      -- "sindrets/diffview.nvim",        -- optional
      -- "ibhagwan/fzf-lua",              -- optional
    },
    config = true,
    keys = {
      { "<leader>gs", "<cmd> :Neogit<cr>", desc = "status" },
    },
  },
}
