local wk = require("which-key")

local funcs = require("config.functions")

-- Modes:
-- n = normal
-- i = insert
-- s = select
-- x = visual
-- v = visual and select
-- c = command-line
-- t = terminal
-- o = operator-pending: like d, y, c, etc

wk.add({
  { -- Visual mode only
    mode = { "v" },
    -- Keep things highlighted after moving with < and >
    { "<", "<gv", desc = "Move left keeping highlight" },
    { ">", ">gv", desc = "Move right keeping highlight" },

    {
      "<leader>s",
      [[y:<C-u>%s/<C-r>0/<C-r>0/gI<Left><Left><Left>]],
      desc = "Replace all instances of the selection",
    },
  },
  { -- Normal mode only
    mode = { "n" },

    {
      "<leader><leader>",
      function()
        vim.cmd("so")
      end,
      desc = "Source file",
    },

    -- Diff
    { "<leader>dt", ":windo diffthis<CR>", desc = "Diff current split windows" },
    { "<leader>do", ":windo diffoff<CR>", desc = "Stop Diff" },

    -- splits a one liner {} block separated by ';' into separate lines
    { "]j", "f{i<CR><ESC>lli<CR><ESC>f;a<CR><ESC>f;a<CR><ESC>f;a<CR><ESC>f;a<CR><ESC>", desc = "" },

    -- Rectangular selection
    { "<leader>su", vim.cmd.UndotreeToggle, desc = "Open undotree" },
    { "<leader>nh", "<cmd>nohl<CR>", desc = "[N]o [H]ighlights" },
    { "D", "<cmd>bd<CR>", desc = "Cloes current buffer/tab" },
    { "<M-d>", "<cmd>delete<CR>", desc = "Same as 'dd'" },

    { "J", "mzJ`z", desc = "J stays at beginning of line" },
    { "<C-u>", "<C-u>zz", desc = "Half-page jump up" },
    { "<C-d>", "<C-d>zz", desc = "Half-page jump down" },

    -- Keep stuff centered while moving around
    { "*", "*zzzv", desc = "Next item in search" },
    { "#", "#zzzv", desc = "Previous item in search" },
    { ",", ",zzzv", desc = "Next item in search" },
    { ";", ";zzzv", desc = "Previous item in search" },
    { "n", "nzzzv", desc = "Next item in search" },
    { "N", "Nzzzv", desc = "Previous item in search" },

    { "Q", "<Nop>", desc = "No more [Q]uitting by mistake" },

    { "j", "gj", desc = "Move down wrapped line" },
    { "k", "gk", desc = "Move up wrapped line" },

    -- vim's quickfix navigation
    { "<C-k>", "<cmd>cnext<CR>zz", desc = "Next Quickfix" },
    { "<C-j>", "<cmd>cprev<CR>zz", desc = "Previous Quickfix" },
    { "<leader>po", "<cmd>copen<CR>zz", desc = "Open Quickfix" },
    { "<leader>k", "<cmd>lnext<CR>zz", desc = "Next Location" },
    { "<leader>j", "<cmd>lprev<CR>zz", desc = "Previous Location" },

    -- Window management
    { "<C-M-i>", "<C-w>+", desc = "Increase Split relative to the current active split" },
    { "<C-M-d>", "<C-w>-", desc = "Decrease Split relative to the current active split" },
    { "<M-m>", "<C-w><", desc = "Increase Split relative to the current active split" },
    { "<M-p>", "<C-w>>", desc = "Decrease Split relative to the current active split" },
    { "<leader>sv", "<C-w>v<C-w>><C-w>><C-w>><C-w>>", desc = "Split window vertically" },
    { "<leader>sh", "<C-w>s", desc = "Split window horizontally" },
    { "<leader>se", "<C-w>=", desc = "Make splits equal size" },
    { "<leader>sx", "<cmd>close<CR>", desc = "Close current split" },

    -- -- Tab management
    -- { "<leader>to", "<cmd>tabnew<CR>", desc = "Open new tab" },
    -- { "<leader>tf", "<cmd>tabnew %<CR>", desc = "Open current buffer in new tab" },
    -- { "<leader>tt", "<cmd>tabn<CR>", desc = "Go to previous tab" },
    -- { "<leader>tT", "<cmd>tabp<CR>", desc = "Go to previous tab" },
    -- { "<leader>tx", "<cmd>tabclose<CR>", desc = "Close current tab" },

    { "<leader>x", "<cmd>!chmod +x %<CR>", desc = "Same as 'chmod +x file'" },

    { "<leader>it", "<cmd>InspectTree<CR>", desc = "Inspect Tree" },

    {
      "<leader>s",
      [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
      desc = "Replace all instances of the word under the cursor",
    },

    -- -- Tmux
    -- {
    --   "<C-f>",
    --   "<cmd>silent !tmux neww ~/dotfiles/scripts/tmux-sessionizer<CR>",
    --   desc = "Search and create a new tmux session based on the basename of the file chosen",
    -- },
    -- { "<M-Left>", "<cmd>TmuxNavigateLeft<CR>", desc = "Move to left window" },
    -- { "<M-Down>", "<cmd>TmuxNavigateDown<CR>", desc = "Move to Down window" },
    -- { "<M-Up>", "<cmd>TmuxNavigateUp<CR>", desc = "Move to Up window" },
    -- { "<M-Right>", "<cmd>TmuxNavigateRight<CR>", desc = "Move to right window" },
    -- {
    --   "<leader>tm",
    --   function()
    --     vim.cmd([[silent !tmux set status]])
    --   end,
    --   desc = "Toggle tmux statusline on/off",
    -- },

    -- HACK: Create table of contents in neovim with markdown-toc
    -- https://youtu.be/BVyrXsZ_ViA
    {
      "<leader>mtt",
      function()
        funcs.update_markdown_toc("## Contents", "### Table of contents")
      end,
      { desc = "[P]Insert/update Markdown TOC (English)" },
    },
  },
  { -- Normal and Visual and Select modes
    mode = { "n", "v" },
    -- Enable/Disable rectangular selection
    { "<leader>ven", ":set ve=none<CR>", desc = "Disable rectangular selection" },
    { "<leader>vea", ":set ve=all<CR>", desc = "Enable rectangular selection" },

    -- Register
    { "<leader>d", [["_d]], desc = "Delete without copying deleted content" },
  },
  { -- Visual mode only
    mode = { "x" },
    { "<leader>p", [["_dP]], desc = "Paste preserving yank" },
  },
})
