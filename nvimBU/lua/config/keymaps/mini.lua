local M = {}

local wk = require("which-key")

M.keymaps = wk.add({
  mode = { "n", "x" },
  { "s", "<Nop>" }
})

return M.keymaps
