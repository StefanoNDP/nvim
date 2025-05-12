return {
  "stevearc/conform.nvim",
  enabled = true,
  version = false,
  lazy = true,
  cmd = "ConformInfo",
  opts = function()
    return {
      formatters = {
        biome = {
          -- args = { "--fix" },
          require_cwd = true,
        },
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
        -- csharpier = {
        --   command = "dotnet-csharpier",
        --   args = { "--write-stdout" },
        -- },
        csharpier = {
          command = "csharpier",
          args = { "format", "$FILENAME" },
          stdin = false,
          require_cwd = true,
        },
        sqlfluff = {
          args = { "format", "--dialect=ansi", "-" },
        },
      },
      formatters_by_ft = {
        bash = { "shellharden" },
        c = { "clang-format" },
        cc = { "clang-format" },
        cpp = { "clang-format" },
        cs = { "csharpier" },
        csharp = { "csharpier" },
        lua = { "stylua" },
        gdscript = { "gdformat" },
        objc = { "clang-format" },
        objcpp = { "clang-format" },
        opencl = { "clang-format" },
        json = { "biome" },
        jsonc = { "biome" },
        sql = { "sqlfluff" },
        mysql = { "sqlfluff" },
        plsql = { "sqlfluff" },
        ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" }, -- Don't stop after first
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" }, -- Don't stop after first
        javascript = { "biome" },
        javascriptreact = { "biome" },
        ["javascript.jsx"] = { "biome" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
        ["typescript.tsx"] = { "biome" },
        -- Stop searching after finding first formatter
        -- name = { "formatter1", "formatter2", stop_after_first = true },
      },
      format_on_save = {
        timeout_ms = 2500,
        lsp_format = "fallback",
      },
    }
  end,
  config = function(_, opts)
    require("conform").setup(opts)
  end,
}
