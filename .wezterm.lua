local wezterm = require("wezterm")
local config = {}
local act = wezterm.action

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.automatically_reload_config = true
config.check_for_updates = true

-- config.term = "xterm-256color"
config.term = "xterm-kitty"
config.enable_kitty_graphics = true

config.leader = { key = "Space", mods = "ALT", timeout_milliseconds = 1000 }

config.keys = {
  { -- Split horizontal
    key = "H",
    mods = "LEADER|SHIFT",
    action = wezterm.action({
      SplitVertical = { domain = "CurrentPaneDomain" },
    }),
  },
  { -- Split vertical
    key = "V",
    mods = "LEADER|SHIFT",
    action = wezterm.action({
      SplitHorizontal = { domain = "CurrentPaneDomain" },
    }),
  },
  { -- Create new tab
    key = "T",
    mods = "CTRL|SHIFT",
    action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
  },
  { -- Activate split left
    key = "h",
    mods = "LEADER",
    action = wezterm.action({ ActivatePaneDirection = "Left" }),
  },
  { -- Activate split down
    key = "j",
    mods = "LEADER",
    action = wezterm.action({ ActivatePaneDirection = "Down" }),
  },
  { -- Activate split up
    key = "k",
    mods = "LEADER",
    action = wezterm.action({ ActivatePaneDirection = "Up" }),
  },
  { -- Activate split right
    key = "l",
    mods = "LEADER",
    action = wezterm.action({ ActivatePaneDirection = "Right" }),
  },
  { -- ?
    key = "a",
    mods = "LEADER|CTRL",
    action = wezterm.action({ SendString = "\x01" }),
  },
  -- Toggle full screen/split screen
  { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
  { -- Adjust split size to left
    key = "-",
    mods = "LEADER",
    action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }),
  },
  { -- Adjust split size downwards
    key = "<",
    mods = "LEADER",
    action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }),
  },
  { -- Adjust split size upwards
    key = ">",
    mods = "LEADER|SHIFT",
    action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }),
  },
  { -- Adjust split size to right
    key = "+",
    mods = "LEADER",
    action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }),
  },
  { -- Close current tab
    key = "x",
    mods = "LEADER",
    action = wezterm.action({ CloseCurrentTab = { confirm = true } }),
  },
  { -- Close current shell/split
    key = "w",
    mods = "LEADER",
    action = wezterm.action({ CloseCurrentPane = { confirm = true } }),
  },
  { -- rotate panes
    key = "Space",
    mods = "LEADER",
    action = wezterm.action.RotatePanes("Clockwise"),
  },
  { -- Swap the active and selected panes
    key = "0",
    mods = "LEADER",
    action = wezterm.action.PaneSelect({
      mode = "SwapWithActive",
    }),
  },
  { -- activate copy mode or vim mode
    key = "Enter",
    mods = "LEADER",
    action = wezterm.action.ActivateCopyMode,
  },
  { key = "h", mods = "LEADER|ALT", action = act.MoveTabRelative(-1) },
  { key = "l", mods = "LEADER|ALT", action = act.MoveTabRelative(1) },
  -- Turn off the default alt-enter Fullscreen action since it conflicts with
  -- my neovim's "mini.jump" key mapping
  {
    key = "Enter",
    mods = "ALT",
    action = wezterm.action.DisableDefaultAssignment,
  },
}

for i = 1, 9 do
  -- LEADER (Default: CTRL + b) + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1),
  })
  -- F1 through F9 to activate that tab
  table.insert(config.keys, {
    key = "F" .. tostring(i),
    action = act.ActivateTab(i - 1),
  })
end

-- config.default_prog = { "powershell.exe -NoProfile" }
-- config.default_prog =
--   { "C:\\Program Files\\PowerShell\\7\\pwsh.exe -WorkingDirectory ~" }
config.default_prog =
  { "C:\\Program Files\\PowerShell\\7\\pwsh.exe", "-NoLogo" }
-- config.default_prog = { "C:\\Program Files\\Git\\bin\\bash.exe" }
-- config.default_prog = { "wsl.exe", "~", "-d", "Ubuntu", "-u", "sd" }
config.color_scheme = "Catppuccin Mocha"
-- config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
-- config.font = wezterm.font("JetBrains Mono")
wezterm.font_with_fallback({
  "JetBrains Mono",
  "Noto Color Emoji",
  "Symbols Nerd Font Mono",
})

config.font_size = 12.0
config.adjust_window_size_when_changing_font_size = false
config.underline_position = -3
config.underline_thickness = "250%"
config.freetype_load_target = "Normal"
config.freetype_render_target = "Normal"
config.freetype_load_flags = "NO_HINTING"
config.disable_default_key_bindings = false
config.enable_wayland = false
config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = false

config.window_frame = {
  font_size = 11.0,
  active_titlebar_bg = "#181825",
  inactive_titlebar_bg = "#11111b",
}

config.colors = {
  tab_bar = {
    active_tab = {
      bg_color = "#cba6f7",
      fg_color = "#45475a",
    },
    inactive_tab = {
      bg_color = "#1e1e2e",
      fg_color = "#a6adc8",
    },
    inactive_tab_hover = {
      bg_color = "#313244",
      fg_color = "#bac2de",
      italic = true,
    },
  },
}
config.window_decorations = "NONE | RESIZE"
config.initial_cols = 80
-- config.front_end = "OpenGL"
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.webgpu_force_fallback_adapter = false

config.background = {
  {
    source = {
      Color = "rgba(30, 30, 46, 1.00)",
    },
    width = "100%",
    height = "100%",
  },
  {
    source = {
      -- File = "C:/Users/sd/nvim/img/grateful_miyamoto_musashi.jpg",
      File = "C:/Users/sd/nvim/img/musashi_myiamoto_grateful.jpg",
    },
    opacity = 0.075,
  },
  {
    source = {
      Color = "rgba(26, 26, 42, 0.95)",
    },
    width = "100%",
    height = "100%",
  },
}

for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
  if gpu.backend == "Vulkan" and gpu.device_type == "DiscreteGpu" then
    config.webgpu_preferred_adapter = gpu
    -- config.front_end = "WebGpu"
    -- config.webgpu_power_preference = "HighPerformance"
    -- config.webgpu_force_fallback_adapter = false
    break
  end
end

return config
