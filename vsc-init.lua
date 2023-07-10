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
vim.o.ignorecase = true
vim.o.smartcase = true

require("lazy").setup({
	"nvim-lua/plenary.nvim",
	{
		"ggandor/leap.nvim",
		disable = true,
		config = function()
			require("leap").add_default_mappings()
		end,
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
			vim.g.matchup_matchparen_offscreen = {
				-- method = "popup",
			}
		end,
	},
	{
		"gbprod/yanky.nvim",
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
})

local function getVisualSelection()
	local start = vim.fn.getpos("v")
	local finish = vim.fn.getcurpos()
	return start, finish
end

local function exit_visual_mode()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

vim.keymap.set("n", "<space>", ":call VSCodeNotify('vspacecode.space')<CR>")
vim.keymap.set("x", "<space>", function()
	local start, finish = getVisualSelection()
	if vim.fn.visualmode() == "V" then
		vim.fn.VSCodeNotifyRange("vspacecode.space", start[2], finish[2], 1)
	else
		vim.fn.VSCodeNotifyRangePos("vspacecode.space", start[2], finish[2], start[3], finish[3], 1)
	end
	exit_visual_mode()
end)
