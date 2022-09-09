local M = {}

function M:config()
  vim.g.lightline= {
    colorscheme = 'wombat',
    component = { readonly = '%{&readonly?"":""}'},
    separator = { left = '', right = ''},
    subseparator = { left = '', right = '' }
  }

  vim.cmd([[
    if has('termguicolors')
       set termguicolors
    endif
  ]])

  vim.g.edge_stype = 'aura'
  vim.g.edge_better_performance = 1

  vim.api.nvim_command('colorscheme gruvbox')
end

return M
