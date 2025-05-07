local lspconfig = require("config.lsp.setup")

-- HOW TO:
-- https://github.com/Lommix/godot.nvim?tab=readme-ov-file#how-to-use-nvim-as-external-editor
--
--
-- Create a bash script, make it executeable.
-- Example: /home/USER/godotrc.sh
--
-- Add the following context
-- #!/usr/bin/env bash
-- [ -n "$1" ] && file=$1
-- nvim --server ~/.cache/nvim/godot.pipe --remote-send ':e '"$file"'<CR>'

-- In Godot, go to "Editor->Editor Settings->Text Editor->External" and make sure they look like this
-- "Exec Path": /home/USER/godotrc.sh
-- "Exec Flags": {file} <- This should already be set
-- "Use External Editor": Checked
--
-- You may also want to enable Auto Reload for external changes
-- Go to "Editor->Editor Settings->Text Editor->Behavior" and
-- enable "Auto Reload Scripts on External Change"
--
-- Now go to a godot project (or create) and open neovim with the following args:
-- nvim --listen ~/.cache/nvim/godot.pipe .
--
-- Now, with neovim open with those args, you can open godot and double-click/right-click->open any
-- script that it'll be openned in nvim
--
-- For more "advanced" users
-- https://github.com/niscolas/nvim-godot
-- Same as above but use this .sh script
-- https://github.com/niscolas/nvim-godot/blob/main/run.sh
--
-- And change "Exec Flags" of External Text Editor to
-- "Exec Flags": "{file}" "{line},{col}"
--
-- Now you don't even need to have nvim opened with those args above, it'll automatically open a godot
-- nvim instance if there isn't one already.

return {
  lspconfig.setupServer("gdscript", {
    on_attach = function(client, bufnr)
      print("Hello Godot")
    end,
  }),
}
