local M = {}

local wk = require("which-key")
local luasnip = require("luasnip")

M.keymaps = wk.add({
  {
    mode = { "i" },
    {
      "<C-s>e",
      function()
        luasnip.expand()
      end,
      desc = ""
    },
  }
  {
    mode = { "i", "s" },
    {
      "<C-s>,",
      function()
        luasnip.jump(1)
      end, desc = ""
    },
    {
      "<C-s>.",
      function()
        luasnip.jump(-1)
      end, desc = ""
    },
    {
      "<C-s>c",
      function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end,
      desc = ""
    },
  }
})

return M.keymaps
