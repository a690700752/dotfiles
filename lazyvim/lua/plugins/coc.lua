-- Autocomplete
function _G.check_back_space()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

-- Use K to show documentation in preview window
function _G.show_docs()
  local cw = vim.fn.expand("<cword>")
  if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
    vim.api.nvim_command("h " .. cw)
  elseif vim.api.nvim_eval("coc#rpc#ready()") then
    vim.fn.CocActionAsync("doHover")
  else
    vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
  end
end

return {
  {
    "neoclide/coc.nvim",
    branch = "release",
    event = "LazyFile",
    config = function()
      -- Always show the signcolumn, otherwise it would shift the text each time
      -- diagnostics appeared/became resolved
      vim.opt.signcolumn = "yes"

      local keyset = vim.keymap.set
      -- Use Tab for trigger completion with characters ahead and navigate
      -- NOTE: There's always a completion item selected by default, you may want to enable
      -- no select by setting `"suggest.noselect": true` in your configuration file
      -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
      -- other plugins before putting this into your config
      local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
      keyset(
        "i",
        "<C-j>",
        'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<c-j>" : coc#refresh()',
        opts
      )
      keyset("i", "<C-k>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-k>"]], opts)

      -- Make <CR> to accept selected completion item or notify coc.nvim to format
      -- <C-g>u breaks current undo, please make your own choice
      keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

      -- Use `[g` and `]g` to navigate diagnostics
      -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
      keyset("n", "<leader>ee", "<Plug>(coc-diagnostic-prev-error)", { silent = true })
      keyset("n", "<leader>en", "<Plug>(coc-diagnostic-next-error)", { silent = true })

      -- GoTo code navigation
      keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
      keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
      keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
      keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

      keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })

      -- Symbol renaming
      keyset("n", "<leader>xr", "<Plug>(coc-rename)", { silent = true })

      -- actions
      keyset("n", "<leader>x.", "<Plug>(coc-codeaction-cursor)", { silent = true })

      vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 2, function()
        return vim.fn["coc#status"]()
      end)
    end,
  },
}
