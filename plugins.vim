
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

Plug 'kiyoon/vim-tmuxpaste'
Plug 'fisadev/vim-isort'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'LumaKernel/fern-mapping-fzf.vim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'lambdalisue/fern-git-status.vim'
let g:fern#renderer = "nerdfont"

function! s:init_fern() abort
  " Use 'select' instead of 'edit' for default 'open' action
  "nmap <buffer> <Plug>(fern-action-open) <Plug>(fern-action-open:select)
  " Even if some other plugins set foldcolumn, fern should not increase the fold column.
  set foldcolumn=0
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

nnoremap <Leader>ff :Fern . -drawer -toggle<CR>
nnoremap <Leader>fg :Fern . -drawer -toggle -reveal=%<CR>
nnoremap <Leader>fh :Fern . -drawer -toggle -reveal=%:h<CR>
nnoremap <Leader>fs :Fern . -drawer -toggle -reveal=%:p:h<CR>
nnoremap <Leader>ft :Fern . -drawer -toggle -reveal=%:t<CR>
nnoremap <Leader>fr :Fern . -drawer -toggle -reveal=%:r<CR>
nnoremap <Leader>fe :Fern . -drawer -toggle -reveal=%:e<CR>
nnoremap <Leader>fn :Fern . -drawer -toggle -reveal=%:p<CR>


Plug 'github/copilot.vim'

" All of your Plugins must be added before the following line
call plug#end()            " required
filetype plugin indent on    " required


call coc#add_extension('coc-pyright')
call coc#add_extension('coc-sh')
call coc#add_extension('coc-clangd')
call coc#add_extension('coc-vimlsp')
call coc#add_extension('coc-java')
call coc#add_extension('coc-html')
call coc#add_extension('coc-css')
call coc#add_extension('coc-json')
call coc#add_extension('coc-yaml')
call coc#add_extension('coc-markdownlint')
