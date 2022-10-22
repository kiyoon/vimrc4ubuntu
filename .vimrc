
" settings profile based on OS name
"let os = 'fc'
let os = 'ubuntu'

if os ==? 'fc'
	let use_ycm				= 1
	let use_ycm_spellcheck	= 0
	let use_isort           = 0
	let use_pathogen        = 0
	let use_syntastic       = 0
elseif os ==? 'ubuntu'
	let use_ycm				= 1
	let use_ycm_spellcheck	= 1
	let use_isort           = 1
	let use_pathogen        = 1
	let use_syntastic       = 1
endif

" directory path where the vimrc is installed
let vimrc_installed_dir = system('dirname "$(realpath "$MYVIMRC")" | tr -d ''\n''')

if use_ycm 
	exec "source " . vimrc_installed_dir . "/ycm.vim"
	nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
	nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
	nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>

	" Change pop-up window colour to blue background and yellow text
	highlight Pmenu ctermfg=190 ctermbg=17 guifg=#AACCFF guibg=#222233
	highlight PmenuSel ctermfg=17 ctermbg=190 guifg=#AACCFF guibg=#222233
endif

if use_isort
	let g:vim_isort_map = '<C-i>'
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

" This needs to be defined after colourscheme definition because it maps colours.
if use_syntastic
	set statusline+=%#warningmsg#
	set statusline+=%{SyntasticStatuslineFlag()}
	set statusline+=%*

	let g:syntastic_mode_map = {
	    \ "mode": "active",
	    \ "active_filetypes": ["python"],
	    \ "passive_filetypes": [] }

	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 0
	let g:syntastic_check_on_open = 1
	let g:syntastic_check_on_wq = 0
	let g:syntastic_python_python_exec = 'python3'
	let g:syntastic_python_checkers = ['flake8']
	" Ignore style warnings
	let g:syntastic_python_flake8_args='--select=E,F --ignore=E501,E203,E202,E272,E251,E211,E222,E701,E303,E265,E231,E126,E128,E401,E305,E302'

	let g:syntastic_error_symbol = "\u2717"
	let g:syntastic_style_error_symbol = "\u203C"
	"let g:syntastic_warning_symbol = "\u26A0"
	"let g:syntastic_style_warning_symbol = "S\u26A0"

	" https://stackoverflow.com/questions/17677441/changing-error-highlight-color-used-by-syntastic
	" https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
	highlight SyntasticErrorSign cterm=NONE ctermfg=125
	highlight SyntasticError cterm=NONE ctermfg=white ctermbg=125
	highlight SyntasticStyleErrorSign cterm=NONE ctermfg=grey
	highlight SyntasticStyleError cterm=NONE ctermfg=black ctermbg=grey

	" From official Syntastic doc
	" Shrink the location list height when fewer than 10 errors are found.
    function! SyntasticCheckHook(errors)
        if !empty(a:errors)
            let g:syntastic_loc_list_height = min([len(a:errors), 10])
        endif
    endfunction

	" https://vi.stackexchange.com/questions/16927/open-and-close-syntastic-window-with-one-mapping
"	function! ToggleSyntastic()
"		for i in range(1, winnr('$'))
"			let bnum = winbufnr(i)
"			if getbufvar(bnum, '&buftype') == 'quickfix'
"				lclose
"				SyntasticToggleMode
"				let g:syntastic_mode_map = {
"					\ "mode": "passive",
"					\ "active_filetypes": [],
"					\ "passive_filetypes": [] }
"				return
"			endif
"		endfor
"		let g:syntastic_mode_map = {
"			\ "mode": "active",
"			\ "active_filetypes": ["python"],
"			\ "passive_filetypes": [] }
"		SyntasticCheck
"	endfunction
	function! ToggleSyntastic()
		if g:syntastic_mode_map["mode"] == "active"
			lclose
			SyntasticToggleMode
			let g:syntastic_mode_map = {
				\ "mode": "passive",
				\ "active_filetypes": [],
				\ "passive_filetypes": [] }
		else
			let g:syntastic_mode_map = {
				\ "mode": "active",
				\ "active_filetypes": ["python"],
				\ "passive_filetypes": [] }
			SyntasticCheck
		endif
	endfunction
	silent! nnoremap <F6> :call ToggleSyntastic()<CR>


	" YouCompleteMe : syntax checker off
	" YCM dosesn't support syntax checker for python anyway,
	" and because of the checker it clears out the location list when first loading a file,
	" which should not happen.
	autocmd FileType python let g:ycm_show_diagnostics_ui = 0
endif

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



"""""""""""""""""
" <leader>l to toggle location list
" https://vim.fandom.com/wiki/Toggle_to_open_or_close_the_quickfix_window
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>e :call ToggleList("Quickfix List", 'c')<CR>
nnoremap <C-j> :lnext<CR>
nnoremap <C-k> :lprevious<CR>


" highlight cursor line
"set cursorline

" set each buffer store up to 1000 lines(<1000), maximum buffer size
" 1000kb(s1000)
set viminfo='20,<1000,s1000

" Maintain undo history between sessions (persistent undo)
set undofile 
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
  let l:undo = l:parent . 'undo/'
  let l:tmp = l:parent . 'tmp/'
  if exists('*mkdir')
    if !isdirectory(l:parent)
      call mkdir(l:parent)
    endif
    if !isdirectory(l:backup)
      call mkdir(l:backup)
    endif
    if !isdirectory(l:undo)
      call mkdir(l:undo)
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
  if isdirectory(l:undo)
    execute 'set undodir=' . escape(l:undo, ' ') . '/,.'
  else
    let l:missing_dir = 1
  endif
  if isdirectory(l:tmp)
    execute 'set directory=' . escape(l:tmp, ' ') . '/,.'
  else
    let l:missing_dir = 1
  endif
  if l:missing_dir
    echo 'Warning: Unable to create backup directories:' l:backup 'and' l:undo 'and' l:tmp
    echo 'Try: mkdir -p' l:backup
    echo 'and: mkdir -p' l:undo
    echo 'and: mkdir -p' l:tmp
    set backupdir=.
    set directory=.
    set undodir=.
  endif
endfunction
call InitBackupDir()

if use_ycm
	if !use_ycm_spellcheck
		" YouCompleteMe : syntax checker off
		let g:ycm_show_diagnostics_ui = 0
	endif
	" YCM : for compiler option

	if os ==? 'ubuntu'
		let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
	else
		let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
	endif
	" YCM : no highlight
	" let g:ycm_enable_diagnostic_highlighting = 0
	" YCM : change warning symbol
	let g:ycm_warning_symbol = '??'
endif

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

" Select last pasted
" https://vim.fandom.com/wiki/Selecting_your_pasted_text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Add python import at the beginning of the file.
" Copy the word, find the first import statement and attach import before the first one.
" If the first line first word of the file is import, it will search the second import statement.
" It will also try to restore the previous search string (@/).
function! AddPythonImport(module)
	normal! gg
	let import_searched = search('import')
	if import_searched
		normal! O
	else
		normal! gg
		" comment check: https://stackoverflow.com/questions/73356266/how-can-i-check-if-the-current-line-is-commented-in-vim-script
		let commented = ! match(getline('.'), ' *#.*')
		if commented
			normal! o
		else
			normal! O
		endif
	endif
	call setline('.', 'import ' . a:module)
	"call feedkeys('iimport ' . a:module)
	"call feedkeys("\<ESC>")
endfunction

autocmd FileType python nnoremap <leader>i "syiw:call AddPythonImport(@s)<CR>
autocmd FileType python vnoremap <leader>i "sy:call AddPythonImport(@s)<CR>

" Below <expr> example will behave differently when there is no 'import' in the file.
" This is not a practical common but it's for example sake.
"nnoremap <expr> + search('import') > 0 ? 'Oimport os' : 'ggOimport os'

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

	function! DetectRunningProgram(windowIdx)
		" Detects if VIM or iPython is running on a Screen window.
		" Returns: 'vim', 'ipython', or 'others'
		"
		let runningProgram = system('bash ''' . g:vimrc_installed_dir . '/scripts/display_screen_window_commands.sh'' | grep ''^' . a:windowIdx . ' '' | awk ''{for(i=2;i<=NF;++i)printf $i" "}'' ')
		if empty(runningProgram)
			return '-bash'
		elseif runningProgram[0:2] ==# 'vi ' || runningProgram[0:3] ==# 'vim '
			return 'vim'
		elseif stridx(runningProgram, '/ipython ') > 0
			return 'ipython'
		endif
		return 'others'
	endfunction

	function! ScreenAddBuffer(content)
		" Add content to the GNU Screen buffer.
		" Paste using C-a ]
		"
		let tempname = tempname()
		call writefile(split(a:content, "\n"), tempname, 'b')

		" msgwait: Suppress messages like 'Slurped 300 characters to buffer'
		let screenMsgWaitCommand = 'screen -X msgwait 0'
		let screenRegCommand = 'screen -X readbuf ' . tempname
		let screenMsgWaitUndoCommand = 'screen -X msgwait 5'
		call system(screenMsgWaitCommand)
		call system(screenRegCommand)
		call system(screenMsgWaitUndoCommand)
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
		if a:pasteTo ==? 'vim'
			" ^[ => Ctrl+[ = ESC
			" Enter paste mode
			call system('screen -p ' . a:pasteWindow . ' -X stuff ''^[:set paste\no''')
		elseif a:pasteTo ==? 'ipython'
			call system('screen -p ' . a:pasteWindow . ' -X stuff ''^U%cpaste\n''')
			" Without sleep, sometimes you don't see what's being pasted.
			execute 'sleep 100m'
		endif
		call system(screenPasteCommand)
		call system(screenMsgWaitUndoCommand)

		if a:addNewLine == 1
			" vim already adds line by typing 'o'
			if a:pasteTo != 'vim'
				call system('screen -p ' . a:pasteWindow . ' -X stuff ''\n''')
			endif
		endif
		echom 'Paste to Screen window ' . a:pasteWindow . ' (' . a:pasteTo . ')'
		if a:pasteTo ==? 'vim'
			" ^[ => Ctrl+[ = ESC
			" Exit paste mode and force redraw (need to redraw if pasting to same screen)
			call system('screen -p ' . a:pasteWindow . ' -X stuff ''^[:set nopaste\n:redraw!\n''')
		elseif a:pasteTo ==? 'ipython'
			execute 'sleep 100m'
			call system('screen -p ' . a:pasteWindow . ' -X stuff ''\n--\n''')
		endif
		call delete(tempname)
	endfunction

	" 1. save count to pasteWindow
	" 2. yank using @s register.
	" 3. detect if vim or ipython is running
	" 4. execute screen command.
	nnoremap <silent> - :<C-U>let pasteWindow=ChooseScreenWindow(v:count)<CR>"syy:call ScreenPaste(pasteWindow, @s, 1, DetectRunningProgram(pasteWindow))<CR>
	vnoremap <silent> - :<C-U>let pasteWindow=ChooseScreenWindow(v:count)<CR>gv"sy:call ScreenPaste(pasteWindow, @s, 1, DetectRunningProgram(pasteWindow))<CR>
	" pasting to window 0 is not 0; but \;. Explicit separate command because v:count is 0 for no count, and also 0 is a command that moves the cursor.
	nnoremap <silent> <leader>- "syy:<C-U>call ScreenPaste(0, @s, 1, DetectRunningProgram(0))<CR>
	vnoremap <silent> <leader>- "sy:<C-U>call ScreenPaste(0, @s, 1, DetectRunningProgram(0))<CR>
	"""""""""""""""
	" Same thing but <num>_ to paste without detecting running programs and without the return at the end.
	nnoremap <silent> _ :<C-U>let pasteWindow=ChooseScreenWindow(v:count)<CR>"syy:call ScreenPaste(pasteWindow, @s, 0, 'nodetect')<CR>
	vnoremap <silent> _ :<C-U>let pasteWindow=ChooseScreenWindow(v:count)<CR>gv"sy:call ScreenPaste(pasteWindow, @s, 0, 'nodetect')<CR>
	nnoremap <silent> <leader>_ "syy:<C-U>call ScreenPaste(0, @s, 0, 'nodetect')<CR>
	vnoremap <silent> <leader>_ "sy:<C-U>call ScreenPaste(0, @s, 0, 'nodetect')<CR>

	"""""""""""""""
	" Copy to Screen buffer
	
	nnoremap <silent> <C-_> :<C-U>let pasteWindow=ChooseScreenWindow(v:count)<CR>"syy:call ScreenAddBuffer(@s)<CR>
	vnoremap <silent> <C-_> :<C-U>let pasteWindow=ChooseScreenWindow(v:count)<CR>gv"sy:call ScreenAddBuffer(@s)<CR>
	""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
endif


