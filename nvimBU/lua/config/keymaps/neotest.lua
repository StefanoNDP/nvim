local M = {}

local wk = require("which-key")
local neotest = ":lua require('neotest')."

-- stylua: ignore
M.keymaps = wk.add({
  {
    mode = { "n" },
    { "<leader>t", "", desc = "+test" },
    { "<leader>tf", neotest .. "run.run(vim.fn.expand('%'))<CR>", desc = "Neotest Run File" },
    { "<leader>tF", neotest .. "run.run(vim.uv.cwd())<CR>", desc = "Neotest Run All Test Files" },
    { "<leader>tr", neotest .. "run.run()<CR>", desc = "Neotest Run Nearest" },
    { "<leader>tl", neotest .. "run.run_last()<CR>", desc = "Neotest Run Last" },
    { "<leader>ts", neotest .. "summary.toggle()<CR>", desc = "Neotest Toggle Summary" },
    { "<leader>to", neotest .. "output.open({ enter = true, auto_close = true })<CR>", desc = "Neotest Show Output", },
    { "<leader>tO", neotest .. "output_panel.toggle()<CR>", desc = "Neotest Toggle Output Panel" },
    { "<leader>tS", neotest .. "run.stop()<CR>", desc = "Neotest Stop" },
    { "<leader>tw", neotest .. "watch.toggle(vim.fn.expand(' % '))<CR>", desc = "Neotest Toggle Watch" }
  }
})

return M.keymaps
