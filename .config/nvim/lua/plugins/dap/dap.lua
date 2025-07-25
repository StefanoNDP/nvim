-- Catppuccin compatibility
local catppuccin = function()
  local sign = vim.fn.sign_define

  local dapBreakpoint = {
    breakpoint = {
      text = "",
      texthl = "DapBreakpoint",
      linehl = "",
      numhl = "",
    },
    breakpointCondition = {
      text = "",
      texthl = "DapBreakpointCondition",
      linehl = "",
      numhl = "",
    },
    dapLogPoint = {
      text = "◆",
      texthl = "DapLogPoint",
      linehl = "",
      numhl = "",
    },
    rejected = {
      text = "",
      texthl = "LspDiagnosticsSignHint",
      linehl = "",
      numhl = "",
    },
    stopped = {
      text = "",
      texthl = "LspDiagnosticsSignInformation",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "LspDiagnosticsSignInformation",
    },
  }

  sign("DapBreakpoint", dapBreakpoint.breakpoint)
  sign("DapBreakpointCondition", dapBreakpoint.breakpointCondition)
  sign("DapLogPoint", dapBreakpoint.dapLogPoint)
  sign("DapStopped", dapBreakpoint.stopped)
  sign("DapBreakpointRejected", dapBreakpoint.rejected)
end

return {
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    enabled = true,
    version = false,
    event = "VeryLazy",
    opts = function()
      return { -- Below are the defaults
        enabled = true, -- enable this plugin (the default)
        -- enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        -- highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        -- highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        -- show_stop_reason = true, -- show stop reason when stopped for exceptions
        -- commented = false, -- prefix virtual text with comment string
        -- only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
        -- all_references = false, -- show virtual text on all all references of the variable (not only definitions)
        -- clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
        -- --- A callback that determines how a variable is displayed or whether it should be omitted
        -- --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
        -- --- @param buf number
        -- --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
        -- --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
        -- --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
        -- --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
        -- display_callback = function(variable, buf, stackframe, node, options)
        --   -- by default, strip out new line characters
        --   if options.virt_text_pos == "inline" then
        --     return " = " .. variable.value:gsub("%s+", " ")
        --   else
        --     return variable.name .. " = " .. variable.value:gsub("%s+", " ")
        --   end
        -- end,
        -- -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
        -- virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
        --
        -- -- experimental features:
        -- all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        -- virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
        -- virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
      }
    end,
    config = function(_, opts)
      require("nvim-dap-virtual-text").setup(opts)
    end,
  },
  { -- DAP UI
    "rcarriga/nvim-dap-ui",
    enabled = false,
    version = false,
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    opts = function()
      return {
        layouts = {
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "top",
            size = 10,
          },
          {
            elements = {
              { id = "stacks", size = 0.5 },
              { id = "watches", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
          {
            elements = {
              { id = "scopes", size = 0.5 },
              { id = "breakpoints", size = 0.5 },
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
  },
  { -- Minimalistic DAP UI
    "igorlfs/nvim-dap-view",
    enabled = true,
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
  },
  {
    "mfussenegger/nvim-dap",
    enabled = true,
    version = false,
    -- lazy = true,
    dependencies = { "jbyuki/one-small-step-for-vimkind", "igorlfs/nvim-dap-view" },
    config = function()
      local dap = require("dap")
      local dapui

      dap.set_log_level("TRACE")

      require("config.keymaps.dap")
      catppuccin()
      require("plugins.dap.adapters.c_sharp")
      require("plugins.dap.adapters.godot")
      require("plugins.dap.adapters.lua")

      if vim.g.whichDap == 0 then
        dapui = require("dapui")
        -- DAP UI
        dap.listeners.after.event_initialized.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.attach.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
          dapui.open()
        end
        -- dap.listeners.before.event_terminated.dapui_config = function()
        --   dapui.close()
        -- end
        -- dap.listeners.before.event_exited.dapui_config = function()
        --   dapui.close()
        -- end
      else
        dapui = require("dap-view")
        -- DAP View
        dap.listeners.after.event_initialized["dap-view-config"] = function()
          dapui.open()
        end
        dap.listeners.before.attach["dap-view-config"] = function()
          dapui.open()
        end
        dap.listeners.before.launch["dap-view-config"] = function()
          dapui.open()
        end
        -- dap.listeners.before.event_terminated["dap-view-config"] = function()
        --   dapui.close()
        -- end
        -- dap.listeners.before.event_exited["dap-view-config"] = function()
        --   dapui.close()
        -- end
      end

      -- vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
    end,
  },
}
