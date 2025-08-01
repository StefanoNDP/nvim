local funcs = require("config.functions")
local vars = require("config.vars")

local excludeAll = {
  -- "Utilities",
  -- "node_modules",
  -- "Utilities/omnisharp*",
  -- ".git",
  -- "dist",
  -- "lazy-lock.json",
}

local excludeExplorer = {
  -- "Utilities",
  -- "node_modules",
  -- "Utilities/omnisharp*",
  -- ".git",
  -- "dist",
  -- "lazy-lock.json",
}

local excludeFiles = {
  -- "node_modules",
  -- "Utilities/omnisharp*",
  -- ".git",
  -- "dist",
  -- "lazy-lock.json",
  -- "%__virtual.cs$",
}

local excludeGrep = {
  -- "node_modules",
  -- "Utilities/omnisharp*",
  -- ".git",
  -- "dist",
  -- "lazy-lock.json",
  -- "%__virtual.cs$",
}

local shouldOpenExplorer = function()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname:match("^%a+://") or bufname == "" then
    return true -- There's no opened buffers, open explorer
  end
  return false -- There's a buffer open, don't open explorer
end

local checkExplorer = function()
  if shouldOpenExplorer() then
    require("snacks").explorer()
  end
end

return {
  "folke/snacks.nvim",
  enabled = true,
  version = false,
  priority = 1000,
  lazy = false,
  opts = {
    animate = { enabled = false },
    bigfile = { enabled = true, notify = true, size = vars.maxFileSize },
    bufdelete = { enabled = false },
    dashboard = { enabled = false },
    debug = { enabled = false },
    dim = { enabled = false },
    explorer = { enabled = true, replace_netrw = true },
    git = { enabled = true },
    gitbrowse = { enabled = true },
    image = { enabled = true },
    indent = {
      enabled = false,
      animate = { enabled = false },
      hl = vars.highlights,
      scope = { hl = vars.highlights },
      chunk = {
        enabled = false,
        char = { corner_top = "╭", corner_bottom = "╰" },
        hl = vars.highlights,
      },
    },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = {
      enabled = true,
      margin = { top = 1, right = 1, bottom = 1 },
      top_down = false,
    },
    notify = { enabled = true },
    profiler = { enabled = true },
    quickfile = { enabled = true },
    rename = { enabled = true },
    scope = { enabled = true },
    scratch = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = {
      enabled = true,
      left = { "fold", "git" },
      right = { "mark", "sign" },
      folds = { open = true, git_hl = true },
      git = { patterns = { "GitSign", "GitSigns", "MiniDiffSign" } },
    },
    terminal = { enabled = true },
    toggle = { enabled = true },
    util = { enabled = true },
    words = { enabled = true },
    picker = {
      enabled = true,
      cwd = vim.fn.getcwd(),
      formatters = {
        file = {
          truncate = 80,
        },
      },
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
          follow = true,
          show_empty = true,
          win = {
            list = {
              keys = {
                ["A"] = "explorer_add_dotnet",
                ["y"] = "copy_file_path",
                ["s"] = "search_in_directory",
                ["D"] = "diff",
              },
              wo = {
                number = true,
                relativenumber = true,
              },
            },
          },
          auto_close = true,
          cwd = vim.fn.getcwd(),
          actions = {
            explorer_add_dotnet = function(picker)
              local dir = picker:dir()
              local tree = require("snacks.explorer.tree")
              local actions = require("snacks.explorer.actions")
              local easydotnet = require("easy-dotnet")

              easydotnet.create_new_item(dir, function(item_path)
                tree:open(dir)
                tree:refresh(dir)
                actions.update(picker, { target = item_path })
              end)
            end,
            copy_file_path = {
              action = function(_, item)
                if not item then
                  return
                end

                local vals = {
                  ["BASENAME"] = vim.fn.fnamemodify(item.file, ":t:r"),
                  ["EXTENSION"] = vim.fn.fnamemodify(item.file, ":t:e"),
                  ["FILENAME"] = vim.fn.fnamemodify(item.file, ":t"),
                  ["PATH"] = item.file,
                  ["PATH (CWD)"] = vim.fn.fnamemodify(item.file, ":."),
                  ["PATH (HOME)"] = vim.fn.fnamemodify(item.file, ":~"),
                  ["URI"] = vim.uri_from_fname(item.file),
                }

                local options = vim.tbl_filter(function(val)
                  return vals[val] ~= ""
                end, vim.tbl_keys(vals))
                if vim.tbl_isempty(options) then
                  vim.notify("No values to copy", vim.log.levels.WARN)
                  return
                end
                table.sort(options)
                vim.ui.select(options, {
                  prompt = "Choose to copy to clipboard:",
                  format_item = function(list_item)
                    return ("%s: %s"):format(list_item, vals[list_item])
                  end,
                }, function(choice)
                  local result = vals[choice]
                  if result then
                    vim.fn.setreg("+", result)
                    Snacks.notify.info("Yanked `" .. result .. "`")
                  end
                end)
              end,
            },
            search_in_directory = {
              action = function(_, item)
                if not item then
                  return
                end
                local dir = vim.fn.fnamemodify(item.file, ":p:h")
                Snacks.picker.grep({
                  cwd = dir,
                  cmd = "rg",
                  args = {
                    "-g",
                    "!.git",
                    "-g",
                    "!node_modules",
                    "-g",
                    "!dist",
                    "-g",
                    "!build",
                    "-g",
                    "!coverage",
                    "-g",
                    "!.DS_Store",
                    "-g",
                    "!.docusaurus",
                    "-g",
                    "!.dart_tool",
                  },
                  show_empty = true,
                  hidden = true,
                  ignored = true,
                  follow = false,
                  supports_live = true,
                })
              end,
            },
            diff = {
              action = function(picker)
                picker:close()
                local sel = picker:selected()
                if #sel > 0 and sel then
                  Snacks.notify.info(sel[1].file)
                  vim.cmd("tabnew " .. sel[1].file)
                  vim.cmd("vert diffs " .. sel[2].file)
                  Snacks.notify.info(
                    "Diffing " .. sel[1].file .. " against " .. sel[2].file
                  )
                  return
                end

                Snacks.notify.info("Select two entries for the diff")
              end,
            },
          },
          layout = {
            preview = true,
            layout = {
              zindex = 35, -- 1 Below Lazy window
              box = "vertical",
              width = 0,
              height = 0.999,
              border = "top",
              title = " {title} {live} {flags}",
              title_pos = "left",
              {
                box = "horizontal",
                {
                  box = "vertical",
                  {
                    win = "input",
                    height = 1,
                    border = "rounded",
                  },
                  { win = "list", border = "rounded" },
                },
                {
                  win = "preview",
                  title = "{preview}",
                  width = 0.65,
                  border = "rounded",
                },
              },
            },
          },
          exclude = funcs.mergeTablesNoDup(excludeAll, excludeExplorer),
        },
        files = {
          hidden = true,
          ignored = true,
          follow = true,
          show_empty = true,
          win = {
            list = {
              wo = {
                number = true,
                relativenumber = true,
              },
            },
          },
          cmd = "rg",
          exclude = funcs.mergeTablesNoDup(excludeAll, excludeFiles),
        },
        grep = {
          hidden = true,
          ignored = true,
          follow = true,
          show_empty = true,
          win = {
            list = {
              wo = {
                number = true,
                relativenumber = true,
              },
            },
          },
          exclude = funcs.mergeTablesNoDup(excludeAll, excludeGrep),
        },
        register = {
          finder = "vim_registers",
          format = "register",
          preview = "preview",
          confirm = { "copy", "close" },
        },
      },
      icons = {
        tree = {
          vertical = "│ ",
          middle = "├╴",
          last = "╰╴",
        },
        ft = {
          razor = vars.dotnetIcon,
          cshtml = vars.dotnetIcon,
        },
        filetype = {
          razor = vars.dotnetIcon,
          cshtml = vars.dotnetIcon,
        },
        file_type = {
          razor = vars.dotnetIcon,
          cshtml = vars.dotnetIcon,
        },
      },
    },
    win = {
      enabled = false,
      list = {
        wo = {
          number = true,
          relativenumber = true,
        },
      },
    },
    zen = { enabled = false },
  },
  keys = require("config.keymaps.snacks"),
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        local Snacks = require("snacks")
        -- Disable animations globally
        vim.g.snacks_animate = false

        -- Create some toggle mappings
        local toggleConceal = {
          off = 0,
          on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
        }
        -- local toggleBackground = { off = "light", on = "dark", name = "Dark Background" }

        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("conceallevel", toggleConceal):map("<leader>uc")
        -- Snacks.toggle.option("background", toggleBackground):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>th")

        Snacks.toggle.profiler():map("<leader>ppp") -- Toggle the profiler
        Snacks.toggle.profiler_highlights():map("<leader>pph") -- Toggle the profiler highlights

        -- NOTE: Snacks explorer seems to take 100ms to finish, so we run our function after it
        local timeToWait_ms = 105
        vim.defer_fn(checkExplorer, timeToWait_ms)
      end,
    })

    -- Show LSP Progress
    ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
    local progress = vim.defaulttable()
    vim.api.nvim_create_autocmd("LspProgress", {
      ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= "table" then
          return
        end
        local p = progress[client.id]

        for i = 1, #p + 1 do
          if i == #p + 1 or p[i].token == ev.data.params.token then
            p[i] = {
              token = ev.data.params.token,
              msg = ("[%3d%%] %s%s"):format(
                value.kind == "end" and 100 or value.percentage or 100,
                value.title or "",
                value.message and (" **%s**"):format(value.message) or ""
              ),
              done = value.kind == "end",
            }
            break
          end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v)
          return table.insert(msg, v.msg) or not v.done
        end, p)

        local spinner = {
          "⠋",
          "⠙",
          "⠹",
          "⠸",
          "⠼",
          "⠴",
          "⠦",
          "⠧",
          "⠇",
          "⠏",
        }

        -- local spinner = { "", "", "", "", "", "" }
        vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
          id = "lsp_progress",
          title = client.name,
          opts = function(notif)
            notif.icon = #progress[client.id] == 0 and " "
              or spinner[math.floor((vim.uv or vim.loop).hrtime() / (1e6 * 80)) % #spinner + 1]
          end,
        })
      end,
    })
  end,
}
