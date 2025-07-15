return {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  enabled = true,
  version = false,
  lazy = false,
  opts = {
    disabled_filetypes = {
      ["dapui*"] = true, -- Disable Hardtime in Dapui
    },
  },
}
