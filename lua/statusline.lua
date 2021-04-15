-- copied from https://github.com/richin13/dotfiles/blob/develop/dotfiles/.config/nvim/lua/plugins/status-line.lua
-- Copyright (c) 2018 Ricardo Madriz / MIT License

local gl = require('galaxyline')
local condition = require('galaxyline.condition')

-- copied from galaxyline.provider_fileinfo, modified to include file path
local function file_readonly(readonly_icon)
  if vim.bo.filetype == 'help' then
    return ''
  end
  local icon = readonly_icon or ''
  if vim.bo.readonly == true then
    return " " .. icon .. " "
  end
  return ''
end
function get_current_file_name(modified_icon, readonly_icon)
  local file = vim.fn.expand('%')
  if vim.fn.empty(file) == 1 then return '' end
  if string.len(file_readonly(readonly_icon)) ~= 0 then
    return file .. file_readonly(readonly_icon)
  end
  local icon = modified_icon or ''
  if vim.bo.modifiable then
    if vim.bo.modified then
      return file .. ' ' .. icon .. '  '
    end
  end
  return file .. ' '
end


local gls = gl.section
gl.short_line_list = { 'defx', 'packager', 'vista' }

-- Colors
--local colors = {
--  bg = '#282a36',
--  fg = '#f8f8f2',
--  section_bg = '#38393f',
--  yellow = '#f1fa8c',
--  cyan = '#8be9fd',
--  green = '#50fa7b',
--  orange = '#ffb86c',
--  magenta = '#ff79c6',
--  blue = '#8be9fd',
--  red = '#ff5555'
--}

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

local mode_color = function()
  local mode_colors = {
    n = colors.cyan,
    i = colors.green,
    c = colors.orange,
    V = colors.magenta,
    [''] = colors.magenta,
    v = colors.magenta,
    R = colors.red,
  }

  return mode_colors[vim.fn.mode()]
end

-- Left side
gls.left[1] = {
  ViMode = {
    provider = function()
      --local alias = {
      --  n = 'NORMAL',
      --  i = 'INSERT',
      --  c = 'COMMAND',
      --  V = 'VISUAL',
      --  [''] = 'VISUAL',
      --  v = 'VISUAL',
      --  R = 'REPLACE',
      --}
      local alias = {
        n = 'Ⓝ',
        i = 'Ⓘ',
        c = 'Ⓒ',
        V = 'Ⓥ',
        [''] = 'Ⓥ',
        v = 'Ⓥ',
        R = 'Ⓡ',
      }
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color())
      return alias[vim.fn.mode()]..' '
    end,
    icon = "▋",
    highlight = { colors.bg, colors.bg, "bold" },
    separator = " ",
    separator_highlight = {colors.bg, colors.section_bg},
  },
}

--gls.left[3] = {
--  GitBranch = {
--    provider = function()
--      local vcs = require('galaxyline.provider_vcs')
--      local branch_name = vcs.get_git_branch()
--      if (branch_name == nil) then
--          return ""
--      elseif (string.len(branch_name) > 28) then
--        return string.sub(branch_name, 1, 25).."..."
--      end
--      return branch_name
--    end,
--    icon = ' ',
--    condition = check_git_workspace,
--    highlight = {colors.fg,colors.bg},
--  }
--}
gls.left[3] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = function()
        return condition.buffer_not_empty() and condition.hide_in_width()
    end,
    icon = ' ',
    separator = ' ',
    highlight = {colors.fg,colors.section_bg},
    separator_highlight = {colors.fg,colors.section_bg},
  }
}
gls.left[4] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = '',
    highlight = { colors.green, colors.section_bg },
  }
}
gls.left[5] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = '',
    highlight = { colors.orange, colors.section_bg },
  }
}
gls.left[6] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '',
    highlight = { colors.red,colors.section_bg },
  }
}
gls.left[7] = {
  GitLeftEnd = {
    provider = function() return ' ' end,
    condition = check_git_workspace,
    highlight = {colors.bg,colors.section_bg}
  }
}
gls.left[10] = {
  Space = {
    provider = function() return " " end,
    highlight = {colors.fg,colors.bg}
  }
}

gls.left[11] = {
  FileName = {
    provider = get_current_file_name,
    highlight = { colors.fg, colors.bg },
    separator_highlight = { colors.fg, colors.bg },
  }
}

gls.left[12] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red,colors.bg}
  }
}
gls.left[13] = {
  Space = {
    provider = function () return ' ' end,
    highlight = {colors.section_bg,colors.bg},
  }
}
gls.left[14] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.orange,colors.bg},
  }
}
gls.left[15] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = {colors.blue,colors.bg},
  }
}


--gls.mid[1] = {
--  ShowLspClient = {
--    provider = 'GetLspClient',
--    condition = function ()
--      local tbl = {['dashboard'] = true,['']=true}
--      if tbl[vim.bo.filetype] then
--        return false
--      end
--      return true
--    end,
--    icon = ' LSP:',
--    highlight = {colors.fg,colors.bg}
--  }
--}
--
--
-- Right side
gls.right[1]= {
  FileFormat = {
    provider = function() return vim.bo.filetype end,
    highlight = { colors.fg,colors.section_bg },
    icon = ' ',
    separator = '',
    separator_highlight = { colors.section_bg,colors.bg },
  }
}
gls.right[2] = {
  LineInfo = {
    provider = 'LineColumn',
    highlight = { colors.fg, colors.section_bg },
    separator = ' | ',
    separator_highlight = { colors.bg, colors.section_bg },
  },
}


-- Short status line
gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    highlight = { colors.fg, colors.section_bg },
    separator = ' ',
    separator_highlight = { colors.section_bg, colors.bg },
  }
}

gls.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    highlight = { colors.yellow, colors.section_bg },
    separator = ' ',
    separator_highlight = { colors.section_bg, colors.bg },
  }
}

-- Force manual load so that nvim boots with a status line
-- gl.load_galaxyline()
