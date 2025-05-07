return {
  "smjonas/inc-rename.nvim",
  enabled = true,
  version = false,
  event = "VeryLazy",
  cmd = "IncRename",
  opts = function()
    return {}
  end,
  config = function(_, opts)
    require("inc_rename").setup(opts)
  end,
}
