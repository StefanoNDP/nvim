return {
  "mrjones2014/smart-splits.nvim",
  enabled = false,
  version = false,
  event = "VeryLazy",
  opts = function()
    return {
      multiplexer_integration = true,
    }
  end,
  config = function(_, opts)
    require("smart-splits").setup(opts)
  end,
}
