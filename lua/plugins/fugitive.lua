local M = {}
local map = vim.api.nvim_set_keymap

function M:config()
  map('n', '<leader>gb', ':Git blame<CR>', { noremap = true })
  map('n', '<leader>gl', ':GcLog<CR>', { noremap = true })
  map('n', '<leader>gd', ':Gdiffsplit<CR>', { noremap = true })
end

return M
