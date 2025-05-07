return {
  -- "pocco81/true-zen.nvim" -- Original, seems to be unmaintained
  "mrcapivaro/true-zen.nvim",
  enabled = true,
  version = false,
  opts = function()
    require("config.keymaps.zen")
    return {
      modes = {
        narrow = {},
      },
      integrations = {
        tmux = true, -- hide tmux status bar in (minimalist, ataraxis)
        kitty = { -- increment font size in Kitty. Note: you must set `allow_remote_control socket-only` and `listen_on unix:/tmp/kitty` in your personal config (ataraxis)
          enabled = true,
          font = "+3", -- Not working
        },
        twilight = false, -- enable twilight (ataraxis)
        lualine = true, -- hide nvim-lualine (ataraxis)
      },
    }
  end,
  config = function(_, opts)
    -- vim.wo.foldmethod = "manual" -- Doesn't work with treesitter folds
    require("true-zen").setup(opts)
  end,
}
