local M = {}

function M:config()
  vim.api.nvim_set_keymap('n', 'cf', '<cmd>FineCmdline<CR>', { noremap = true })
end

return M
