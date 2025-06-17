local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

-- Capabilities encoding
M.capabilities.general.positionEncodings = { "utf-8", "utf-16", "utf-32" }

M.capabilities.workspace.configuration = true
M.capabilities.workspace.didChangeConfiguration.dynamicRegistration = true
M.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
-- M.capabilities.workspace.executeCommand.dynamicRegistration = true

-- TODO(lewis6991): do not advertise didChangeWatchedFiles on Linux
-- or BSD since all the current backends are too limited.
-- Ref: #27807, #28058, #23291, #26520
M.capabilities.workspace.didChangeWatchedFiles.relativePatternSupport = false

M.capabilities.textDocument.diagnostic.dynamicRegistration = true

M.capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.preselectSupport = true
M.capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
M.capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
M.capabilities.textDocument.completion.completionItem.deprecatedSupport = true
M.capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
M.capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
M.capabilities.textDocument.completion.completionItem.resolveSupport =
  { properties = { "documentation", "detail", "additionalTextEdits" } }

M.capabilities.textDocument.foldingRange.dynamicRegistration = false
M.capabilities.textDocument.foldingRange.lineFoldingOnly = true

-- M.lspCapabilities = vim.tbl_deep_extend("force", require("lspconfig.util").default_config, {
--   capabilities = vim.tbl_deep_extend(
--     "force",
--     vim.lsp.protocol.make_client_capabilities(),
--     require("lsp-file-operations").default_capabilities()
--   ),
-- })

-- M.lspCapabilities.capabilities.encoding = M.capabilities.encoding
-- M.lspCapabilities.capabilities.workspace = M.capabilities.workspace
-- M.lspCapabilities.capabilities.textDocument = M.capabilities.textDocument

-- -- M.capabilities = require("blink.cmp").get_lsp_capabilities(M.lspCapabilities.capabilities)
-- M.capabilities = M.lspCapabilities.capabilities

return M
