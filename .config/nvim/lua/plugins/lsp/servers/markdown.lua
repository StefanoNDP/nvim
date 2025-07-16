local lspconfig = require("config.lsp.setup")
local funcs = require("config.functions")
local vars = require("config.vars")

return {
  lspconfig.setupServer("marksman", {
    on_attach = function(client, bufnr)
      print("Hello markdown")
    end,
  }),
}
