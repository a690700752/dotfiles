---@type NvPluginSpec[]
local plugins = {
	{
		"nvim-telescope/telescope-file-browser.nvim",
		after = "telescope.nvim",
		config = function()
			require("telescope").load_extension("file_browser")
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		after = "telescope.nvim",
		config = function()
			require("telescope").load_extension("ui-select")
		end,
	},
	{ "gpanders/editorconfig.nvim" },
	{ "tpope/vim-surround" },
	{
		"github/copilot.vim",
		enabled = false,
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_tab_fallback = ""
		end,
	},
	{ "TimUntersberger/neogit" },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},
	{
		"hkupty/iron.nvim",
		config = function()
			local iron = require("iron.core")
			local view = require("iron.view")

			iron.setup({
				config = {
					-- If iron should expose `<plug>(...)` mappings for the plugins
					should_map_plug = false,
					-- Whether a repl should be discarded or not
					scratch_repl = true,
					repl_definition = {
						sh = {
							command = { "bash" },
						},
						typescript = {
							format = function(lines)
								print("called")
								for idx, line in ipairs(lines) do
									lines[idx] = line:gsub("export function", "function")
								end
								return lines
							end,
							command = { "ts-node", "--skipProject" },
							open = ".editor\n",
							close = "\04",
						},
					},
					-- Your repl definitions come here
					repl_open_cmd = view.split.vertical("40%"),
					-- how the REPL window will be opened, the default is opening
					-- a float window of height 40 at the bottom.
				},
				-- Iron doesn't set keymaps by default anymore. Set them here
				-- or use `should_map_plug = true` and map from you vim files
				keymaps = {
					-- send_motion = "<space><enter>",
					visual_send = "<leader>oe",
					-- send_file = "<space>sf",
					-- send_line = "<space>sl",
					-- send_mark = "<space>sm",
					-- mark_motion = "<space>mc",
					-- mark_visual = "<space>mc",
					-- remove_mark = "<space>md",
					-- cr = "<space>s<cr>",
					-- interrupt = "<space>s<space>",
					-- exit = "<space>sq",
					-- clear = "<space>cl",
				},
			})
		end,
	},
	{
		"nvim-orgmode/orgmode",
		config = function()
			require("orgmode").setup_ts_grammar()
			require("orgmode").setup({
				org_agenda_files = { "~/prj/note/orgs/*" },
				org_default_notes_file = "~/prj/note/orgs/refile.org",
				org_todo_keywords = { "TODO", "WAIT", "|", "DONE", "CANCELED" },
				org_capture_templates = {
					t = {
						description = "Task",
						template = "* %?\n %U",
						target = "~/prj/note/orgs/gtd.org",
						headline = "INBOX",
					},
				},
				mappings = {
					prefix = "<leader>a",
				},
			})
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
		"nvim-telescope/telescope.nvim",
		opts = {
			defaults = {
				mappings = {
					i = {
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
					},
				},
			},
		},
	},
	{
		"hrsh7th/nvim-cmp",
		opts = function()
			local cmp = require("cmp")
			return {
				mapping = {
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					-- ["<CR>"] = cmp.mapping(function(fallback)
					--   fallback()
					-- end),
					-- ["<Tab>"] = cmp.mapping(function(fallback)
					--   local copilot_keys = vim.fn["copilot#Accept"]()
					--   -- local copilot_keys = ''
					--   if copilot_keys ~= "" and type(copilot_keys) == "string" then
					--     vim.api.nvim_feedkeys(copilot_keys, "i", true)
					--   elseif cmp.visible() then
					--     cmp.select_next_item()
					--   elseif require("luasnip").expand_or_jumpable() then
					--     vim.fn.feedkeys(
					--       vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
					--       ""
					--     )
					--   else
					--     fallback()
					--   end
					-- end, {
					--   "i",
					--   "s",
					-- }),
				},
				sources = {
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "nvim_lua" },
					{ name = "path" },
					{ name = "orgmode" },
				},
			}
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"lua",
				"vim",
				"typescript",
				"org",
				"tsx",
			},
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
		},
	},
	{ "JoosepAlviste/nvim-ts-context-commentstring" },
	{
		"numToStr/Comment.nvim",
		opts = function()
			return {
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			}
		end,
	},
	{
		"rmagatti/auto-session",
		enable = false,
		config = function()
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
			require("auto-session").setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			})
		end,
	},
	{
		"aserowy/tmux.nvim",
		config = function()
			require("tmux").setup({
				copy_sync = {
					enable = false,
				},
				navigation = {
					-- cycles to opposite pane while navigating into the border
					cycle_navigation = false,
					-- enables default keybindings (C-hjkl) for normal mode
					enable_default_keybindings = true,
					-- prevents unzoom tmux when navigating beyond vim border
					persist_zoom = true,
				},
			})
		end,
	},
	{ "David-Kunz/jester" },
	{ "tpope/vim-repeat" },
	{
		"ggandor/leap.nvim",
		enabled = false,
		config = function()
			require("leap").add_default_mappings()
		end,
	},
	{ "stevearc/dressing.nvim" },
	{ "gennaro-tedesco/nvim-peekup" },
	{
		"phaazon/hop.nvim",
		config = function()
			require("hop").setup()
		end,
	},
	{
		"lukas-reineke/headlines.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = true, -- or `opts = {}`
		enabled = false,
	},
}

-- add lazy false to each item
for _, plugin in ipairs(plugins) do
	plugin["lazy"] = false
end

return plugins
