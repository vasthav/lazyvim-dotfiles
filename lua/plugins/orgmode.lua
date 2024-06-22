return {
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      require("orgmode").setup_ts_grammar()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "org" },
        },
        ensure_installed = { "org" }, -- Or run :TSUpdate org
      })
      require("orgmode").setup({
        org_agenda_files = { "~/orgfiles/**/*" },
        org_default_notes_file = "~/orgfiles/refile.org",
        org_todo_keywords = { "TODO(t)", "|", "DONE(d)" },
        org_capture_templates = {
          t = {
            description = "Todo",
            template = "* TODO %?\n%U",
            target = "~/orgfiles/todo.org",
          },
          j = {
            description = "Journal",
            template = "\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?",
            target = "~/orgfiles/journal.org",
          },
          n = {
            description = "Notes",
            template = "* %?\n %u",
            target = "~/orgfiles/notes.org",
          },
        },
      })
    end,
  },
}
