require('copilot').setup({
  panel = {
    enabled = false,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = true,
    debounce = 75,
    keymap = {
      accept = "<M-l>",
      accept_word = false,
      accept_line = false,
      next = "<M-j>",
      prev = "<M-k>",
      dismiss = "<C-l>",
    },
  },
  --filetypes = {
  --  yaml = false,
  --  markdown = false,
  --  help = false,
  --  gitcommit = false,
  --  gitrebase = false,
  --  hgcommit = false,
  --  svn = false,
  --  cvs = false,
  --  ["."] = false,
  --},
  filetypes = {
      ["*"] = false,  -- disable for all by default
      -- only enable for specific filetypes
      cpp = true,
      dot = true,
      lua = true,
      python = true,
      rust = true,
      sh = true,
  },
  --copilot_node_command = "/home/felixwidmaier/.local/bin/node_latest.sif",
  server_opts_overrides = {},
})

require("copilot_cmp").setup()

require("CopilotChat").setup()
