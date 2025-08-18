local lspconfig = require("config.lsp.setup")

return {
  lspconfig.setupServer("bashls", {
    on_attach = function(client, bufnr)
      print("Hello bash")
    end,
  }),
}
