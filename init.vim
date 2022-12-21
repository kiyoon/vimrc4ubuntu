" neovim init file.

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Remove the white status bar below
"set laststatus=0 ruler

" nvim-tree recommends disabling netrw, VIM's built-in file explorer
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

set termguicolors
lua vim.opt.iskeyword:append("-")                   -- treats words with `-` as single words

lua << EOF
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})
EOF

exec "source " . stdpath('config') . '/.vimrc'

"nmap ; <Cmd>call asyncrun#run("!", "", "docker run --gpus all --rm --device=/dev/video0:/dev/video0 -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix -v ~/project/nvim-hand-gesture:/workspace kiyoon/nvim-hand-gesture")<CR>
nmap ,; <Cmd>call system("docker run --gpus all --rm --device=/dev/video0:/dev/video0 -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix -v ~/project/nvim-hand-gesture:/workspace -v /run/user:/run/user kiyoon/nvim-hand-gesture --socket_path " . v:servername . " &")<CR>
