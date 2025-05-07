local M = {}

local wk = require("which-key")
local funcs = require("config.functions")

M.keymaps = wk.add({
  mode = { "n" },
  {
    "gD",
    function()
      local params = vim.lsp.util.make_position_params()
      funcs.execute({
        command = "typescript.goToSourceDefinition",
        arguments = { params.textDocument.uri, params.position },
        open = true,
      })
    end,
    desc = "Goto Source Definition",
  },
  {
    "gR",
    function()
      funcs.execute({
        command = "typescript.findAllFileReferences",
        arguments = { vim.uri_from_bufnr(0) },
        open = true,
      })
    end,
    desc = "File References",
  },
  {
    "<leader>co",
    funcs.action["source.organizeImports"],
    desc = "Organize Imports",
  },
  {
    "<leader>cM",
    funcs.action["source.addMissingImports.ts"],
    desc = "Add missing imports",
  },
  {
    "<leader>cu",
    funcs.action["source.removeUnused.ts"],
    desc = "Remove unused imports",
  },
  {
    "<leader>cD",
    funcs.action["source.fixAll.ts"],
    desc = "Fix all diagnostics",
  },
  {
    "<leader>cV",
    function()
      funcs.execute({ command = "typescript.selectTypeScriptVersion" })
    end,
    desc = "Select TS workspace version",
  },
})

return M.keymaps
