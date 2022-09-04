local M = {}
local map = vim.api.nvim_set_keymap


function M:config()
  vim.g['Lf_WindowPosition'] = 'popup'
  vim.g['Lf_PreviewInPopup'] = 1
  vim.g['Lf_DevIconsFont'] = 'DroidSansMono Nerd Font Mono'
 
 vim.g.Lf_CommandMap = {
    ['<C-p>'] = {'<C-k>'},
    ['<C-k>'] = {'<C-p>'},
    ['<C-j>'] = {'<C-n>'}
  }

  map('n', '<leader>f', ':Leaderf file<CR>', {})
  map('n', '<leader>b', ':Leaderf! buffer<CR>', {})
  map('n', '<leader>F', ':Leaderf rg ', {})
  map('v', '<D-f>', 'y/<C-r>"<CR>', { noremap = true })
  map('v', '<leader>f', '<Plug>LeaderfRgVisualLiteralNoBoundary<CR>', {
    noremap = true,
    unique = true
  })
  map('v', '<leader>F', '<Plug>LeaderfRgVisualLiteralNoBoundary', {
    noremap = true,
    unique = true
  })
end

return M
