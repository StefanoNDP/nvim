return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    ft = { "markdown", "markdown.mdx", "rmd", "org", "norg" },
    version = false,
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
    opts = function()
      return {
        pipe_table = { preset = "round" },
        link = {
          render_modes = true,
        },
        completions = {
          lsp = { enabled = true },
        },
        preset = "obsidian",
        filetypes = { "markdown", "markdown.mdx" },
      }
    end,
    config = function(_, opts)
      require("render-markdown").setup(opts)
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    enabled = true,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown", "markdown.mdx", "rmd", "org", "norg" },
    version = false,
    lazy = true,
    build = "cd app && npm install && git restore .",
    -- build = "cd app && yarn install && git restore .", -- If you prefer yarn over npm
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      require("config.keymaps.languages.markdown")
    end,
  },
}
