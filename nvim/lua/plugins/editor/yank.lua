return {
  "gbprod/yanky.nvim",
  dependencies = {
    { "kkharji/sqlite.lua" },
  },
  enabled = true,
  version = false,
  desc = "Better Yank/Paste",
  event = "VeryLazy",
  opts = {
    ring = { storage = "sqlite" },
    highlight = { timer = 150 },
    textobj = { enabled = true },
    system_clipboard = { clipboard_register = true },
  },
  keys = require("config.keymaps.yank"),
}
