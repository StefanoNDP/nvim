local lspconfig = require("config.lsp.setup")

return {
  lspconfig.setupServer("angularls", {
    on_attach = function(client, bufnr)
      print("Hello Angular")
    end,
  }),
}
