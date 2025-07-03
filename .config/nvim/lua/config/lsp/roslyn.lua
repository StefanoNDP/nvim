local rzls_base_path =
  vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "rzls", "libexec")
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
  vim.fs.joinpath(
    rzls_base_path,
    "RazorExtension",
    "Microsoft.VisualStudioCode.RazorExtension.dll"
  ),
}
local capabilities = require("config.lsp.capabilities").capabilities

---@type vim.lsp.ClientConfig
return {
  on_attach = function(client, bufnr)
    if vim.version().minor >= 9 and lsp_semantic_tokens then
      client.server_capabilities.semanticTokensProvider = vim.NIL
    end
    print("Hello Roslyn!")
  end,
  offset_encoding = "utf-8",
  cmd = cmd,
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
