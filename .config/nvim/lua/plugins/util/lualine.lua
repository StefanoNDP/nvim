local M = {}

local colors = require("config.colors").words

M.merge_colors = function(foreground, background)
  local new_name = foreground .. background

  local hl_fg = vim.api.nvim_get_hl(0, { name = foreground })
  local hl_bg = vim.api.nvim_get_hl(0, { name = background })

  local fg = string.format("#%06x", hl_fg.fg and hl_fg.fg or 0)
  local bg = string.format("#%06x", hl_bg.bg and hl_bg.bg or 0)

  vim.api.nvim_set_hl(0, new_name, { fg = fg, bg = bg })
  return new_name
end

M.get_dap_repl_winbar = function(active)
  return function()
    local get_mode = require("lualine.highlight").get_mode_suffix
    local filetype = vim.bo.filetype
    local disabled_filetypes = { "dap-view", "dap-repl", "dap-view-term" }

    if not vim.tbl_contains(disabled_filetypes, filetype) then
      return ""
    end

    local background_color =
      string.format("lualine_b" .. "%s", active and get_mode() or "_inactive")

    local controls_string = "%#" .. background_color .. "#"
    for element in require("dapui.controls").controls():gmatch("%S+") do
      local color, action = string.match(element, "%%#(.*)#(%%.*)%%#0#")
      controls_string = controls_string
        .. " %#"
        .. M.merge_colors(color, background_color)
        .. "#"
        .. action
    end
    return controls_string
  end
end

M.diff_source = function()
  local added = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.added or 0
  local modified = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.changed or 0
  local removed = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.removed or 0
  if added == 0 and modified == 0 and removed == 0 then
    return nil
  else
    return { added = added, modified = modified, removed = removed }
  end
end

M.conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 and M.conditions.checkFileSize()
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 96
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
  check_diff = function()
    local added = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.added or 0
    local modified = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.changed or 0
    local removed = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.removed or 0
    if added > 0 or modified > 0 or removed > 0 then
      return true
    end
    return false
  end,
  check_diagnostic = function()
    local errors = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warns = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local infos = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    local hints = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    if #errors > 0 or #warns > 0 or #infos > 0 or #hints > 0 then
      return true
    end
    return false
  end,
  checkFileSize = function()
    local file = vim.fn.expand("%:p")
    local size = vim.fn.getfsize(file)
    if size <= 0 then
      return false
    end
    return true
  end,
  checkLsp = function()
    local clients = vim.lsp.get_clients()
    return next(clients) ~= nil
  end,
  -- Lsp server name .
  lspInfo = function()
    local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    local clients = vim.lsp.get_clients()
    local client_names = {}
    for _, client in ipairs(clients) do
      table.insert(client_names, client.name)
    end
    if #client_names > 0 then
      return table.concat(client_names, ", ")
    else
      return ""
    end
  end,
}

M.line = function()
  local lazy_status = require("lazy.status") -- to configure lazy pending updates count
  local snacks = require("snacks")
  return {
    line_a = {
      -- "mode",
      -- {
      --   function()
      --     return ""
      --   end,
      --   cond = M.conditions.checkFileSize,
      -- },
      {
        -- filesize component
        "filesize",
        cond = M.conditions.checkFileSize,
      },
      {
        function()
          return ""
        end,
        cond = M.conditions.buffer_not_empty,
      },
      {
        "filename",
        path = 0,
        newfile_status = true,
        cond = M.conditions.buffer_not_empty,
      },
    },
    line_b = {
      {
        "branch",
        cond = M.conditions.check_git_workspace,
      },
      -- stylua: ignore
      {
        function() return "" end,
        cond = M.conditions.check_git_workspace and (M.conditions.check_diff or M.conditions.check_diagnostic),
      },
      {
        "diff",
        colored = true,
        symbols = { added = "+", modified = "~", removed = "-" },
        source = M.diff_source,
        cond = M.conditions.hide_in_width,
      },
      -- stylua: ignore
      {
        function() return "" end,
        cond = M.conditions.check_diagnostic and (M.conditions.check_git_workspace or M.conditions.check_diff),
      },
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = "✘ ", warn = "▲ ", hint = "⚑ ", info = "» " },
        diagnostics_color = {
          error = { fg = colors.red },
          warn = { fg = colors.yellow },
          hint = { fg = colors.blue },
          info = { fg = colors.cyan },
        },
        always_visible = false,
        update_in_insert = true,
      },
    },
    line_c = {},
    line_x = {
      {
        function()
          return ""
        end,
        cond = snacks.profiler.running,
      },
      {
        snacks.profiler.status,
        cond = snacks.profiler.running,
      },
      {
        function()
          return ""
        end,
        cond = lazy_status.has_updates,
      },
      {
        lazy_status.updates,
        cond = lazy_status.has_updates,
      },
      {
        function()
          return ""
        end,
        cond = M.conditions.buffer_not_empty,
      },
      { "encoding", cond = M.conditions.buffer_not_empty },
      function()
        return ""
      end,
      -- { "fileformat" },
      -- {
      --   function()
      --     return ""
      --   end,
      --   cond = M.conditions.buffer_not_empty,
      -- },
      {
        "filetype",
      },
    },
    line_y = {
      "progress",
      -- function()
      --   return ""
      -- end,
      -- "location",
    },
    line_z = {
      --   "os.date('%d/%m/%Y %H:%M:%S')",
    },
  }
end

M.win = {
  win_a = {
    {
      "navic",
      cond = function()
        return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
      end,
      color_correction = "dynamic",
    },
  },
  win_b = {
    M.get_dap_repl_winbar(true),
  },
  win_c = {
    {
      function()
        return "%="
      end,
      cond = M.conditions.checkLsp,
    },
    {
      function()
        return ""
      end,
      cond = M.conditions.checkLsp,
    },
    {
      M.conditions.lspInfo,
      icon = " LSP:",
      color = { fg = colors.white, gui = "bold" },
      cond = M.conditions.checkLsp,
    },
    {
      function()
        return ""
      end,
      cond = M.conditions.checkLsp,
    },
  },
  win_x = {},
  win_y = {
    -- "os.date('%d/%m/%Y %H:%M:%S')",
  },
  win_z = {
    "os.date('%d/%m/%Y %H:%M:%S')",
    -- function()
    --   return "   "
    -- end,
  },
}

M.lualine = {
  "nvim-lualine/lualine.nvim",
  enabled = true,
  version = false,
  event = "VeryLazy",
  opts = function()
    return {
      options = {
        disabled_filetypes = {
          winbar = {
            "dap-view",
            "dap-repl",
            "dap-view-term",
          },
        },
        component_separators = "",
        theme = "catppuccin",
      },
      sections = {
        lualine_a = M.line().line_a,
        lualine_b = M.line().line_b,
        lualine_c = M.line().line_c,
        lualine_x = M.line().line_x,
        lualine_y = M.line().line_y,
        lualine_z = M.line().line_z,
      },
      inactive_sections = {
        lualine_a = M.line().line_a,
        lualine_b = M.line().line_b,
        lualine_c = M.line().line_c,
        lualine_x = M.line().line_x,
        lualine_y = M.line().line_y,
        lualine_z = M.line().line_z,
      },
      tabline = {},
      extensions = {},
      winbar = {
        lualine_a = M.win.win_a,
        lualine_b = M.win.win_b,
        lualine_c = M.win.win_c,
        lualine_x = M.win.win_x,
        lualine_y = M.win.win_y,
        lualine_z = M.win.win_z,
      },
      inactive_winbar = {
        lualine_a = M.win.win_a,
        lualine_b = M.win.win_b,
        lualine_c = M.win.win_c,
        lualine_x = M.win.win_x,
        lualine_y = M.win.win_y,
        lualine_z = M.win.win_z,
      },
    }
  end,
  config = function(_, opts)
    require("lualine").setup(opts)
  end,
}

return M.lualine
