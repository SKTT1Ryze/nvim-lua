local M = {}
local map = vim.api.nvim_set_keymap

function M:config()
  require('nvim-tree').setup()

  map('n', '<leader>e', ':NvimTreeToggle<CR>', {noremap = true})
  map('n', '<leader>t', ':NvimTreeFindFile<CR>', {noremap = true})
end

return M
