local lspconfig = require("config.lsp.setup")
local funcs = require("config.functions")
local vars = require("config.vars")

return {
  lspconfig.setupServer("jsonls", {
    -- on_new_config = function(new_config)
    --   new_config.settings.json.schemas = require("schemastore").json.schemas or {}
    --   vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
    -- end,
    settings = {
      json = {
        format = { enable = true },
        -- schemas = {
        --   description = "Biome configuration schema",
        --   fileMatch = "biome.json",
        --   url = "https://biomejs.dev/schemas/1.9.4/schema.json",
        -- },
        validate = { enable = true },
      },
    },
    on_attach = function(client, bufnr)
      print("Hello json")
    end,
  }),
}
