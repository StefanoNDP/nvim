local M = {}

M.godot = function()
  local dap = require("dap")

  dap.adapters.godot = {
    type = "server",
    host = "127.0.0.1",
    port = os.getenv("GDScript_Port") or "6006",
  }

  dap.configurations.gdscript = {
    {
      launch_game_instance = false,
      launch_scene = false,
      name = "Launch Scene",
      project = "${workspaceFolder}",
      request = "launch",
      type = "godot",
      port = 6007,
      debugServer = 6006,

      -- address = "127.0.0.1",
      -- scene = "main|current|pinned|<path>",
      -- editor_path = "<path>",
      -- -- engine command line flags
      -- profiling = false,
      -- single_threaded_scene = false,
      -- debug_collisions = false,
      -- debug_paths = false,
      -- debug_navigation = false,
      -- debug_avoidance = false,
      -- debug_stringnames = false,
      -- frame_delay = 0,
      -- time_scale = 1.0,
      -- disable_vsync = false,
      -- fixed_fps = 60,
      -- -- anything else
      -- additional_options = "",
    },
  }
end

return M.godot()
