local M = {}

local vars = require("config.vars")

-- Credits to @wookayin: https://github.com/tpope/vim-repeat/issues/92#issuecomment-1826910664
-- I modified his code to accept both string and function instead of function only
-- Not to be used directly, use my the function below it: rMap

---Register a global internal keymap that wraps `rhs` to be repeatable.
---@param mode string|table keymap mode, see vim.keymap.set()
---@param lhs string lhs of the internal keymap to be created, should be in the form `<Plug>(...)`
---@param rhs string|function rhs of the keymap, see vim.keymap.set()
---@return string The name of a registered internal `<Plug>(name)` keymap. Make sure you use { remap = true }.
M.make_repeatable_keymap = function(mode, lhs, rhs)
  vim.validate({
    mode = { mode, { "string", "table" } },
    rhs = { rhs, { "string", "function" }, lhs = { name = "string" } },
  })
  if not vim.startswith(lhs, "<Plug>") then
    error("`lhs` should start with `<Plug>`, given: " .. lhs)
  end
  vim.keymap.set(mode, lhs, function()
    (type(rhs) == "function" and rhs or vim.api.nvim_input)(rhs)
    vim.fn["repeat#set"](vim.api.nvim_replace_termcodes(lhs, true, true, true))
  end)
  return lhs
end

---Wrapper of the above function, you use it just like you would use vim.keymap.set
---The only difference is the added "name" argument, which will be used by the function above
---@param mode string: Text mode: (i)nsert, (v)isual, (n)ormal, etc
---@param key  string: Keymap: a, b, <C-s>, <leader>a, etc
---@param name string: UNIQUE name for the function, can be whatever you want as long as it's UNIQUE
---@param func string|function: Function to run
---@param opts table: vim.keymap.set's options: description, remap, silent, etc
M.repeatable_keymap_set = function(mode, key, name, func, opts)
  mode = mode or ""
  key = key or ""
  name = name or ""
  opts = opts or {}
  func = func or ""
  assert(type(mode) == "string", "Expected a string value from mode")
  assert(mode and #mode > 0, "Expected a non-empty string from mode")
  assert(type(key) == "string", "Expected a string value from key")
  assert(key and #key > 0, "Expected a non-empty string from key")
  assert(type(name) == "string", "Expected a string value from name")
  assert(name and #name > 0, "Expected a non-empty string from name")
  assert(type(opts) == "table", "Expected a table from opts")
  assert(type(func) == "function" or "string", "Expected a function or string from func")
  assert(func and #func > 0, "Expected a non-empty string from func")
  vim.keymap.set(mode, key, M.make_repeatable_keymap(mode, "<Plug>(" .. name .. ")", func), opts)
end

M.getOS = function()
  return (vim.uv or vim.loop).os_uname().sysname
end

M.getOSLowerCase = function()
  return (vim.uv or vim.loop).os_uname().sysname:lower()
end

M.ignore = function(filename)
  filename = filename or ""
  assert(type(filename) == "string", "Expected a string value from filename")
  local lines = {}
  local ignorefile = vim.fn.getcwd() .. "/" .. filename
  if vim.fn.filereadable(ignorefile) == 1 then
    for line in io.lines(ignorefile) do
      table.insert(lines, tostring(line))
    end
  end
  return lines
end

M.ext = function(opts, args)
  vim.tbl_deep_extend("force", opts, args)
end

M.kmExt = function(args)
  vim.tbl_deep_extend("force", vars.kmOpts, args)
end

--- @param fname table|string
--- @param git boolean
M.getRoot = function(name, git)
  local ret = require("lspconfig.util").root_pattern(name)
  if git then
    ret = require("lspconfig.util").root_pattern(name) or require("lspconfig.util").find_git_ancestor
  end
  return ret
end

M.reloadModule = function(name)
  require("plenary.reload").reload_module(name)
end

M.isLoaded = function(name)
  assert(type(name) == "string", "Expected a string value")
  return package.loaded[name]
end

M.action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

---@param opts LspCommand
function M.execute(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }
  if opts.open then
    require("trouble").open({
      mode = "lsp_command",
      params = params,
    })
  else
    return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
  end
end

---@param on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
function M.on_attach(on_attach, name)
  return vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        return on_attach(client, buffer)
      end
    end,
  })
end

M.mergeTablesNoDup = function(...)
  local result = {}
  local set = {}

  for _, tab in ipairs({ ... }) do
    for _, value in ipairs(tab) do
      if not set[value] then
        table.insert(result, tostring(value))
        set[value] = true
      end
    end
  end

  return result
end

-- HACK: Create table of contents in neovim with markdown-toc
-- https://youtu.be/BVyrXsZ_ViA
--
-- Generate/update a Markdown TOC
-- To generate the TOC I use the markdown-toc plugin
-- https://github.com/jonschlinkert/markdown-toc
-- And the markdown-toc plugin installed as a LazyExtra
-- Function to update the Markdown TOC with customizable headings
M.update_markdown_toc = function(heading2, heading3)
  local path = vim.fn.expand("%") -- Expands the current file name to a full path
  local bufnr = 0 -- The current buffer number, 0 references the current active buffer
  -- Save the current view
  -- If I don't do this, my folds are lost when I run this keymap
  vim.cmd("mkview")
  -- Retrieves all lines from the current buffer
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local toc_exists = false -- Flag to check if TOC marker exists
  local frontmatter_end = 0 -- To store the end line number of frontmatter
  -- Check for frontmatter and TOC marker
  for i, line in ipairs(lines) do
    if i == 1 and line:match("^---$") then
      -- Frontmatter start detected, now find the end
      for j = i + 1, #lines do
        if lines[j]:match("^---$") then
          frontmatter_end = j
          break
        end
      end
    end
    -- Checks for the TOC marker
    if line:match("^%s*<!%-%-%s*toc%s*%-%->%s*$") then
      toc_exists = true
      break
    end
  end
  -- Inserts H2 and H3 headings and <!-- toc --> at the appropriate position
  if not toc_exists then
    local insertion_line = 1 -- Default insertion point after first line
    if frontmatter_end > 0 then
      -- Find H1 after frontmatter
      for i = frontmatter_end + 1, #lines do
        if lines[i]:match("^#%s+") then
          insertion_line = i + 1
          break
        end
      end
    else
      -- Find H1 from the beginning
      for i, line in ipairs(lines) do
        if line:match("^#%s+") then
          insertion_line = i + 1
          break
        end
      end
    end
    -- Insert the specified headings and <!-- toc --> without blank lines
    -- Insert the TOC inside a H2 and H3 heading right below the main H1 at the top lamw25wmal
    vim.api.nvim_buf_set_lines(
      bufnr,
      insertion_line,
      insertion_line,
      false,
      { heading2, heading3, "<!-- toc -->" }
    )
  end
  -- Silently save the file, in case TOC is being created for the first time
  vim.cmd("silent write")
  -- Silently run markdown-toc to update the TOC without displaying command output
  -- vim.fn.system("markdown-toc -i " .. path)
  -- I want my bulletpoints to be created only as "-" so passing that option as
  -- an argument according to the docs
  -- https://github.com/jonschlinkert/markdown-toc?tab=readme-ov-file#optionsbullets
  vim.fn.system('markdown-toc --bullets "-" -i ' .. path)
  vim.cmd("edit!") -- Reloads the file to reflect the changes made by markdown-toc
  vim.cmd("silent write") -- Silently save the file
  vim.notify("TOC updated and file saved", vim.log.levels.INFO)
  -- -- In case a cleanup is needed, leaving this old code here as a reference
  -- -- I used this code before I implemented the frontmatter check
  -- -- Moves the cursor to the top of the file
  -- vim.api.nvim_win_set_cursor(bufnr, { 1, 0 })
  -- -- Deletes leading blank lines from the top of the file
  -- while true do
  --   -- Retrieves the first line of the buffer
  --   local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
  --   -- Checks if the line is empty
  --   if line == "" then
  --     -- Deletes the line if it's empty
  --     vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, {})
  --   else
  --     -- Breaks the loop if the line is not empty, indicating content or TOC marker
  --     break
  --   end
  -- end
  -- Restore the saved view (including folds)
  vim.cmd("loadview")
end

return M
