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
  {
    "Issafalcon/neotest-dotnet",
    enabled = false,
    version = false,
    lazy = true,
    ft = { "cs", "csproj", "sln", "slnx", "csx", "razor" },
  },
  { "tris203/rzls.nvim", version = false, lazy = true },
  {
    "seblyng/roslyn.nvim",
    dependencies = {
      {
        "tris203/rzls.nvim",
        -- config = function()
        --   ---@diagnostic disable-next-line: missing-fields
        --   require("rzls").setup({})
        -- end,
        config = true,
      },
    },
    version = false,
    ft = { "cs", "csproj", "sln", "slnx", "csx", "razor" },
    opts = function()
      return {
        filewatching = "roslyn",
        choose_target = nil,
        ignore_target = nil,
        broad_search = true,
        lock_target = false,
      }
    end,
    config = function(_, opts)
      vim.lsp.config("roslyn", { require("config.lsp.roslyn") })

      require("roslyn").setup(opts)
    end,
  },
  {
    "GustavEikaas/easy-dotnet.nvim",
    enabled = true,
    ft = { "cs", "csproj", "sln", "slnx", "props", "csx", "targets", "fsharp", "vb", "razor" },
    cmd = "Dotnet",
    dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
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
          local secret_path = home_dir .. "/.microsoft/usersecrets/" .. secret_guid .. "/secrets.json"
          path = secret_path
        end
        return path
      end
      local sdkPath = function()
        return "C:\\Program Files\\dotnet\\sdk\\8.0.409"
      end

      return {
        --Optional function to return the path for the dotnet sdk (e.g C:/ProgramFiles/dotnet/sdk/8.0.0)
        -- easy-dotnet will resolve the path automatically if this argument is omitted, for a performance improvement you can add a function that returns a hardcoded string
        -- You should define this function to return a hardcoded path for a performance improvement 🚀
        get_sdk_path = sdkPath(),
        test_runner = {
          ---@type "split" | "float" | "buf"
          viewmode = "float",
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
            run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
            filter_failed_tests = { lhs = "<leader>fe", desc = "filter failed tests" },
            debug_test = { lhs = "<leader>d", desc = "debug test" },
            go_to_file = { lhs = "g", desc = "got to file" },
            run_all = { lhs = "<leader>R", desc = "run all tests" },
            run = { lhs = "<leader>r", desc = "run test" },
            peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
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
        terminal = function(path, action, args)
          local commands = {
            run = function()
              return string.format("dotnet run --project %s %s", path, args)
            end,
            test = function()
              return string.format("dotnet test %s %s", path, args)
            end,
            -- restore = function() return string.format("dotnet restore %s %s", path, args) end,
            restore = function()
              return string.format(
                "dotnet restore --configfile %s %s %s",
                os.getenv("NUGET_CONFIG"),
                path,
                args
              )
            end,
            build = function()
              return string.format("dotnet build %s %s", path, args)
            end,
            -- build = function()
            --   return string.format("dotnet build %s /flp:v=q /flp:logfile=%s %s", path, logPath, args)
            -- end,
            watch = function()
              return string.format("dotnet watch --project %s %s", path, args)
            end,
          }

          local function filter_warnings(line)
            if not line:find("warning") then
              return line:match("^(.+)%((%d+),(%d+)%)%: (.+)$")
            end
          end

          local overseer_components = {
            { "on_complete_dispose", timeout = 30 },
            "default",
            { "unique", replace = true },
            {
              "on_output_parse",
              parser = {
                diagnostics = {
                  { "extract", filter_warnings, "filename", "lnum", "col", "text" },
                },
              },
            },
            { "on_result_diagnostics_quickfix", open = true, close = true },
          }

          local funcs = require("config.functions")

          if action == "run" or action == "test" then
            table.insert(overseer_components, { "restart_on_save", paths = { funcs.git() } })
          end

          local command = commands[action]() .. "\r"
          -- vim.cmd("vsplit")
          -- vim.cmd("term " .. command)

          local task = require("overseer").new_task({
            strategy = {
              "toggleterm",
              use_shell = false,
              direction = "horizontal",
              open_on_start = false,
            },
            name = action,
            cmd = command,
            cwd = funcs.git(),
            components = overseer_components,
          })
          task:start()
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
        },
        -- choose which picker to use with the plugin
        -- possible values are "telescope" | "fzf" | "snacks" | "basic"
        -- if no picker is specified, the plugin will determine
        -- the available one automatically with this priority:
        -- telescope -> fzf -> snacks ->  basic
        picker = "snacks",
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

-- -- lua/easy-dotnet/dotnet_cli.lua file from easy-dotnet line 21
-- -- function M.list_packages(sln_file_path) return string.format("dotnet solution %s list", sln_file_path) end
-- function M.list_packages(sln_file_path) return string.format("dotnet sln %s list", sln_file_path) end

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
