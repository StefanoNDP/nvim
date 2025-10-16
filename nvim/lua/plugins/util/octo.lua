return {
  "pwntester/octo.nvim",
  enabled = vim.g.isDesktop,
  version = false,
  cmd = "Octo",
  event = { { event = "BufReadCmd", pattern = "octo://*" } },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
    "nvim-mini/mini.icons",
  },
  opts = function()
    return {
      enable_builtin = true,
      default_to_projects_v2 = true,
      default_merge_method = "squash",
      default_remote = { "origin", "upstream" },
      picker = "snacks",
    }
  end,
  keys = require("config.keymaps.octo"),
  config = function(_, opts)
    -- Keep some empty windows in sessions
    vim.api.nvim_create_autocmd("ExitPre", {
      group = vim.api.nvim_create_augroup("octo_exit_pre", { clear = true }),
      callback = function(ev)
        local keep = { "octo" }
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.tbl_contains(keep, vim.bo[buf].filetype) then
            vim.bo[buf].buftype = "" -- set buftype to empty to keep the window
          end
        end
      end,
    })
    require("octo").setup(opts)
  end,
}
