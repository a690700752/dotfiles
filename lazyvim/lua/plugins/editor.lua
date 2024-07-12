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

  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.defaults["<leader><tab>"] = nil
    end,
  },

  "LunarVim/bigfile.nvim",

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

  {
    "echasnovski/mini.surround",
    -- keys = function(_, keys)
    --   keys[1] = {
    --     "S",
    --     [[:<C-u>lua MiniSurround.add('visual')<CR>]],
    --     desc = "Add surrounding",
    --     mode = { "x" },
    --   }
    -- end,
    opts = {
      mappings = {
        add = "S",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
        -- add = "ms",
        -- delete = "md",
        -- find = "",
        -- find_left = "",
        -- highlight = "",
        -- replace = "mr",
        -- update_n_lines = "",
      },
    },
  },

  {
    "folke/flash.nvim",
    keys = {
      { "S", mode = { "x" }, false },
      -- { "s", false },
    },
    opts = {
      modes = {
        search = {
          enabled = false,
        },
      },
    },
  },
}
