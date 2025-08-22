-- opt-in to use filetype.lua for setting custom filetypes
vim.g.do_filetype_lua = 1 -- Enable

vim.scriptencoding = "utf-8" -- Set encoding to utf-8
vim.opt.encoding = "utf-8" -- Set encoding to utf-8
vim.opt.fileencoding = "utf-8" -- Set encoding to utf-8
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.wildoptions = "pum"
vim.opt.pumblend = 5
vim.opt.formatoptions:append({ "r" }) -- Add asterisk in blocked appends
vim.opt.title = true

vim.o.autochdir = false

vim.opt.showcmd = true
vim.opt.cmdheight = 0
vim.opt.laststatus = 2
-- vim.opt.statuscolumn = "%s %{v:relnum} %{v:lnum}"

vim.opt.inccommand = "split" -- Preview commands

-- 0 for dap-ui 1 for dap-view
vim.g.whichDap = 0

local funcs = require("config.functions")
if funcs.get_os() == "windows" then
  vim.g.undotree_DiffCommand = vim.fn.stdpath("config") .. "/bin/diff.exe"
  vim.g.sqlite_clib_path = vim.fn.stdpath("config") .. "/sqlite/sqlite3.dll"

  vim.g.nofsync = true

  vim.opt.shell = "powershell"
  vim.o.shellcmdflag =
    "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';"

  -- Setting shell redirection
  vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'

  -- Setting shell pipe
  vim.o.shellpipe = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'

  -- Setting shell quote options
  vim.o.shellquote = ""
  vim.o.shellxquote = ""

  vim.opt.shellslash = false
  vim.o.shellslash = false
  vim.g.shellslash = false

  vim.cmd([[set noshellslash]])

  -- Set python3 host prog
  vim.g.python3_host_prog = "C:\\Python310\\python.exe"
else
  -- Set python3 host prog
  vim.g.python3_host_prog = "/usr/bin/python3"
end

-- recommended settings
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_keepdir = 1
vim.g.netrw_liststyle = 3

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.g.nvim_tree_respect_buf_cwd = 1
vim.g.nvim_tree_update_cwd = 1

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Hide deprecation warnings
vim.g.deprecation_warnings = false
vim.g.VM_show_warnings = false

-- Line numbers
vim.o.nu = true
vim.o.rnu = true

-- -- OSC 52 (Operating System Command) support
-- -- Control sequence that causes the terminal emulator to write to or read from the system clipboard.
-- vim.g.clipboard = {
--   name = "OSC 52",
--   copy = {
--     ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
--     ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
--   },
--   paste = {
--     ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
--     ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
--   },
-- }
-- vim.g.clipboard = "osc52"

-- Clipboard accross everything
vim.opt.clipboard:append({ "unnamed", "unnamedplus", vim.env.SSH_TTY }) -- Append system clipboard to the register
-- vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

-- Disable Perl, Ruby
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.editorconfig = true

-- Tab and indentation
vim.opt.tabstop = 4 -- 4 Spaces for tabs
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4 -- 4 Spaces for indent width
vim.opt.expandtab = true -- Expand tab to spaces
vim.opt.cindent = true
vim.opt.smartindent = true
vim.opt.autoindent = true -- Copy indent from current line when starting a new one
vim.opt.wrap = false

vim.opt.breakindent = true
vim.opt.linebreak = true

-- Undo start
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undolevels = 10000

if vim.fn.isdirectory(vim.fn.expand("~") .. "/.vim/undodir") == 0 then
  vim.cmd([[silent !mkdir -p ~/.vim/undodir]])
end

vim.opt.undodir = vim.fn.expand("~") .. "/.vim/undodir"

vim.opt.undofile = true
-- Undo end

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- If mixed case in search, assumes case-sensitive
vim.opt.cursorline = true -- Highlight current/cursor line
vim.opt.cursorcolumn = true -- Highlight current/cursor column

vim.opt.hidden = true -- Keep buffers in memory
vim.opt.termguicolors = true -- Use truecolor in the terminal
vim.opt.winblend = 0
vim.opt.background = "dark" -- Colorschemes that can be light or dark will be made dark
vim.opt.backspace = { "start", "eol", "indent" } -- Allow backspace on indent, end of line or insert mode start position
vim.opt.splitright = true -- Split vertical window to the right
vim.opt.splitbelow = true -- Split horizontal window to the bottom
vim.opt.splitkeep = "cursor" --
vim.opt.showmode = false -- Dont show mode since we have a statusline
-- vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.mouse = "" -- Disable mouse mode
vim.opt.mousemoveevent = false
vim.opt.sidescrolloff = 1 -- Columns of context
vim.opt.scrolloff = 10 -- Lines of context
vim.opt.isfname:append("@-@")

-- Milliseconds to wait after nothing is typed before writting swapfile to disk
-- Also used for CursorHold
vim.opt.updatetime = 250

vim.opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
-- menu: popup menu to show possible completions
-- menuone: popup even when there's only one match
-- noselect: Do not select, force to select one from the menu
-- noinsert: Do not insert text until a selection is made
-- preview: Show extra information about the currently selected completion.
vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert", "preview" } -- Better completion experience

vim.opt.shortmess = vim.opt.shortmess + { c = true } -- Avoid showing extra messages when using completion
vim.opt.textwidth = 80 -- Max width/columns
vim.opt.colorcolumn = "+1" -- Show gutter after textwidth
vim.opt.signcolumn = "yes" -- Show sign column so that text doesn't shift

-- Spelling
-- medical spellfile from https://github.com/melvio/medical-spell-files
-- vim.opt.spelllang = { "en_us", "pt_pt", "pt_br", "medical" }
-- vim.opt.spelllang = { "en_us", "pt_pt", "medical" }
vim.opt.spelllang = { "en_us" }
vim.opt.spellfile = { os.getenv("HOME") .. "/.config/nvim/spell/en.utf-8.add" } -- extra words
vim.opt.spelloptions = "camel" -- Split camelCase words when spellchecking

-- vim.g.commentstring = "" -- Mini.nvim comment

vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings
vim.opt.listchars:append({ lead = "_", tab = " »", trail = "" })
vim.opt.list = true -- Show some invisible characters (tab, space, white space, etc)

-- Folds
vim.opt.foldcolumn = "0" -- Show gutter
vim.opt.foldmethod = "manual"
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""

vim.opt.foldnestmax = 6
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "/",
  eob = " ",
}

-- Highlight groups
vim.api.nvim_set_hl(0, "hl_black", { fg = "#cdd6f4", bg = "#11111b" })
vim.api.nvim_set_hl(0, "hl_magenta", { fg = "#11111b", bg = "#f5c2e7" })
vim.api.nvim_set_hl(0, "hl_cyan", { fg = "#11111b", bg = "#94e2d5" })
vim.api.nvim_set_hl(0, "hl_white", { fg = "#11111b", bg = "#cdd6f4" })
vim.api.nvim_set_hl(0, "hl_rosewate", { fg = "#11111b", bg = "#f5e0dc" })
vim.api.nvim_set_hl(0, "hl_flamingo", { fg = "#11111b", bg = "#f2cdcd" })
vim.api.nvim_set_hl(0, "hl_pink", { fg = "#11111b", bg = "#f5c2e7" })
vim.api.nvim_set_hl(0, "hl_mauve", { fg = "#11111b", bg = "#cba6f7" })
vim.api.nvim_set_hl(0, "hl_red", { fg = "#11111b", bg = "#f38ba8" })
vim.api.nvim_set_hl(0, "hl_maroon", { fg = "#11111b", bg = "#eba0ac" })
vim.api.nvim_set_hl(0, "hl_peach", { fg = "#11111b", bg = "#fab387" })
vim.api.nvim_set_hl(0, "hl_yellow", { fg = "#11111b", bg = "#f9e2af" })
vim.api.nvim_set_hl(0, "hl_green", { fg = "#11111b", bg = "#a6e3a1" })
vim.api.nvim_set_hl(0, "hl_teal", { fg = "#11111b", bg = "#94e2d5" })
vim.api.nvim_set_hl(0, "hl_sky", { fg = "#11111b", bg = "#89dceb" })
vim.api.nvim_set_hl(0, "hl_sapphire", { fg = "#11111b", bg = "#74c7ec" })
vim.api.nvim_set_hl(0, "hl_blue", { fg = "#11111b", bg = "#89b4fa" })
vim.api.nvim_set_hl(0, "hl_lavender", { fg = "#11111b", bg = "#b4befe" })
vim.api.nvim_set_hl(0, "hl_text", { fg = "#11111b", bg = "#cdd6f4" })
vim.api.nvim_set_hl(0, "hl_subtext1", { fg = "#11111b", bg = "#bac2de" })
vim.api.nvim_set_hl(0, "hl_subtext0", { fg = "#11111b", bg = "#a6adc8" })
vim.api.nvim_set_hl(0, "hl_overlay2", { fg = "#11111b", bg = "#9399b2" })
vim.api.nvim_set_hl(0, "hl_overlay1", { fg = "#11111b", bg = "#7f849c" })
vim.api.nvim_set_hl(0, "hl_overlay0", { fg = "#cdd6f4", bg = "#6c7086" })
vim.api.nvim_set_hl(0, "hl_surface2", { fg = "#cdd6f4", bg = "#585b70" })
vim.api.nvim_set_hl(0, "hl_surface1", { fg = "#cdd6f4", bg = "#45475a" })
vim.api.nvim_set_hl(0, "hl_surface0", { fg = "#cdd6f4", bg = "#313244" })
vim.api.nvim_set_hl(0, "hl_base", { fg = "#cdd6f4", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_mantle", { fg = "#cdd6f4", bg = "#181825" })
vim.api.nvim_set_hl(0, "hl_crust", { fg = "#cdd6f4", bg = "#11111b" })

vim.api.nvim_set_hl(0, "hl_fg_black", { fg = "#11111b", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_magenta", { fg = "#f5c2e7", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_cyan", { fg = "#94e2d5", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_white", { fg = "#cdd6f4", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_rosewate", { fg = "#f5e0dc", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_flamingo", { fg = "#f2cdcd", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_pink", { fg = "#f5c2e7", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_mauve", { fg = "#cba6f7", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_red", { fg = "#f38ba8", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_maroon", { fg = "#eba0ac", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_peach", { fg = "#fab387", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_yellow", { fg = "#f9e2af", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_green", { fg = "#a6e3a1", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_teal", { fg = "#94e2d5", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_sky", { fg = "#89dceb", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_sapphire", { fg = "#74c7ec", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_blue", { fg = "#89b4fa", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_lavender", { fg = "#b4befe", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_text", { fg = "#cdd6f4", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_subtext1", { fg = "#bac2de", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_subtext0", { fg = "#a6adc8", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_overlay2", { fg = "#9399b2", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_overlay1", { fg = "#7f849c", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_overlay0", { fg = "#6c7086", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_surface2", { fg = "#585b70", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_surface1", { fg = "#45475a", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_surface0", { fg = "#313244", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_base", { fg = "#1e1e2e", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_mantle", { fg = "#181825", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "hl_fg_crust", { fg = "#11111b", bg = "#1e1e2e" })

vim.g.conceallevel = 0

vim.cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
  highlight CursorColumn guibg=#313244 ctermbg=none
]])
