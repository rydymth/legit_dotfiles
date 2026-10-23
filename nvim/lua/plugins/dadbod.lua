return {
  { "tpope/vim-dadbod", cmd = "DB" },
  { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = { { "<leader>db", "<cmd>DBUIToggle<cr>", desc = "Database UI" } },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 0
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod"
    end,
  },
}
