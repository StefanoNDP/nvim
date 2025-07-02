local M = {}

local wk = require("which-key")
local conform = ":lua require('conform')."
local lsp = ":lua vim.lsp.buf."
local preview = ":lua require('goto-preview')."
local diagnostic = ":lua vim.diagnostic."
local codelens = ":lua vim.lsp.codelens."

M.keymaps = wk.add({
  {
    mode = { "n" },
    { "gw", lsp .. "document_symbol()<CR>", desc = "" },
    { "gW", lsp .. "workspace_symbol()<CR>", desc = "" },
    { "gD", lsp .. "declaration({ border = 'rounded' })<CR>", desc = "" },
    -- { "K", lsp .. "hover({ popup_opts = { border = 'rounded' } })<CR>", desc = "" },
    {
      "K",
      function()
        vim.lsp.buf.hover({
          border = "rounded",
          max_height = 25,
          max_width = 88,
        })
      end,
      desc = "",
    },
    { "<C-s>", lsp .. "signature_help({ border = 'rounded' })<CR>", desc = "" },
    { "<leader>ca", lsp .. "code_action()<CR>", desc = "" },
    {
      "<leader>cd",
      function()
        vim.diagnostic.open_float(nil, { focus = false })
      end,
      desc = "",
    },
    { "<leader>cA", lsp .. "range_code_action()<CR>", desc = "" },
    -- { "<leader>cr", lsp .. "rename()<CR>", desc = "" },
    {
      "<leader>cr",
      ":IncRename " .. vim.fn.expand("<cword>"),
      desc = "Rename",
    },

    { "<leader>wa", lsp .. "add_workspace_folder()<CR>", desc = "" },
    { "<leader>wr", lsp .. "remove_workspace_folder()<CR>", desc = "" },
    {
      "<leader>wi",
      "<cmd>print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
      desc = "",
    },

    { "gd", lsp .. "definition()<CR>", desc = "Go to definition" },
    { "gtd", lsp .. "type_definition()<CR>", desc = "Go to type definition" },
    { "gr", lsp .. "references()<CR>", desc = "Go to reference" },
    { "gi", lsp .. "implementation()<CR>", desc = "Go to implementation" },

    { "gpd", preview .. "goto_preview_definition()<CR>", desc = "" },
    { "gpt", preview .. "goto_preview_type_definition()<CR>", desc = "" },
    { "gpD", preview .. "goto_preview_declaration()<CR>", desc = "" },
    { "gpi", preview .. "goto_preview_implementation()<CR>", desc = "" },
    { "gpr", preview .. "goto_preview_references()<CR>", desc = "" },
    { "gP", preview .. "close_all_win()<CR>", desc = "" },

    { "gG", diagnostic .. "open_float()<CR>", desc = "" },
    {
      "gL",
      diagnostic .. "show_line_diagnostic({ border = 'rounded' })<CR>",
      desc = "",
    },
    { "]d", diagnostic .. "goto_next({ border = 'rounded' })<CR>", desc = "" },
    { "[d", diagnostic .. "goto_prev({ border = 'rounded' })<CR>", desc = "" },
    { "<leader>sl", ":LspStop<CR>", desc = "" },

    { "<leader>bc", ":Navbuddy<CR>", desc = "Open breadcrumbs" },

    {
      "<leader>cL",
      codelens .. "refresh()<CR>",
      desc = "Refresh & Display Codelens",
    },

    {
      "<leader>lsc",
      function()
        local buf_ft = api.nvim_get_option_value("filetype", { buf = 0 })
        local clients = vim.lsp.get_clients()
        local lclient_names = {}
        for _, lclient in ipairs(clients) do
          local filetypes = lclient.config.filetypes
          -- if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 and lclient.name ~= "null-ls" then
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            -- return client.name
            if
              lclient
              and lclient:supports_method(vim.lsp.protocol.Methods.codeLens, buffer)
            then
              print("True")
              return true
            end
          end
        end
        print("False")
        return false
      end,
      desc = "Check if any attached LSP supports codelens",
    },
  },
  {
    mode = { "n", "v" },
    { "<leader>cl", codelens .. "run()<CR>", desc = "Run Codelens" },
  },
  {
    mode = { "n", "x" },
    {
      "<leader>cf",
      conform .. "format({ bufnr = bufnr })<CR>",
      desc = "Format buffer",
    },
  },
})

return M.keymaps
