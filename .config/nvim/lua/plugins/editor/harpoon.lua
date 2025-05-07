return { -- fast file access
  "theprimeagen/harpoon",
  enabled = true,
  version = false,
  branch = "harpoon2",
  event = "VeryLazy",
  requires = {
    { "nvim-lua/plenary.nvim" },
  },
  opts = function()
    return {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    }
  end,
  config = function(_, opts)
    require("harpoon").setup(opts)
    require("config.keymaps.harpoon")
  end,
}
