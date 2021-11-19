
" settings profile based on OS name
"let os = 'fc'
let os = 'ubuntu'

if os == 'fc'
	let use_ycm				= 1
	let use_ycm_spellcheck	= 0
	let use_pathogen        = 0
elseif os == 'ubuntu'
	let use_ycm				= 0
	let use_ycm_spellcheck	= 1
	let use_pathogen        = 1
endif

" directory path where the vimrc is installed
let installed_dir = "~/vimrc4ubuntu"

if use_ycm 
	exec "source " . installed_dir . "/ycm.vim"
endif

if use_pathogen
	execute pathogen#infect()
endif

" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif
"

syntax on

" set the colorscheme to ron. When using screen or tmux, colorscheme is changed to default. To prevent this, it should be written.
"color default
color ron

" Open new split panes to right and bottom, which feels more natural than Vim’s default:
set splitbelow
set splitright

" show line numbers
set nu

" highlight search
set hlsearch

" search as characters are entered
set incsearch

" view matching brace
set sm

" scroll offset
set scrolloff=2

" number of undo history
set history=100

" Maintain undo history between sessions (persistent undo)
set undofile 
function! InitUndoDir()
  if has('win32') || has('win32unix') "windows/cygwin
    let l:separator = '_'
  else
    let l:separator = '.'
  endif
  let l:parent = $HOME . '/' . l:separator . 'vim/'
  let l:undo = l:parent . 'undo/'
  if exists('*mkdir')
    if !isdirectory(l:parent)
      call mkdir(l:parent)
    endif
    if !isdirectory(l:undo)
      call mkdir(l:undo)
    endif
  endif
  let l:missing_dir = 0
  if isdirectory(l:undo)
    execute 'set undodir=' . escape(l:undo, ' ') . '/,.'
  else
    let l:missing_dir = 1
  endif
  if l:missing_dir
    echo 'Warning: Unable to create undo directories:' l:undo
    echo 'Try: mkdir -p' l:undo
    set undodir=.
  endif
endfunction
call InitUndoDir()

" highlight cursor line
"set cursorline

" set each buffer store up to 1000 lines(<1000), maximum buffer size
" 1000kb(s1000)
set viminfo='20,<1000,s1000

" backup
set backup
" backup ext to date
:au BufWritePre * let &bex = '-' . strftime("%Y%m%d_%H%M%S") . '~'
" set auto backupdir to ~/.vim/backup
function! InitBackupDir()
  if has('win32') || has('win32unix') "windows/cygwin
    let l:separator = '_'
  else
    let l:separator = '.'
  endif
  let l:parent = $HOME . '/' . l:separator . 'vim/'
  let l:backup = l:parent . 'backup/'
  let l:tmp = l:parent . 'tmp/'
  if exists('*mkdir')
    if !isdirectory(l:parent)
      call mkdir(l:parent)
    endif
    if !isdirectory(l:backup)
      call mkdir(l:backup)
    endif
    if !isdirectory(l:tmp)
      call mkdir(l:tmp)
    endif
  endif
  let l:missing_dir = 0
  if isdirectory(l:backup)
    execute 'set backupdir=' . escape(l:backup, ' ') . '/,.'
  else
    let l:missing_dir = 1
  endif
  if isdirectory(l:tmp)
    execute 'set directory=' . escape(l:tmp, ' ') . '/,.'
  else
    let l:missing_dir = 1
  endif
  if l:missing_dir
    echo 'Warning: Unable to create backup directories:' l:backup 'and' l:tmp
    echo 'Try: mkdir -p' l:backup
    echo 'and: mkdir -p' l:tmp
    set backupdir=.
    set directory=.
  endif
endfunction
call InitBackupDir()

if !use_ycm_spellcheck
	" YouCompleteMe : syntax checker off
	let g:ycm_show_diagnostics_ui = 0
endif
" YCM : for compiler option

if os == 'ubuntu'
	let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
else
	let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
endif
" YCM : no highlight
" let g:ycm_enable_diagnostic_highlighting = 0
" YCM : change warning symbol
let g:ycm_warning_symbol = '??'

" make backspace working properly
set backspace=indent,eol,start

" set tab length to 4 spaces
set tabstop=4
set shiftwidth=4

" automatic indent on bash
filetype plugin indent on

" use tab as spaces in python, tex
autocmd FileType python,tex set expandtab

" latex settings (global values require vim-latex plugin)
autocmd FileType tex set tabstop=2
autocmd FileType tex set shiftwidth=2
autocmd FileType tex set iskeyword+=:
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_MultipleCompileFormats='pdf, aux'

" turn off automatic new line when the text is too long in a line (e.g. SML)
autocmd FileType sml set textwidth=0 wrapmargin=0
autocmd FileType vim set textwidth=0 wrapmargin=0

set wildmenu

set foldmethod=marker

" zf folding comment set
set commentstring=%s
autocmd FileType c,cpp,java,html,php setl commentstring=//%s 
autocmd FileType sh,python setl commentstring=#%s 
autocmd FileType matlab setl commentstring=%%s
autocmd FileType sml setl commentstring=(*%s*)
"autocmd FileType html,php setl commentstring=<!--%s-->

" set foldcolumn automatically if there is at least one fold
function HasFolds()
	"Attempt to move between folds, checking line numbers to see if it worked.
	"If it did, there are folds.

	function! HasFoldsInner()
		let origline=line('.')  
		:norm zk
		if origline==line('.')
			:norm zj
			if origline==line('.')
				return 0
			else
				return 1
			endif
		else
			return 1
		endif
		return 0
	endfunction

	" suppress all sounds when this function calls
"	set belloff=all
	set noeb vb t_vb=
	let l:winview=winsaveview() "save window and cursor position
	let foldsexist=HasFoldsInner()
	if foldsexist
		set foldcolumn=3
	else
		"Move to the end of the current fold and check again in case the
		"cursor was on the sole fold in the file when we checked
		if line('.')!=1
			:norm [z
			:norm k
		else
			:norm ]z
			:norm j
		endif
		let foldsexist=HasFoldsInner()
		if foldsexist
			set foldcolumn=3
		else
			set foldcolumn=0
		endif
	end
	call winrestview(l:winview) "restore window/cursor position

	" enable bell sounds again
"	set belloff=
	set novb eb
endfunction

au CursorHold,BufWinEnter ?* call HasFolds()


" restore the cursor position
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END


" match behaviour of Y with C and D
nnoremap Y y$
vnoremap Y $y

" paste mode by <F3>, and leave automatically
set pastetoggle=<F3>
autocmd InsertLeave * set nopaste


" Commands that only work in a GNU Screen session.
if $STY

	""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" Press <num>- to copy and paste lines to screen window <num>.
	" For example, 1- will paste selection (or current line)
	" to window 1 on GNU Screen.
	" If number not specified, then it will paste to window named `-console`.
	function! ChooseScreenWindow(vcount)
		if a:vcount == 0
			" No number given. By default, paste to -console window.
			return "-console"
		else
			return a:vcount
		endif
	endfunction


	function! ScreenPaste(pasteWindow, content, addNewLine, pasteTo)
"		function! EscapeForScreenStuff(content)
"			" Escape string for GNU Screen (stuff).
"			" By doing this, Screen stuff will be operating the literal string, not evaluating environment variables.
"			" For example, without this, $HOME will be pasted as /home/user.
"			" \ -> \\
"			" $ -> \$
"			" ^ -> \^
"			" ' -> '"'"'
"			" newline -> ^@ -> \n (literal string)
"			" no space escaping
"			let strsub = substitute(a:content,'\\','\\\\','g')
"			let strsub = substitute(strsub,'\$','\\$','g')
"			let strsub = substitute(strsub,'\^','\\^','g')
"			let strsub = substitute(strsub,'''','''"''"''','g')
"			let strsub = substitute(strtrans(strsub),'\^@','\\n','g')
"			return strsub
"		endfunction
"		let escapedContent = EscapeForScreenStuff(a:content)
"		let newlinestr = a:addNewLine ? "\n" : ''
"		let screenPasteCommand = 'screen -p ' . a:pasteWindow . ' -X stuff ''' . escapedContent . newlinestr . ''''

		let tempname = tempname()
		call writefile(split(a:content, "\n"), tempname, 'b')


		" msgwait: Suppress messages like 'Slurped 300 characters to buffer'
		let screenMsgWaitCommand = 'screen -X msgwait 0'
		let screenRegCommand = 'screen -X readreg s ' . tempname
		let screenMsgWaitUndoCommand = 'screen -X msgwait 5'
		let screenPasteCommand = 'screen -p ' . a:pasteWindow . ' -X paste s'
		call system(screenMsgWaitCommand)
		call system(screenRegCommand)
		if a:pasteTo == 'vim'
			" ^[ => Ctrl+[ = ESC
			" Enter paste mode
			call system('screen -p ' . a:pasteWindow . ' -X stuff ''^[:set paste\no''')
		elseif a:pasteTo == 'ipython'
			call system('screen -p ' . a:pasteWindow . ' -X stuff ''^U%cpaste\n''')
		endif
		call system(screenPasteCommand)
		call system(screenMsgWaitUndoCommand)

		if a:addNewLine == 1
			call system('screen -p ' . a:pasteWindow . ' -X stuff ''\n''')
		endif
		echom 'Pasted to Screen window ' . a:pasteWindow
		if a:pasteTo == 'vim'
			" ^[ => Ctrl+[ = ESC
			" Exit paste mode and force redraw (need to redraw if pasting to same screen)
			call system('screen -p ' . a:pasteWindow . ' -X stuff ''^[:set nopaste\n:redraw!\n''')
		elseif a:pasteTo == 'ipython'
			call system('screen -p ' . a:pasteWindow . ' -X stuff ''\n--\n''')
		endif
		call delete(tempname)
	endfunction

	" 1. save count to pasteWindow
	" 2. yank using @s register.
	" 4. execute screen command.
	nnoremap <silent> - :<C-U>let pasteWindow=ChooseScreenWindow(v:count)<CR>"syy:call ScreenPaste(pasteWindow, @s, 1, 0)<CR>
	vnoremap <silent> - :<C-U>let pasteWindow=ChooseScreenWindow(v:count)<CR>gv"sy:call ScreenPaste(pasteWindow, @s, 1, 0)<CR>
	" pasting to window 0 is not 0; but \;. Explicit separate command because v:count is 0 for no count, and also 0 is a command that moves the cursor.
	nnoremap <silent> <leader>- "syy:<C-U>call ScreenPaste(0, @s, 1, 0)<CR>
	vnoremap <silent> <leader>- "sy:<C-U>call ScreenPaste(0, @s, 1, 0)<CR>
	"""""""""""""""
	" Same thing but <num>_ to paste without the return at the end.
	nnoremap <silent> _ :<C-U>let pasteWindow=ChooseScreenWindow(v:count)<CR>"syy:call ScreenPaste(pasteWindow, @s, 0, 0)<CR>
	vnoremap <silent> _ :<C-U>let pasteWindow=ChooseScreenWindow(v:count)<CR>gv"sy:call ScreenPaste(pasteWindow, @s, 0, 0)<CR>
	nnoremap <silent> <leader>_ "syy:<C-U>call ScreenPaste(0, @s, 0, 0)<CR>
	vnoremap <silent> <leader>_ "sy:<C-U>call ScreenPaste(0, @s, 0, 0)<CR>

	"""""""""""""""
	" Paste to VIM
	
	nnoremap <silent> <C-_> :<C-U>let pasteWindow=ChooseScreenWindow(v:count)<CR>"syy:call ScreenPaste(pasteWindow, @s, 0, 'vim')<CR>
	vnoremap <silent> <C-_> :<C-U>let pasteWindow=ChooseScreenWindow(v:count)<CR>gv"sy:call ScreenPaste(pasteWindow, @s, 0, 'vim')<CR>
	nnoremap <silent> <leader><C-_> "syy:<C-U>call ScreenPaste(0, @s, 0, 'vim')<CR>
	vnoremap <silent> <leader><C-_> "sy:<C-U>call ScreenPaste(0, @s, 0, 'vim)<CR>

	"""""""""""""""
	" Paste to iPython
	
	nnoremap <silent> ; :<C-U>let pasteWindow=ChooseScreenWindow(v:count)<CR>"syy:call ScreenPaste(pasteWindow, @s, 0, 'ipython')<CR>
	vnoremap <silent> ; :<C-U>let pasteWindow=ChooseScreenWindow(v:count)<CR>gv"sy:call ScreenPaste(pasteWindow, @s, 0, 'ipython')<CR>
	nnoremap <silent> <leader>; "syy:<C-U>call ScreenPaste(0, @s, 0, 'ipython')<CR>
	vnoremap <silent> <leader>; "sy:<C-U>call ScreenPaste(0, @s, 0, 'ipython)<CR>
	""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
endif
