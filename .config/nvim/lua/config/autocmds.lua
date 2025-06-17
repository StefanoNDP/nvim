local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- -- Set cwd when entering
-- vim.cmd([[
-- autocmd!
-- autocmd VimEnter * cd $PWD
-- ]])

-- Omnifunc
-- api.nvim_command("setlocal omnifunc=v:lua.vim.lsp.omnifunc")
vim.cmd([[autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni]])

-- Turn on/off tmux statusline on vim enter/leave
vim.cmd([[silent !tmux set status off]]) -- VimEnter conflicts with Snacks Explorer's preview
vim.cmd([[autocmd VimLeave * silent !tmux set status on]])

-- ftplugin start
local ftmodule = "ftplugin.%s"
local function loadftmodule(ft, action)
  local modname = ftmodule:format(ft)
  local _, res = pcall(require, modname)
  if type(res) == "table" then
    if type(res[action]) == "function" then
      res[action]()
    end
  elseif
    type(res) == "string"
    and not res:match("Module '" .. modname .. "' not found")
    and not res:match("	no file")
  then
    print(res)
  end
end

vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "BufWinEnter", "Colorscheme" }, {
  pattern = { "*" },
  callback = function()
    loadftmodule(vim.bo.filetype, "ftplugin")
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "*" },
  callback = function()
    loadftmodule(vim.bo.filetype, "newfile")
  end,
})

vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "VimEnter", "BufWinEnter", "Colorscheme" }, {
  pattern = { "*" },
  callback = function()
    loadftmodule(vim.bo.filetype, "syntax")
  end,
})
-- ftplugin end

-- It's free real estate
-- vim.opt.cmdheight = 0

-- Remove trailing ^M
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\r\+$//e]],
})

-- Set conceallevel for certain file types
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("ft_conceal"),
  pattern = { "*.md", "*.json", "*.org", "*.norg", "markdown", "markdown.mdx", "rmd", "org", "norg" },
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- -- Fix conceallevel for json files
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   group = augroup("json_conceal"),
--   pattern = { "json", "jsonc", "json5" },
--   callback = function()
--     vim.opt_local.conceallevel = 0
--   end,
-- })

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Reenable DoMatchParen if it was disabled by a BigFile
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local vars = require("config.vars")
    local maxSize = vars.maxFileSize
    local size = vim.fn.getfsize(vim.fn.expand("%"))
    if size >= maxSize then
      -- vim.cmd([[autocmd BufDelete * silent :DoMatchParen]])
      vim.cmd([[:DoMatchParen]])
    end
  end,
})

-- Roslyn: Diagnostic refresh
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave", "TextChanged" }, {
  pattern = "*",
  callback = function()
    local clients = vim.lsp.get_clients({ name = "roslyn" })
    if not clients or #clients == 0 then
      return
    end

    local buffers = vim.lsp.get_buffers_by_client_id(clients[1].id)
    for _, buf in ipairs(buffers) do
      vim.lsp.util._refresh("textDocument/diagnostic", { bufnr = buf })
    end
  end,
})

-- Roslyn: textDocument/_vs_onAutoInsert
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    if client and (client.name == "roslyn" or client.name == "roslyn_ls") then
      vim.api.nvim_create_autocmd("InsertCharPre", {
        desc = "Roslyn: Trigger an auto insert on '/'.",
        buffer = bufnr,
        callback = function()
          local char = vim.v.char

          if char ~= "/" then
            return
          end

          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          row, col = row - 1, col + 1
          local uri = vim.uri_from_bufnr(bufnr)

          local params = {
            _vs_textDocument = { uri = uri },
            _vs_position = { line = row, character = col },
            _vs_ch = char,
            _vs_options = {
              tabSize = vim.bo[bufnr].tabstop,
              insertSpaces = vim.bo[bufnr].expandtab,
            },
          }

          -- NOTE: We should send textDocument/_vs_onAutoInsert request only after
          -- buffer has changed.
          vim.defer_fn(function()
            client:request(
              ---@diagnostic disable-next-line: param-type-mismatch
              "textDocument/_vs_onAutoInsert",
              params,
              function(err, result, _)
                if err or not result then
                  return
                end

                vim.snippet.expand(result._vs_textEdit.newText)
              end,
              bufnr
            )
          end, 1)
        end,
      })
    end
  end,
})

-- Example of a file watcher using Neovim's built-in autocommands
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.csproj" },
  callback = function()
    -- Send a /filesChanged request to the LSP server
    vim.lsp.buf.execute_command({
      command = "workspace/didChangeWatchedFiles",
      arguments = {
        {
          changes = {
            {
              uri = vim.uri_from_fname(vim.fn.expand("<afile>")),
              type = 2, -- Changed
            },
          },
        },
      },
    })
  end,
})

-- Map "q" to quit in nvim-dap-ui/view
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
  callback = function(evt)
    require("which-key").add({ mode = { "n" }, { "q", "<C-w>q", buffer = evt.buf } })
  end,
})
