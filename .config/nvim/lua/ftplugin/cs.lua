local ft = {}

ft.ftplugin = function()
  vim.opt.autoindent = true -- Copy indent from current line when starting a new one
  vim.opt.expandtab = true
  vim.opt.smartindent = true
  vim.opt.tabstop = 4
  vim.opt.softtabstop = 4
  vim.opt.shiftwidth = 4
end

return ft
