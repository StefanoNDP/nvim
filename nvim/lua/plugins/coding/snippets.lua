local funcs = require("config.functions")

return {
  { "kmarius/jsregexp", enabled = true, version = false, lazy = false },
  {
    "L3MON4D3/LuaSnip",
    enabled = true,
    version = false,
    lazy = true,
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
      luasnip.filetype_extend("c_sharp", { "csharpdoc" })
      luasnip.filetype_extend("csharp", { "csharpdoc" })
      luasnip.filetype_extend("gdscript", { "gdscriptdoc" })
      luasnip.filetype_extend("lua", { "luadoc" })
      luasnip.filetype_extend("markdown", { "mddoc" })
      luasnip.filetype_extend("sh", { "shelldoc" })
      luasnip.filetype_extend("javascript", { "jsdoc" })
      luasnip.filetype_extend("typescript", { "tsdoc" })

      -- require("config.keymaps.snippets")
    end,
  },
}
