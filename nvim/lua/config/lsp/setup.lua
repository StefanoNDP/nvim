local M = {}

M.onAttach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    local navic = require("nvim-navic")
    navic.attach(client, bufnr)
  end
  -- require("lsp_signature").on_attach({
  --   bind = true,
  --   handler_opts = {
  --     border = "rounded",
  --   },
  -- }, bufnr)
end

M.setupServer = function(name, args)
  args = args or {}
  name = name or ""
  assert(type(name) == "string", "Expected a string value")

  local lspconfig = require("lspconfig")
  local capabilities = require("config.lsp.capabilities").capabilities

  local opts = {
    flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
    on_attach = M.onAttach,
    capabilities = capabilities,
  }

  if args then
    opts = vim.tbl_extend("force", opts, args)
  end

  lspconfig[name].setup(opts)
end

M.setupServers = function(names, args)
  args = args or {}
  names = names or {}
  assert(type(names) == "table", "Expected a table value")

  local lspconfig = require("lspconfig")
  local capabilities = require("config.lsp.capabilities").capabilities

  local opts = {
    flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
    on_attach = M.onAttach,
    capabilities = capabilities,
  }

  if args then
    opts = vim.tbl_extend("force", opts, args)
  end

  for _, llsp in ipairs(names) do
    lspconfig[llsp].setup(opts)
  end
end

return M
