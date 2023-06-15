-- load your globals, autocmds here or anything .__.
vim.cmd("command! ExtractStyles !extract_styles %")
vim.o.guifont = "JetBrainsMono Nerd Font"

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99

vim.defer_fn(function()
	vim.api.nvim_set_hl(0, "Folded", {
		fg = "#5c6370",
		-- bg = "#282c34",
	})
end, 0)

function _G.pprint(...)
	local objects = vim.tbl_map(vim.inspect, { ... })
	print(unpack(objects))
end

---@return 'Windows' | 'OSX'
function _G.get_os()
	return jit.os
end

function _G.get_cfg_path()
	return get_os() == "Windows" and (os.getenv("UserProfile") .. "/AppData/Local/nvim/lua/custom")
		or "~/.config/nvim/lua/custom/"
end

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

vim.o.shell = "/usr/bin/env zsh"
