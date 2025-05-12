local M = {}

local wk = require("which-key")

M.keymaps = wk.add({
  mode = { "n" },
  { "<leader>tb", function() require("toggle-bool").toggle_bool() end, desc =  "Toggle Bool" }
})

return M.keymaps
