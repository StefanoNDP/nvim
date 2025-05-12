return { -- Breadcrumbs-like navigation
  "hasansujon786/nvim-navbuddy",
  enabled = true,
  version = false,
  -- lazy = true,
  event = "VeryLazy",
  dependencies = {
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
  },
  opts = function()
    return { lsp = { auto_attach = true } }
  end,
  config = function(_, opts)
    require("nvim-navbuddy").setup(opts)
  end,
}
