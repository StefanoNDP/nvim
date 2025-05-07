return {
  name = "clang++ debug",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p")
    return {
      cmd = { "clang++" },
      args = {
        "-std=c++20",
        "-ferror-limit=0",
        "-Wall",
        "-Wextra",
        "-Wpedantic",
        "-Wshadow-all",
        "-Wno-unused-parameter",
        "--debug",
        file,
      },
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}

--             set -l params "-std=c++20 -O2 -ferror-limit=0 -Wall -Wextra -Wpedantic -Wshadow-all -Wno-unused-parameter"
--             clang++ $params -o $filename $filename.$fileExtension
--             # case cpp
--             # clang++ -std=c++20 -Wall -O2 -o $filename $filename.$fileExtension
--
--             set -l params "-std=c++20 -ferror-limit=0 -Wall -Wextra -Wpedantic -Wshadow-all -Wno-unused-parameter --debug"
--             clang++ $params -o $filename $filename.$fileExtension
--             # case cpp
--             # clang++ -std=c++20 -Wall --debug -o $filename $filename.$fileExtension
