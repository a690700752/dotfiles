local M = {}

-- 提示用户输入 shell 指令
function M.run_shell_command()
  vim.ui.input({ prompt = "请输入 shell 指令: " }, function(input)
    if input then
      -- 执行用户输入的 shell 指令，并获取输出
      local handle = io.popen(input)
      local result = handle:read("*a")
      handle:close()

      -- 获取当前光标位置
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))

      -- 按行分割结果
      local lines = {}
      for s in result:gmatch("[^\r\n]+") do
        table.insert(lines, s)
      end

      -- 将结果插入到当前光标位置
      vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, lines)
    end
  end)
end

return M
