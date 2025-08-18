local M = {}

local wk = require("which-key")

M.keymaps = wk.add({
  mode = { "n" },
  { "gt", "<cmd>BufferLineCycleNext<CR>", desc = "Go to next tab" },
  { "gT", "<cmd>BufferLineCyclePrev<CR>", desc = "Go to previous tab" },
  { "<C-M-l>", "<cmd>BufferLineMoveNext<CR>", desc = "Move tab right" },
  { "<C-M-h>", "<cmd>BufferLineMovePrev<CR>", desc = "Move tab left" },
  { "<C-M-p>", "<cmd>BufferLineTogglePin<CR>", desc = "Pin tab" },
  { "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to tab 1" },
  { "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to tab 2" },
  { "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to tab 3" },
  { "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to tab 4" },
  { "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to tab 5" },
  { "<leader>6", "<cmd>BufferLineGoToBuffer 6<CR>", desc = "Go to tab 6" },
  { "<leader>7", "<cmd>BufferLineGoToBuffer 7<CR>", desc = "Go to tab 7" },
  { "<leader>8", "<cmd>BufferLineGoToBuffer 8<CR>", desc = "Go to tab 8" },
  { "<leader>9", "<cmd>BufferLineGoToBuffer 9<CR>", desc = "Go to tab 9" },
  { "<leader>$", "<cmd>BufferLineGoToBuffer -1<CR>", desc = "Go to last tab" },
  { "<leader>0", "<cmd>BufferLineGoToBuffer +1<CR>", desc = "Go to first tab" },
})

return M.keymaps

