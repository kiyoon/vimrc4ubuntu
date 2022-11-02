" neovim init file.

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Remove the white status bar below
set laststatus=0 ruler

source ~/.vimrc
