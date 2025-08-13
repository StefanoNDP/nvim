return {
  "MunifTanjim/prettier.nvim",
  enabled = true,
  version = false,
  opts = function()
    return {
      bin = "prettierd",
      filetypes = {
        "css",
        "graphql",
        "cshtml",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "json5",
        "jsonc",
        "less",
        "markdown",
        "scss",
        "typescript",
        "typescriptreact",
        "yaml",
      },
    }
  end,
  config = function(_, opts)
    require("prettier").setup(opts)
  end,
}
