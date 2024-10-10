return {
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
}
