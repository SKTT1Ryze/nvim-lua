local M = {}
local map = vim.api.nvim_set_keymap

function M:config()
  require('toggleterm').setup()

  map('n', '<D-j>', ':ToggleTerm<CR>', {noremap = true, silent = true})
end

return M
