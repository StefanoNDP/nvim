local M = {}

local wk = require("which-key")

M.keymaps = wk.add({
  {
    mode = { "v" },
    {
      "<leader>re",
      function()
        require("refactoring").select_refactor({
          show_success_message = true,
        })
      end,
    },
  },
})

return M.keymaps
