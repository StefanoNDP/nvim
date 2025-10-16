local M = {}

M.maxFileSize = 2 * 1024 * 1024

M.dotnetIcon = ""

M.highlights = {
  "RainbowDelimiterRed",
  "RainbowDelimiterYellow",
  "RainbowDelimiterBlue",
  "RainbowDelimiterOrange",
  "RainbowDelimiterGreen",
  "RainbowDelimiterViolet",
  "RainbowDelimiterCyan",
}

M.rootPatterns = {
  general = { ".git", "Makefile", "makefile" },
  biome = { ".git", "Makefile", "makefile", "biome.json", "biome.jsonc" },
  cmake = {
    ".git",
    "Makefile",
    "makefile",
    "CMakePresets.json",
    "CTestConfig.cmake",
    "CMakefile",
    "build",
    "cmake",
  },
  cpp = {
    ".git",
    "Makefile",
    "makefile",
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac", -- AutoTools
    "*.uproject", -- Unreal Engine
  },
  c_sharp = { ".git", "Makefile", "makefile", "*.sln", "*.fsproj", "*.csproj" },
  csharp = { ".git", "Makefile", "makefile", "*.sln", "*.fsproj", "*.csproj" },
  cs = { ".git", "Makefile", "makefile", "*.sln", "*.fsproj", "*.csproj" },
  gdscript = { ".git", "Makefile", "makefile", "project.godot" },
  json = { ".git", "Makefile", "makefile" },
  lua = {
    ".git",
    "Makefile",
    "makefile",
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
  },
  markdown = { ".git", "Makefile", "makefile", ".marksman.toml" },
  prettier = {
    ".git",
    "Makefile",
    "makefile",
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.json5",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.toml",
    ".prettierrc.js",
    ".prettierrc.cjs",
    ".prettierrc.mjs",
    ".prettierrc.ts",
    ".prettierrc.cts",
    ".prettierrc.mts",
    "prettier.config.js",
    "prettier.config.cjs",
    "prettier.config.mjs",
    "prettier.config.ts",
    "prettier.config.cts",
    "prettier.config.mts",
  },
  tailwind = {
    ".git",
    "Makefile",
    "makefile",
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "tailwind.config.ts",
    "postcss.config.js",
    "postcss.config.cjs",
    "postcss.config.mjs",
    "postcss.config.ts",
  },
  typescript = {
    ".git",
    "Makefile",
    "makefile",
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
  },
  -- ".bzr",
  -- ".hg",
  -- ".null-ls-root",
  -- ".svn",
  -- "_darcs",
  -- "build.ninja",
  -- "config.h.in",
  -- "configure.ac",
  -- "configure.in",
  -- "meson.build",
  -- "meson_options.txt",
}

-- Probably won't use it
M.kmOpts = { noremap = true, silent = true, remap = false }

-- Catppuccin compatibility with DAP
M.catppuccinDAP = function()
  local sign = vim.fn.sign_define

  local dapBreakpoint = {
    breakpoint = {
      text = "",
      texthl = "DapBreakpoint",
      linehl = "",
      numhl = "",
    },
    breakpointCondition = {
      text = "",
      texthl = "DapBreakpointCondition",
      linehl = "",
      numhl = "",
    },
    dapLogPoint = {
      text = "◆",
      texthl = "DapLogPoint",
      linehl = "",
      numhl = "",
    },
    rejected = {
      text = "",
      texthl = "LspDiagnosticsSignHint",
      linehl = "",
      numhl = "",
    },
    stopped = {
      text = "",
      texthl = "LspDiagnosticsSignInformation",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "LspDiagnosticsSignInformation",
    },
  }

  sign("DapBreakpoint", dapBreakpoint.breakpoint)
  sign("DapBreakpointCondition", dapBreakpoint.breakpointCondition)
  sign("DapLogPoint", dapBreakpoint.dapLogPoint)
  sign("DapStopped", dapBreakpoint.stopped)
  sign("DapBreakpointRejected", dapBreakpoint.rejected)
end

return M
