return {
  "rcarriga/nvim-dap-ui",
  enabled = true,
  version = false,
  event = "VeryLazy",
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  opts = function()
    return {
      layouts = {
        {
          elements = {
            {
              id = "stacks",
              size = 0.33,
            },
            {
              id = "watches",
              size = 0.33,
            },
            {
              id = "disassembly",
              size = 0.34,
            },
          },
          position = "right",
          size = 0.23,
        },
        {
          elements = {
            {
              id = "repl",
              size = 1.0,
            },
            -- {
            --   id = "console",
            --   size = 0.25,
            -- },
          },
          position = "bottom",
          size = 0.31,
        },
        {
          elements = {
            {
              id = "scopes",
              size = 0.5,
            },
            {
              id = "breakpoints",
              size = 0.5,
            },
          },
          position = "left",
          size = 0.19,
        },
      },
    }
  end,
  config = function(_, opts)
    require("dapui").setup(opts)
  end,
}
