return {
  "folke/noice.nvim",
  version = false,
  enabled = true,
  event = "VeryLazy",
  opts = {
    cmdline = { enabled = true, view = "cmdline" },
    messages = { enabled = false },
    notify = { enabled = true },
    popupmenu = { enabled = false },
    lsp = {
      progress = { enabled = false },
      hover = { enabled = false },
      signature = { enabled = false },
      message = { enabled = false },
    },
    presets = { bottom_search = true, command_palette = true },
  },
  config = function(_, opts)
    require("noice").setup(opts)
  end,
}
