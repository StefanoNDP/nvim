local persistence = ":lua require('persistence')."

return {
  { "<leader>qs", persistence .. "load()<CR>", desc = "Restore Session" },
  { "<leader>qS", persistence .. "select()<CR>", desc = "Select Session" },
  { "<leader>ql", persistence .. "load({ last = true })<CR>", desc = "Restore Last Session" },
  { "<leader>qd", persistence .. "stop()<CR>", desc = "Don't Save Current Session" },
}
