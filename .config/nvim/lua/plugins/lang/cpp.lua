return { -- C++
  {
    "bfrg/vim-c-cpp-modern",
    enabled = true,
    version = false,
    ft = { "c", "cc", "cpp", "objc", "objcpp", "opencl" },
    config = function()
      vim.g.cpp_member_highlight = 1
      vim.g.cpp_operator_highlight = 1
    end,
  },
  -- stylua: ignore
  { "ranjithshegde/ccls.nvim", enabled = true, version = false, ft = { "c", "cc", "cpp", "objc", "objcpp", "opencl" } },
  {
    "p00f/clangd_extensions.nvim",
    enabled = true,
    -- dependencies = { "mortepau/codicons.nvim" },
    -- lazy = true,
    version = false,
    ft = { "c", "cc", "cpp", "objc", "objcpp", "opencl" },
    opts = function()
      return {
        ast = {
          role_icons = {
            type = "",
            declaration = "",
            expression = "",
            specifier = "",
            statement = "",
            ["template argument"] = "",
          },
          kind_icons = {
            Compound = "",
            Recovery = "",
            TranslationUnit = "",
            PackExpansion = "",
            TemplateTypeParm = "",
            TemplateTemplateParm = "",
            TemplateParamObject = "",
          },
          highlights = {
            detail = "Comment",
          },
        },
        memory_usage = {
          border = "Rounded",
        },
        symbol_info = {
          border = "Rounded",
        },
      }
    end,
    config = function(_, opts)
      require("clangd_extensions").setup(opts) -- avoid duplicate setup call.
    end,
  },
  {
    "Badhi/nvim-treesitter-cpp-tools",
    enabled = true,
    version = false,
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = function()
      return {
        preview = {
          quit = "q", -- optional keymapping for quit preview
          accept = "<tab>", -- optional keymapping for accept preview
        },
        header_extension = "h", -- optional
        source_extension = "cpp", -- optional
        custom_define_class_function_commands = { -- optional
          TSCppImplWrite = {
            output_handle = require("nt-cpp-tools.output_handlers").get_add_to_cpp(),
          },
          --[[
                <your impl function custom command name> = {
                    output_handle = function (str, context)
                        -- string contains the class implementation
                        -- do whatever you want to do with it
                    end
                }
            ]]
        },
      }
    end,
    config = true,
  },
}
