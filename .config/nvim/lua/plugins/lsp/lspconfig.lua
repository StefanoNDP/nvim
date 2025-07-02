local api = vim.api

return {
  {
    "antosha417/nvim-lsp-file-operations",
    opts = function()
      return {
        -- used to see debug logs in file `vim.fn.stdpath("cache") .. lsp-file-operations.log`
        debug = false,
        -- select which file operations to enable
        operations = {
          willRenameFiles = true,
          didRenameFiles = true,
          willCreateFiles = true,
          didCreateFiles = true,
          willDeleteFiles = true,
          didDeleteFiles = true,
        },
        -- how long to wait (in milliseconds) for file rename information before cancelling
        timeout_ms = 10000,
      }
    end,
    config = function(_, opts)
      require("lsp-file-operations").setup(opts)
    end,
  },
  { -- Preview
    "rmagatti/goto-preview",
    enabled = true,
    version = false,
    lazy = true,
    dependencies = { "rmagatti/logger.nvim" },
    event = "BufEnter",
    opts = function()
      return {
        width = 90, -- Width of the floating window
        height = 20, -- Height of the floating window
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }, -- Border characters of the floating window
        default_mappings = true,
        debug = false, -- Print debug information
        opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
        resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
        post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        -- references = { -- Configure the telescope UI for slowing the references cycling window.
        --   telescope = require("telescope.themes").get_dropdown({ hide_preview = false }),
        -- },
        -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
        focus_on_open = true, -- Focus the floating window when opening it.
        dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
        force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
        bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
        stack_floating_preview_windows = true, -- Whether to nest floating windows
        preview_window_title = { enable = true, position = "left" }, -- Whether
      }
    end,
    config = function(_, opts)
      require("goto-preview").setup(opts)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    version = false,
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    after = "folke/neoconf.nvim",
    dependencies = { "folke/neoconf.nvim", "williamboman/mason.nvim" },
    opts = function()
      require("config.keymaps.lspconfig")
      return {
        servers = {
          tsserver = { enabled = false },
          ts_ls = { enabled = false },
        },
        setup = {
          tsserver = function()
            return true
          end,
          ts_ls = function()
            return true
          end,
        },
        codelens = {
          enable = true,
        },
        inlay_hints = {
          enabled = true,
          -- exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
      }
    end,
    config = function(_, opts)
      local vars = require("config.vars")
      local maxSize = vars.maxFileSize
      local size = vim.fn.getfsize(vim.fn.expand("%"))
      if size >= maxSize then
        local clients = vim.lsp.get_clients()
        for _, lclient in ipairs(clients) do
          vim.lsp.stop_client(lclient)
        end
        return
      end

      local lgroup = api.nvim_create_augroup("UserLspConfig", {})

      api.nvim_create_autocmd("LspAttach", {
        group = lgroup,
        callback = function(event)
          local buffer = event.data.buffer
          local bufnr = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Enable completion triggered by <c-x><c-o>
          -- api.nvim_command("setlocal omnifunc=v:lua.vim.lsp.omnifunc")

          -- Codelens
          -- if client and client:supports_method(vim.lsp.protocol.Methods.codeLens) then
          if
            client and client:supports_method(vim.lsp.protocol.Methods.codelens, buffer)
          then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd(
              -- { "BufWritePost", "BufEnter", "CursorHold", "InsertLeave", "TextChanged" },
              { "BufWritePost", "BufEnter", "InsertLeave", "TextChanged" },
              {
                buffer = buffer,
                callback = vim.lsp.codelens.refresh,
              }
            )
          end

          -- if client and client:supports_method(vim.lsp.protocol.Methods.inlayHint) then
          --   if
          --     api.nvim_buf_is_valid(bufnr)
          --     and vim.bo[bufnr].buftype == ""
          --     and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[bufnr].filetype)
          --   then
          --     vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          --   end
          -- end
        end,
      })

      -- border = "rounded",
      vim.diagnostic.config({
        underline = true,
        update_in_insert = true,
        float = {
          focusable = false,
          border = "rounded",
          style = "minimal",
          source = true,
          header = "",
          prefix = "",
        },
        virtual_text = false,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "⚑",
            [vim.diagnostic.severity.INFO] = "»",
          },
          linehl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
          },
          numhl = {
            [vim.diagnostic.severity.WARN] = "WarningMsg",
          },
        },
      })

      -- Show line diagnostics automatically in hover window
      -- vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])
    end,
  },
}
