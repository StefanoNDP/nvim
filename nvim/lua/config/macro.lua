-- Macros

-- "Tutorial"
-- 1. Create a macro (q->KEY->macro->q)
-- 2. Open the registers (:registers)
-- It'll show Type Name Content, the "Name" will be the KEY youpaste assigned and content is the actions
-- done by the macro
-- Example: The macro yanks a word and paste 2 lines down it'll show: c "q viwyjjp in the resgisters
-- (y)ank your macro
-- Place it here and format it like so
-- vim.fn.setreg("KEY", "SEQUENCE")
--
-- For loading specific macros for specific filetypes works as well, template below

-- Can be used in sequences like so "seq1/2" .. esc .. "seq2/2"
-- You can also use ^[ which is interpreted as escape so it wouldbe "seq1/2^[seq2/2"
local esc = vim.api.nvim_replace_termcodes("<esc>", true, true, true)

-- vim.fn.setreg("q", "viwyjjp")

-- vim.api.nvim_create_augroup("nwscriptMacro", { clear = true })
--
-- vim.api.nvim_create_autocmd("FileType", {
--   group = "nwscriptMacro",
--   pattern = { "nss", "nwscript" }, -- This will trigger for .nss (nwscript) files
--   callback = function()
--     vim.fn.setreg("q", "viwyjjp")
--   end,
-- })
