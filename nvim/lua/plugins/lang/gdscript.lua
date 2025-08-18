return { -- Godot/GDScript
  "habamax/vim-godot",
  enabled = true,
  version = false,
  event = "VeryLazy",
  -- ft = { "gd", "gdscript", "gdscript3" },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "gdscript",
        "gdshader",
        "godot_resource",
      },
    })
  end,
}
