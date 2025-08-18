local M = {}

local wk = require("which-key")
local hlist = function()
  local keys = {}
  for i = 1, 9 do
    table.insert(keys, {
      "<leader>h" .. i,
      function()
        require("harpoon"):list():select(i)
      end,
      desc = "Harpoon select " .. i,
    })
  end
  return keys
end

M.keymaps = wk.add({
  mode = { "n" },
  -- { "<leader>m", ":lua require('require("harpoon").mark').add_file()<CR>", desc = "" },
  {
    "<leader>ha",
    function()
      -- harpoon:list():append()
      require("harpoon"):list():add()
    end,
    desc = "Harpoon add",
  },
  -- { "<leader>ht", ":lua require('require("harpoon").ui').toggle_quick_menu()<CR>", desc = "" },
  {
    "<leader>ht",
    function()
      require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
    end,
    desc = "Harpoon toggle list",
  },
  -- Toggle previous & next buffers stored within Harpoon list
  {
    "<C-S-P>",
    function()
      require("harpoon"):list():prev()
    end,
    desc = "Harpoon select next",
  },
  {
    "<C-S-N>",
    function()
      require("harpoon"):list():next()
    end,
    desc = "Harpoon select previous",
  },
  hlist(),
})

return M.keymaps
