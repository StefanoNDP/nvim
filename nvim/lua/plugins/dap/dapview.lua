return {
  "igorlfs/nvim-dap-view",
  enabled = false,
  version = false,
  -- event = "VeryLazy",
  -- lazy = true,
  ---@module 'dap-view'
  ---@type dapview.config
  opts = {
    winbar = {
      -- sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
      sections = {
        "watches",
        "scopes",
        "exceptions",
        "breakpoints",
        "threads",
        "repl",
        "console",
        "disassembly",
      },
      -- custom_sections = {
      --   disassembly = {
      --     keymap = "D",
      --     label = "Disassembly",
      --   },
      -- },
      base_sections = {
        breakpoints = {
          label = "Breakpoints",
        },
        -- disassembly = {
        --   keymap = "D",
        --   label = "Disassembly",
        -- },
        scopes = {
          label = "Scopes",
        },
        exceptions = {
          label = "Exceptions",
        },
        watches = {
          label = "Watches",
        },
        threads = {
          label = "Threads",
        },
        repl = {
          label = "Repl",
        },
        console = {
          label = "Console",
        },
      },
      default_section = "repl",
      controls = { enabled = true, position = "left" },
    },
    windows = {
      terminal = {
        -- hide = { "coreclr" },
        start_hidden = false,
        -- position = "below",
        -- start_hidden = true,
      },
    },
  },
}
