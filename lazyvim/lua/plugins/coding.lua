local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      -- local luasnip = require("luasnip")

      opts.mapping["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      opts.mapping["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      -- opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
      --   -- local copilot_keys = vim.fn["codeium#Accept"]()
      --   -- local copilot_keys = ''
      --   -- if copilot_keys ~= "" and type(copilot_keys) == "string" then
      --   -- vim.api.nvim_feedkeys(copilot_keys, "i", true)
      --
      --   local codeium_status = vim.fn["codeium#GetStatusString"]()
      --   if string.find(codeium_status, "/") then
      --     vim.api.nvim_feedkeys(vim.fn["codeium#Accept"](), "i", true)
      --   elseif cmp.visible() then
      --     cmp.select_next_item()
      --   -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
      --   -- that way you will only jump inside the snippet region
      --   elseif luasnip.expand_or_jumpable() then
      --     luasnip.expand_or_jump()
      --   elseif has_words_before() then
      --     cmp.complete()
      --   else
      --     fallback()
      --   end
      -- end, {
      --   "i",
      --   "s",
      -- })
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
    "Olical/conjure",
    ft = { "clojure", "fennel", "python", "hy" },
    config = function(_, opts)
      require("conjure.main").main()
      require("conjure.mapping")["on-filetype"]()
    end,
    dependencies = {
      {
        "PaterJason/cmp-conjure",
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
    ft = { "hy" },
  },
}
