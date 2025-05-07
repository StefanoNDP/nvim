local funcs = require("config.functions")

return {
  "SmiteshP/nvim-navic",
  enabled = true,
  version = false,
  lazy = true,
  init = function()
    vim.g.navic_silence = true
    funcs.on_attach(function(client, buffer)
      if client.supports_method("textDocument/documentSymbol") then
        require("nvim-navic").attach(client, buffer)
      end
    end)
  end,
  opts = function()
    return {
      highlight = true,
      lazy_update_context = true,
      lsp = { auto_attach = true },
      depth_limit = 5,
      icons = require("blink.cmp").kind_icons,
      click = true,
    }
  end,
  config = function(_, opts)
    require("nvim-navic").setup(opts)
  end,
}
