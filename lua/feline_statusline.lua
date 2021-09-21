local lsp = require('feline.providers.lsp')
local vi_mode_utils = require('feline.providers.vi_mode')

-- check if the window is > 80 chars
function is_wide(winid)
    return vim.api.nvim_win_get_width(winid) > 80
end


-- Solarized dark
local colors = {
    --bg = '#002b36',  -- base03
    bg = '#03303c',  -- half-way between base03 and base02
    fg = '#839496',  -- base0
    section_bg = '#073642', -- base02
    yellow = '#b58900',
    cyan = '#2aa198',
    green = '#859900',
    orange = '#cb4b16',
    magenta = '#d33682',
    violet = '#6c71c4',
    blue = '#268bd2',
    red = '#dc322f'
}

local vi_mode_colors = {
    NORMAL = 'cyan',
    OP = 'green',
    INSERT = 'green',
    VISUAL = 'magenta',
    BLOCK = 'magenta',
    REPLACE = 'red',
    ['V-REPLACE'] = 'red',
    ENTER = 'cyan',
    MORE = 'cyan',
    SELECT = 'orange',
    COMMAND = 'orange',
    SHELL = 'green',
    TERM = 'green',
    NONE = 'yellow'
}

local vi_mode_text = {
    NORMAL = 'Ⓝ',
    OP = '<|',
    INSERT = 'Ⓘ',
    VISUAL = 'Ⓥ',
    BLOCK = 'Ⓥ',
    REPLACE = 'Ⓡ',
    ['V-REPLACE'] = 'Ⓡ',
    ENTER = '<>',
    MORE = '<>',
    SELECT = '<>',
    COMMAND = 'Ⓒ',
    SHELL = '<|',
    TERM = '<|',
    NONE = '<>'
}

local components = {
    active = {{}, {}},  -- two components: left and right
    inactive = {{}},
}


-- Left side

-- vi mode
table.insert(components.active[1], {
    provider = function()
        return vi_mode_text[vi_mode_utils.get_vim_mode()]
    end,
    icon = "▋",
    hl = function()
        return {
            name = vi_mode_utils.get_mode_highlight_name(),
            fg = vi_mode_utils.get_mode_color(),
            style = 'bold'
        }
    end,
    right_sep = ' ',
})

-- GIT
table.insert(components.active[1], {
    provider = 'git_branch',
    enabled = is_wide,
    icon = '  ',
    hl = {bg='section_bg'},
    left_sep = {str = 'slant_left_2', hl = {fg = 'section_bg', bg = 'bg'}},
    right_sep = {str = ' ', hl = {bg = 'section_bg'}},
})
-- diffAdd
table.insert(components.active[1], {
    provider = 'git_diff_added',
    enabled = is_wide,
    hl = {
        fg = 'green',
        bg = 'section_bg',
    }
})
-- diffModfified
table.insert(components.active[1], {
    provider = 'git_diff_changed',
    enabled = is_wide,
    hl = {
        fg = 'orange',
        bg = 'section_bg',
    }
})
-- diffRemove
table.insert(components.active[1], {
    provider = 'git_diff_removed',
    enabled = is_wide,
    hl = {
        fg = 'red',
        bg = 'section_bg',
    },
})
table.insert(components.active[1], {
    provider = ' ',
    enabled = is_wide,
    hl = { bg = 'section_bg' },
    right_sep = {
        {str = 'slant_right_2', hl = {fg = 'section_bg'}},
    },
})

-- filename
table.insert(components.active[1], {
    provider = 'file_info',
    file_modified_icon = '',
    type = 'relative-short',
    --type = 'base-only',
    left_sep = ' ',
})


-- diagnosticErrors
table.insert(components.active[1], {
    provider = 'diagnostic_errors',
    enabled = function() return lsp.diagnostics_exist('Error') end,
    hl = { fg = 'red' }
})
-- diagnosticWarn
table.insert(components.active[1], {
    provider = 'diagnostic_warnings',
    enabled = function() return lsp.diagnostics_exist('Warning') end,
    hl = { fg = 'yellow' }
})
-- diagnosticHint
table.insert(components.active[1], {
    provider = 'diagnostic_hints',
    enabled = function() return lsp.diagnostics_exist('Hint') end,
    hl = { fg = 'cyan' }
})
-- diagnosticInfo
table.insert(components.active[1], {
    provider = 'diagnostic_info',
    enabled = function() return lsp.diagnostics_exist('Information') end,
    hl = { fg = 'blue' }
})


-- Right side

-- fileFormat
table.insert(components.active[2], {
    provider = 'file_type',
    hl = { bg = 'section_bg' },
    left_sep = {
        {str = 'slant_left', hl = {fg = 'section_bg', bg = 'bg'}},
        {str = ' ', hl = {bg = 'section_bg'}},
    },
})

-- cursor position
table.insert(components.active[2], {
    provider = 'position',
    hl = { bg = 'section_bg' },
    left_sep = {str = ' ', hl = {bg = 'section_bg'}},
})


-- INACTIVE

-- filename
table.insert(components.inactive[1], {
    provider = 'file_info',
    colored_icon = false,
    file_modified_icon = '',
    type = 'relative-short',
})


require('feline').setup({
    colors = colors,
    default_bg = bg,
    default_fg = fg,
    vi_mode_colors = vi_mode_colors,
    components = components,
})