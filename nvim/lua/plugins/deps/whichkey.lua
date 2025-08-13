return {
  "folke/which-key.nvim",
  enabled = true,
  version = false,
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    spec = {
      {
        mode = { "n", "v" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "gx", desc = "Open with system app" }, -- better descriptions
        { "z", group = "fold" },
        { "<leader>ts", group = "TS CPP Tools" },
        { "<leader>q", group = "persistence" },
        { "<leader>p", group = "pomodoro" },
        { "<leader>d", group = "dap" },
        { "<leader>r", group = "refactoring" },
        { "<leader>t", group = "neotest" },
        { "<leader>f", group = "file/find" },
        { "<leader>c", group = "code" },
        { "<leader>x", group = "trouble" },
        { "<leader>z", group = "zen" },
        {
          "<leader>b",
          group = "buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "windows",
          proxy = "<c-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
}
