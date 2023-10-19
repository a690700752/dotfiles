return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>*", mode = { "n", "v" }, "<cmd>Telescope grep_string<cr>", desc = "Live Grep" },
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
}
