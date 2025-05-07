local lspSetup = require("config.lsp.setup")

-- local cmd = {
--   "omnisharp",
--   "-z",
--   "--hostPID", tostring(vim.fn.getpid()),
--   "DotNet:enablePackageRestore=false",
--   "--encoding", "utf-8",
--   "-lsp",
-- }

return {
  -- lspSetup.setupServer("omnisharp", {
  -- lspSetup.setupServer("omnisharp-mono", {
  lspSetup.setupServer("roslyn", {
    -- use_mono = true,
    keys = require("config.keymaps.languages.c_sharp"),
    -- settings = {
    --   filetypes = { "cs", "fsharp", "vb" },
    --   FormattingOptions = {
    --     EnableEditorConfigSupport = true, -- .editorconfig support.
    --     OrganizeImports = true, -- "using" directives are grouped and sorted when formatting document.
    --   },
    --   RoslynExtensionsOptions = {
    --     EnableAnalyzersSupport = true, -- support for roslyn analyzers, code fixes and rulesets.
    --     EnableImportCompletion = true, -- Adds completion support for unimported types/extension methods
    --   },
    --   MsBuild = {
    --     -- If true, MSBuild project system will only load projects for files that
    --     -- were opened in the editor. This setting is useful for big C# codebases
    --     -- and allows for faster initialization of code navigation features only
    --     -- for projects that are relevant to code that is being edited. With this
    --     -- setting enabled OmniSharp may load fewer projects and may thus display
    --     -- incomplete reference lists for symbols.
    --     -- LoadProjectsOnDemand = nil,
    --   },
    --   Sdk = {
    --     -- Specifies whether to include preview versions of the .NET SDK when
    --     -- determining which version to use for project loading.
    --     -- IncludePrereleases = nil,
    --   },
    -- },
    -- cmd = cmd,
    on_attach = function(client, bufnr)
      -- require("config.keymaps.languages.c_sharp")
      print("Hello Roslyn")
    end,
  }),
}
