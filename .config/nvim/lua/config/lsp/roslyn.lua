local documentstore = require("rzls.documentstore")
local razor = require("rzls.razor")
local Log = require("rzls.log")
-- local roslyn_base_path =
--   vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "roslyn", "libexec")
local rzls_base_path = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "rzls", "libexec")
local cmd = {
  "roslyn",
  "--stdio",
  "--logLevel=Information",
  "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
  "--razorSourceGenerator="
    .. vim.fs.joinpath(rzls_base_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
  "--razorDesignTimePath="
    .. vim.fs.joinpath(rzls_base_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
  "--extension",
  -- vim.fs.joinpath(roslyn_base_path, "Microsoft.CodeAnalysis.LanguageServer.dll"),
  vim.fs.joinpath(rzls_base_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
}

local not_implemented = function(err, result, ctx, config)
  vim.print("Called " .. ctx.method)
  vim.print(vim.inspect(err))
  vim.print(vim.inspect(result))
  vim.print(vim.inspect(ctx))
  vim.print(vim.inspect(config))
  return { "error" }
end

local not_supported = function()
  return {}, nil
end

local uv = vim.uv
local fs = vim.fs

---@param client vim.lsp.Client
---@param target string
local function on_init_sln(client, target)
  vim.notify("Initializing: " .. target, vim.log.levels.INFO, { title = "roslyn_ls" })
  ---@diagnostic disable-next-line: param-type-mismatch
  client:notify("solution/open", {
    solution = vim.uri_from_fname(target),
  })
end

---@param client vim.lsp.Client
---@param project_files string[]
local function on_init_project(client, project_files)
  vim.notify("Initializing: projects", vim.log.levels.INFO, { title = "roslyn_ls" })
  ---@diagnostic disable-next-line: param-type-mismatch
  client:notify("project/open", {
    projects = vim.tbl_map(function(file)
      return vim.uri_from_fname(file)
    end, project_files),
  })
end

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

local function roslyn_handlers()
  return {
    ["workspace/projectInitializationComplete"] = function(_, _, ctx)
      vim.notify("Roslyn project initialization complete", vim.log.levels.INFO, { title = "roslyn_ls" })

      local buffers = vim.lsp.get_buffers_by_client_id(ctx.client_id)
      for _, buf in ipairs(buffers) do
        vim.lsp.util._refresh("textDocument/diagnostic", { bufnr = buf })
      end
    end,
    ["workspace/_roslyn_projectHasUnresolvedDependencies"] = function()
      vim.notify("Detected missing dependencies. Run `dotnet restore` command.", vim.log.levels.ERROR, {
        title = "roslyn_ls",
      })
      return vim.NIL
    end,
    ["workspace/_roslyn_projectNeedsRestore"] = function(_, result, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))

      ---@diagnostic disable-next-line: param-type-mismatch
      client:request("workspace/_roslyn_restore", result, function(err, response)
        if err then
          vim.notify(err.message, vim.log.levels.ERROR, { title = "roslyn_ls" })
        end
        if response then
          for _, v in ipairs(response) do
            vim.notify(v.message, vim.log.levels.INFO, { title = "roslyn_ls" })
          end
        end
      end)

      return vim.NIL
    end,
    ["razor/provideDynamicFileInfo"] = function(_, _, _)
      vim.notify(
        "Razor is not supported.\nPlease use https://github.com/tris203/rzls.nvim",
        vim.log.levels.WARN,
        { title = "roslyn_ls" }
      )
      return vim.NIL
    end,

    ["textDocument/_vs_onAutoInsert"] = function(err, result, _)
      if err or not result then
        return
      end
      apply_vs_text_edit(result._vs_textEdit)
    end,

    -- VS Windows only
    ["razor/inlineCompletion"] = not_implemented,
    ["razor/validateBreakpointRange"] = not_implemented,
    ["razor/onAutoInsert"] = not_implemented,
    ["razor/semanticTokensRefresh"] = not_implemented,
    ["razor/textPresentation"] = not_implemented,
    ["razor/uriPresentation"] = not_implemented,
    ["razor/spellCheck"] = not_implemented,
    ["razor/projectContexts"] = not_implemented,
    ["razor/pullDiagnostics"] = not_implemented,
    ["razor/mapCode"] = not_implemented,

    -- VS Windows and VS Code
    ---@param _err lsp.ResponseError
    ---@param result razor.VBufUpdate
    ["razor/updateCSharpBuffer"] = function(_err, result)
      local buf = documentstore.update_vbuf(result, razor.language_kinds.csharp)
      if buf then
        require("rzls.refresh").diagnostics.add(buf)
      end
    end,
    ---@param _err lsp.ResponseError
    ---@param result razor.VBufUpdate
    ["razor/updateHtmlBuffer"] = function(_err, result)
      documentstore.update_vbuf(result, razor.language_kinds.html)
    end,
    ["razor/provideCodeActions"] = require("rzls.handlers.providecodeactions"),
    ["razor/resolveCodeActions"] = require("rzls.handlers.resolvecodeactions"),
    ["razor/provideHtmlColorPresentation"] = not_supported,
    ["razor/provideHtmlDocumentColor"] = require("rzls.handlers.providehtmldocumentcolor"),
    ["razor/provideSemanticTokensRange"] = require("rzls.handlers.providesemantictokensrange"),
    ["razor/foldingRange"] = require("rzls.handlers.foldingrange"),

    ["razor/htmlFormatting"] = require("rzls.handlers.htmlformatting"),
    ["razor/htmlOnTypeFormatting"] = not_implemented,
    ["razor/simplifyMethod"] = not_implemented,
    ["razor/formatNewFile"] = not_implemented,
    ["razor/inlayHint"] = require("rzls.handlers.inlayhint"),
    ["razor/inlayHintResolve"] = require("rzls.handlers.inlayhintresolve"),

    -- VS Windows only at the moment, but could/should be migrated
    ["razor/documentSymbol"] = not_implemented,
    ["razor/rename"] = not_implemented,
    ["razor/hover"] = not_implemented,
    ["razor/definition"] = not_implemented,
    ["razor/documentHighlight"] = not_implemented,
    ["razor/signatureHelp"] = not_implemented,
    ["razor/implementation"] = not_implemented,
    ["razor/references"] = not_implemented,

    -- Called to get C# diagnostics from Roslyn when publishing diagnostics for VS Code
    ["razor/csharpPullDiagnostics"] = require("rzls.handlers.csharppulldiagnostics"),
    ["razor/completion"] = require("rzls.handlers.completion"),
    ["razor/completionItem/resolve"] = require("rzls.handlers.completionitemresolve"),

    -- Standard LSP methods
    [vim.lsp.protocol.Methods.textDocument_colorPresentation] = not_supported,
    [vim.lsp.protocol.Methods.window_logMessage] = function(_, result)
      Log.rzls = result.message
      return vim.lsp.handlers[vim.lsp.protocol.Methods.window_logMessage]
    end,
  }
end

local capabilities = require("config.lsp.capabilities").capabilities

---@type vim.lsp.ClientConfig
return {
  on_attach = function(client, bufnr)
    print("Hello Roslyn!")
  end,
  name = "roslyn_ls",
  offset_encoding = "utf-8",
  -- cmd = {
  --   "Microsoft.CodeAnalysis.LanguageServer",
  --   "--logLevel",
  --   "Information",
  --   "--extensionLogDirectory",
  --   fs.joinpath(uv.os_tmpdir(), "roslyn_ls/logs"),
  --   "--stdio",
  -- },
  cmd = cmd,
  filetypes = { "cs" },
  handlers = roslyn_handlers(),
  root_dir = function(bufnr, cb)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    -- don't try to find sln or csproj for files from libraries
    -- outside of the project
    if not bufname:match("^" .. fs.joinpath("/tmp/MetadataAsSource/")) then
      -- try find solutions root first
      local root_dir = fs.root(bufnr, function(fname, _)
        return fname:match("%.sln$") ~= nil
      end)

      if not root_dir then
        -- try find projects root
        root_dir = fs.root(bufnr, function(fname, _)
          return fname:match("%.csproj$") ~= nil
        end)
      end

      if root_dir then
        cb(root_dir)
      end
    end
  end,
  on_init = {
    function(client)
      local root_dir = client.config.root_dir

      -- try load first solution we find
      for entry, type in fs.dir(root_dir) do
        if type == "file" and vim.endswith(entry, ".sln") then
          on_init_sln(client, fs.joinpath(root_dir, entry))
          return
        end
      end

      -- if no solution is found load project
      for entry, type in fs.dir(root_dir) do
        if type == "file" and vim.endswith(entry, ".csproj") then
          on_init_project(client, { fs.joinpath(root_dir, entry) })
        end
      end
    end,
  },
  capabilities = capabilities,
  settings = {
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostics_scope = "fullSolution",
      dotnet_compiler_diagnostics_scope = "fullSolution",
    },
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
      dotnet_enable_tests_code_lens = true,
    },
    ["csharp|formatting"] = {
      dotnet_organize_imports_on_format = true,
    },
    ["csharp|completion"] = {
      dotnet_provide_regex_completions = true,
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_show_name_completion_suggestions = true,
    },
    ["csharp|symbol_search"] = {
      dotnet_search_reference_assemblies = true,
    },
  },
}
