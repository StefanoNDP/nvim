return {
  "danymat/neogen",
  enabled = vim.g.isDesktop,
  version = false,
  event = "VeryLazy",
  cmd = "Neogen",
  dependencies = { "nvim-treesitter/nvim-treesitter", "L3MON4D3/LuaSnip" },
  opts = function()
    require("config.keymaps.neogen")
    return {
      snippet_engine = "luasnip",
    }
  end,
  config = function(_, opts)
    require("neogen").setup(opts)
  end,
}
