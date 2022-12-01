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

" Plugin install at once but activate conditionally
function! Cond(Cond, ...)
  let opts = get(a:000, 0, {})
  return a:Cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin()

Plug 'kiyoon/vim-tmuxpaste'
Plug 'fisadev/vim-isort'
let g:vim_isort_map = '<C-i>'
Plug 'tpope/vim-surround'
"Plug 'tpope/vim-fugitive'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'		" vil, val to select line
Plug 'kana/vim-textobj-entire'	    " vie, vae to select entire buffer (file)
Plug 'kana/vim-textobj-fold'		" viz, vaz to select fold
Plug 'kana/vim-textobj-indent'		" vii, vai, viI, vaI to select indent

Plug 'vim-python/python-syntax'
let g:python_highlight_all = 1

Plug 'chaoren/vim-wordmotion'
let g:wordmotion_prefix = ','

" use normal easymotion when in VIM mode
Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))
" use VSCode easymotion when in VSCode mode
Plug 'asvetliakov/vim-easymotion', Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' })
" Use uppercase target labels and type as a lower case
"let g:EasyMotion_use_upper = 1
 " type `l` and match `l`&`L`
let g:EasyMotion_smartcase = 1
" Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1

" \f{char} to move to {char}
" within line
map  <Leader>f <Plug>(easymotion-bd-fl)
map  <Leader>t <Plug>(easymotion-bd-tl)
map  <Leader>w <Plug>(easymotion-bd-wl)
map  <Leader>e <Plug>(easymotion-bd-el)
"nmap <Leader>f <Plug>(easymotion-overwin-f)

" \s{char}{char} to move to {char}{char}
" anywhere, even across windows
map  <Leader>s <Plug>(easymotion-bd-f2)
nmap <Leader>s <Plug>(easymotion-overwin-f2)

if !exists('g:vscode')
	Plug 'tpope/vim-commentary'

	"Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'neoclide/coc.nvim', {'tag': 'v0.0.81'}
	" (Default binding) Use <C-e> and <C-y> to cancel and confirm completion
	" I personally use <C-n> <C-p> to confirm completion without closing the popup.
	"
	" Toggle CoC diagnostics
	"nnoremap <silent> <F6> :call CocActionAsync('diagnosticToggle')<CR>
	" Show CoC diagnostics window
	nnoremap <silent> <F6> :CocDiagnostics<CR>
	" navigate diagnostics
	nmap <silent> <C-j> <Plug>(coc-diagnostic-next)
	nmap <silent> <C-k> <Plug>(coc-diagnostic-prev)
	" Use <c-space> to trigger completion.
	if has('nvim')
		inoremap <silent><expr> <c-space> coc#refresh()
	else
		inoremap <silent><expr> <c-@> coc#refresh()
	endif
	" Remap keys for gotos
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)
	

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

	nnoremap <space>f :Fern . -drawer -toggle<CR>
	nnoremap <space>g :Fern . -drawer -toggle -reveal=%<CR>

	Plug 'github/copilot.vim'
else
	" tpope/vim-commentary behaviour for VSCode-neovim
	xmap gc  <Plug>VSCodeCommentary
	nmap gc  <Plug>VSCodeCommentary
	omap gc  <Plug>VSCodeCommentary
	nmap gcc <Plug>VSCodeCommentaryLine
endif

" All of your Plugins must be added before the following line
call plug#end()            " required
filetype plugin indent on    " required


if !exists('g:vscode')
	call coc#add_extension('coc-pyright')
	call coc#add_extension('coc-sh')
	call coc#add_extension('coc-clangd')
	call coc#add_extension('coc-vimlsp')
	call coc#add_extension('coc-java')
	call coc#add_extension('coc-html')
	"call coc#add_extension('coc-css')
	call coc#add_extension('coc-json')
	call coc#add_extension('coc-yaml')
	call coc#add_extension('coc-markdownlint')
endif
