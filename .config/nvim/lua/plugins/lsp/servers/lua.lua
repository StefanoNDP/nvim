local lspconfig = require("config.lsp.setup")

return {
  lspconfig.setupServer("lua_ls", {
    on_attach = function(client, bufnr)
      print("Hello Lua")
    end,
    settings = { -- custom settings for lua
      Lua = {
        -- make the language server recognize "vim" global
        diagnostics = {
          globals = { "vim" },
        },
        doc = {
          privateName = { "^_" },
        },
        codeLens = {
          enable = true,
          events = { "BufWritePost", "BufEnter", "CursorHold", "InsertLeave", "TextChanged" },
        },
        hint = {
          enable = true,
          -- setType = false,
          -- paramType = true,
          -- paramName = "Disable",
          -- semicolon = "Disable",
          arrayIndex = "Disable",
        },
        workspace = {
          checkThirdParty = false,
          -- make language server aware of runtime files
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
        telemetry = { enable = false },
      },
    },
  }),
}
