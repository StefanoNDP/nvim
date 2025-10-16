return {
  "folke/trouble.nvim",
  enabled = true,
  version = false,
  event = "VeryLazy",
  dependencies = { "nvim-mini/mini.icons" },
  cmd = "Trouble",
  keys = require("config.keymaps.trouble"),
  opts = function()
    return {
      -- If you use trouble for diagnostics, then you want to exclude the virtual buffers from diagnostics
      modes = {
        diagnostics = {
          filter = function(items)
            return vim.tbl_filter(function(item)
              return not string.match(item.basename, [[%__virtual.cs$]])
            end, items)
          end,
        },
      },
    }
  end,
  config = function(_, opts)
    require("trouble").setup(opts)
  end,
}
