local tc = ":lua require('todo-comments')."

return {
  { "]t", tc .. "jump_next()<CR>", desc = "Next Todo Comment" },
  { "[t", tc .. "jump_prev()<CR>", desc = "Previous Todo Comment" },
}
