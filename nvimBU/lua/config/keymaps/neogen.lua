local M = {}

local wk = require("which-key")
local neogen = require("neogen")

M.keymaps = wk.add({
  mode = { "n" },
  {
    "<leader>ngf",
    function()
      neogen.generate({ type = "func" })
    end,
    desc = "Neogen function",
  },
  {
    "<leader>ngc",
    function()
      neogen.generate({ type = "class" })
    end,
    desc = "Neogen class",
  },
  {
    "<leader>ngt",
    function()
      neogen.generate({ type = "type" })
    end,
    desc = "Neogen type",
  },
  {
    "<leader>ngn",
    function()
      neogen.generate()
    end,
    desc = "Neogen Annotations",
  },
})

return M.keymaps
