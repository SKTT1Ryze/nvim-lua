local Plugins = {}

function ensure_vim_plug()
  vim.cmd([[
    if empty(glob('~/.config/nvim/autoload/plug.vim'))
      :exe '!curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    endif
  ]])
end

function Plugins:config()
  ensure_vim_plug()
  
  local Plug = vim.fn['plug#']

  vim.call('plug#begin', '~/.config/nvim/plugged')
  
  -- Comment
  Plug('tomtom/tcomment_vim')
  
  -- File manager
  Plug('preservim/nerdtree')
  Plug('Yggdroot/LeaderF', {['do'] = vim.fn[':LeaderfInstallCExtension']})
  Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install']})
  Plug('junegunn/fzf.vim')
  
  -- Git manager
  Plug('airblade/vim-gitgutter')
  Plug('tpope/vim-fugitive')

  -- Themes
  Plug('itchyny/lightline.vim')
  Plug('yuttie/inkstained-vim')
  Plug('sainnhe/everforest')
  Plug('arcticicestudio/nord-vim')
  
  -- Lsp
  Plug('neoclide/coc.nvim', {['branch'] = 'release'})
  
  vim.call('plug#end')

  require('plugins.tcomment_vim').config()
  require('plugins.nerdtree').config()
  require('plugins.leaderf').config()
  require('plugins.colorscheme').config()
  require('plugins.coc_nvim').config()
end

return Plugins
