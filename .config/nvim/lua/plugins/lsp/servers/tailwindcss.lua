local lspconfig = require("config.lsp.setup")

-- local path = "/home/archuser/.local/share/nvm/v23.10.0/bin/tailwindcss-language-server"

return {
  lspconfig.setupServer("tailwindcss", {
    filetypes_exclude = { "markdown" },
    -- cmd = { vim.fn.exepath("tailwindcss-language-server"), "--stdio" },
    -- cmd = { path, "--stdio" },
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
