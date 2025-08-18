local M = {}

-- Catppuccin Mocha Colors
M.words = {
  -- red = "#ff0000",
  -- green = "#00ff00",
  -- blue = "#0000ff",
  -- black = "#000000",
  -- white = "#ffffff",

  black = "#11111b",
  magenta = "#f5c2e7",
  cyan = "#94e2d5",
  white = "#cdd6f4",
  rosewater = "#f5e0dc",
  flamingo = "#f2cdcd",
  pink = "#f5c2e7",
  mauve = "#cba6f7",
  red = "#f38ba8",
  maroon = "#eba0ac",
  peach = "#fab387",
  yellow = "#f9e2af",
  green = "#a6e3a1",
  teal = "#94e2d5",
  sky = "#89dceb",
  sapphire = "#74c7ec",
  blue = "#89b4fa",
  lavender = "#b4befe",
  text = "#cdd6f4",
  subtext1 = "#bac2de",
  subtext0 = "#a6adc8",
  overlay2 = "#9399b2",
  overlay1 = "#7f849c",
  overlay0 = "#6c7086",
  surface2 = "#585b70",
  surface1 = "#45475a",
  surface0 = "#313244",
  base = "#1e1e2e",
  mantle = "#181825",
  crust = "#11111b",
}

-- scheme: "Catppuccin Mocha"
-- author: "https://github.com/catppuccin/catppuccin"
-- base00: "1e1e2e" # base
-- base01: "181825" # mantle
-- base02: "313244" # surface0
-- base03: "45475a" # surface1
-- base04: "585b70" # surface2
-- base05: "cdd6f4" # text
-- base06: "f5e0dc" # rosewater
-- base07: "b4befe" # lavender
-- base08: "f38ba8" # red
-- base09: "fab387" # peach
-- base0A: "f9e2af" # yellow
-- base0B: "a6e3a1" # green
-- base0C: "94e2d5" # teal
-- base0D: "89b4fa" # blue
-- base0E: "cba6f7" # mauve
-- base0F: "f2cdcd" # flamingo

-- Not needed, but here just in case
-- vim.api.nvim_set_hl(0, "NavicIconsFile", { default = true, bg = "#1e1e2e", fg = "#6c7086" })
-- vim.api.nvim_set_hl(0, "NavicIconsModule", { default = true, bg = "#1e1e2e", fg = "#4ec9b0" })
-- vim.api.nvim_set_hl(0, "NavicIconsNamespace", { default = true, bg = "#1e1e2e", fg = "#f9e2af" })
-- vim.api.nvim_set_hl(0, "NavicIconsPackage", { default = true, bg = "#1e1e2e", fg = "#8b8792" })
-- vim.api.nvim_set_hl(0, "NavicIconsClass", { default = true, bg = "#1e1e2e", fg = "#f9e2af" })
-- vim.api.nvim_set_hl(0, "NavicIconsMethod", { default = true, bg = "#1e1e2e", fg = "#89b4fa" })
-- vim.api.nvim_set_hl(0, "NavicIconsProperty", { default = true, bg = "#1e1e2e", fg = "#89b4fa" })
-- vim.api.nvim_set_hl(0, "NavicIconsField", { default = true, bg = "#1e1e2e", fg = "#c8c8c8" })
-- vim.api.nvim_set_hl(0, "NavicIconsConstructor", { default = true, bg = "#1e1e2e", fg = "#f9e2af" })
-- vim.api.nvim_set_hl(0, "NavicIconsEnum", { default = true, bg = "#1e1e2e", fg = "#fab387" })
-- vim.api.nvim_set_hl(0, "NavicIconsInterface", { default = true, bg = "#1e1e2e", fg = "#f9e2af" })
-- vim.api.nvim_set_hl(0, "NavicIconsFunction", { default = true, bg = "#1e1e2e", fg = "#dcdcaa" })
-- vim.api.nvim_set_hl(0, "NavicIconsVariable", { default = true, bg = "#1e1e2e", fg = "#c8c8c8" })
-- vim.api.nvim_set_hl(0, "NavicIconsConstant", { default = true, bg = "#1e1e2e", fg = "#fab387" })
-- vim.api.nvim_set_hl(0, "NavicIconsString", { default = true, bg = "#1e1e2e", fg = "#a6e3a1" })
-- vim.api.nvim_set_hl(0, "NavicIconsNumber", { default = true, bg = "#1e1e2e", fg = "#b5cea8" })
-- vim.api.nvim_set_hl(0, "NavicIconsBoolean", { default = true, bg = "#1e1e2e", fg = "#fab387" })
-- vim.api.nvim_set_hl(0, "NavicIconsArray", { default = true, bg = "#1e1e2e", fg = "#b4befe" })
-- vim.api.nvim_set_hl(0, "NavicIconsObject", { default = true, bg = "#1e1e2e", fg = "#fafafa" })
-- vim.api.nvim_set_hl(0, "NavicIconsKey", { default = true, bg = "#1e1e2e", fg = "#569cd6" })
-- vim.api.nvim_set_hl(0, "NavicIconsNull", { default = true, bg = "#1e1e2e", fg = "#656565" })
-- vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { default = true, bg = "#1e1e2e", fg = "#89b4fa" })
-- vim.api.nvim_set_hl(0, "NavicIconsStruct", { default = true, bg = "#1e1e2e", fg = "#fab387" })
-- vim.api.nvim_set_hl(0, "NavicIconsEvent", { default = true, bg = "#1e1e2e", fg = "#dda0dd" })
-- vim.api.nvim_set_hl(0, "NavicIconsOperator", { default = true, bg = "#1e1e2e", fg = "#89dceb" })
-- vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { default = true, bg = "#1e1e2e", fg = "#fab387" })

return M
