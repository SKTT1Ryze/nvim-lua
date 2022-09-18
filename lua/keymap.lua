local KeyMap = {}
local map = vim.api.nvim_set_keymap

function KeyMap:config()
  -- Map leader key
  map('n', '<Space>', '', {})
  vim.g.mapleader = ' '

  map('n', '<C-z>', 'u', {noremap = true, silent = true})
  map('v', '<leader>y', '\"+y', {noremap = true})
  map('n', '<leader>p', '\"+p', {noremap = true})
  map('v', '<Tab>', 'I<Space><Esc>', {noremap = true})
  map('n', '<C-j>', '10j', {noremap = true})
  map('n', '<C-k>', '10k', {noremap = true})
end

return KeyMap
