local M = {}

local wk = require("which-key")

M.keymaps = wk.add({
  mode = { "n" },
  { "<leader>mpt", ":MarkdownPreviewToggle<CR>", desc = "Markdown-Preview toggle" },
  { "<leader>mrt", ":RenderMarkdown toggle<CR>", desc = "Render-Markdown toggle" },
})

return M.keymaps
