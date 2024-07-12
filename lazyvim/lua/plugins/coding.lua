return {
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      -- local luasnip = require("luasnip")

      opts.mapping["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      opts.mapping["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })
    end,
  },
  {
    "echasnovski/mini.comment",
    keys = {
      { "<leader>;", "gcc", remap = true, desc = "Comment Lines" },
      { "<leader>;", "gc", mode = "x", remap = true, desc = "Comment Lines" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<C-k>", mode = { "i" }, false }
    end,
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver = {
        --   init_options = {
        --     preferences = {
        --       importModuleSpecifierPreference = "relative",
        --       importModuleSpecifierEnding = "minimal",
        --     },
        --   },
        -- },
        vtsls = {
          settings = {
            typescript = {
              preferences = {
                importModuleSpecifier = "relative",
                importModuleSpecifierEnding = "minimal",
              },
            },
          },
        },
      },
    },
  },
}
