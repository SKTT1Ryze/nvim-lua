local M = {}

function M:config()
  require "toggleterm".setup()

  vim.keymap.set('n', '<LEADER>j', ':ToggleTerm<CR>')
  vim.keymap.set('t', '<LEADER>j', '<C-\\><C-n>:ToggleTerm<CR>')
end

return M
