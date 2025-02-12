-- nvim-treesitter config
require'nvim-treesitter.configs'.setup {
    -- one of "all" or a list of languages
    ensure_installed = "all",
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true, -- to prevent spell checking of source code
    },
    indent = {
        enable = false,
        disable = {"python", "yaml", "cpp"},
    },
    textobjects = {
        select = {
            enable  = true,
            keymaps = {
                ["ac"] = "@comment.outer",
                ["aC"] = "@class.outer",
                ["iC"] = "@class.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["ia"] = "@parameter.inner",
                ["iA"] = "@parameter.outer",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>s"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>S"] = "@parameter.inner",
            },
        },
        --move = {
        --    enable = true,
        --    set_jumps = true, -- whether to set jumps in the jumplist
        --    goto_next_start = {
        --        ["]b"] = "@block.outer",
        --        ["]m"] = "@function.outer",
        --        ["]]"] = "@class.outer",
        --    },
        --    goto_next_end = {
        --        ["]B"] = "@block.outer",
        --        ["]M"] = "@function.outer",
        --        ["]["] = "@class.outer",
        --    },
        --    goto_previous_start = {
        --        ["[b"] = "@block.outer",
        --        ["[m"] = "@function.outer",
        --        ["[["] = "@class.outer",
        --    },
        --    goto_previous_end = {
        --        ["[B"] = "@block.outer",
        --        ["[M"] = "@function.outer",
        --        ["[]"] = "@class.outer",
        --    },
        --},
    },
}

require'treesitter-context'.setup{
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 10, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 3, -- Maximum number of lines to show for a single context
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20, -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}
