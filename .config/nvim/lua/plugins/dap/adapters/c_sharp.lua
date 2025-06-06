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
        spinner:stop_spinner("Build failed with exit code " .. return_code, vim.log.levels.ERROR)
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
  local debug_dll = nil

  for _, adapter in ipairs({ "netcoredbg", "coreclr" }) do
    dap.adapters[adapter] = {
      type = "executable",
      command = vim.fn.exepath("netcoredbg"),
      args = { "--interpreter=vscode" },
      options = {
        detached = false,
      },
    }
  end

  local function ensure_dll()
    if debug_dll ~= nil then
      return debug_dll
    end
    local dll = dotnet.get_debug_dll()
    debug_dll = dll
    return dll
  end

  for _, lang in ipairs({ "cs", "fsharp", "vb" }) do
    dap.configurations[lang] = {
      --   {
      --     type = "netcoredbg",
      --     name = "Launch file",
      --     request = "launch",
      --     ---@diagnostic disable-next-line: redundant-parameter
      --     program = function()
      --       -- return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
      --       local line = 1
      --       local file = vim.fn.getcwd() .. "/.debugpath"
      --       local cmd = string.format("sed -n %dp %s", line, file)
      --       local output = vim.fn.system(cmd)
      --       return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. output, "file")
      --       -- return output
      --     end,
      --     cwd = "${workspaceFolder}",
      --   },
      -- }
      {
        type = "netcoredbg",
        name = "Launch file",
        request = "launch",
        ---@diagnostic disable-next-line: redundant-parameter
        program = function()
          return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
      },
      {
        type = "coreclr",
        name = "netcoredbg [coreclr]",
        request = "launch",
        env = function()
          local dll = ensure_dll()
          local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
          return vars or nil
        end,
        program = function()
          local dll = ensure_dll()
          local co = coroutine.running()
          M.rebuild_project(co, dll.project_path)
          return dll.relative_dll_path
        end,
        cwd = function()
          local dll = ensure_dll()
          return dll.relative_project_path
        end,
      },
      {
        log_level = "DEBUG",
        type = "netcoredbg",
        justMyCode = false,
        stopAtEntry = false,
        name = "netcoredbg [overseer]",
        request = "launch",
        env = function()
          local dll = ensure_dll()
          local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
          return vars or nil
        end,
        program = function()
          require("overseer").enable_dap()
          local dll = ensure_dll()
          return dll.relative_dll_path
        end,
        cwd = function()
          local dll = ensure_dll()
          return dll.relative_project_path
        end,
        preLaunchTask = "Build .NET App With Spinner",
      },
    }

    dap.listeners.before["event_terminated"]["easy-dotnet"] = function()
      debug_dll = nil
    end
  end
end

return M.c_sharp()
