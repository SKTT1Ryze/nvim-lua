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

local coc_status_record = {}

function _G.coc_status_notify(msg, level)
  local notify_opts = {
    title = "LSP Status",
    timeout = 500,
    hide_from_history = true,
    on_close = reset_coc_status_record
  }

  -- if coc_status_record is not {} then add it to notify_opts to key called "replace"
  if coc_status_record ~= {} then
    notify_opts["replace"] = coc_status_record.id
  end
  coc_status_record = vim.notify(msg, level, notify_opts)
end

function _G.reset_coc_status_record(window)
  coc_status_record = {}
end

local coc_diag_record = {}

function _G.coc_diag_notify(msg, level)
  local notify_opts = {
    title = "LSP Diagnostics",
    timeout = 500,
    on_close = reset_coc_diag_record
  }

  -- if coc_diag_record is not {} then add it to notify_opts to key called "replace"
  if coc_diag_record ~= {} then
    notify_opts["replace"] = coc_diag_record.id
  end
  coc_diag_record = vim.notify(msg, level, notify_opts)
end

function _G.reset_coc_diag_record(window)
  coc_diag_record = {}
end

function notify_config()
  vim.cmd([[
  function! s:DiagnosticNotify() abort
    let l:info = get(b:, 'coc_diagnostic_info', {})
    if empty(l:info) | return '' | endif
    let l:msgs = []
    let l:level = 'info'
     if get(l:info, 'warning', 0)
      let l:level = 'warn'
    endif
    if get(l:info, 'error', 0)
      let l:level = 'error'
    endif
   
    if get(l:info, 'error', 0)
      call add(l:msgs, ' Errors: ' . l:info['error'])
    endif
    if get(l:info, 'warning', 0)
      call add(l:msgs, ' Warnings: ' . l:info['warning'])
    endif
    if get(l:info, 'information', 0)
      call add(l:msgs, ' Infos: ' . l:info['information'])
    endif
    if get(l:info, 'hint', 0)
      call add(l:msgs, ' Hints: ' . l:info['hint'])
    endif
    let l:msg = join(l:msgs, "\n")
    if empty(l:msg) | let l:msg = ' All OK' | endif
    call v:lua.coc_diag_notify(l:msg, l:level)
  endfunction
  
  function! s:StatusNotify() abort
    let l:status = get(g:, 'coc_status', '')
    let l:level = 'info'
    if empty(l:status) | return '' | endif
    call v:lua.coc_status_notify(l:status, l:level)
  endfunction
  
  function! s:InitCoc() abort
    execute "lua vim.notify('Initialized coc.nvim for LSP support', 'info', { title = 'LSP Status' })"
  endfunction
  
  " notifications
  autocmd User CocNvimInit call s:InitCoc()
  autocmd User CocDiagnosticChange call s:DiagnosticNotify()
  autocmd User CocStatusChange call s:StatusNotify()

  ]])
end

-- Use K to show documentation in preview window.
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
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
  vim.opt.updatetime = 300

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

  map('n', 'K', '<CMD>lua _G.show_docs()<CR>', {silent = true})
  notify_config()
end

return M
