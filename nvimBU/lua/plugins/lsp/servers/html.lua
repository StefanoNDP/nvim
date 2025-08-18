local lspconfig = require("config.lsp.setup")

return {
  lspconfig.setupServer("html", {
    on_attach = function(client, bufnr)
      print("Hello HTML")
    end,
  }),
}
