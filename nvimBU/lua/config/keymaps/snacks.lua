return {
  -- BufDelete
  -- {
  --   "D",
  --   function()
  --     Snacks.bufdelete()
  --   end,
  --   desc = "Delete Active Buffer",
  -- },
  -- Explorer
  {
    "<leader>op",
    function()
      Snacks.explorer()
    end,
    desc = "Open CWD File Explorer",
  },
  -- Find
  {
    "<leader>fhi",
    function()
      Snacks.picker.pick("highlight")
    end,
    desc = "Find projects",
  },
  {
    "<leader>fp",
    function()
      Snacks.picker.pick("projects")
    end,
    desc = "Find projects",
  },
  {
    "<leader>ff",
    function()
      Snacks.picker.files()
    end,
    desc = "Find files",
  },
  {
    "<leader>fs",
    function()
      Snacks.picker.grep()
    end,
    desc = "Find Grep",
  },
  {
    "<leader>fd",
    function()
      Snacks.picker.diagnostics()
    end,
    desc = "Find Diagnostics",
  },
  {
    "<leader>fD",
    function()
      Snacks.picker.diagnostics_buffer()
    end,
    desc = "Find Buffer Diagnostics",
  },
  {
    "<leader>fb",
    function()
      Snacks.picker.buffers()
    end,
    desc = "Find Buffers",
  },
  {
    "<leader>fh",
    function()
      Snacks.picker.help()
    end,
    desc = "Find Help Pages",
  },
  {
    "<leader>fgf",
    function()
      Snacks.picker.git_files()
    end,
    desc = "Find Git Files",
  },
  {
    "<leader>fm",
    function()
      Snacks.picker.marks()
    end,
    desc = "Find Marks",
  },
  {
    "<leader>fps",
    function()
      Snacks.picker.lsp_symbols()
    end,
    desc = "Find LSP Symbols",
  },
  {
    "<leader>fws",
    function()
      Snacks.picker.lsp_workspace_symbols()
    end,
    desc = "Find LSP Workspace Symbols",
  },
  {
    "<leader>fn",
    ":Nerdy<CR>",
    desc = "Find Nerdfonts Glyphs",
  },
  -- Git
  {
    "<leader>gS",
    function()
      Snacks.gitbrowse.open()
    end,
    desc = "Open the repository of active file in the browser",
  },
  {
    "<leader>gl",
    function()
      Snacks.lazygit()
    end,
    desc = "Opens lazygit",
  },
  {
    "<leader>gll",
    function()
      Snacks.lazygit.log()
    end,
    desc = "Opens lazygit with the log view",
  },
  {
    "<leader>glf",
    function()
      Snacks.lazygit.log_file()
    end,
    desc = "Opens lazygit with the log of the current file",
  },
  -- Notify(ier)
  {
    "<leader>n",
    function()
      -- if Snacks.config.picker and Snacks.config.picker.enabled then
      --   Snacks.picker.notifications()
      -- else
      Snacks.notifier.show_history()
      -- end
    end,
    desc = "Notification History",
  },
  {
    "<leader>un",
    function()
      Snacks.notifier.hide()
    end,
    desc = "Dismiss All Notifications",
  },
  -- Picker
  {
    "<leader>sp",
    function()
      Snacks.picker()
    end,
    desc = "Show all pickers",
  },
  -- Profiler
  {
    "<leader>pps",
    function()
      Snacks.profiler.scratch()
    end,
    desc = "Profiler scratch buffer",
  },
  -- Registers
  {
    '<leader>s"',
    function()
      Snacks.picker.registers()
    end,
    desc = "Registers",
  },
  -- Scratch
  {
    "<leader>.",
    function()
      Snacks.scratch()
    end,
    desc = "Toggle Scratch Buffer",
  },
  {
    "<leader>S",
    function()
      Snacks.scratch.select()
    end,
    desc = "Select Scratch Buffer",
  },
  -- Terminal
  {
    "<leader>tt",
    function()
      Snacks.terminal.toggle()
    end,
    desc = "Toggle terminal",
  },
  -- Words
  {
    "<leader>wj",
    function()
      Snacks.words.jump(1, true)
    end,
    desc = "Jumps to next reference",
  },
}
