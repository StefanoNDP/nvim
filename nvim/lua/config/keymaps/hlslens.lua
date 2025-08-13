local M = {}

local wk = require("which-key")

M.keymaps = wk.add({
  mode = { "n" },
  {
    "n",
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
    desc = ""
  },
  {
    "N",
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    desc = ""
  },
  {
    "*",
    [[*<Cmd>lua require('hlslens').start()<CR>]],
    desc = ""
  },
  {
    "#",
    [[#<Cmd>lua require('hlslens').start()<CR>]],
    desc = ""
  },
  {
    "g*",
    [[g*<Cmd>lua require('hlslens').start()<CR>]],
    desc = ""
  },
  {
    "g#",
    [[g#<Cmd>lua require('hlslens').start()<CR>]],
    desc = ""
  }
})

return M.keymaps
