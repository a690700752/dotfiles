-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del("n", "<leader><tab>l")
vim.keymap.del("n", "<leader><tab>f")
vim.keymap.del("n", "<leader><tab><tab>")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.del("n", "<leader><tab>d")
vim.keymap.del("n", "<leader><tab>[")

local map = vim.keymap.set

map("i", "jk", "<Esc>")
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

vim.api.nvim_create_user_command("MdNumberSection", function()
  vim.cmd("w")
  vim.cmd("!md-number-section %")
end, {})

vim.api.nvim_create_user_command("TsxExtractStyles", function()
  vim.cmd("w")
  vim.cmd("!tsx-extract_styles %")
end, {})
