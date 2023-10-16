return {
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
    event = "VeryLazy",
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
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "org",
      })
    end,
  },
}
