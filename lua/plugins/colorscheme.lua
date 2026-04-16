local M = {}

function M:config()
  vim.g.lightline = {
    colorscheme = 'solarized',
    component = { readonly = '%{&readonly?"":""}' },
    separator = { left = '', right = '' },
    subseparator = { left = '', right = '' }
  }

  vim.opt.termguicolors = true

  vim.g.edge_style = 'aura'
  vim.g.edge_better_performance = 1

  vim.cmd('syntax on')
  -- vim.api.nvim_command('colorscheme purify')
  -- vim.api.nvim_command('colorscheme edge')
  -- vim.api.nvim_command('colorscheme gruvbox')
  -- vim.api.nvim_command('colorscheme catppuccin')
  -- vim.api.nvim_command('colorscheme night-owl')
  vim.cmd.colorscheme('NeoSolarized')
end

return M
