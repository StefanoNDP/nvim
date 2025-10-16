local add_dotnet_mappings = function()
  local dotnet = require("easy-dotnet")
  vim.api.nvim_create_user_command("Secrets", function()
    dotnet.secrets()
  end, {})

  vim.keymap.set("n", "<A-t>", function()
    vim.cmd("Dotnet testrunner")
  end, { nowait = true })

  vim.keymap.set("n", "<C-p>", function()
    dotnet.run_with_profile(true)
  end, { nowait = true })

  -- -- Example keybinding
  -- vim.keymap.set("n", "<C-p>", function()
  --   dotnet.run_project()
  -- end)

  vim.keymap.set("n", "<C-b>", function()
    dotnet.build_default_quickfix()
  end, { nowait = true })
end

return { -- C#
  -- {
  --   "Issafalcon/neotest-dotnet",
  --   enabled = false,
  --   version = false,
  --   lazy = true,
  --   ft = { "cs", "c_sharp", "csharp", "csproj", "sln", "slnx", "csx", "razor" },
  --   config = true,
  -- },
  {
    "nsidorenco/neotest-vstest",
    enabled = vim.g.isDesktop,
    version = false,
    lazy = true,
    ft = { "cs", "c_sharp", "csharp", "csproj", "sln", "slnx", "csx", "razor" },
  },
  -- { "tris203/rzls.nvim", version = false, lazy = true },
  -- { -- Unity
  --   "apyra/nvim-unity-sync",
  --   enabled = true,
  --   version = false,
  --   lazy = true,
  --   ft = { "cs" },
  --   opts = function()
  --     return {}
  --   end,
  --   config = function(_, opts)
  --     require("unity.plugin").setup(opts)
  --   end,
  -- },
  {
    "seblyng/roslyn.nvim",
    init = function()
      vim.filetype.add({
        extension = {
          razor = "razor",
          cshtml = "razor",
        },
      })
    end,
    dependencies = {
      {
        "tris203/rzls.nvim",
        lazy = false,
        version = false,
        -- config = function()
        --   ---@diagnostic disable-next-line: missing-fields
        --   require("rzls").setup({})
        -- end,
        config = true,
      },
    },
    version = false,
    ft = { "cs", "c_sharp", "csharp", "razor" },
    opts = {
      filewatching = "roslyn",
      choose_target = nil,
      ignore_target = nil,
      broad_search = true,
      lock_target = false,
    },
    config = true,
  },
  {
    "GustavEikaas/easy-dotnet.nvim",
    enabled = true,
    ft = {
      "cs",
      "c_sharp",
      "csharp",
      "csproj",
      "sln",
      "slnx",
      "props",
      "csx",
      "targets",
      "fsharp",
      "vb",
      "razor",
    },
    cmd = "Dotnet",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "igorlfs/nvim-dap-view",
    },
    event = "VeryLazy",
    opts = function()
      local function get_secret_path(secret_guid)
        local path = ""
        local home_dir = vim.fn.expand("~")
        if require("easy-dotnet.extensions").isWindows() then
          local secret_path = home_dir
            .. "\\AppData\\Roaming\\Microsoft\\UserSecrets\\"
            .. secret_guid
            .. "\\secrets.json"
          path = secret_path
        else
          local secret_path = home_dir
            .. "/.microsoft/usersecrets/"
            .. secret_guid
            .. "/secrets.json"
          path = secret_path
        end
        return path
      end

      -- local sdk_path = function()
      --   return "C:\\Program Files\\dotnet\\sdk\\9.0.304"
      -- end

      return {
        --Optional function to return the path for the dotnet sdk (e.g C:/ProgramFiles/dotnet/sdk/8.0.0)
        -- easy-dotnet will resolve the path automatically if this argument is omitted, for a performance improvement you can add a function that returns a hardcoded string
        -- You should define this function to return a hardcoded path for a performance improvement 🚀
        -- get_sdk_path = sdk_path,
        ---@type TestRunnerOptions
        test_runner = {
          ---@type "split" | "float" | "buf"
          viewmode = "float",
          vsplit_width = nil,
          vsplit_pos = nil,
          enable_buffer_test_execution = true, --Experimental, run tests directly from buffer
          noBuild = false,
          noRestore = false,
          icons = {
            passed = "",
            skipped = "󰒬",
            failed = "✘",
            success = "",
            reload = "",
            test = "",
            sln = "󰘐",
            project = "󰘐",
            dir = "",
            package = "",
          },
          mappings = {
            run_test_from_buffer = {
              lhs = "<leader>r",
              desc = "run test from buffer",
            },
            peek_stack_trace_from_buffer = {
              lhs = "<leader>p",
              desc = "peek stack trace from buffer",
            },
            filter_failed_tests = {
              lhs = "<leader>fe",
              desc = "filter failed tests",
            },
            debug_test = { lhs = "<leader>d", desc = "debug test" },
            go_to_file = { lhs = "g", desc = "go to file" },
            run_all = { lhs = "<leader>R", desc = "run all tests" },
            run = { lhs = "<leader>r", desc = "run test" },
            peek_stacktrace = {
              lhs = "<leader>p",
              desc = "peek stacktrace of failed test",
            },
            expand = { lhs = "o", desc = "expand" },
            expand_node = { lhs = "E", desc = "expand node" },
            expand_all = { lhs = "-", desc = "expand all" },
            collapse_all = { lhs = "W", desc = "collapse all" },
            close = { lhs = "q", desc = "close testrunner" },
            refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
          },
          --- Optional table of extra args e.g "--blame crash"
          additional_args = {},
        },
        new = {
          project = {
            prefix = "sln", -- "sln" | "none"
          },
        },
        ---@param action "test" | "restore" | "build" | "run"
        terminal = function(path, action, args)
          args = args or ""
          local commands = {
            run = function()
              return string.format("dotnet run --project %s %s", path, args)
            end,
            test = function()
              return string.format("dotnet test %s %s", path, args)
            end,
            restore = function()
              return string.format("dotnet restore %s %s", path, args)
            end,
            build = function()
              return string.format("dotnet build %s %s", path, args)
            end,
            watch = function()
              return string.format("dotnet watch --project %s %s", path, args)
            end,
          }

          local command = commands[action]()
          if require("easy-dotnet.extensions").isWindows() == true then
            command = command .. "\r"
          end
          vim.cmd("split")
          vim.cmd("term " .. command)
        end,
        secrets = {
          path = get_secret_path,
        },
        csproj_mappings = true,
        fsproj_mappings = true,
        auto_bootstrap_namespace = {
          --block_scoped, file_scoped
          type = "block_scoped",
          enabled = true,
          use_clipboard_json = {
            behavior = "prompt", -- 'auto' | 'prompt' | 'never'
            register = "+", -- which register to check
          },
        },
        server = {
          ---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
          log_level = nil,
        },
        -- choose which picker to use with the plugin
        -- possible values are "telescope" | "fzf" | "snacks" | "basic"
        -- if no picker is specified, the plugin will determine
        -- the available one automatically with this priority:
        -- telescope -> fzf -> snacks ->  basic
        picker = "snacks",
        background_scanning = true,
        notifications = {
          --Set this to false if you have configured lualine to avoid double logging
          handler = function(start_event)
            local spinner = require("easy-dotnet.ui-modules.spinner").new()
            spinner:start_spinner(start_event.job.name)
            ---@param finished_event JobEvent
            return function(finished_event)
              spinner:stop_spinner(
                finished_event.result.text,
                finished_event.result.level
              )
            end
          end,
        },
        -- debugger = {
        --   mappings = {
        --     open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
        --   },
        --   -- The path to netcoredbg
        --   bin_path = vim.fn.stdpath("config") .. "\\mason\\bin\\netcoredbg.cmd",
        --   auto_register_dap = true,
        -- },
        diagnostics = {
          default_severity = "error",
          setqflist = false,
        },
      }
    end,
    config = function(_, opts)
      local dotnet = require("easy-dotnet")

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if dotnet.is_dotnet_project() then
            add_dotnet_mappings()
          end
        end,
      })

      dotnet.setup(opts)
    end,
  },
}

-- TODO: Add these to "Properties/launchSettings.json" automatically
-- "NeovimDebugProject.Api": {
-- 	"commandName": "Project",
-- 	"dotnetRunMessages": true,
-- 	"launchBrowser": true,
-- 	"launchUrl": "swagger",
-- 	"environmentVariables": {
-- 		"ASPNETCORE_ENVIRONMENT": "Development"
-- 	},
-- 	"applicationUrl": "https://localhost:7073;http://localhost:7071"
-- }
