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
		opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      -- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
	},
	"tpope/vim-repeat",
	{
		"tpope/vim-surround",
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
		"gbprod/yanky.nvim",
		enabled = false,
		config = function()
			require("yanky").setup({})
			vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
			vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
			vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
			vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
			vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
			vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"vim",
					"typescript",
					"org",
					"tsx",
				},
				-- context_commentstring = {
				-- 	enable = true,
				-- 	enable_autocmd = false,
				-- },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						node_incremental = "<CR>",
					},
				},
			})
		end,
	},
})

local function getVisualSelection()
	local start = vim.fn.getpos("v")
	local finish = vim.fn.getcurpos()
	return start, finish
end

vim.keymap.set("n", "<space>", ":call VSCodeNotify('vspacecode.space')<CR>")
vim.keymap.set("x", "<space>", function()
	local start, finish = getVisualSelection()
	if vim.fn.mode() == "V" then
		require("vscode-neovim").notify_range("vspacecode.space", start[2], finish[2], 1)
	else
		require("vscode-neovim").notify_range_pos("vspacecode.space", start[2], finish[2], start[3], finish[3], 1)
	end
end)

vim.keymap.set("n", "g;", function()
	vim.fn.VSCodeNotify("workbench.action.navigateToLastEditLocation")
end)
