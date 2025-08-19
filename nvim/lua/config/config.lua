<<<<<<< HEAD
-- Godot
local pipepath = nil

local funcs = require("config.functions")
if funcs.get_os_lower() == "windows" then
  pipepath = [[\\.\pipe\nvim-godot]]
else
  pipepath = vim.fn.stdpath("cache") .. "/godot.pipe"
end
if pipepath and not vim.uv.fs_stat(pipepath) then
  vim.fn.serverstart(pipepath)
end
||||||| 5adad98
=======
return {}
-- -- Godot
-- local pipepath = nil
--
-- local funcs = require("config.functions")
-- if funcs.get_os_lower() == "windows" then
--   pipepath = [[\\.\pipe\nvim-godot]]
-- else
--   pipepath = vim.fn.stdpath("cache") .. "/godot.pipe"
-- end
--
-- if pipepath and not vim.uv.fs_stat(pipepath) then
--   vim.fn.serverstart(pipepath)
-- end
>>>>>>> df31f4152963cbde077545f259117fb74f7123a8
