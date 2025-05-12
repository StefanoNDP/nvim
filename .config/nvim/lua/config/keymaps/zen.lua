local M = {}

local wk = require("which-key")

M.keymaps = wk.add({
    {
      mode = { "v" },
      { "<leader>zn", ":'<,'>TZNarrow<CR>", desc = "Zen Narrow Visual" },
    },
    {
      mode = { "n" },
      { "<leader>zn", ":TZNarrow<CR>", desc = "Zen Narrow" },
      { "<leader>zf", ":TZFocus<CR>", desc = "Zen Focus" },
      { "<leader>zm", ":TZMinimalist<CR>", desc = "Zen Minimalist" },
      { "<leader>za", ":TZAtaraxis<CR>", desc = "Zen Ataraxis" }
    },
})

return M.keymaps

