
" Automatic installation of vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()

Plug 'fisadev/vim-isort'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" All of your Plugins must be added before the following line
call plug#end()            " required
filetype plugin indent on    " required


call coc#add_extension('coc-pyright')
call coc#add_extension('coc-sh')
call coc#add_extension('coc-clangd')
call coc#add_extension('coc-java')
call coc#add_extension('coc-html')
call coc#add_extension('coc-css')
call coc#add_extension('coc-json')
call coc#add_extension('coc-yaml')
call coc#add_extension('coc-markdownlint')
