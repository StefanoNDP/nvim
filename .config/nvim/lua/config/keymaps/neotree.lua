local M = {}

local wk = require("which-key")
local neotest = ":lua require('neotest')."

-- stylua: ignore
M.keymaps = wk.add({
  {
    mode = { "n" },
    { "<leader>op", ":Neotree toggle<CR>", desc = "Open CWD File Explorer" },
  }
})

return M.keymaps
