local M = {}

local wk = require("which-key")
local refactor = ": lua require('refactoring')."

-- stylua: ignore start
M.keymaps = wk.add({
  {
    mode = { "n" },
    { "<leader>rb", refactor .. "refactor('Extract Block')<CR>", desc = "Extract Block" },
    { "<leader>rf", refactor .. "refactor('Extract Block To File')<CR>", desc = "Extract Block To File" },
    { "<leader>rP", refactor .. "debug.printf({ below = false })<CR>", desc = "Debug Print" },
    { "<leader>rp", refactor .. "debug.print_var({ normal = true })<CR>", desc = "Debug Print Variable" },
    { "<leader>rc", refactor .. "debug.cleanup({})<CR>", desc = "Debug Cleanup" },
  },
  {
    mode = { "v" },
    -- { "<leader>rs", Snacks.picker.pick("refactoring"), desc = "Refactor" },
        {
      "<leader>re",
      function()
        require("refactoring").select_refactor({
          show_success_message = true,
        })
      end,
    },
    { "<leader>rf", refactor .. "refactor('Extract Function')<CR>", desc = "Extract Function" },
    { "<leader>rF", refactor .. "refactor('Extract Function To File')<CR>", desc = "Extract Function To File", },
    { "<leader>rv", refactor .. "refactor('Extract Variable')<CR>", desc = "Extract Variable" },
    { "<leader>rp", refactor .. "debug.print_var()<CR>", desc = "Debug Print Variable" },
  },
  {
    mode = { "n", "v" },
    { "<leader>r", "", desc = "+refactor" },
    { "<leader>ri", refactor .. "refactor('Inline Variable')<CR>", desc = "Inline Variable" },
  },
})

return M.keymaps
