local ft = {}

ft.ftplugin = function()
  vim.opt.expandtab = false -- Use tabs
end

ft.setup = function()
  -- CTags support
  vim.g.tagbar_type_gdscript = {
    ctagstype = "gdscript",
    kinds = {
      "function",
      "var",
    },
  }

  local port = os.getenv("GDScript_Port") or "6005"
  local cmd = vim.lsp.rpc.connect("127.0.0.1", tonumber(port))
  -- local pipe = vim.fn.stdpath("cache") .. "/godot.pipe" -- I use ~/.cache/nvim/godot.pipe

  local pipe = nil

  local funcs = require("config.functions")
  if funcs.get_os_lower() == "windows" then
    pipe = [[\\.\pipe\nvim-godot]]
  else
    pipe = vim.fn.stdpath("cache") .. "/godot.pipe"
  end

  vim.lsp.start({
    name = "Godot",
    cmd = cmd,
    filetypes = { "gdscript", "cs", "csharp", "c_sharp" },
    root_dir = vim.fs.dirname(vim.fs.find({ "project.godot", ".git" }, {
      upward = true,
      path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
    })[1]),
    on_attach = function(client, bufnr)
      vim.api.nvim_command('echo serverstart("' .. pipe .. '")')
    end,
  })
end

return ft
