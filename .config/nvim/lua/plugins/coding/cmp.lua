local max_height = 30
local max_width = 120

return {
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
      -- "moyiz/blink-emoji.nvim",
      -- "mikavilpas/blink-ripgrep.nvim",
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
      -- {
      --   -- "Exafunction/codeium.nvim",
      --   "Exafunction/windsurf.nvim",
      --   version = false,
      --   lazy = true,
      --   cmd = "Codeium",
      --   event = "InsertEnter",
      --   dependencies = { "nvim-lua/plenary.nvim", "saghen/blink.compat" },
      --   opts = function()
      --     return {
      --       enable_cmp_source = true,
      --       virtual_text = {
      --         enabled = true,
      --         enable_chat = true,
      --         -- filetypes = {
      --         --   python = true,
      --         --   markdown = true,
      --         -- },
      --         default_filetype_enabled = true,
      --       },
      --     }
      --   end,
      --   config = function(_, opts)
      --     require("codeium").setup(opts)
      --   end,
      -- },
    },
    opts = {
      completion = {
        -- trigger = {
        --   show_in_snippet = false,
        -- },
        list = {
          max_items = 50,
        },
        documentation = {
          window = { border = "rounded", max_height = max_height },
          auto_show = true,
          auto_show_delay_ms = 200,
          treesitter_highlighting = false,
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
                -- text = function(ctx)
                --   local highlights_info = require("colorful-menu").blink_highlights(ctx)
                --   if highlights_info ~= nil then
                --     -- Or you want to add more item to label
                --     return highlights_info.label
                --   else
                --     return ctx.label
                --   end
                -- end,
                -- highlight = function(ctx)
                --   local highlights = {}
                --   local highlights_info = require("colorful-menu").blink_highlights(ctx)
                --   if highlights_info ~= nil then
                --     highlights = highlights_info.highlights
                --   end
                --   for _, idx in ipairs(ctx.label_matched_indices) do
                --     table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                --   end
                --   -- Do something else
                --   return highlights
                -- end,
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
            if
              cmp.is_ghost_text_visible() and not cmp.is_menu_visible()
              or cmp.snippet_active()
            then
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

          -- codeium = "",
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
        -- default = { "codeium", "cmdline", "lsp", "snippets", "path" },
        default = { "cmdline", "lsp", "snippets", "path" },
        per_filetype = {
          -- lua = { "lazydev", "codeium", "cmdline", "lsp", "snippets", "path" },
          lua = { "lazydev", "cmdline", "lsp", "snippets", "path" },
          -- cs = { "easy-dotnet", "codeium", "cmdline", "lsp", "snippets", "path" },
          cs = { "lsp", "easy-dotnet", "cmdline", "snippets", "path" },
          -- sql = { "dadbod", "codeium", "cmdline", "lsp", "snippets", "path" },
          sql = { "dadbod", "cmdline", "lsp", "snippets", "path" },
        },
        providers = {
          -- codeium = {
          --   name = "codeium",
          --   module = "blink.compat.source",
          --   score_offset = 5,
          --   transform_items = function(_, items)
          --     for _, item in ipairs(items) do
          --       item.kind_icon = " "
          --     end
          --     return items
          --   end,
          --   async = true,
          -- },
          cmdline = {
            module = "blink.cmp.sources.cmdline",
            name = "[cmd]",
            score_offset = 5,
            -- Disable shell commands on windows, since they cause neovim to hang
            enabled = function()
              return vim.fn.has("win32") == 0
                or vim.fn.getcmdtype() ~= ":"
                or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
            end,
            async = true,
          },
          lazydev = {
            name = "[LazyDev]",
            module = "lazydev.integrations.blink",
            score_offset = 3,
            async = true,
          },
          dadbod = {
            name = "[DB]",
            module = "vim_dadbod_completion.blink",
            score_offset = 3,
            async = true,
          },
          lsp = {
            name = "[LSP]",
            score_offset = 3,
            async = true,
          },
          ["easy-dotnet"] = {
            name = "easy-dotnet",
            enabled = true,
            module = "easy-dotnet.completion.blink",
            score_offset = 10000,
            async = true,
          },
          snippets = {
            name = "[snip]",
            score_offset = 2,
            opts = {
              use_show_condition = true,
              show_autosnippets = true,
            },
            async = true,
          },
          path = {
            name = "[path]",
            score_offset = 1,
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
        window = {
          border = "rounded",
          max_height = max_height,
          treesitter_highlighting = false,
        },
      },
      fuzzy = {
        use_frecency = false,
        -- use_typo_resistance = false,
        implementation = "prefer_rust_with_warning",
      },
    },
    opts_extend = { "sources.default" },
  },
}
