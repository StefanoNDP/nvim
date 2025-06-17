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
  handlers = require("rzls.roslyn_handlers"),
  -- handlers = vim.tbl_deep_extend("force", require("rzls.roslyn_handlers"), {}),
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
