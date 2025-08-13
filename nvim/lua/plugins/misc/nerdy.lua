return {
  "2kabhishek/nerdy.nvim",
  dependencies = { "folke/snacks.nvim" },
  enabled = true,
  version = false,
  cmd = "Nerdy",
  event = "VeryLazy",
  opts = {
    max_recents = 30,
    add_default_keybindings = true,
    use_new_command = true,
  },
  config = true,
}
