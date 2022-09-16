local M = {}

function M:config()
  require"toggleterm".setup()

  vim.keymap.set('n', '<D-j>', ':ToggleTerm<CR>')
  vim.keymap.set('t', '<D-j>', '<C-\\><C-n>:ToggleTerm<CR>')
end

return M
