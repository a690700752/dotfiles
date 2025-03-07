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

-- 创建一个自动命令组来管理自动命令
local group = vim.api.nvim_create_augroup("MarkdownSettings", { clear = true })

-- 当文件类型是 markdown 时，设置 nowrap
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  group = group,
  callback = function()
    vim.wo.wrap = false
  end,
})
