-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

---@diagnostic disable-next-line: undefined-field
local concurrency = (vim.uv.available_parallelism())

-- Setup lazy.nvim
require("lazy").setup({
  concurrency = concurrency,
  rocks = {
    hererocks = true,
  },
  spec = {
    { import = "plugins.colorscheme" },
    { import = "plugins.deps" },
    { import = "plugins.ui" },
    { import = "plugins.treesitter" },
    { import = "plugins.editor" },
    { import = "plugins.lang" },
    { import = "plugins.coding" },

    { import = "plugins.dap.servers" },
    { import = "plugins.dap" },
    { import = "plugins.lsp" },
    { import = "plugins.lsp.servers" },
    { import = "plugins.formatting" },
    { import = "plugins.linting" },

    { import = "plugins.util" },
    { import = "plugins.test" },
    { import = "plugins.misc" },
  },
  ui = {
    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = "rounded",
    -- The backdrop opacity. 0 is fully opaque, 100 is fully transparent. Default: 60
    backdrop = 60,
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "catppuccin-mocha" } },
  -- automatically check for plugin updates
  checker = {
    enabled = true,
    notify = false,
    concurrency = concurrency,
  },
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
