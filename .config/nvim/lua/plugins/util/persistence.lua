return {
  "folke/persistence.nvim",
  enabled = true,
  version = false,
  event = "BufReadPre",
  opts = {},
  keys = require("config.keymaps.persistence"),
}
