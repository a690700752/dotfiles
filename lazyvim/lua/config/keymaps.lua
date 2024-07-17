-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del("n", "<leader><tab>l")
vim.keymap.del("n", "<leader><tab>f")
vim.keymap.del("n", "<leader><tab><tab>")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.del("n", "<leader><tab>d")
vim.keymap.del("n", "<leader><tab>[")
vim.keymap.del("n", "<leader><tab>o")

local map = vim.keymap.set

map("i", "jk", "<Esc>")
map("n", "<leader>w/", "<C-W>v", { desc = "Split window right", remap = true })
-- map("n", "<leader>ee", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Show Error" })
-- map("n", "<leader>en", function()
--   local nextError = vim.diagnostic.get_next({
--     severity = vim.diagnostic.severity.ERROR,
--   })
--   if nextError then
--     vim.diagnostic.goto_next({
--       severity = vim.diagnostic.severity.ERROR,
--     })
--   else
--     vim.diagnostic.goto_next()
--   end
-- end, { desc = "Next Error" })
map("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>fS", "<cmd>wa<cr>", { desc = "Save All" })
map("n", "<leader><tab>", "<cmd>e #<cr>", { desc = "Last Buffer" })
map("n", "<leader>'", "<leader>fT", { desc = "Terminal (cwd)", remap = true })
-- map("n", "<leader>xr", function()
--   vim.lsp.buf.rename()
-- end, { desc = "Rename" })
map("n", "<leader>xr", ":IncRename ", { desc = "Rename" })

map("n", "<leader>xi", "<leader>co", { desc = "Orgnize Imports", remap = true })

map("n", "<leader>x.", function()
  vim.lsp.buf.code_action()
end, { desc = "Code Action" })

map("n", "g;", "`Mzz", { desc = "Jump Modify Position" })

map("n", "<leader>pp", "<leader>fp", { desc = "Projects", remap = true })

vim.api.nvim_create_user_command("MdNumberSection", function()
  vim.cmd("w")
  vim.cmd("!md-number-section %")
end, {})

vim.api.nvim_create_user_command("TsxExtractStyles", function()
  vim.cmd("w")
  vim.cmd("!tsx-extract-styles %")
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

vim.api.nvim_create_user_command("CocRefactor", function()
  vim.fn.CocActionAsync("codeAction", vim.fn.visualmode(), { "refactor" }, true)
end, { range = true })

vim.api.nvim_create_user_command("CopyAbsolutePath", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, {})

vim.api.nvim_create_user_command("CopyRelativePath", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
end, {})

-- local exec_selection = function(args)
--   -- Use args.line1 and args.line2 to get the selected range
--   local line_start, line_end = args.line1, args.line2
--   -- Read the selected lines as Lua code
--   local lines = vim.api.nvim_buf_get_lines(0, line_start - 1, line_end, false)
--   local code = table.concat(lines, "\n")
--
--   -- Execute the code in the Lua environment of Neovim
--   local result = loadstring(code)()
--
--   -- If the code has returned a result, print it
--   if result then
--     print(result)
--   end
-- end
--
-- vim.api.nvim_create_user_command("ExecSelection", exec_selection, { range = true })

vim.api.nvim_create_user_command("InsertOutput", require("config/shell_command").run_shell_command, {})
