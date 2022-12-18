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

