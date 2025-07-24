return {
  "Jorenar/nvim-dap-disasm",
  dependencies = { "igorlfs/nvim-dap-view" },
  enabled = true,
  version = false,
  -- event = "VeryLazy",
  -- lazy = true,
  -- opts = function()
  --   return {
  --     -- Add disassembly biew to elements of nvim-dap-ui
  --     dapui_register = true,
  --
  --     -- Add disassembly biew to elements of nvim-dap-view
  --     dapview_register = true,
  --
  --     -- Add custom REPL commands for stepping with instruction granularity
  --     repl_commands = true,
  --
  --     -- Show winbar with buttons to step into the code with instruction granularity
  --     -- This settings is overriden (disabled) if the dapview integration is enabled and the plugin is installed
  --     winbar = true,
  --
  --     -- The sign to use for instruction the exectution is stopped at
  --     sign = "DapStopped",
  --
  --     -- Number of instructions to show before the memory reference
  --     ins_before_memref = 16,
  --
  --     -- Number of instructions to show after the memory reference
  --     ins_after_memref = 16,
  --
  --     -- Labels of buttons in winbar
  --     controls = {
  --       step_into = "Step Into",
  --       step_over = "Step Over",
  --       step_back = "Step Back",
  --     },
  --
  --     -- Columns to display in the disassembly view
  --     columns = {
  --       "address",
  --       "instructionBytes",
  --       "instruction",
  --     },
  --   }
  -- end,
  -- config = function(_, opts)
  --   local disasm = require("nvim-dap-disasm")
  --   disasm.setup(opts)
  -- end,
  config = true,
}
