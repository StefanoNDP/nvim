return {
  "gbprod/yanky.nvim",
  -- dependencies = {
  --   { "kkharji/sqlite.lua" },
  -- },
  enabled = true,
  version = false,
  desc = "Better Yank/Paste",
  event = "VeryLazy",
  opts = {
    preserve_cursor_position = { enabled = true },
    -- ring = { storage = "sqlite" },
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 150,
    },
    textobj = { enabled = true },
    system_clipboard = {
      sync_with_ring = true,
      clipboard_register = true,
    },
  },
  keys = require("config.keymaps.yank"),
}
