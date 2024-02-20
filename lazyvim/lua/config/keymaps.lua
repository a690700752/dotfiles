-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.g.maplocalleader = ","

vim.keymap.del("n", "<leader><tab>l")
vim.keymap.del("n", "<leader><tab>f")
vim.keymap.del("n", "<leader><tab><tab>")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.del("n", "<leader><tab>d")
vim.keymap.del("n", "<leader><tab>[")

local map = vim.keymap.set

map("i", "jk", "<Esc>")
map("n", "<leader>ee", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Show Error" })
map("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>fS", "<cmd>wa<cr>", { desc = "Save All" })
map("n", "<leader><tab>", "<cmd>e #<cr>", { desc = "Last Buffer" })
map("n", "<leader>'", "<leader>fT", { desc = "Terminal (cwd)", remap = true })
map("n", "<leader>xr", function()
  vim.lsp.buf.rename()
end, { desc = "Rename" })
map("n", "<leader>x.", function()
  vim.lsp.buf.code_action()
end, { desc = "Code Action" })
map("n", "g;", "`Mzz", { desc = "Jump Modify Position" })

map("n", "vir", "vi(", { desc = "Balanced (" })
map("n", "var", "va(", { desc = "Balanced (" })

map("n", "vic", "vi{", { desc = "Balanced {" })
map("n", "vac", "va{", { desc = "Balanced {" })

map("n", "vig", 'vi"', { desc = "Balanced string" })
map("n", "vag", 'va"', { desc = "Balanced string" })

vim.api.nvim_create_user_command("MdNumberSection", function()
  vim.cmd("w")
  vim.cmd("!md-number-section %")
end, {})

vim.api.nvim_create_user_command("TsxExtractStyles", function()
  vim.cmd("w")
  vim.cmd("!tsx-extract_styles %")
end, {})

vim.api.nvim_create_user_command("FileInFolder", function(tbl)
  -- call Telescope find_files with a custom cwd
  require("telescope.builtin").find_files({
    cwd = tbl.args,
    hidden = true,
    no_ignore = true,
  })
end, {
  nargs = 1,
  complete = "file",
})

vim.api.nvim_create_user_command("GrepInFolder", function(tbl)
  -- call Telescope live_grep with a custom cwd
  require("telescope.builtin").live_grep({
    cwd = tbl.args,
    hidden = true,
    no_ignore = true,
  })
end, {
  nargs = 1,
  complete = "file",
})
