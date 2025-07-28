local words = require("config.colors").words

local word_color_group = function(_, match)
  local hi = require("mini.hipatterns")
  local hex = words[match]
  if hex == nil then
    return nil
  end
  return hi.compute_hex_color_group(hex, "bg")
end

return {
  "echasnovski/mini.nvim",
  enabled = true,
  version = false,
  event = "VeryLazy",
  config = function()
    -- Text editing
    require("mini.ai").setup({})
    require("mini.align").setup({})
    require("mini.move").setup({
      mappings = {
        left = "<M-h>",
        right = "<M-l>",
        down = "<M-j>",
        up = "<M-k>",
        line_left = "<M-h>",
        line_right = "<M-l>",
        line_down = "<M-j>",
        line_up = "<M-k>",
      },
      options = { reindent_linewise = true },
    })
    require("mini.operators").setup({})
    require("mini.splitjoin").setup({})
    require("mini.surround").setup({})

    -- General workflow
    require("mini.basics").setup({})
    require("mini.bracketed").setup({})
    require("mini.clue").setup({})
    require("mini.diff").setup({
      view = {
        style = vim.go.number and "number",
        signs = {
          add = "+",
          change = "~",
          delete = "-",
          topdelete = "‾",
          changedelete = "~",
        },
      },
    })
    -- vim.keymap.set("v", "<leader>to", ":lua require('mini.diff').toggle_overlay()<CR>", kopts)
    require("mini.jump").setup({
      mappings = { forward = "<M-f>", backward = "<M-F>" },
    })
    require("mini.jump2d").setup({ mappings = { start_jumping = "<M-CR>" } })

    -- Appearance
    local hi = require("mini.hipatterns")
    require("mini.hipatterns").setup({
      highlighters = {
        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),

        shorthand = {
          pattern = "()#%x%x%x()%f[^%x%w]",
          group = function(_, _, data)
            ---@type string
            local match = data.full_match
            local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
            local hex_color = "#" .. r .. r .. g .. g .. b .. b

            return hi.compute_hex_color_group(hex_color, "bg")
          end,
          extmark_opts = { priority = 2000 },
        },

        -- Highlight standalone:
        -- They're just here as a "fallback" if "todo-commends" stops working
        -- FIX FIXME BUG FIXIT ISSUE TODO HACK FAILED FAIL WARN WARNING XXX PERF OPTIM PERFORMANCE OPTIMIZE
        -- PASS PASSED NOTE INFO TRACK KEEPTRACK TEST TESTING
        fix = { pattern = "%f[%w]()FIX()%f[%W]", group = "hl_peach" },
        fixit = { pattern = "%f[%w]()FIXIT()%f[%W]", group = "hl_peach" },
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "hl_peach" },
        bug = { pattern = "%f[%w]()BUG()%f[%W]", group = "hl_peach" },
        issue = { pattern = "%f[%w]()ISSUE()%f[%W]", group = "hl_peach" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "hl_sky" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "hl_yellow" },
        warn = { pattern = "%f[%w]()WARN()%f[%W]", group = "hl_red" },
        warning = { pattern = "%f[%w]()WARNING()%f[%W]", group = "hl_red" },
        warnxxx = { pattern = "%f[%w]()XXX()%f[%W]", group = "hl_red" },
        perf = { pattern = "%f[%w]()PERF()%f[%W]", group = "hl_green" },
        performance = {
          pattern = "%f[%w]()PERFORMANCE()%f[%W]",
          group = "hl_green",
        },
        optim = { pattern = "%f[%w]()OPTIM()%f[%W]", group = "hl_green" },
        optimize = { pattern = "%f[%w]()OPTIMIZE()%f[%W]", group = "hl_green" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "hl_blue" },
        info = { pattern = "%f[%w]()INFO()%f[%W]", group = "hl_blue" },
        track = { pattern = "%f[%w]()TRACK()%f[%W]", group = "hl_blue" },
        keeptrack = { pattern = "%f[%w]()KEEPTRACK()%f[%W]", group = "hl_blue" },
        test = { pattern = "%f[%w]()TEST()%f[%W]", group = "hl_white" },
        testing = { pattern = "%f[%w]()TESTING()%f[%W]", group = "hl_white" },
        fail = { pattern = "%f[%w]()FAIL()%f[%W]", group = "hl_white" },
        failed = { pattern = "%f[%w]()FAILED()%f[%W]", group = "hl_white" },
        pass = { pattern = "%f[%w]()PASS()%f[%W]", group = "hl_white" },
        passed = { pattern = "%f[%w]()PASSED()%f[%W]", group = "hl_white" },

        -- Highlight word color strings (`red`, `green`, `blue`, etc) using that color (Themed)
        word_color = { pattern = "%S+", group = word_color_group },
      },
    })

    local map = require("mini.map")
    require("mini.map").setup({
      integrations = {
        map.gen_integration.builtin_search(),
        map.gen_integration.diff(),
        map.gen_integration.diagnostic(),
        map.gen_integration.gitsigns(),
      },
      window = {
        width = 5,
        show_integration_count = true,
      },
    })
    require("mini.map").toggle()
    require("mini.trailspace").setup({})

    -- Load keymaps
    require("config.keymaps.mini")
  end,
}
