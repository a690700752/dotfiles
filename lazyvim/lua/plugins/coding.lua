return {
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")

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
}
