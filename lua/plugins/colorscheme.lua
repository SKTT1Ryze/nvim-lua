local M = {}

function M:config()
  vim.g.lightline = {
    colorscheme = 'purify',
    component = { readonly = '%{&readonly?"":""}' },
    separator = { left = '', right = '' },
    subseparator = { left = '', right = '' }
  }

  vim.cmd([[
    if has('termguicolors')
       set termguicolors
    endif
  ]])

  vim.g.edge_stype = 'aura'
  vim.g.edge_better_performance = 1

  vim.api.nvim_command('syntax on')
  -- vim.api.nvim_command('colorscheme purify')
  -- vim.api.nvim_command('colorscheme edge')
  -- vim.api.nvim_command('colorscheme gruvbox')
  -- vim.api.nvim_command('colorscheme catppuccin')
  -- vim.api.nvim_command('colorscheme night-owl')
  vim.api.nvim_command('colorscheme NeoSolarized')
end

return M
