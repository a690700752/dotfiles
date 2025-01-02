return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap["<C-j>"] = { "select_next", "fallback" }
      opts.keymap["<C-k>"] = { "select_prev", "fallback" }
    end,
  },
}
