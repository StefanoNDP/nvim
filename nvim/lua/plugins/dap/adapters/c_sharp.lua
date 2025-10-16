local M = {}

--- Rebuilds the project before starting the debug session
---@param co thread
function M.rebuild_project(co, path)
  local spinner = require("easy-dotnet.ui-modules.spinner").new()
  spinner:start_spinner("Building")
  vim.fn.jobstart(string.format("dotnet build %s", path), {
    on_exit = function(_, return_code)
      if return_code == 0 then
        spinner:stop_spinner("Built successfully")
      else
        spinner:stop_spinner(
          "Build failed with exit code " .. return_code,
          vim.log.levels.ERROR
        )
        error("Build failed")
      end
      coroutine.resume(co)
    end,
  })
  coroutine.yield()
end

M.c_sharp = function()
  local dap = require("dap")
  local dotnet = require("easy-dotnet")

  local function file_exists(path)
    local stat = vim.uv.fs_stat(path)
    return stat and stat.type == "file"
  end

  local debug_dll = nil

  local function ensure_dll()
    if debug_dll ~= nil then
      return debug_dll
    end
    local dll = dotnet.get_debug_dll()
    debug_dll = dll
    return dll
  end

  for _, lang in ipairs({ "cs", "c_sharp", "csharp", "fsharp" }) do
    dap.configurations[lang] = {
      {
        type = "coreclr",
        name = "netcoredbg [coreclr]",
        request = "launch",
        env = function()
          local dll = ensure_dll()
          local vars =
            -- dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
            dotnet.get_environment_variables(
              dll.project_name,
              dll.absolute_project_path
            )
          return vars or nil
        end,
        program = function()
          if vim.uv.os_uname().sysname:lower():match("windows") ~= 0 then
            vim.cmd([[set noshellslash]])
          end

          local dll = ensure_dll()
          local co = coroutine.running()
          M.rebuild_project(co, dll.project_path)
          if not file_exists(dll.target_path) then
            error("Project has not been built, path: " .. dll.target_path)
          end
          return dll.target_path
        end,
        cwd = function()
          local dll = ensure_dll()
          return dll.absolute_project_path
        end,
      },
    }

    dap.listeners.before["event_terminated"]["easy-dotnet"] = function()
      debug_dll = nil
    end

    dap.adapters.coreclr = {
      type = "executable",
      command = "netcoredbg",
      args = { "--interpreter=vscode" },
    }
  end
end

return M.c_sharp()
