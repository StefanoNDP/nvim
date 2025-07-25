-- Boilerplate --
local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.t

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local l = require("luasnip.extras").lambda

local snippets, autosnippets = {}, {}

local group = vim.api.nvim_create_augroup("C# Snippets", { clear = true })
local file_pattern = "*.cs"

--- Creates a snippet
local function cs(trigger, nodes, opts)
  local snippet = s(trigger, nodes)
  local target_table = snippets

  local pattern = file_pattern
  local keymaps = {}

  if opts ~= nil then
    -- check for custom pattern
    if opts.pattern then
      pattern = opts.pattern
    end

    -- if opts is a string
    if type(opts) == "string" then
      if opts == "auto" then
        target_table = autosnippets
      else
        table.insert(keymaps, { "i", opts })
      end
    end

    -- if opts is a table
    if type(opts) == "table" then
      for _, keymap in ipairs(opts) do
        if type(keymap) == "string" then
          table.insert(keymaps, { "i", keymap })
        else
          table.insert(keymaps, keymap)
        end
      end
    end

    -- set autocmd for each keymap
    if opts ~= "auto" then
      for _, keymap in ipairs(keymaps) do
        vim.api.nvim_create_autocmd("BufEnter", {
          pattern = pattern,
          group = group,
          callback = function()
            vim.keymap.set(keymap[1], keymap[2], function()
              ls.snip_expand(snippet)
            end, { noremap = true, silent = true, buffer = true })
          end,
        })
      end
    end
  end

  -- insert snippet into appropriate table
  table.insert(target_table, snippet)
end

-- Snippets go here --

-- Populate file
cs(
  "GEN",
  fmt(
    [[
namespace {};

/// <summary>
/// {}
/// </summary>
internal class {}
{{
  public static void Main(string[] args)
  {{
    Console.ReadKey();
  }}
}}
{}
    ]],
    {
      i(1, "Namespace"),
      i(2, "Summary"),
      i(3, "Class"),
      i(0),
    }
  )
)

-- Create main class
cs(
  "Class",
  fmt(
    [[
/// <summary>
/// {}
/// </summary>
internal class {}
{{
  public static void Main(string[] args)
  {{
    Console.ReadKey();
  }}
}}
{}
    ]],
    {
      i(1, "Summary"),
      i(2, "Class"),
      i(0),
    }
  )
)

-- Create main function
cs(
  "Main",
  fmt(
    [[
public static void Main(string[] args)
{{
  Console.ReadKey();
}}
{}
    ]],
    {
      i(0),
    }
  )
)

-- UNITY Snippets
s("start", { t("void Start() {"), t({ "", "    " }), i(1), t({ "", "}" }) })
s("update", { t("void Update() {"), t({ "", "    " }), i(1), t({ "", "}" }) })
s("awake", { t("void Awake() {"), t({ "", "    " }), i(1), t({ "", "}" }) })
s("fixedupdate", { t("void FixedUpdate() {"), t({ "", "    " }), i(1), t({ "", "}" }) })
s("onenable", { t("void OnEnable() {"), t({ "", "    " }), i(1), t({ "", "}" }) })
s("ondisable", { t("void OnDisable() {"), t({ "", "    " }), i(1), t({ "", "}" }) })
s(
  "ontriggerenter",
  { t("void OnTriggerEnter(Collider other) {"), t({ "", "    " }), i(1), t({ "", "}" }) }
)
s(
  "oncollisionenter",
  { t("void OnCollisionEnter(Collision collision) {"), t({ "", "    " }), i(1), t({ "", "}" }) }
)
s(
  "serializefield",
  { t("[SerializeField] private "), i(1, "Type"), t(" "), i(2, "variableName"), t(";") }
)
s("publicfield", { t("public "), i(1, "Type"), t(" "), i(2, "variableName"), t(";") })
s("log", { t('Debug.Log("'), i(1, "message"), t('");') })
s("class", {
  t("using UnityEngine;"),
  t({ "", "" }),
  t("public class "),
  i(1, "ClassName"),
  t(" : MonoBehaviour"),
  t({ "", "{" }),
  t({ "", "    " }),
  i(2, "// Your code here"),
  t({ "", "}" }),
})

-- Boilerplate --
return snippets, autosnippets
