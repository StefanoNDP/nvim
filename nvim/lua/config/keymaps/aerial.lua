local snack = ":lua require('aerial')."

return {
  { "<leader>bC", "<cmd>AerialToggle<CR>", desc = "Aerial (Symbols)" },
  { "<leader>bS", snack .. "snacks_picker()<CR>", desc = "Aerial (Symbols)" },
}
