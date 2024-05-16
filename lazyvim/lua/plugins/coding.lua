local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      -- local luasnip = require("luasnip")

      opts.mapping["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      opts.mapping["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })
    end,
  },
  {
    "ms-jpq/coq_nvim",
    enabled = false,
    branch = "coq",
    event = "InsertEnter",
    config = function()
      vim.cmd([[
        COQnow -s
        ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
        ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
        ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
        " ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
        ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-n><C-y>" : "\<C-y>") : "\<CR>"
        ino <silent><expr> <C-j>   pumvisible() ? (complete_info().selected == -1 ? "\<C-n><C-n>" : "\<C-n>") : "\<C-j>"
        ino <silent><expr> <C-k>   pumvisible() ? "\<C-p>" : "\<C-k>"
      ]])

      require("coq_3p")({
        { src = "codeium", short_name = "COD" },
      })
      vim.g.coq_settings = {
        keymap = { bigger_preview = "<F13>", recommended = false, jump_to_mark = "<F13>" },
      }
      vim.keymap.set("i", "<Tab>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
    end,
    dependencies = {
      {
        "ms-jpq/coq.artifacts",
        branch = "artifacts",
      },
      {
        "Exafunction/codeium.vim",
      },
      {
        "ms-jpq/coq.thirdparty",
        branch = "3p",
      },
    },
  },
  {
    "echasnovski/mini.comment",
    keys = {
      { "<leader>;", "gcc", remap = true, desc = "Comment Lines" },
      { "<leader>;", "gc", mode = "x", remap = true, desc = "Comment Lines" },
    },
  },
  {
    "Olical/conjure",
    ft = { "clojure", "fennel", "python", "hy" },
    config = function(_, opts)
      require("conjure.main").main()
      require("conjure.mapping")["on-filetype"]()
    end,
    dependencies = {
      {
        "PaterJason/cmp-conjure",
        enabled = false,
        config = function()
          local cmp = require("cmp")
          local config = cmp.get_config()
          table.insert(config.sources, {
            name = "buffer",
            option = {
              sources = {
                { name = "conjure" },
              },
            },
          })
          cmp.setup(config)
        end,
      },
    },
  },
  {
    "gpanders/nvim-parinfer",
    enabled = false,
    ft = { "hy", "clojure" },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    lazy = true,
    cmd = { "Refactor" },
    config = function()
      require("refactoring").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    enabled = false,
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<C-k>", mode = { "i" }, false }
    end,
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        tsserver = {
          init_options = {
            preferences = {
              importModuleSpecifierPreference = "relative",
              importModuleSpecifierEnding = "minimal",
            },
          },
        },
      },
    },
  },
}
