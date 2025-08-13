local M = {}

local wk = require("which-key")
local gitsigns = require("gitsigns")

M.keymaps = wk.add({
  {
    mode = { "n" },
    -- Navigation
    {
      "]c",
      function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end,
      desc = "",
    },

    {
      "[c",
      function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end,
      desc = "",
    },

    -- Actions
    { "<leader>gss", gitsigns.stage_hunk },
    { "<leader>gsr", gitsigns.reset_hunk },
    { "<leader>gsu", gitsigns.undo_stage_hunk },

    { "<leader>gsS", gitsigns.stage_buffer },
    { "<leader>gsR", gitsigns.reset_buffer },
    { "<leader>gsp", gitsigns.preview_hunk },
    { "<leader>gsi", gitsigns.preview_hunk_inline },

    {
      "<leader>gsb",
      function()
        gitsigns.blame_line({ full = true })
      end,
      desc = "",
    },

    { "<leader>gsd", gitsigns.diffthis, desc = "" },

    {
      "<leader>gsD",
      function()
        gitsigns.diffthis("~")
      end,
      desc = "",
    },

    { "<leader>gsb", gitsigns.toggle_current_line_blame, desc = "" },
    { "<leader>gst", gitsigns.toggle_deleted, desc = "" },
    { "<leader>gsw", gitsigns.toggle_word_diff, desc = "" },
    { "<leader>gsl", gitsigns.toggle_linehl, desc = "" },
    {
      "<leader>gso",
      function()
        gitsigns.toggle_linehl()
        gitsigns.toggle_deleted()
      end,
      desc = "",
    },
  },
  {
    mode = { "v" },
    {
      "<leader>gss",
      function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end,
      desc = "",
    },
    {
      "<leader>gsr",
      function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end,
      desc = "",
    },
  },
  {
    mode = { "o", "x" },
    { "ih", gitsigns.select_hunk, desc = "" },
  },
})

return M.keymaps
