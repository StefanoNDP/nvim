local M = {}

local wk = require("which-key")

M.keymaps = wk.add({
  mode = { "n" },
  { "<leader>ct", "<cmd>CloakToggle<CR>", desc = "Cloak toggle" },
})

return M.keymaps
