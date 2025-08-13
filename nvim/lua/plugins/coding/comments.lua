-- FIX: Fix me
-- FIXME: Fix me
-- BUG: Fix me
-- FIXIT: Fix me
-- ISSUE: Fix me
--
-- TODO: What else?
--
-- HACK: What am I looking at?
--
-- WARN: ???
-- WARNING: ???
-- XXX: ???
--
-- PERF: BRRR
-- OPTIM: BRRR
-- PERFORMANCE: BRRR
-- OPTIMIZE: BRRR
--
-- NOTE: A note
-- INFO: Just to let you know
-- TRACK: Reference
-- KEEPTRACK: Reference
--
-- TEST: Test
-- TESTING: Testing
-- PASS: it just
-- PASSED: works
-- FAILED: not
-- FAIL: working

return {
  {
    "folke/todo-comments.nvim",
    enabled = true,
    version = false,
    -- lazy = false,
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "TodoTrouble" },
    keys = require("config.keymaps.comments"),
    opts = {
      signs = true,
      sign_priority = 1000,
      colors = {
        peach = { "hl_fg_peach", "#FAB387" },
        sky = { "hl_fg_sky", "#89DCEB" },
        yellow = { "hl_fg_yellow", "#F9E2AF" },
        red = { "hl_fg_red", "#F38BA8" },
        green = { "hl_fg_green", "#A6E3A1" },
        blue = { "hl_fg_blue", "#89B4FA" },
        white = { "hl_fg_white", "#CDD6F4" },
      },
      -- stylua: ignore
      keywords = {
        FIX = { icon = " ", color = "peach", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "sky" },
        HACK = { icon = " ", color = "yellow", },
        WARN = { icon = " ", color = "red", alt = { "WARNING", "XXX" } },
        PERF = { icon = "󱤧 ", color = "green", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "blue", alt = { "INFO", "TRACK", "KEEPTRACK" } },
        TEST = { icon = "󰅐 ", color = "white", alt = { "TESTING", "PASS", "PASSED", "FAILED", "FAIL" } },
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    enabled = true,
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    version = false,
    opts = function()
      return {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },
}
