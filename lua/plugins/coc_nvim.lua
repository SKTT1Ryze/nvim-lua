local M = {}
local map = vim.api.nvim_set_keymap

function _G.CheckBackSpace()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

function M:config()
  vim.g.coc_global_extenstions = {
    'coc-highlight',
    'coc-rust-analyzer',
    'coc-vimlsp',
    'coc-json',
    'coc-tsserver',
    'coc-sumneko-lua'
  }

  vim.opt.signcolumn = 'number'

  -- <TAB> to select candidate forward or
  -- pump completion candidate
  vim.cmd([[
    inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ v:lua.CheckBackSpace() ? "\<Tab>" :
      \ coc#refresh()
    
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
  ]])

  -- <CR> to confirm
  vim.cmd([[
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  ]])

  -- diagnostic info
  map('n', '<LEADER>d', ':CocList diagnostics<CR>', {
    silent = true,
    nowait = true,
    noremap = true}
    )

  -- Goto code navigation
  map('n', 'gd', '<Plug>(coc-definition)', {silent = true})
  map('n', 'gD', ':tab sp<CR><Plug>(coc-definition)', {silent = true})
  map('n', 'gy', '<Plug>(coc-type-definition)', {silent = true})
  map('n', 'gi', '<Plug>(coc-implementation)', {silent = true})
  map('n', 'gr', '<Plug>(coc-references)', {silent = true})

  -- Go Back
  map('n', 'gb', '<C-o>', {silent = true})
end

return M
