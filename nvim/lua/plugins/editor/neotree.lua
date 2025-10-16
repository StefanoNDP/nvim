local shouldOpenExplorer = function()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname:match("^%a+://") or bufname == "" then
    return true -- There's no opened buffers, open explorer
  end
  return false -- There's a buffer open, don't open explorer
end

local checkExplorer = function()
  if shouldOpenExplorer() then
    vim.cmd([[Neotree]])
    -- require("snacks").explorer()
  end
end

return {
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
    },
    enabled = vim.g.enableNeoTree,
    version = false,
    lazy = true,
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    enabled = vim.g.enableNeoTree,
    lazy = true,
    version = "2.*",
    config = function()
      require("window-picker").setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
      "antosha417/nvim-lsp-file-operations",
      "s1n7ax/nvim-window-picker",
    },
    enabled = vim.g.enableNeoTree,
    version = false,
    lazy = false,
    branch = "v3.x",
    -- init = function()
    --   -- NOTE: Snacks explorer seems to take 100ms to finish, so we run our function after it
    --   local timeToWait_ms = 105
    --   vim.defer_fn(checkExplorer, timeToWait_ms)
    -- end,
    opts = function()
      return {
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function()
              vim.opt_local.number = true
              vim.opt_local.relativenumber = true
              -- vim.cmd([[
              --   setlocal number
              --   set number
              --   setlocal relativenumber
              --   set relativenumber
              -- ]])
            end,
          },
          {
            event = "after_render",
            handler = function(state)
              state.config = {
                use_float = false,
                use_snacks_image = true,
                use_image_nvim = true,
              }
              state.commands.toggle_preview(state)
            end,
          },
          {
            event = "file_opened",
            handler = function()
              vim.cmd([[Neotree close]])
            end,
          },
        },
        window = {
          mappings = {
            ["<esc>"] = {
              "close_neotree",
            },
            ["A"] = "easy",
            -- ["y"] = "copy_file_path",
            -- ["s"] = "search_in_directory",
            -- ["D"] = "diff",
            ["P"] = {
              "toggle_preview",
              config = {
                use_float = false,
                use_snacks_image = true,
                use_image_nvim = true,
              },
            },
            ["l"] = "focus_preview",
            ["<C-b>"] = { "scroll_preview", config = { direction = 10 } },
            ["<C-f>"] = { "scroll_preview", config = { direction = -10 } },
          },
        },
        commands = {
          ["easy"] = function(state)
            local node = state.tree:get_node()
            local path = node.type == "directory" and node.path
              or vim.fs.dirname(node.path)
            require("easy-dotnet").create_new_item(path, function()
              require("neo-tree.sources.manager").refresh(state.name)
            end)
          end,
          ["close_neotree"] = function()
            vim.cmd([[Neotree close]])
          end,
          -- ["copy_file_path"] = {
          --   action = function(_, item)
          --     if not item then
          --       return
          --     end
          --
          --     local vals = {
          --       ["BASENAME"] = vim.fn.fnamemodify(item.file, ":t:r"),
          --       ["EXTENSION"] = vim.fn.fnamemodify(item.file, ":t:e"),
          --       ["FILENAME"] = vim.fn.fnamemodify(item.file, ":t"),
          --       ["PATH"] = item.file,
          --       ["PATH (CWD)"] = vim.fn.fnamemodify(item.file, ":."),
          --       ["PATH (HOME)"] = vim.fn.fnamemodify(item.file, ":~"),
          --       ["URI"] = vim.uri_from_fname(item.file),
          --     }
          --
          --     local options = vim.tbl_filter(function(val)
          --       return vals[val] ~= ""
          --     end, vim.tbl_keys(vals))
          --     if vim.tbl_isempty(options) then
          --       vim.notify("No values to copy", vim.log.levels.WARN)
          --       return
          --     end
          --     table.sort(options)
          --     vim.ui.select(options, {
          --       prompt = "Choose to copy to clipboard:",
          --       format_item = function(list_item)
          --         return ("%s: %s"):format(list_item, vals[list_item])
          --       end,
          --     }, function(choice)
          --       local result = vals[choice]
          --       if result then
          --         vim.fn.setreg("+", result)
          --         Snacks.notify.info("Yanked `" .. result .. "`")
          --       end
          --     end)
          --   end,
          -- },
          -- ["search_in_directory"] = {
          --   action = function(_, item)
          --     if not item then
          --       return
          --     end
          --     local dir = vim.fn.fnamemodify(item.file, ":p:h")
          --     Snacks.picker.grep({
          --       cwd = dir,
          --       cmd = "rg",
          --       args = {
          --         "-g",
          --         "!.git",
          --         "-g",
          --         "!node_modules",
          --         "-g",
          --         "!dist",
          --         "-g",
          --         "!build",
          --         "-g",
          --         "!coverage",
          --         "-g",
          --         "!.DS_Store",
          --         "-g",
          --         "!.docusaurus",
          --         "-g",
          --         "!.dart_tool",
          --       },
          --       show_empty = true,
          --       hidden = true,
          --       ignored = true,
          --       follow = false,
          --       supports_live = true,
          --     })
          --   end,
          -- },
          -- ["diff"] = {
          --   action = function(picker)
          --     picker:close()
          --     local sel = picker:selected()
          --     if #sel > 0 and sel then
          --       Snacks.notify.info(sel[1].file)
          --       vim.cmd("tabnew " .. sel[1].file)
          --       vim.cmd("vert diffs " .. sel[2].file)
          --       Snacks.notify.info(
          --         "Diffing " .. sel[1].file .. " against " .. sel[2].file
          --       )
          --       return
          --     end
          --
          --     Snacks.notify.info("Select two entries for the diff")
          --   end,
          -- },
        },
        close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "NC", -- or "" to use 'winborder' on Neovim v0.11+
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
        open_files_using_relative_paths = false,
        sort_case_insensitive = false, -- used when sorting files and directories in the tree
        default_component_configs = {
          container = {
            enable_character_fade = true,
          },
          indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side
            -- indent guides
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "╰",
            highlight = "NeoTreeIndentMarker",
            -- expander config, needed for nesting files
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󰜌",
            provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
              if node.type == "file" or node.type == "terminal" then
                local success, web_devicons =
                  pcall(require, "nvim-web-devicons")
                local name = node.type == "terminal" and "terminal" or node.name
                if success then
                  local devicon, hl = web_devicons.get_icon(name)
                  icon.text = devicon or icon.text
                  icon.highlight = hl or icon.highlight
                end
              end
            end,
            -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
            -- then these will never be used.
            default = "*",
            highlight = "NeoTreeFileIcon",
          },
          modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              -- Change type
              added = "✚", -- or "✚"
              modified = "", -- or ""
              deleted = "✖", -- this can only be used in the git_status source
              renamed = "󰁕", -- this can only be used in the git_status source
              -- Status type
              untracked = "",
              ignored = "",
              unstaged = "󰄱",
              staged = "",
              conflict = "",
            },
          },
          -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
          file_size = {
            enabled = true,
            width = 12, -- width of the column
            required_width = 64, -- min width of window required to show this column
          },
          type = {
            enabled = true,
            width = 10, -- width of the column
            required_width = 122, -- min width of window required to show this column
          },
          last_modified = {
            enabled = true,
            width = 20, -- width of the column
            required_width = 88, -- min width of window required to show this column
          },
          created = {
            enabled = true,
            width = 20, -- width of the column
            required_width = 110, -- min width of window required to show this column
          },
          symlink_target = {
            enabled = false,
          },
        },
        filesystem = {
          filtered_items = {
            visible = true, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_hidden = false, -- only works on Windows for hidden files/directories
            hide_by_name = {
              "node_modules",
            },
            hide_by_pattern = { -- uses glob style patterns
              --"*.meta",
              --"*/src/*/tsconfig.json",
            },
            always_show = { -- remains visible even if other settings would normally hide it
              --".gitignored",
            },
            always_show_by_pattern = { -- uses glob style patterns
              --".env*",
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
              --".DS_Store",
              --"thumbs.db"
            },
            never_show_by_pattern = { -- uses glob style patterns
              --".null-ls_*",
            },
          },
          follow_current_file = {
            enabled = true, -- This will find and focus the file in the active buffer every time
            --               -- the current file is changed while the tree is open.
            leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
          group_empty_dirs = false, -- when true, empty folders will be grouped together
          hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
          -- in whatever position is specified in window.position
          -- "open_current",  -- netrw disabled, opening a directory opens within the
          -- window like netrw would, regardless of window.position
          -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
          use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
          -- instead of relying on nvim autocmd events.
        },
        buffers = {
          follow_current_file = {
            enabled = true, -- This will find and focus the file in the active buffer every time
            --              -- the current file is changed while the tree is open.
            leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
          group_empty_dirs = false, -- when true, empty folders will be grouped together
          show_unloaded = true,
        },
        git_status = {
          window = {
            position = "float",
          },
        },
      }
    end,
    config = function(_, opts)
      require("neo-tree").setup(opts)
      require("config.keymaps.neotree")
      --   -- NOTE: Snacks explorer seems to take 100ms to finish, so we run our function after it
      --   local timeToWait_ms = 105
      --   vim.defer_fn(checkExplorer, timeToWait_ms)
    end,
  },
}
