return { -- colorscheme
  "catppuccin/nvim",
  enabled = true,
  version = false,
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = function()
    return {
      flavour = "mocha",
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false, -- disables setting the background color.
      show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
      term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      no_underline = false, -- Force no underline
      styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "bold" },
        loops = { "bold" },
        functions = { "bold" },
        keywords = { "italic" },
        strings = {},
        variables = {},
        numbers = {},
        booleans = { "bold", "italic" },
        properties = {},
        types = {},
        operators = { "bold" },
        miscs = {}, -- Uncomment to turn off hard-coded styles
      },
      optional = true,
      default_integrations = true,
      integrations = {
        blink_cmp = true,
        cmp = false,
        dap = true,
        dap_ui = true,
        fidget = true,
        gitgutter = false,
        gitsigns = false,
        harpoon = true,
        lsp_trouble = true,
        mason = true,
        notify = true,
        nvimtree = false,
        overseer = false,
        rainbow_delimiters = true,
        semantic_tokens = true,
        telescope = false,
        treesitter = true,
        treesitter_context = true,
        ufo = true,
        which_key = true,

        mini = {
          enabled = true,
          indentscope_color = "mauve", -- catppuccin color (eg. `lavender`) Default: text
        },
        navic = {
          enabled = true,
          -- custom_bg = "#1e1e2e", -- "lualine" will set background to mantle (#181825)
        },
        snacks = {
          enabled = true,
          indent_scope_color = "mauve", -- catppuccin color (eg. `lavender`) Default: text
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
      },
      custom_highlights = function(colors)
        return {
          ["@comment"] = { fg = colors.green },
          ["@comment.documentation"] = { fg = colors.green },
          String = { fg = colors.peach },
          ["@type.builtin"] = { fg = colors.blue },
          ["@variable.member"] = { fg = colors.sky }, -- For fields.
        }
      end,
    }
  end,
  config = function(_, opts)
    require("catppuccin").setup(opts)
    -- Setup must be called before loading
    vim.cmd.colorscheme("catppuccin")
  end,
}
