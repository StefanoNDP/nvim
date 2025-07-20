local vars = require("config.vars")

return {
  "ahmedkhalf/project.nvim",
  enabled = true,
  version = false,
  opts = function()
    require("config.keymaps.project")
    return {
      -- manual_mode = false, -- Change rootDir automatically (false) or manually (true)
      patterns = vars.rootPatterns.general,
      show_hidden = true,
    }
  end,
  event = "VeryLazy",
  config = function(_, opts)
    require("project_nvim").setup(opts)
    local history = require("project_nvim.utils.history")
    history.delete_project = function(project)
      for k, v in pairs(history.recent_projects) do
        if v == project.value then
          history.recent_projects[k] = nil
          return
        end
      end
    end
  end,
}
