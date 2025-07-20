local M = {}

local dap = ":lua require('dap')."
local dapui
if vim.g.whichDap == 0 then
  dapui = ":lua require('dapui')."
else
  dapui = ":lua require('dap-view')."
end
local widgets = ":lua require('dap.ui.widgets')."
local neotest = ":lua require('neotest')."
local vimkind = ":lua require('osv')."

local wk = require("which-key")

M.keymaps = wk.add({
  {
    mode = { "n" },
    { "<leader>du", dapui .. "toggle()<CR>", desc = "DAP Toggle" }, -- DAP View
    -- stylua: ignore
    { "<leader>dB", dap .. "set_breakpoint(vim.fn.input('Condition: '))", desc = "Breakpoint Condition" },
    {
      "<leader>d<space>",
      function()
        require("which-key").show({ delay = 1000000000, keys = "<leader>d", loop = true })
      end,
      desc = "DAP Hydra Mode (which-key)",
    },
    {
      "<leader>dR",
      function()
        local dapl = require("dap")
        local extension = vim.fn.expand("%:e")
        dapl.run(dapl.configurations[extension][1])
      end,
      desc = "Run default configuration",
    },
    { "<leader>db", dap .. "toggle_breakpoint()<CR>", desc = "DAP Toggle Breakpoint" },
    { "<leader>dc", dap .. "continue()<CR>", desc = "DAP Run/Continue" },
    { "<leader>da", dap .. "continue({ before = get_args })<CR>", desc = "DAP Run with Args" },
    { "<leader>dC", dap .. "run_to_cursor()<CR>", desc = "DAP Run to Cursor" },
    { "<leader>dg", dap .. "goto_()<CR>", desc = "DAP Go to Line (No Execute)" },
    { "<leader>di", dap .. "step_into()<CR>", desc = "DAP Step Into" },
    { "<leader>dj", dap .. "down()<CR>", desc = "DAP Down" },
    { "<leader>dk", dap .. "up()<CR>", desc = "DAP Up" },
    { "<leader>dl", dap .. "run_last()<CR>", desc = "DAP Run Last" },
    { "<leader>dL", vimkind .. "launch({ port = 8086 })<CR>", desc = "DAP Start Lua DAP" },
    { "<leader>do", dap .. "step_out()<CR>", desc = "DAP Step Out" },
    { "<leader>dO", dap .. "step_over()<CR>", desc = "DAP Step Over" },
    { "<leader>dP", dap .. "pause()<CR>", desc = "DAP Pause" },
    { "<leader>dr", dap .. "restart()<CR>", desc = "DAP Restart" },
    -- { "<leader>dr", dap .. "repl.toggle()<CR>", desc = "DAP Toggle REPL" },
    { "<leader>ds", dap .. "session()<CR>", desc = "DAP Session" },
    { "<leader>dT", dap .. "terminate()<CR>", desc = "DAP Terminate" },
    { "<leader>dw", widgets .. "hover()<CR>", desc = "DAP Widgets" },
    { "<leader>dn", neotest .. "run.run({ strategy = 'dap' })<CR>", desc = "Debug Nearest" },
  },
  {
    mode = { "n", "v" },
    { "<leader>d", "", desc = "+debuf" },
    { "<leader>de", dapui .. "eval()<CR>", desc = "Eval" },
  },
})

return M.keymaps
