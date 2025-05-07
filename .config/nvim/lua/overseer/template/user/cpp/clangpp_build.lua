return {
  name = "clang++ build",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p")
    return {
      cmd = { "clang++" },
      args = {
        "-std=c++20",
        "-O2",
        "-ferror-limit=0",
        "-Wall",
        "-Wextra",
        "-Wpedantic",
        "-Wshadow-all",
        "-Wno-unused-parameter",
        file,
      },
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
