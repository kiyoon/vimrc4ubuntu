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

Plug 'kiyoon/tmuxsend.vim'
Plug 'christoomey/vim-tmux-navigator'

Plug 'svermeulen/vim-subversive'
" s for substitute
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)
xmap s <plug>(SubversiveSubstitute)
" <space>siwie to substitute word from entire buffer
" <space>siwip to substitute word from paragraph
" <space>siwif to substitute word from function 
" <space>siwic to substitute word from class
" <space>ssip to substitute word from paragraph
nmap <space>s <plug>(SubversiveSubstituteRange)
xmap <space>s <plug>(SubversiveSubstituteRange)
nmap <space>ss <plug>(SubversiveSubstitute\ordRange)

" Scroll through paste by C-n C-p
" Change the default buffer by [y ]y
" :Yanks to see the yank history
" :ClearYanks to clear the yank history
Plug 'svermeulen/vim-yoink'
nmap <c-n> <plug>(YoinkPostPasteSwapBack)
nmap <c-p> <plug>(YoinkPostPasteSwapForward)
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)
"nmap gp <plug>(YoinkPaste_gp)
nmap gP <plug>(YoinkPaste_gP)
nmap [y <plug>(YoinkRotateBack)
nmap ]y <plug>(YoinkRotateForward)
nmap y <plug>(YoinkYankPreserveCursorPosition)
xmap y <plug>(YoinkYankPreserveCursorPosition)
nmap <c-=> <plug>(YoinkPostPasteToggleFormat)

Plug 'tpope/vim-surround'
"Plug 'tpope/vim-fugitive'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'		" vil, val to select line
Plug 'kana/vim-textobj-entire'	    " vie, vae to select entire buffer (file)
Plug 'kana/vim-textobj-fold'		" viz, vaz to select fold

"Plug 'vim-python/python-syntax'
"let g:python_highlight_all = 1

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
map  <space>f <Plug>(easymotion-bd-fl)
map  <space>t <Plug>(easymotion-bd-tl)
map  <space>w <Plug>(easymotion-bd-wl)
map  <space>e <Plug>(easymotion-bd-el)
"nmap <Leader>f <Plug>(easymotion-overwin-f)

" <space>m{char}{char} to move to {char}{char}
" anywhere, even across windows
map  <space>m <Plug>(easymotion-bd-f2)
nmap <space>m <Plug>(easymotion-overwin-f2)

if !exists('g:vscode')
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	"Plug 'neoclide/coc.nvim', {'tag': 'v0.0.81'}
	" (Default binding) Use <C-e> and <C-y> to cancel and confirm completion
	" I personally use <C-n> <C-p> to confirm completion without closing the popup.
	"
	"let g:coc_node_args = ['--max-old-space-size=8192']	" prevent javascript heap out of memory
	" Toggle CoC diagnostics
	"nnoremap <silent> <F6> :call CocActionAsync('diagnosticToggle')<CR>
	" Show CoC diagnostics window
	nnoremap <silent> <F6> :CocDiagnostics<CR>
	" navigate diagnostics
	nmap <silent> <M-j> <Plug>(coc-diagnostic-next)
	nmap <silent> <M-k> <Plug>(coc-diagnostic-prev)
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
	nmap <silent> gs :call CocAction('jumpDefinition', 'split')<CR>
	nmap <silent> gt :call CocAction('jumpDefinition', 'tabe')<CR>
	au filetype python nmap <C-i> :CocCommand pyright.organizeimports<CR>
	nmap <space>rn <Plug>(coc-rename)
	

	"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	"Plug 'junegunn/fzf.vim'

	Plug 'github/copilot.vim'
else
	" tpope/vim-commentary behaviour for VSCode-neovim
	xmap gc  <Plug>VSCodeCommentary
	nmap gc  <Plug>VSCodeCommentary
	omap gc  <Plug>VSCodeCommentary
	nmap gcc <Plug>VSCodeCommentaryLine
endif

if has("nvim")
	if !exists('g:vscode')
		Plug 'numToStr/Comment.nvim'
	endif
	Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
	Plug 'EdenEast/nightfox.nvim'
	Plug 'nvim-lualine/lualine.nvim'

	Plug 'nvim-lua/plenary.nvim'
	Plug 'sindrets/diffview.nvim'
	nnoremap <leader>dv :DiffviewOpen<CR>
	nnoremap <leader>dc :DiffviewClose<CR>

	Plug 'smjonas/inc-rename.nvim'

lua << EOF
	vim.keymap.set("n", "<leader>rn", function()
	  return ":IncRename " .. vim.fn.expand("<cword>")
	end, { expr = true })
EOF

	Plug 'lewis6991/gitsigns.nvim'

	Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons
	Plug 'nvim-tree/nvim-tree.lua'
	nnoremap <leader>nt :NvimTreeToggle<CR>
	nnoremap <leader>nr :NvimTreeRefresh<CR>
	nnoremap <leader>nf :NvimTreeFindFile<CR>

	Plug 'lukas-reineke/indent-blankline.nvim'
	Plug 'kiyoon/test-indent-object'

	" Better syntax highlighting
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'nvim-treesitter/nvim-treesitter-textobjects'
	Plug 'kiyoon/treesitter-indent-object.nvim'
	Plug 'andymass/vim-matchup'		" % to match up if, else, etc. Enabled in the treesitter config below

	" Mason makes it easier to install language servers
	" Always load mason, mason-lspconfig and nvim-lspconfig in order.
	Plug 'williamboman/mason.nvim'
	Plug 'williamboman/mason-lspconfig.nvim'
	Plug 'neovim/nvim-lspconfig'

	Plug 'goolord/alpha-nvim'
	Plug 'lewis6991/impatient.nvim'

	Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
	Plug 'kiyoon/telescope-insert-path.nvim'
	" Find files using Telescope command-line sugar.
	nnoremap <leader>ff <cmd>Telescope find_files<cr>
	inoremap <C-t> <cmd>Telescope find_files<cr>
	nnoremap <leader>fg <cmd>Telescope live_grep<cr>
	nnoremap <leader>fb <cmd>Telescope buffers<cr>
	nnoremap <leader>fh <cmd>Telescope help_tags<cr>

	" Wilder.nvim
	function! UpdateRemotePlugins(...)
		" Needed to refresh runtime files
		let &rtp=&rtp
		UpdateRemotePlugins
	endfunction

	Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
	Plug 'romgrk/fzy-lua-native'
	Plug 'nixprime/cpsm'
	
	Plug 'RRethy/vim-illuminate'
	Plug 'ahmedkhalf/project.nvim'

	" LSP
	Plug 'folke/neodev.nvim'
	Plug 'hrsh7th/nvim-cmp' " The completion plugin
	Plug 'hrsh7th/cmp-buffer' " buffer completions
	Plug 'hrsh7th/cmp-path' " path completions
	Plug 'saadparwaiz1/cmp_luasnip' " snippet completions
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-nvim-lua'
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
	call coc#add_extension('coc-sumneko-lua')
endif

if has("nvim")
	lua require('impatient')
	lua require('Comment').setup()
	lua require('gitsigns').setup()

	"lua require"treesitter-unit".toggle_highlighting()

	lua require('user.lsp')
"
	lua require("inc_rename").setup()

	lua require('user.alpha')
	lua require('user.wilder')
	lua require('user.nvim_tree')
	lua require('user.treesitter')
	lua require('user.indent_blankline')
	lua require('user.tokyonight')
	lua require('user.illuminate')
	lua require('user.telescope')

	lua require'treesitter_indent_object'.setup()
	" vai to select context-aware indent
	xmap ai <Cmd>lua require'treesitter_indent_object.textobj'.select_indent_outer()<CR>
	" vaI to ensure select entire line (or just use Vai)
	xmap aI <Cmd>lua require'treesitter_indent_object.textobj'.select_indent_outer(true)<CR>
	" select inner block (only if block, only else block, etc.)
	xmap ii <Cmd>lua require'treesitter_indent_object.textobj'.select_indent_inner()<CR>
	" select entire inner range (including if, else, etc.)
	xmap iI <Cmd>lua require'treesitter_indent_object.textobj'.select_indent_inner(true)<CR>

endif


