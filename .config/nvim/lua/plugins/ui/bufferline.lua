return {
  "akinsho/bufferline.nvim",
  enabled = true,
  after = "catppuccin",
  dependencies = { "echasnovski/mini.icons" },
  version = false,
  -- lazy = false,
  event = "VeryLazy",
  opts = function()
    return {
      options = {
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        separator_style = "slant",
        numbers = "ordinal", -- function({ ordinal, id, lower, raise }): string,
        tab_size = 15,
        color_icons = true,
        get_element_icon = function(element)
          local icon, hl =
            require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
          return icon, hl
        end,
        show_buffer_close_icons = true,
        show_close_icon = true,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "left",
          },
        },
        hover = {
          enabled = true,
          delay = 1,
          reveal = { "close" },
        },
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and "✘ " or "▲ "
          return " " .. icon .. count
        end,
        groups = {
          items = {
            require("bufferline.groups").builtin.pinned:with({ icon = "" }),
          },
        },
        -- GROUPS
        toggle_hidden_on_enter = true, -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
        items = {
          {
            name = "Tests", -- Mandatory
            highlight = { underline = true, sp = "blue" }, -- Optional
            priority = 2, -- determines where it will appear relative to other groups (Optional)
            icon = "", -- Optional
            matcher = function(buf) -- Mandatory
              return buf.filename:match("%_test") -- "_test" suffix
                or buf.filename:match("%_spec") -- "_spec" suffix
                or buf.filename:match("test_%") -- "test_" preffix
                or buf.filename:match("spec_%") -- "spec_" preffix
            end,
          },
          {
            name = "Docs",
            highlight = { undercurl = true, sp = "green" },
            auto_close = false, -- whether or not close this group if it doesn't contain the current buffer
            matcher = function(buf)
              return buf.filename:match("%.md") -- ".md" extension
                or buf.filename:match("%.txt") -- ".txt" extension
            end,
            separator = { -- Optional
              style = require("bufferline.groups").separator.tab,
            },
          },
        },
      },
      highlights = require("catppuccin.groups.integrations.bufferline").get(),
    }
  end,
  config = function(_, opts)
    require("bufferline").setup(opts)
    require("config.keymaps.bufferline")
  end,
}
