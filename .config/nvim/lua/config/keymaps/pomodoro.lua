local M = {}

local wk = require("which-key")

M.keymaps = wk.add({
  {
    mode = { "n" },
    -- Pomodoro Show UI and Stop
    { "<leader>pui", ":PomodoroUI<CR>", desc = "Pomodoro show UI" },
    { "<leader>pS", ":PomodoroStop<CR>", desc = "Pomodoro stop timer" },

    -- Pomodoro 25/5 minutes work/break
    { "<leader>pow", ":PomodoroStart 25<CR>", desc = "Pomodoro work 25 mins" },
    { "<leader>pob", ":PomodoroForceBreak 5<CR>", desc = "Pomodoro break 5 mins" },

    -- DeskTime's 52/17 minutes work/break
    { "<leader>pdw", ":PomodoroStart 50<CR>", desc = "Pomodoro work 50 mins" },
    { "<leader>pdb", ":PomodoroForceBreak 10<CR>", desc = "Pomodoro break 10 mins" },

    -- DeskTime's updated 112/26 minutes work/break
    { "<leader>puw", ":PomodoroStart 100<CR>", desc = "Pomodoro work 100 mins" },
    { "<leader>pub", ":PomodoroForceBreak 20<CR>", desc = "Pomodoro break 20 mins" }
  }
})

return M.keymaps

