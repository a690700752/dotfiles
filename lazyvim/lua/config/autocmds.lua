-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function registerLastModify()
  vim.api.nvim_create_augroup("last_modify_pos", {
    clear = true,
  })

  local insertEnterFileType

  vim.api.nvim_create_autocmd("InsertEnter", {
    group = "last_modify_pos",
    pattern = "*",
    callback = function()
      insertEnterFileType = vim.bo.filetype
    end,
  })

  vim.api.nvim_create_autocmd("InsertLeave", {
    group = "last_modify_pos",
    pattern = "*",
    callback = function()
      if insertEnterFileType ~= "TelescopePrompt" then
        vim.cmd("normal! mM")
      end
    end,
  })
end

registerLastModify()

vim.cmd("hi FlashLabel guifg=#ffffff")

vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
    end
  end,
})

-- local function switch_input_method()
--   local cur_pos = vim.api.nvim_win_get_cursor(0)
--   local line = vim.api.nvim_get_current_line()
--   local col = cur_pos[2]
--   if col > 0 and col <= #line then
--     local utf8 = require("utils.utf8")
--     local lineUtf8 = utf8.new(line)
--     local utf8Idx = utf8.byteIdx2Idx(lineUtf8, col)
--     local left_char = utf8.get(lineUtf8, utf8Idx)
--     local right_char = utf8.get(lineUtf8, utf8Idx + 1)
--     if (left_char ~= nil and #left_char > 1) or (right_char ~= nil and #right_char > 1) then
--       -- print("zh")
--       io.popen("macism com.apple.inputmethod.SCIM.ITABC")
--     else
--       -- print("en")
--       io.popen("macism com.apple.keylayout.ABC")
--     end
--   end
-- end
--
-- vim.api.nvim_create_autocmd("InsertEnter", {
--   callback = function()
--     switch_input_method()
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("InsertLeave", {
--   callback = function()
--     io.popen("macism com.apple.keylayout.ABC")
--   end,
-- })
