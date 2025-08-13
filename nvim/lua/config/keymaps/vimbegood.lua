local M = {}

local wk = require("which-key")

M.keymaps = wk.add({
  mode = { "n" },
  { "<leader>vb", ":VimBeGood<CR>", desc = "Vim be good" },
})

return M.keymaps
