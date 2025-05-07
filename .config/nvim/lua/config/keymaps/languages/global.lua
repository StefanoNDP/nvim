local M = {}

local wk = require("which-key")
local lsp = ":lua vim.lsp.buf."

M.keymaps = wk.add({
  {
    mode = { "n" },
    { "gd", lsp .. "definition()<CR>", desc = "Go to definition" },
    { "gtd", lsp .. "type_definition()<CR>", desc = "Go to type definition" },
    { "gr", lsp .. "references()<CR>", desc = "Go to reference" },
    { "gi", lsp .. "implementation()<CR>", desc = "Go to implementation" },
  },
})

return M.keymaps
