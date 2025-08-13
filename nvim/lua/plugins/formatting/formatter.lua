return {
  "stevearc/conform.nvim",
  enabled = true,
  version = false,
  lazy = false,
  cmd = "ConformInfo",
  opts = function()
    return {
      formatters = {
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find("<!%-%- toc %-%->") or line:find("<!%-%-toc:start%-%->") then
                return true
              end
            end
          end,
        },
        ["markdownlint-cli2"] = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == "markdownlint"
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },
        csharpier = {
          command = "csharpier",
          args = { "format", "$FILENAME" },
          stdin = false,
          require_cwd = true,
        },
        xmlformatter = {
          command = "xmlformat --blanks indent-char ' ' compress",
        },
        prettier = {
          --   command = "prettierd",
          --   args = { vim.api.nvim_buf_get_name(0) },
          stdin = true,
        },
        sqlfluff = {
          args = { "format", "--dialect=ansi", "-" },
        },
      },
      formatters_by_ft = {
        bash = { "shellharden" },
        cs = { "csharpier" },
        csharp = { "csharpier" },
        lua = { "stylua" },
        gdscript = { "gdformat" },
        json = { "prettier" },
        jsonc = { "prettier" },
        json5 = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        cshtml = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        xml = { "xmlformatter" },
        ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" }, -- Don't stop after first
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" }, -- Don't stop after first
        -- Stop searching after finding first formatter
        -- name = { "formatter1", "formatter2", stop_after_first = true },
      },
      format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
      },
    }
  end,
  config = function(_, opts)
    require("conform").setup(opts)
  end,
}
