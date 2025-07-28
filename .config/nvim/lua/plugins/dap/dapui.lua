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
              id = "scopes",
              size = 0.25,
            },
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "stacks",
              size = 0.25,
            },
            {
              id = "watches",
              size = 0.25,
            },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            {
              id = "repl",
              size = 0.5,
            },
            -- {
            --   id = "console",
            --   size = 0.33,
            -- },
            {
              id = "disassembly",
              size = 0.5,
            },
          },
          position = "bottom",
          size = 10,
        },
      },
    }
  end,
  config = function(_, opts)
    require("dapui").setup(opts)
  end,
}
