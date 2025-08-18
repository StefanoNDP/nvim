return {
  {
    "Kurren123/mssql.nvim",
    enabled = true,
    version = false,
    opts = {
      keymap_prefix = "<leader>m",
    },
    dependencies = { "folke/which-key.nvim" },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    enabled = true,
    version = false,
    ft = { "sql", "mysql", "plsql" },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = {
      {
        "tpope/vim-dadbod",
        cmd = "DB",
        lazy = true,
        ft = { "sql", "mysql", "plsql" },
      },
      {
        "kristijanhusak/vim-dadbod-completion",
        lazy = true,
        ft = { "sql", "mysql", "plsql" },
      },
    },
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
    },
    init = function()
      local data_path = vim.fn.stdpath("data")

      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true

      vim.g.dbs = {
        StefanoDB = "sqlserver://NBStefano01\\SQLEXPRESS/StefanoDB?ODBC+Driver+21+for+SQL+Server",
      }

      -- NOTE: The default behavior of auto-execution of queries on save is disabled
      -- this is useful when you have a big query that you don't want to run every time
      -- you save the file running those queries can crash neovim to run use the
      -- default keymap: <leader>S
      vim.g.db_ui_execute_on_save = false
    end,
  },
}

-- For connecting to M$SQL Server using Dadbod/Dadbod-ui:
-- sqlserver://PCNAME\INSTANCENAME/DBNAME?ODBC+Driver+xx+for+SQL+Server
-- PCNAME: Windows, go to Settings (Win + i) -> System -> About -> Device Name
--    DESKTOP-XXXXX Is usually the default one
-- INSTANCENAME: The Instance Name you used when setting up a SQL Server
--    MSSQLSERVER if you chose "Default instance"
--    YOUR_INSTANCE_NAME if you chose "Named instance"
-- xx: Current Intalled/Used SQL Server Management Studio
--    17 for 2017
--    19 for 2019
--    21 for 2021
--
-- Ex: sqlserver://DESKTOP-asdasd123\MSSQLSERVER/MyAwesomeDB?ODBC+Driver+21+for+SQL+Server
--
-- For MSSQL
-- Create a "connections.json" at the root of your project with at least
-- the following info:
-- CONNECTION_NAME: can be whatever you want
-- server: usually localhost unless it's somewhere else
-- authenticationType: SqlLogin unelss you used Windows Auth
--    user: must be su unless you changed it or is using Windows Auth
--    Password: is the one you created when setting up the SQL server or is using Windows Auth
-- "initialCatalog": database name,
--
-- {
--   "CONNECTION_NAME": {
--     "server": "localhost",
--     "database": "dbA",
--     "authenticationType": "SqlLogin",
--     "user": "sa",
--     "password": "YOURPASSWORD",
--     "dataSource": "DESKTOP-asdasd123\\MSSQLSERVER",
--     "initialCatalog": "MyAwesomeDB",
--     "persistSecurityInfo": true,
--     "pooling": false,
--     "encrypt": true,
--     "trustServerCertificate": true
--   }
-- }
