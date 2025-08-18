return {
  "kevinhwang91/nvim-hlslens",
  enabled = true,
  version = false,
  event = "VeryLazy",
  opts = function()
    return {}
  end,
  config = function(_, opts)
    require("hlslens").setup(opts)
    require("config.keymaps.hlslens")
  end,
}
