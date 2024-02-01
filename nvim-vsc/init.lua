local vscode = require("vscode-neovim")
vim.notify = vscode.notify
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true

require("lazy").setup({
	"nvim-lua/plenary.nvim",
	{
		"ggandor/leap.nvim",
		enabled = false,
		config = function()
			require("leap").add_default_mappings()
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {
			modes = {
				search = {
					enabled = false,
				},
			},
		},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function()
        vim.api.nvim_feedkeys('l', 'n', true);
        vim.schedule(function()
          vim.defer_fn(function() require("flash").jump() end, 10);
        end);
          -- vim.api.nvim_feedkeys('h', 'n', true);
          --   vim.schedule(function ()
          --   end);
      end, desc = "Flash" },
      -- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
	},
	"tpope/vim-repeat",
	{
		"tpope/vim-surround",
		event = "VeryLazy",
		config = function()
			vim.g["surround_no_mappings"] = 1
			-- Just the defaults copied here.
			vim.keymap.set("n", "ds", "<Plug>Dsurround")
			vim.keymap.set("n", "cs", "<Plug>Csurround")
			vim.keymap.set("n", "cS", "<Plug>CSurround")
			vim.keymap.set("n", "ys", "<Plug>Ysurround")
			vim.keymap.set("n", "yS", "<Plug>YSurround")
			vim.keymap.set("n", "yss", "<Plug>Yssurround")
			vim.keymap.set("n", "ySs", "<Plug>YSsurround")
			vim.keymap.set("n", "ySS", "<Plug>YSsurround")

			-- The conflicting ones. Note that `<Plug>(leap-cross-window)`
			-- _does_ work in Visual mode, if jumping to the same buffer,
			-- so in theory, `gs` could be useful for Leap too...
			vim.keymap.set("x", "gs", "<Plug>VSurround")
			vim.keymap.set("x", "gS", "<Plug>VgSurround")
		end,
	},
	{
		"andymass/vim-matchup",
		enabled = false,
		config = function()
			vim.g.loaded_matchit = 1
			vim.g.matchup_matchparen_enabled = 1
			vim.g.matchup_matchparen_offscreen = {
				-- method = "popup",
			}
			vim.cmd(":hi MatchParen ctermbg=blue guibg=lightblue")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		build = ":TSUpdate",
		opts = {
			highlight = {
				enable = false,
			},
			ensure_installed = {
				"typescript",
				"tsx",
			},
			-- incremental_selection = {
			-- 	enable = true,
			-- 	keymaps = {
			-- 		init_selection = "<CR>",
			-- 		node_incremental = "<CR>",
			-- 	},
			-- },
			-- context_commentstring = {
			-- 	enable = true,
			-- 	enable_autocmd = false,
			-- },
		},
	},
	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		opts = {},
	},
	{
		"chrisgrieser/nvim-recorder",
		event = "VeryLazy",
		opts = {
			mapping = {
				startStopRecording = "Q",
				playMacro = "q",
				switchSlot = "<C-q>",
				-- editMacro = "cq",
				-- yankMacro = "yq",
				-- addBreakPoint = "##", -- ⚠️ this should be a string you don't use in insert mode during a macro
			},
		},
	},
})

local function getVisualSelection()
	local start = vim.fn.getpos("v")
	local finish = vim.fn.getcurpos()
	return start, finish
end

vim.keymap.set("n", "<space>", function()
	vscode.action("vspacecode.space")
end)
vim.keymap.set("n", "<C-N>", function()
	vscode.action("workbench.action.toggleSidebarVisibility")
end)
vim.keymap.set("x", "<space>", function()
	local start, finish = getVisualSelection()
	if vim.fn.mode() == "V" then
		vscode.action("vspacecode.space", {
			range = {
				start[2],
				finish[2],
			},
		})
	else
		vscode.action("vspacecode.space", {
			range = {
				start = {
					line = start[2],
					character = start[3],
				},
				["end"] = {
					line = finish[2],
					character = finish[3],
				},
			},
		})
	end
end)

vim.keymap.set("n", "g;", function()
	vscode.action("workbench.action.navigateToLastEditLocation")
end)
