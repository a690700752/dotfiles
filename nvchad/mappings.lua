---@type MappingsTable
local M = {}

local function get_cfg_path()
	return jit.os == "Windows" and (os.getenv("UserProfile") .. "/AppData/Local/nvim/lua/custom")
		or "~/.config/nvim/lua/custom/"
end

M.disabled = {
	n = {
		["<leader>/"] = {},
		["<leader>h"] = {},
		["<leader>v"] = {},
		["<TAB>"] = {},
		["<S-Tab>"] = {},
	},

	v = {
		["<leader>/"] = {},
	},
}

M.comment = {
	-- toggle comment in both modes
	n = {
		["<leader>;"] = {
			function()
				require("Comment.api").toggle.linewise.current()
			end,
			"toggle comment",
		},
	},

	v = {
		["<leader>;"] = {
			"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
			"toggle comment",
		},
	},
}

M.telescope = {
	n = {
		["<leader>pf"] = { "<cmd> :Telescope find_files<cr>", "find files" },
		["<leader>pp"] = { "<cmd> :Telescope possession list<cr>", "sessions" },
		["<leader>ff"] = { "<cmd> :Telescope file_browser path=%:p:h<cr>", "file tree" },
		["<leader>bb"] = {
			"<cmd> :lua require'telescope.builtin'.buffers{ show_all_buffers = true, sort_mru = true }<cr>",
			"buffers",
		},
		["<leader>/"] = { "<cmd> :Telescope live_grep<cr>", "search project" },
		["<leader>?"] = { "<cmd> :Telescope resume<cr>", "search project" },
		["<leader>*"] = { "<cmd> :Telescope grep_string<cr>", "search project" },
		["<leader>x."] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "code action" },
		["<leader>ss"] = { "<cmd> :Telescope current_buffer_fuzzy_find<cr>", "search buffer" },
		["<leader>sj"] = { "<cmd> :Telescope lsp_document_symbols<cr>", "search symbols" },
	},
	v = {
		["<leader>*"] = { "<cmd> :Telescope grep_string<cr>", "search project" },
	},
}

M.normal = {
	n = {
		["<leader><leader>"] = { "<cmd> :Telescope commands<cr>", "commands" },
		["<leader><tab>"] = { "<cmd> :b#<cr>", "last buffer" },

		["<leader>Tb"] = { "<cmd> :NvimTreeToggle<cr>", "file tree" },

		["<leader>w-"] = { "<cmd> :split<cr>", "hsplit" },
		["<leader>w/"] = { "<cmd> :vs<cr>", "vsplit" },

		["<leader>j="] = { "<cmd>lua vim.lsp.buf.format()<cr>", "format" },

		["<leader>fed"] = { "<cmd> :e " .. get_cfg_path() .. "/chadrc.lua<cr>", "edit config" },
		["<leader>fs"] = { "<cmd> :w<cr>", "save" },
		["<leader>fS"] = { "<cmd> :wa<cr>", "save all" },

		["<leader>bd"] = { "<cmd> :bd<cr>", "close buffer" },

		["<leader>gs"] = { "<cmd> :Neogit<cr>", "status" },

		["<leader>'"] = { '<cmd>lua require("nvterm.terminal").toggle "float"<cr>', "terminal" },

		["<leader>xr"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "rename" },

		["<leader>ee"] = { "<cmd>lua vim.diagnostic.open_float()<cr>", "show error" },
		["<leader>en"] = {
			function()
				vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
			end,
			"next error",
		},
		["<leader>ep"] = {
			function()
				vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
			end,
			"previous error",
		},
		["<leader>el"] = { "<cmd>:Telescope diagnostics<cr>", "list diagnostics" },

		["g;"] = { "`Mzz", "jump modify position" },

		["<leader>oe"] = { require("custom/eval_iron").eval_block, "eval block" },
		["s"] = { "<cmd> :HopWord<cr>", "Go to word" },
	},
	v = {
		["s"] = { "<cmd> :HopWord<cr>", "Go to word" },
	},
	t = {
		["<ESC>"] = { '<cmd>lua require("nvterm.terminal").toggle "float"<cr>', "terminal" },
	},
	i = {
		["jk"] = { "<Esc>", "exit insert mode" },
	},
}

vim.cmd("cmap w!! w !sudo tee > /dev/null %")

return M
