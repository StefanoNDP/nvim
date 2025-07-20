return {
  { "mbbill/undotree", enabled = true, version = false, event = "VeryLazy" },
  { "mg979/vim-visual-multi", enabled = true, version = false, event = "VeryLazy" },
  { "tpope/vim-abolish", enabled = true, version = false, event = "VeryLazy" },
  { "tpope/vim-repeat", enabled = true, version = false, event = "VeryLazy" },
  {
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
  },
}
