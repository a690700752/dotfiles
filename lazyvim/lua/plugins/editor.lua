return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        path_display = { "truncate" },
        mappings = {
          i = {
            ["<C-j>"] = {
              require("telescope.actions").move_selection_next,
              type = "action",
              opts = { nowait = true, silent = true },
            },
            ["<C-k>"] = {
              require("telescope.actions").move_selection_previous,
              type = "action",
              opts = { nowait = true, silent = true },
            },
          },
        },
      },
    },
    keys = {
      { "<leader>*", mode = { "n", "v" }, "<cmd>Telescope grep_string<cr>", desc = "Live Grep" },
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep (cwd)" },
      { "<leader>?", "<cmd>Telescope resume<cr>", desc = "Telescope Resume" },
      { "<leader><space>", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>pf", "<cmd>Telescope find_files<cr>", "Find Files" },
      {
        "<leader>bb",
        function()
          require("telescope.builtin").buffers({ show_all_buffers = true, sort_mru = true })
        end,
        desc = "Buffers",
      },
      { "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      {
        "<leader>sj",
        function()
          require("telescope.builtin").lsp_document_symbols({
            symbols = require("lazyvim.config").get_kind_filter(),
          })
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>gs",
        false,
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
      { "<C-N>", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    },
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.defaults["<leader><tab>"] = nil
    end,
  },
  {
    "chrisgrieser/nvim-recorder",
    event = "VeryLazy",
    opts = {
      mapping = {
        startStopRecording = "Q",
        playMacro = "q",
        switchSlot = "<C-q>",
        -- editMacro = "cq",
        -- yankMacro = "yq",
        -- addBreakPoint = "##", -- ⚠️ this should be a string you don't use in insert mode during a macro
      },
    },
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
    keys = function(_, keys)
      keys[1] = {
        "S",
        [[:<C-u>lua MiniSurround.add('visual')<CR>]],
        desc = "Add surrounding",
        mode = { "x" },
      }
    end,
    opts = {
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
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
  {
    "keaising/im-select.nvim",
    event = "VeryLazy",
    config = function()
      require("im_select").setup({})
    end,
  },
  {
    "cshuaimin/ssr.nvim",
    event = "VeryLazy",
  },
}
