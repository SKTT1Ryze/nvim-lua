local M = {}
local map = vim.api.nvim_set_keymap

function M:config()
  map('n', '<leader>e', ':NERDTreeToggle<CR>', {noremap = true})
  map('n', '<leader>t', ':NERDTreeFind<CR>', {noremap = true})
end

return M
