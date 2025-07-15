local lspconfig = require("config.lsp.setup")

return {
  lspconfig.setupServer("cssls", {
    on_attach = function(client, bufnr)
      print("Hello CSS")
    end,
  }),
}
