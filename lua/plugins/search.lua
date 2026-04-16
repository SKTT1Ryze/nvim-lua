local M = {}

function M:config()
  vim.g['Lf_WindowPosition'] = 'popup'
  vim.g['Lf_PreviewInPopup'] = 1
  vim.g['Lf_DevIconsFont'] = 'DroidSansMono Nerd Font Mono'

  vim.g.Lf_CommandMap = {
    ['<C-p>'] = { '<C-k>' },
    ['<C-k>'] = { '<C-p>' },
    ['<C-j>'] = { '<C-n>' }
  }

  -- map('n', '<leader>f', ':FZF<CR>', {})
  -- map('n', '<leader>b', ':Buffers<CR>', {})

  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = "Find files" })
  vim.keymap.set('n', '<leader>r', builtin.live_grep, { desc = "Live grep" })
  vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = "Find buffers" })

  vim.keymap.set('n', '<leader>F', ':Leaderf rg ', { desc = "LeaderF ripgrep" })

  vim.keymap.set('v', '<D-f>', 'y/<C-r>"<CR>', { noremap = true })
  vim.keymap.set('v', '<leader>f', '<Plug>LeaderfRgVisualLiteralNoBoundary<CR>', {
    noremap = true,
    unique = true
  })
  vim.keymap.set('v', '<leader>F', '<Plug>LeaderfRgVisualLiteralNoBoundary', {
    noremap = true,
    unique = true
  })
end

return M
