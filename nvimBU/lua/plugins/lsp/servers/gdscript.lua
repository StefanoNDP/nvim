local lspconfig = require("config.lsp.setup")

-- HOW TO (EASY):
-- https://github.com/Lommix/godot.nvim?tab=readme-ov-file#how-to-use-nvim-as-external-editor

-- HOW TO (ADVANCED): (WINDOWS IS WIP)
-- https://github.com/niscolas/nvim-godot
-- Same as above but use this .sh script
-- https://github.com/niscolas/nvim-godot/blob/main/run.sh
--
-- The "run.sh" file above is already in this repo in "nvim/util/godotrc.sh"
-- There's also a Windows version: "nvim/util/godotrc.ps1"
--
-- In Godot, go to "Editor->Editor Settings->Text Editor->External" and make
-- sure they look like this:
-- "Exec Path": /home/USER/godotrc.sh
-- "Exec Flags": "{file}" "{line},{col}"
-- "Use External Editor": Checked
--
-- You may also want to enable Auto Reload for external changes:
-- Go to "Editor->Editor Settings->Text Editor->Behavior" and enable:
-- "Auto Reload Scripts on External Change"
--
-- Now you can go to a godot project and open neovim with the following args:
-- On Linux:
-- nvim --listen ~/.cache/nvim/godot.pipe
--
-- On Windows:
-- nvim --listen "\\.\pipe\nvim-godot"
--
-- Or you don't even need to have nvim opened with those args above, godot will
-- automatically open a nvim instance if there isn't one already.

return {
  lspconfig.setupServer("gdscript", {
    on_attach = function(client, bufnr)
      print("Hello Godot")
    end,
  }),
}
