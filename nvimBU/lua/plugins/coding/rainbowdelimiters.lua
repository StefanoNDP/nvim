return {
  "HiPhish/rainbow-delimiters.nvim",
  enabled = true,
  -- lazy = false,
  event = "VeryLazy",
  opts = function()
    return {
      strategy = {
        [""] = "rainbow-delimiters.strategy.global",
        vim = "rainbow-delimiters.strategy.local",
        -- commonlisp = require("rainbow-delimiters").strategy["local"],
      },
      query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
        latex = "rainbow-blocks",
      },
      priority = {
        [""] = 110,
        lua = 210,
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
    }
  end,
  config = function(_, opts)
    require("rainbow-delimiters.setup").setup(opts)
  end,
}
