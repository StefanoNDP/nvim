return { -- Global/local settings
  "folke/neoconf.nvim",
  enabled = false,
  version = false,
  -- priority = 1000,
  lazy = false,
  cmd = "Neoconf",
  opts = function()
    return {
      local_settings = ".neoconf.json", -- name of the local settings files
      global_settings = "neoconf.json", -- name of the global settings file in your Nvim config directory
      import = { -- import existing settings from other plugins
        vscode = true, -- local .vscode/settings.json
        coc = true, -- global/local coc-settings.json
        nlsp = true, -- global/local nlsp-settings.nvim json settings
      },
    }
  end,
  config = function(_, opts)
    require("neoconf").setup(opts)
  end,
}
