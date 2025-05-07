local M = {}

local wk = require("which-key")
local omniext = ":lua require('omnisharp_extended')."

M.keymaps = wk.add({
  {
    mode = { "n" },
    { "gd", omniext .. "lsp_definitions()<CR>", desc = "Goto definition (Omnisharp)" },
    { "gtd", omniext .. "lsp_type_definitions()<CR>", desc = "Goto type definition (Omnisharp)" },
    { "gr", omniext .. "lsp_references()<CR>", desc = "Goto reference (Omnisharp)" },
    { "gi", omniext .. "lsp_implementation()<CR>", desc = "Goto implementation (Omnisharp)" },
  },
})

return M.keymaps
