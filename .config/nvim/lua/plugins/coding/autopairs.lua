return {
  "windwp/nvim-autopairs",
  enabled = true,
  version = false,
  event = "InsertEnter",
  opts = function()
    return {
      check_ts = true,
      map_cr = true,
      disable_filetype = { "TelescopePrompt", "vim" },
    }
  end,
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    npairs.setup(opts)

    -- Auto-pair <> but not for greater-than/less-than operators
    npairs.add_rule(Rule("<", ">", {
      -- if you use nvim-ts-autotag, you may want to exclude these filetypes from this rule
      -- so that it doesn't conflict with nvim-ts-autotag
      "-cshtml",
      "-html",
      "-javascriptreact",
      "-typescriptreact",
    }):with_pair(
      -- regex will make it so that it will auto-pair on
      -- `a<` but not `a <`
      -- The `:?:?` part makes it also
      -- work on Rust generics like `some_func::<T>()`
      cond.before_regex("%a+:?:?$", 3)
    ):with_move(function(opts)
      return opts.char == ">"
    end))

    -- Space after =
    npairs.add_rule(Rule("=", "")
      :with_pair(cond.not_inside_quote())
      :with_pair(function(opts)
        local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
        if last_char:match("[%w%=%s]") then
          return true
        end
        return false
      end)
      :replace_endpair(function(opts)
        local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
        local next_char = opts.line:sub(opts.col, opts.col)
        next_char = next_char == " " and "" or " "
        if prev_2char:match("%w$") then
          return "<bs> =" .. next_char
        end
        if prev_2char:match("%=$") then
          return next_char
        end
        if prev_2char:match("=") then
          return "<bs><bs>=" .. next_char
        end
        return ""
      end)
      :set_end_pair_length(0)
      :with_move(cond.none())
      :with_del(cond.none()))

    -- npairs.add_rule()
  end,
}
