local lspconfig = require("config.lsp.setup")

return {
  lspconfig.setupServer("tailwindcss", {
    filetypes_exclude = { "markdown" },
    settings = {
      tailwindCSS = {
        includeLanguages = {
          elixir = "html-eex",
          heex = "html-eex",
        },
      },
    },
    on_attach = function(client, bufnr)
      print("Hello Tailwind")
    end,
  }),
}
