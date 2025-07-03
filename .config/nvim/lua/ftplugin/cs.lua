local ft = {}

ft.ftplugin = function()
  vim.opt.autoindent = true -- Copy indent from current line when starting a new one
  vim.opt.expandtab = true
  vim.opt.smartindent = true
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
end

return ft
