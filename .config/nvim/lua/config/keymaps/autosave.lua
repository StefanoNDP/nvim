local M = {}

local wk = require("which-key")

M.keymaps = wk.add({
  mode = { "n" },
  { "<leader>as", ":ASToggle<CR>", desc = "Auto Save toggle" },
})

return M.keymaps
