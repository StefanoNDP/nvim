local M = {}

local wk = require("which-key")

M.keymaps = wk.add({
  {
    mode = { "n" },
    -- Pomodoro Show UI and Stop
    { "<leader>.n", ":Nvumi<CR>", desc = "Open numi scratch buffer" },
  },
})

return M.keymaps
