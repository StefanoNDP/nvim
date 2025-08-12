return {
  "folke/noice.nvim",
  version = false,
  enabled = true,
  event = "VeryLazy",
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    -- "rcarriga/nvim-notify",
  },
  opts = {
    cmdline = { enabled = true, view = "cmdline" },
    messages = { enabled = false },
    notify = { enabled = false },
    popupmenu = { enabled = false },
    lsp = {
      progress = { enabled = false },
      hover = { enabled = false },
      signature = { enabled = false },
      message = { enabled = false },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      -- inc_rename = true,
    },
  },
  config = function(_, opts)
    require("noice").setup(opts)
  end,
}
