return {
  "stevearc/overseer.nvim",
  enabled = true,
  version = false,
  event = "VeryLazy",
  cmd = {
    "OverseerOpen",
    "OverseerClose",
    "OverseerToggle",
    "OverseerSaveBundle",
    "OverseerLoadBundle",
    "OverseerDeleteBundle",
    "OverseerRunCmd",
    "OverseerRun",
    "OverseerInfo",
    "OverseerBuild",
    "OverseerQuickAction",
    "OverseerTaskAction",
    "OverseerClearCache",
  },
  opts = function()
    return {
      dap = true,
      -- templates = { "builtin", "user.c_sharp.easy_dotnet", "user.run_script" },
      templates = { "builtin" },
      -- task_list = {
      --   bindings = { ["<C-h>"] = false, ["<C-j>"] = false, ["<C-k>"] = false, ["<C-l>"] = false, },
      -- },
      form = { win_opts = { winblend = 0 } },
      confirm = { win_opts = { winblend = 0 } },
      task_win = { win_opts = { winblend = 0 } },
    }
  end,
  keys = require("config.keymaps.overseer"),
  config = function(_, opts)
    require("overseer").setup(opts)

    -- Create WatchRun command
    vim.api.nvim_create_user_command("WatchRun", function()
      local overseer = require("overseer")
      overseer.run_template({ name = "run script" }, function(task)
        if task then
          task:add_component({ "restart_on_save", paths = { vim.fn.expand("%:p") } })
          local main_win = vim.api.nvim_get_current_win()
          overseer.run_action(task, "open vsplit")
          vim.api.nvim_set_current_win(main_win)
        else
          vim.notify("WatchRun not supported for filetype " .. vim.bo.filetype, vim.log.levels.ERROR)
        end
      end)
    end, {})
  end,
}
