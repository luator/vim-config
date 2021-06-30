-- nvim-treesitter config
require'nvim-treesitter.configs'.setup {
    -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true, -- to prevent spell checking of source code
    },
    indent = {
        enable = true
    },
}
