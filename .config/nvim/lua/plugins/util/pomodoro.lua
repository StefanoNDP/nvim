return {
  "quentingruber/pomodoro.nvim",
  enabled = true,
  lazy = false, -- Don't change
  opts = function()
    require("config.keymaps.pomodoro")
    return {
      start_at_launch = false,
      work_duration = 25,
      break_duration = 5,
      delay_duration = 1, -- The additionnal work time you get when you delay a break
      long_break_duration = 15,
      breaks_before_long = 4,
    }
  end,
}
