local M = {}

function M:config()
  vim.cmd([[
    let g:lightline = {
          \ 'colorscheme': 'wombat',
          \ 'component': {
          \   'readonly': '%{&readonly?"":""}',
          \ },
          \ 'separator':    { 'left': '', 'right': '' },
          \ 'subseparator': { 'left': '', 'right': '' },
          \ }

    colorscheme nord
  ]])
end

return M
