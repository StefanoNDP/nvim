local M = {}

local wk = require("which-key")

M.keymaps = wk.add({
  mode = { "n" },
  { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<CR>", desc = "Switch Source/Header (C/C++)" },
  -- switch between header and source file creating if any are missing
  {
    "<M-o>",
    function()
      local filename = vim.fn.expand("%:p")
      local new_filename

      if string.match(filename, ".h$") then
        new_filename = string.gsub(filename, ".h$", ".cpp")
      elseif string.match(filename, ".cpp$") then
        new_filename = string.gsub(filename, ".cpp$", ".h")
      end

      if new_filename then
        vim.cmd("e " .. new_filename)
      end
    end,
    desc = "Switch Source/Header (C/C++), create them if needed.",
  },
  { "<leader>tsd", ":TSCppDefineClassFunc<CR>", desc = "Implement out of class member function" },
  { "<leader>tsc", ":TSCppMakeConcreteClass<CR>", desc = "Create concrete class" },
  { "<leader>ts3", ":TSCppRuleOf3<CR>", desc = "Adds missing functions declarations to obey rule of 3" },
  { "<leader>ts5", ":TSCppRuleOf5<CR>", desc = "Adds missing functions declarations to obey rule of 5" },
})

return M.keymaps
