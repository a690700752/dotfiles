return {
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
