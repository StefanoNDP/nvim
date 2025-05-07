---@class LineRange
---@field line integer
---@field character integer

---@class EditRange
---@field start LineRange
---@field end LineRange

---@class TextEdit
---@field newText string
---@field range EditRange

---@param edit TextEdit
local apply_vs_text_edit = function(edit)
  local bufnr = vim.api.nvim_get_current_buf()
  local start_line = edit.range.start.line
  local start_char = edit.range.start.character
  local end_line = edit.range["end"].line
  local end_char = edit.range["end"].character

  local newText = string.gsub(edit.newText, "\r", "")
  local lines = vim.split(newText, "\n")

  local placeholder_row = -1
  local placeholder_col = -1

  -- placeholder handling
  for i, line in ipairs(lines) do
    local pos = string.find(line, "%$0")
    if pos then
      lines[i] = string.gsub(line, "%$0", "", 1)
      placeholder_row = start_line + i - 1
      placeholder_col = pos - 1
      break
    end
  end

  vim.api.nvim_buf_set_text(bufnr, start_line, start_char, end_line, end_char, lines)

  if placeholder_row ~= -1 and placeholder_col ~= -1 then
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_cursor(win, { placeholder_row + 1, placeholder_col })
  end
end

return { -- C#
  {
    "Issafalcon/neotest-dotnet",
    enabled = false,
    version = false,
    lazy = true,
    ft = { "cs", "csproj", "sln", "slnx", "props", "csx", "targets", "fsharp", "vb", "razor" },
  },
  { "tris203/rzls.nvim", version = false, lazy = true },
  {
    "seblyng/roslyn.nvim",
    dependencies = {
      {
        "tris203/rzls.nvim",
        config = function()
          ---@diagnostic disable-next-line: missing-fields
          require("rzls").setup({})
        end,
      },
    },
    version = false,
    ft = { "cs", "razor" },
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = function()
      local documentstore = require("rzls.documentstore")
      local razor = require("rzls.razor")
      local Log = require("rzls.log")

      return {
        args = {
          "--stdio",
          "--logLevel=Information",
          "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
          "--razorSourceGenerator=" .. vim.fs.joinpath(
            vim.fn.stdpath("data") --[[@as string]],
            "mason",
            "packages",
            "roslyn",
            "libexec",
            "Microsoft.CodeAnalysis.Razor.Compiler.dll"
          ),
          "--razorDesignTimePath=" .. vim.fs.joinpath(
            vim.fn.stdpath("data") --[[@as string]],
            "mason",
            "packages",
            "rzls",
            "libexec",
            "Targets",
            "Microsoft.NET.Sdk.Razor.DesignTime.targets"
          ),
        },
        ---@diagnostic disable-next-line: missing-fields
        config = {
          capabilities = {
            textDocument = {
              _vs_onAutoInsert = { dynamicRegistration = false },
            },
          },
          handlers = {
            ["textDocument/_vs_onAutoInsert"] = function(err, result, _)
              if err or not result then
                return
              end
              apply_vs_text_edit(result._vs_textEdit)
            end,

            -- VS Windows and VS Code
            ---@param _err lsp.ResponseError
            ---@param result VBufUpdate
            ["razor/updateCSharpBuffer"] = function(_err, result)
              documentstore.update_vbuf(result, razor.language_kinds.csharp)
              documentstore.refresh_parent_views(result)
            end,
            ---@param _err lsp.ResponseError
            ---@param result VBufUpdate
            ["razor/updateHtmlBuffer"] = function(_err, result)
              documentstore.update_vbuf(result, razor.language_kinds.html)
            end,
            ["razor/provideHtmlDocumentColor"] = require("rzls.handlers.providehtmldocumentcolor"),
            ["razor/provideSemanticTokensRange"] = require("rzls.handlers.providesemantictokensrange"),
            ["razor/foldingRange"] = require("rzls.handlers.foldingrange"),

            ["razor/htmlFormatting"] = require("rzls.handlers.htmlformatting"),
            ["razor/inlayHint"] = require("rzls.handlers.inlayhint"),
            ["razor/inlayHintResolve"] = require("rzls.handlers.inlayhintresolve"),

            -- Called to get C# diagnostics from Roslyn when publishing diagnostics for VS Code
            ["razor/csharpPullDiagnostics"] = require("rzls.handlers.csharppulldiagnostics"),
            ["razor/completion"] = require("rzls.handlers.completion"),
            ["razor/completionItem/resolve"] = require("rzls.handlers.completionitemresolve"),
            [vim.lsp.protocol.Methods.textDocument_colorPresentation] = not_supported,
            [vim.lsp.protocol.Methods.window_logMessage] = function(_, result)
              Log.rzls = result.message
              return vim.lsp.handlers[vim.lsp.protocol.Methods.window_logMessage]
            end,
          },
          filewatching = "roslyn",
          settings = {
            ["csharp|inlay_hints"] = {
              csharp_enable_inlay_hints_for_implicit_object_creation = true,
              csharp_enable_inlay_hints_for_implicit_variable_types = true,
              csharp_enable_inlay_hints_for_lambda_parameter_types = true,
              csharp_enable_inlay_hints_for_types = true,
              dotnet_enable_inlay_hints_for_indexer_parameters = true,
              dotnet_enable_inlay_hints_for_literal_parameters = true,
              dotnet_enable_inlay_hints_for_object_creation_parameters = true,
              dotnet_enable_inlay_hints_for_other_parameters = true,
              dotnet_enable_inlay_hints_for_parameters = true,
              dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },
            ["csharp|code_lens"] = {
              dotnet_enable_references_code_lens = true,
            },
            ["csharp|formatting"] = {
              dotnet_organize_imports_on_format = true,
            },
          },
        },
      }
    end,
    config = function(_, opts)
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

      return {
        --Optional function to return the path for the dotnet sdk (e.g C:/ProgramFiles/dotnet/sdk/8.0.0)
        -- easy-dotnet will resolve the path automatically if this argument is omitted, for a performance improvement you can add a function that returns a hardcoded string
        -- You should define this function to return a hardcoded path for a performance improvement 🚀
        get_sdk_path = "/usr/share/dotnet/sdk/9.0.104",
        ---@type TestRunnerOptions
        test_runner = {
          ---@type "split" | "float" | "buf"
          viewmode = "float",
          enable_buffer_test_execution = true, --Experimental, run tests directly from buffer
          noBuild = true,
          noRestore = true,
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

          local command = commands[action]() .. "\r"
          vim.cmd("vsplit")
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
      require("easy-dotnet").setup(opts)
    end,
  },
  -- {
  --   -- "MoaidHathot/dotnet.nvim",
  -- },
}
