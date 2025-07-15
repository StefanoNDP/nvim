local vars = require("config.vars")

return {
  "L3MON4D3/LuaSnip",
  enabled = true,
  version = false,
  lazy = true,
  -- build = vars.getOSLowerCase():match("windows") ~= 0 and "make install_jsregexp" or nil,
  -- build = "make install_jsregexp CC=zig",
  build = "make install_jsregexp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "kmarius/jsregexp",
  },
  keys = function()
    return {}
  end,
  opts = function()
    return {
      enable_autosnippets = true,
      history = true,
      delete_check_events = "TextChanged",
    }
  end,
  config = function(_, opts)
    local luasnip = require("luasnip")
    if opts then
      luasnip.setup(opts)
    end

    local path = vim.fn.stdpath("config") .. "/snippets"

    require("luasnip.loaders.from_lua").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load({ paths = path })
    require("luasnip.loaders.from_snipmate").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load({ paths = path })

    luasnip.filetype_extend("cs", { "csharpdoc" })
    luasnip.filetype_extend("gdscript", { "gdscriptdoc" })
    luasnip.filetype_extend("lua", { "luadoc" })
    luasnip.filetype_extend("markdown", { "mddoc" })
    luasnip.filetype_extend("sh", { "shelldoc" })

    -- require("config.keymaps.snippets")
  end,
}
