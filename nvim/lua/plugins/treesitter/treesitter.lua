return {
  { -- HTML and JSX
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    enabled = true,
    version = false,
    opts = function()
      return {
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
        aliases = {
          ["cshtml"] = "html",
          ["razor"] = "html",
        },
      }
    end,
    config = function(_, opts)
      require("nvim-ts-autotag").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    enabled = true,
    version = false,
    event = "VeryLazy",
    opts = function()
      return {
        enable = true,
        mode = "cursor",
        trim_scope = "inner",
        max_lines = 6,
        separator = "-",
      }
    end,
    config = function(_, opts)
      require("treesitter-context").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    enabled = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    version = false,
    event = "VeryLazy",
    opts = function()
      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
      local configs = require("nvim-treesitter.configs")
      for name, fn in pairs(move) do
        if name:find("goto") == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
      return {
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]A"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[A"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      }
    end,
    config = function(_, opts)
      -- If treesitter is already loaded, we need to run config again for textobjects
      if require("config.functions").isLoaded("nvim-treesitter") then
        require("nvim-treesitter.configs").setup({
          textobjects = opts.textobjects,
        })
      end
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    enabled = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    version = false,
    opts = function()
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring"
            and require("ts_context_commentstring.internal").calculate_commentstring()
          or get_option(filetype, option)
      end
      return {
        enable_autocmd = false,
        languages = {
          axaml = "<!-- %s -->",
          blueprint = "// %s",
          c_sharp = { __default = "// %s", __multiline = "/* %s */" },
          csharp = { __default = "// %s", __multiline = "/* %s */" },
          cs = { __default = "// %s", __multiline = "/* %s */" },
          c_project = "<!-- %s -->",
          clojure = ";; %s",
          fsharp = { __default = "// %s", __multiline = "/* %s */" },
          fsharp_project = "<!-- %s -->",
          hyprlang = "# %s",
          ipynb = "# %s",
          kdl = "// %s",
          rust = { __default = "// %s", __multiline = "/* %s */" },
          styled = "/* %s */",
          xaml = "<!-- %s -->",
        },
      }
    end,
    config = function(_, opts)
      require("ts_context_commentstring").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = true,
    version = false,
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = { "LiadOz/nvim-dap-repl-highlights" },
    opts = function()
      local vars = require("config.vars")
      local maxSize = vars.maxFileSize
      local size = vim.fn.getfsize(vim.fn.expand("%"))
      if size >= maxSize then
        local clients = vim.lsp.get_clients()
        for _, lclient in ipairs(clients) do
          vim.lsp.stop_client(lclient)
        end
        return
      end
      require("nvim-treesitter.install").prefer_git = false
      -- require("nvim-treesitter.install").compilers = { "zig" }
      vim.g.skip_ts_context_commentstring_module = true

      -- Windows: https://code.visualstudio.com/docs/cpp/config-mingw
      -- Follow the steps 1-7 of "Installing the MingGW-w64 toolchain"
      -- Before running "pacman -S --needed ...." run "pacman -Syu" first
      -- Choose the "mingw-w64-ucrt-x86_64-gcc" as of this writting, it is number 3 (Three)
      return {
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = {
          -- "maintained",
          "bash",
          "c",
          "c_sharp",
          "cmake",
          "comment",
          "cpp",
          "css",
          -- "dap_repl",
          "diff",
          -- "gdscript",
          -- "gdshader",
          -- "godot_resource",
          "git_config",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "go",
          "godot_resource",
          -- "graphql",
          "html",
          "http",
          -- "hyprlang",
          "ini",
          -- "javascript",
          "json",
          "json5",
          "jsonc",
          "latex",
          -- "llvm",
          "lua",
          "luadoc",
          "luap",
          "make",
          -- "markdown",
          -- "markdown_inline",
          -- "norg",
          -- "php",
          "printf",
          "query",
          "rasi",
          "razor",
          "regex",
          -- "ron",
          -- "rust",
          "sql",
          -- "swift",
          -- "toml",
          -- "tsx",
          -- "typescript",
          "vim",
          "vimdoc",
          "xml",
          "yaml",
        },
        -- ignore_install = { "org" }, -- orgmode.nvim. Only required if ensure_instaleld = "all"

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        auto_install = true,

        indent = {
          enable = true,
        },

        autotag = true,

        -- Syntax highlighting
        highlight = {
          enable = true,
          -- additional_vim_regex_highlighting = false,
          additional_vim_regex_highlighting = { "markdown" },
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      }
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      -- vim.treesitter.language.register("bash", "kitty")
      -- vim.treesitter.language.register("markdown", "octo")

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
}
