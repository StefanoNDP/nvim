return {
  -- "arakkkkk/kanban.nvim" -- Original Author
  "yugapanda/kanban.nvim", -- I prefer his changes
  enabled = true,
  version = false,
  opts = function()
    return {
      markdown = {
        description_folder = "./tasks/", -- Path to save the file corresponding to the task.
        list_head = "## ",
      },
    }
  end,
  config = function(_, opts)
    require("kanban").setup(opts)
  end,
}
