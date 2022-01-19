-- nvim-treesitter config
require'nvim-treesitter.configs'.setup {
    -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true, -- to prevent spell checking of source code
    },
    indent = {
        enable = true,
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
