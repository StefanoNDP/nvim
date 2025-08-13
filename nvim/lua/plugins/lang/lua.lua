return { -- LUA
  "folke/lazydev.nvim",
  enabled = true,
  version = false,
  dependencies = {
    "Bilal2453/luvit-meta", -- optional `vim.uv` typings
    "rcarriga/nvim-dap-ui",
    "folke/snacks.nvim",
  },
  ft = "lua", -- only load on lua files
  cmd = "LazyDev",
  opts = {
    library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "luvit-meta/library", words = { "vim%.uv" } },
      { path = "LazyVim", words = { "LazyVim" } },
      { path = "snacks.nvim", words = { "Snacks" } },
      { path = "lazy.nvim", words = { "LazyVim" } },
      { plugins = { "nvim-dap-ui" }, types = true },
      "nvim-dap-ui",
    },
  },
}
