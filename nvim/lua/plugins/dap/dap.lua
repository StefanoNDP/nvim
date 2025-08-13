local vars = require("config.vars")

return {
  {
    "mfussenegger/nvim-dap",
    enabled = true,
    version = false,
    -- lazy = true,
    event = "VeryLazy",
    dependencies = {
      "jbyuki/one-small-step-for-vimkind",
      "igorlfs/nvim-dap-view",
    },
    config = function()
      local dap = require("dap")
      local dapui

      dap.set_log_level("TRACE")

      require("config.keymaps.dap")
      vars.catppuccinDAP()
      -- catppuccin()
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
        dap.listeners.before.event_terminated.dapui_config = function()
          dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
          dapui.close()
        end
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
        dap.listeners.before.event_terminated["dap-view-config"] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dap-view-config"] = function()
          dapui.close()
        end
      end

      vim.api.nvim_set_hl(
        0,
        "DapStoppedLine",
        { default = true, link = "Visual" }
      )

      -- setup dap config by VsCode launch.json file
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
    end,
  },
}
