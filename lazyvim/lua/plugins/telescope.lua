return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
    opts = function(_, opts)
      LazyVim.on_load("telescope.nvim", function()
        require("telescope").load_extension("live_grep_args")
      end)

      local lga_actions = require("telescope-live-grep-args.actions")

      return vim.tbl_deep_extend("force", opts, {
        defaults = {
          path_display = { "truncate" },
          extensions = {
            live_grep_args = {
              auto_quoting = true, -- enable/disable auto-quoting
              -- define mappings, e.g.
              mappings = { -- extend mappings
                i = {
                  -- ["<C-k>"] = lga_actions.quote_prompt(),
                  -- ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                  -- -- freeze the current list and start a fuzzy search in the frozen list
                  -- ["<C-space>"] = lga_actions.to_fuzzy_refine,
                },
              },
              -- ... also accepts theme settings, for example:
              -- theme = "dropdown", -- use dropdown theme
              -- theme = { }, -- use own theme spec
              -- layout_config = { mirror=true }, -- mirror preview pane
            },
          },
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
      })
    end,
    keys = {
      { "<leader>*", mode = { "n", "v" }, "<cmd>Telescope grep_string<cr>", desc = "Live Grep" },
      {
        "<leader>*",
        mode = { "n", "v" },
        function()
          require("telescope-live-grep-args.shortcuts").grep_word_under_cursor()
        end,
        desc = "Live Grep",
      },
      -- { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep (cwd)" },
      { "<leader>/", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", desc = "Grep (cwd)" },
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
}
