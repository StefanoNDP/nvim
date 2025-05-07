return {
  "gbprod/yanky.nvim",
  enabled = true,
  version = false,
  desc = "Better Yank/Paste",
  event = "VeryLazy",
  opts = {
    highlight = { timer = 150 },
    textobj = { enabled = true },
    system_clipboard = { clipboard_register = true },
  },
  keys = require("config.keymaps.yank"),
}
