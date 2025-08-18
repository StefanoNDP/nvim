local signs = {
  add = { text = "+" },
  change = { text = "~" },
  delete = { text = "-" },
  topdelete = { text = "‾" },
  changedelete = { text = "~" },
  untracked = { text = "" },
}

return {
  "lewis6991/gitsigns.nvim",
  enabled = true,
  event = { "BufReadPre", "BufNewFile" },
  version = false,
  opts = {
    signs = signs,
    signs_staged = signs,
    signcolumn = true,
    numhl = true,
    on_attach = function(bufnr)
      require("config.keymaps.gitsigns")
    end,
  },
}
