return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    enabled = true,
    dependencies = { "williamboman/mason.nvim" },
    version = false,
    config = function()
      require("mason-nvim-dap").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = true,
    dependencies = { "williamboman/mason.nvim" },
    version = false,
    config = function()
      require("mason-lspconfig").setup()
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    enabled = true,
    dependencies = { "williamboman/mason.nvim" },
    version = false,
    opts = function()
      return {
        ensure_installed = {
          -- -- BASH
          -- "bash-language-server", -- LSP
          -- "bash-debug-adapter", -- DAP
          -- "shellharden", -- formatter and linter
          -- -- C/C++
          -- "clangd", -- LSP and linter
          -- "codelldb", -- DAP (lldb)
          -- "clang-format", -- formatter
          -- CSHARP
          "csharpier", -- Formatter
          "netcoredbg", -- DAP
          "roslyn", -- LSP
          "rzls", -- LSP -- Use ':MasonInstall rzls@9.0.0-preview.25156.2' instead
          -- GODOT SCRIPT
          "gdtoolkit", -- formatter and linter
          -- HTML
          "html-lsp",
          -- CSS
          "css-lsp",
          -- JavaScript/TypeScript
          "typescript-language-server", -- LSP
          "tailwindcss-language-server", -- LSP
          "vtsls", -- LSP
          -- "js-debug-adapter", -- DAP
          -- -- JSON
          "jsonls", -- LSP
          -- LUA
          "lua-language-server", -- LSP
          "stylua", -- formatter and linter
          -- MARKDOWN
          "marksman",
          "markdownlint-cli2", -- Linter
          -- "markdown-toc", -- TOC Formatter
          -- -- SQL
          -- "sqlls", -- LSP
          -- "sql-formatter", -- formatter
          -- "sqlfluff", -- linter
          -- XML
          "lemminx", -- LSP
          "sonarlint-language-server", -- Linter
          "xmlformatter", -- formatter
          -- -- YAML
          -- "yaml-language-server", -- LSP
          -- "yamllint", -- linter
          -- -- GLOBAL
          "prettierd", -- formatter - Markdown
        },
        automatic_installation = true,
        auto_update = true,
        run_on_start = true,
        start_delay = 1500, -- Millisseconds
      }
    end,
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    enabled = true,
    version = false,
    -- priority = 1000,
    -- lazy = false,
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonInstallAll",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    build = ":MasonUpdate",
    opts = function()
      return {
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        },
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      }
    end,
    config = function(_, opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsStartingInstall",
        callback = function()
          vim.schedule(function()
            print("mason-tool-installer is starting")
          end)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsUpdateCompleted",
        callback = function(e)
          vim.schedule(function()
            print(vim.inspect(e.data)) -- print the table that lists the programs that were installed
          end)
        end,
      })

      require("mason").setup(opts)
    end,
  },
}
