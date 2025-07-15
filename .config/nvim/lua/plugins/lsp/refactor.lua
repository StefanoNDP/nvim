return {
  "ThePrimeagen/refactoring.nvim",
  enabled = true,
  version = false,
  lazy = true,
  opts = function()
    return {}
  end,
  config = function(_, opts)
    require("config.keymaps.refactoring")
    require("refactoring").setup(opts)
  end,
}
