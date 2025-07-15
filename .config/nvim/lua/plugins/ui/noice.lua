return {
  {
    "folke/noice.nvim",
    version = false,
    enabled = true,
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  {
    "j-hui/fidget.nvim",
    version = false,
    enabled = true,
    opts = function()
      return {}
    end,
    config = function(_, opts)
      require("fidget").setup(opts)
    end,
  },
}
