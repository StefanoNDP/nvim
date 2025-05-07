local max_height = 30
local max_width = 120

return {
  {
    "xzbdmw/colorful-menu.nvim",
    enabled = true,
    version = false,
    event = "VeryLazy",
    opts = function()
      return {
        ls = {
          -- If provided, the plugin truncates the final displayed text to
          -- this width (measured in display cells). Any highlights that extend
          -- beyond the truncation point are ignored. When set to a float
          -- between 0 and 1, it'll be treated as percentage of the width of
          -- the window: math.floor(max_width * vim.api.nvim_win_get_width(0))
          -- Default 60.
          max_width = max_width,
        },
      }
    end,
    config = function(_, opts)
      require("colorful-menu").setup(opts)
    end,
  },
  {
    "Saghen/blink.cmp",
    enabled = true,
    version = "*",
    -- lazy = false,
    -- event = { "BufReadPre", "InsertEnter", "CursorMoved", "TextChanged" },
    event = { "InsertEnter" },
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "moyiz/blink-emoji.nvim",
      "mikavilpas/blink-ripgrep.nvim",
      "kristijanhusak/vim-dadbod-completion",
      "GustavEikaas/easy-dotnet.nvim",
      {
        "saghen/blink.compat",
        version = "*",
        lazy = true,
        opts = { enable_events = true, impersonate_nvim_cmp = true },
        config = function()
          require("blink.compat").setup()
        end,
      },
    },
    opts = {
      completion = {
        -- trigger = {
        --   show_in_snippet = false,
        -- },
        documentation = {
          window = { border = "rounded", max_height = max_height },
          auto_show = true,
          auto_show_delay_ms = 0,
        },
        menu = {
          max_height = max_height,
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon", gap = 1 },
              { "label", "source_name", gap = 1 },
            },
            components = {
              kind_icon = {
                ellipsis = true,
              },
              kind = {
                ellipsis = true,
              },
              label = {
                width = { fill = true, max = max_width },
                text = function(ctx)
                  local highlights_info = require("colorful-menu").blink_highlights(ctx)
                  if highlights_info ~= nil then
                    -- Or you want to add more item to label
                    return highlights_info.label
                  else
                    return ctx.label
                  end
                end,
                highlight = function(ctx)
                  local highlights = {}
                  local highlights_info = require("colorful-menu").blink_highlights(ctx)
                  if highlights_info ~= nil then
                    highlights = highlights_info.highlights
                  end
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                  end
                  -- Do something else
                  return highlights
                end,
              },
            },
          },
        },
        ghost_text = { enabled = true, show_without_selection = true },
      },
      cmdline = {
        completion = { menu = { auto_show = true } },
        keymap = {
          preset = "none",
          ["<Tab>"] = {
            function(cmp)
              if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then
                return cmp.accept()
              end
            end,
            "show_and_insert",
            "select_next",
          },

          ["<S-Tab>"] = { "show_and_insert", "select_prev" },

          ["<C-y>"] = { "select_and_accept" },
          ["<C-e>"] = { "cancel" },
        },
      },
      keymap = {
        preset = "none",
        ["<Tab>"] = {
          function(cmp)
            if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() or cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "fallback",
        },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },

        ["<C-f>"] = { "snippet_forward", "fallback" },
        ["<C-p>"] = { "snippet_backward", "fallback" },

        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },

        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },

        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        kind_icons = {
          Variable = "󰀫",

          Class = "󰠱",
          Interface = "",
          Module = "󰆦",

          Unit = "󰑭",
          Value = "󰎠",
          Enum = "",
          EnumMember = "",

          Snippet = "",
          File = "󰈙",
          Operator = "󰆕",
          TypeParameter = "",
        },
      },
      -- Merge custom sources with the existing ones from LazyVim
      -- Requires the LazyVim blink.cmp extra
      snippets = {
        preset = "luasnip",
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
      sources = {
        default = {
          "cmdline",
          "lsp",
          "easy-dotnet",
          "snippets",
          "path",
          "buffer",
          "omni",
          -- "emoji",
          -- "ripgrep",
        },
        per_filetype = {
          -- org = { "orgmode" },
          sql = {
            "snippets",
            "dadbod",
            "buffer",
            "omni",
            -- "emoji",
            -- "ripgrep",}
          },
          lua = {
            "lazydev",
            "lsp",
            "snippets",
            "path",
            "buffer",
            "omni",
            -- "emoji",
            -- "ripgrep",}
          },
        },
        providers = {
          -- orgmode = {
          --   name = "Orgmode",
          --   module = "orgmode.org.autocompletion.blink",
          --   fallbacks = { "bugger" },
          -- },
          cmdline = {
            module = "blink.cmp.sources.cmdline",
            name = "[cmd]",
            score_offset = 100,
            async = true,
            -- Disable shell commands on windows, since they cause neovim to hang
            enabled = function()
              return vim.fn.has("win32") == 0
                or vim.fn.getcmdtype() ~= ":"
                or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
            end,
          },
          lazydev = {
            name = "[LazyDev]",
            module = "lazydev.integrations.blink",
            score_offset = 95,
            async = true,
          },
          dadbod = {
            name = "[DB]",
            module = "vim_dadbod_completion.blink",
            score_offset = 95,
            async = true,
          },
          lsp = {
            name = "[LSP]",
            score_offset = 95,
            async = true,
          },
          ["easy-dotnet"] = {
            name = "[.NET]",
            enabled = true,
            module = "easy-dotnet.completion.blink",
            score_offset = 95,
            async = true,
          },
          snippets = {
            name = "[snip]",
            score_offset = 90,
            async = true,
            opts = {
              use_show_condition = true,
              show_autosnippets = true,
            },
          },
          path = {
            name = "[path]",
            score_offset = 85,
            async = true,
          },
          buffer = {
            name = "[buf]",
            score_offset = 75,
            async = true,
          },
          omni = {
            score_offset = 70,
            async = true,
            ---@type blink.cmp.CompleteFuncOpts
            opts = {
              complete_func = function()
                return vim.bo.omnifunc
              end,
            },
          },
          ripgrep = {
            name = "[ripgrep]",
            module = "blink-ripgrep",
            score_offset = 65,
            async = true,
          },
          emoji = {
            name = "[emoji]",
            module = "blink-emoji",
            score_offset = 60,
            async = true,
          },
        },
      },
      signature = {
        enabled = true,
        trigger = {
          -- show_on_trigger_character = false,
          show_on_insert = true,
        },
        window = { border = "rounded", max_height = max_height },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
