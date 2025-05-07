local M = {}

M.encoding = {
  offsetEncoding = { "utf-8", "utf-16", "utf-32" },
  general = {
    positionEncoding = { "utf-8", "utf-16", "utf-32" },
  },
}

M.workspace = {
  configuration = true,
  didChangeConfiguration = { dynamicRegistration = true },
  didChangeWorkspaceFolders = { dynamicRegistration = true },
  didChangeWatchedFiles = {
    dynamicRegistration = true,
    -- TODO(lewis6991): do not advertise didChangeWatchedFiles on Linux
    -- or BSD since all the current backends are too limited.
    -- Ref: #27807, #28058, #23291, #26520
    relativePatternSupport = false,
  },
}

M.textDocument = {
  didChangeConfiguration = { dynamicRegistration = true },
  completion = {
    completionItem = {
      snippetSupport = true,
      preselectSupport = true,
      insertReplaceSupport = true,
      labelDetailsSupport = true,
      deprecatedSupport = true,
      commitCharactersSupport = true,
      tagSupport = { valueSet = { 1 } },
      resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" },
      },
    },
  },
  foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  },
}

M.lspCapabilities = vim.tbl_deep_extend("force", require("lspconfig.util").default_config, {
  capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("lsp-file-operations").default_capabilities()
  ),
})

M.lspCapabilities.capabilities.encoding = M.encoding
M.lspCapabilities.capabilities.workspace = M.workspace
M.lspCapabilities.capabilities.textDocument = M.textDocument

M.capabilities = require("blink.cmp").get_lsp_capabilities(M.lspCapabilities.capabilities)

return M
