return {
  {
    "nvim-tree/nvim-web-devicons",
    enabled = true,
    lazy = true,
    opts = function()
      local devicons = require("nvim-web-devicons")
      local vars = require("config.vars")
      devicons.set_icon_by_filetype({
        razor = "razor",
        cshtml = "cshtml",
      })

      devicons.set_icon({
        razor = {
          default = true,
          icon = vars.dotnetIcon,
          color = "#b4befe",
          cterm_color = "153",
          name = "razor",
        },
        cshtml = {
          default = true,
          icon = vars.dotnetIcon,
          color = "#b4befe",
          cterm_color = "153",
          name = "cshtml",
        },
      })

      return {}
    end,
    config = function(_, opts)
      require("nvim-web-devicons").setup(opts)
    end,
  },
  {
    "echasnovski/mini.icons",
    enabled = true,
    version = false,
    lazy = false,
    priority = 1000,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
    opts = function()
      local vars = require("config.vars")
      return {
        file = {
          [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
          ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
          [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
          [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
          [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
          [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
          ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
          ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
          ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
          ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
          ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
        },
        filetype = {
          dotenv = { glyph = "", hl = "MiniIconsYellow" },
          razor = { glyph = vars.dotnetIcon, hl = "MiniIconsBlue" },
          cshtml = { glyph = vars.dotnetIcon, hl = "MiniIconsBlue" },
        },
      }
    end,
    config = function(_, opts)
      require("mini.icons").setup(opts)
    end,
  },
}
