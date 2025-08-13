return {
  "josephburgess/nvumi",
  enabled = false,
  version = false,
  dependencies = { "folke/snacks.nvim", "echasnovski/mini.icons" },
  opts = function()
    require("config.keymaps.nvumi")
    return {
      virtual_text = "newline", -- or "inline"
      prefix = " 🚀 ", -- prefix shown before the output
      date_format = "iso", -- or: "uk", "us", "long"
      keys = {
        run = "<CR>", -- run/refresh calculations
        reset = "R", -- reset buffer
        yank = "<leader>y", -- yank output of current line
        yank_all = "<leader>Y", -- yank all outputs
      },
      -- see below for more on custom conversions/functions
      custom_conversions = {
        {
          id = "kmh",
          phrases = "kmh, kmph, klicks, kilometers per hour",
          base_unit = "speed",
          format = "km/h",
          ratio = 1,
        },
        {
          id = "mph",
          phrases = "mph, miles per hour",
          base_unit = "speed",
          format = "mph",
          ratio = 1.609344, -- 1 mph = 1.609344 km/h
        },
      },
      custom_functions = {
        {
          def = { phrases = "square, sqr" },
          fn = function(args)
            if #args < 1 or type(args[1]) ~= "number" then
              return { error = "square requires a single numeric argument" }
            end
            return { result = args[1] * args[1] }
          end,
        },
        {
          def = { id = "greet", phrases = "hello, hi" },
          fn = function(args)
            local name = args[1] or "stranger"
            return { result = "Hello, " .. name .. "!" }
          end,
        },
        {
          def = { phrases = "coinflip, flip" },
          fn = function()
            return { result = (math.random() > 0.5) and "Heads" or "Tails" }
          end,
        },
      },
    }
  end,
}
