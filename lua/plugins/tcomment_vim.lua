local M = {}
local map = vim.api.nvim_set_keymap

function M:config()
  vim.g['tcomment_textobject_inlinecomment'] = ''

  map('n', '<leader>cn', 'g>c', {})
  map('v', '<leader>cn', 'g>', {})
  map('n', '<leader>cu', 'g<c', {})
  map('v', '<leader>cu', 'g<', {})
end

return M
