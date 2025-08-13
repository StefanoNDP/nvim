local M = {}

local wk = require("which-key")

M.keymaps = wk.add({
  {
    mode = { "v" },
    { "<leader>z", "", desc = "+Zen" },
    { "<leader>zn", ":'<,'>Narrow<CR>", desc = "Zen Narrow Visual" },
  },
  {
    mode = { "n" },
    { "<leader>z", "", desc = "+Zen" },
    { "<leader>zn", ":Narrow<CR>", desc = "Zen Narrow" },
    { "<leader>zf", ":Focus<CR>", desc = "Zen Focus" },
    { "<leader>zz", ":Zen<CR>", desc = "Zen Minimalist" },
  },
})

return M.keymaps
