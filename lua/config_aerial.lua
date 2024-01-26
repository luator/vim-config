require('aerial').setup({
  layout = {default_direction = "prefer_right"},
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
