local servers = function()
  local dap = require("dap")

  -- C/C++
  if not dap.adapters["codelldb"] then
    require("dap").adapters["codelldb"] = {
      -- Executable
      type = "executable",
      command = vim.fn.exepath("codelldb"),

      -- -- Server
      -- type = "server",
      -- port = "${port}",
      -- executable = {
      --   command = vim.fn.exepath("codelldb"),
      --   args = { "--port", "${port}" },
      -- },

      -- -- Server from separate terminal
      -- type = "server",
      -- host = "127.0.0.1",
      -- port = 13000,
      -- executable = {
      --   command = vim.fn.exepath("codelldb"),
      --   args = { "--port", 13000 },
      -- },
    }
  end
  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
    },
    -- {
    --   name = "Attach to process",
    --   type = "codelldb",
    --   request = "attach",
    --   pid = require("dap.utils").pick_process,
    --   cwd = "${workspaceFolder}",
    -- },
  }
  dap.configurations.c = dap.configurations.cpp

  -- C#
  if not dap.adapters["netcoredbg"] then
    require("dap").adapters["netcoredbg"] = {
      type = "executable",
      command = vim.fn.exepath("netcoredbg"),
      args = { "--interpreter=vscode" },
      options = {
        detached = false,
      },
    }
  end
  for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
    if not dap.configurations[lang] then
      dap.configurations[lang] = {
        {
          type = "netcoredbg",
          name = "Launch file",
          request = "launch",
          ---@diagnostic disable-next-line: redundant-parameter
          program = function()
            -- return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
            local line = 1
            local file = vim.fn.getcwd() .. "/.debugpath"
            local cmd = string.format("sed -n %dp %s", line, file)
            local output = vim.fn.system(cmd)
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. output, "file")
            -- return output
          end,
          cwd = "${workspaceFolder}",
        },
      }
    end
  end

  -- GODOT
  dap.adapters.godot = {
    type = "server",
    host = "127.0.0.1",
    port = os.getenv("GDScript_Port") or "6006",
  }

  dap.configurations.gdscript = {
    {
      launch_game_instance = false,
      launch_scene = false,
      name = "Launch Scene",
      project = "${workspaceFolder}",
      request = "launch",
      type = "godot",
      port = 6007,
      debugServer = 6006,

      -- address = "127.0.0.1",
      -- scene = "main|current|pinned|<path>",
      -- editor_path = "<path>",
      -- -- engine command line flags
      -- profiling = false,
      -- single_threaded_scene = false,
      -- debug_collisions = false,
      -- debug_paths = false,
      -- debug_navigation = false,
      -- debug_avoidance = false,
      -- debug_stringnames = false,
      -- frame_delay = 0,
      -- time_scale = 1.0,
      -- disable_vsync = false,
      -- fixed_fps = 60,
      -- -- anything else
      -- additional_options = "",
    },
  }

  -- Lua
  dap.adapters.nlua = function(callback, config)
    local adapter = {
      type = "server",
      host = config.host or "127.0.0.1",
      port = config.port or 8086,
    }
    if config.start_neovim then
      local dap_run = dap.run
      dap.run = function(c)
        adapter.port = c.port
        adapter.host = c.host
      end
      require("osv").run_this()
      dap.run = dap_run
    end
    callback(adapter)
  end
  dap.configurations.lua = {
    {
      type = "nlua",
      request = "attach",
      name = "Run this file",
      start_neovim = {},
    },
    {
      type = "nlua",
      request = "attach",
      name = "Attach to running Neovim instance (port = 8086)",
      port = 8086,
    },
  }

  -- -- Rust
  -- dap.configurations.rust = dap.configurations.cpp

  -- Typescript
  if not dap.adapters["pwa-node"] then
    require("dap").adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        -- 💀 Make sure to update this path to point to your installation
        args = {
          -- LazyVim.get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
          vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
          "${port}",
        },
      },
    }
  end
  if not dap.adapters["node"] then
    dap.adapters["node"] = function(cb, config)
      if config.type == "node" then
        config.type = "pwa-node"
      end
      local nativeAdapter = dap.adapters["pwa-node"]
      if type(nativeAdapter) == "function" then
        nativeAdapter(cb, config)
      else
        cb(nativeAdapter)
      end
    end
  end

  local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

  local vscode = require("dap.ext.vscode")
  vscode.type_to_filetypes["node"] = js_filetypes
  vscode.type_to_filetypes["pwa-node"] = js_filetypes

  for _, language in ipairs(js_filetypes) do
    if not dap.configurations[language] then
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
    end
  end
end

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
  {
    "rcarriga/nvim-dap-ui",
    enabled = true,
    version = false,
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    opts = function()
      return {}
    end,
    config = function(_, opts)
      require("dapui").setup(opts)
    end,
  },
  {
    "mfussenegger/nvim-dap",
    enabled = true,
    version = false,
    -- lazy = true,
    dependencies = { "jbyuki/one-small-step-for-vimkind" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("config.keymaps.dap")
      catppuccin()
      servers()
      require("overseer").enable_dap()

      dap.listeners.after.event_initialized.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
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
