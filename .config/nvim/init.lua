vim.loader.enable()

if vim.g.neovide then
  -- Font
  vim.o.guifont = "JetBrainsMono Nerd Font Mono:h11"
  vim.g.neovide_font_hinting = "none"
  vim.g.neovide_font_edging = "subpixelantialias"

  -- Opacity
  vim.g.neovide_opacity = 0.95
  vim.g.neovide_normal_opacity = 0.95

  -- Blur
  vim.g.neovide_window_blurred = false
  vim.g.neovide_floating_blur_amount_x = 0.0
  vim.g.neovide_floating_blur_amount_y = 0.0

  -- Animation
  vim.g.neovide_position_animation_length = 0.1
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_cursor_short_animation_length = 0.03

  -- Mouse
  vim.g.neovide_hide_mouse_when_typing = false

  -- FPS
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_refresh_rate_idle = 5

  -- Cursor
  vim.g.neovide_curosr_hack = true -- Prevents flickering to command line
  vim.g.neovide_cursor_trail_size = 1.0
  vim.g.neovide_cursor_antialiasing = false
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_cursor_vfx_particle_lifetime = 0.25
  vim.g.neovide_cursor_vfx_particle_highlight_lifetime = 0.25
  vim.g.neovide_cursor_vfx_particle_density = 0.85
  vim.g.neovide_cursor_vfx_particle_speed = 15.0
end

require("config")
