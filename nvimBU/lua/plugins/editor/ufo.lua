return {
  "kevinhwang91/nvim-ufo",
  enabled = true,
  version = false,
  dependencies = { "kevinhwang91/promise-async" },
  event = "VeryLazy",
  config = function()
    require("ufo").setup()
  end,
}
