# Vim setup tips (2022)
1. Use Neovim over Vim. Faster, and better plugin support. Largely compatible with most vim scripts and plugins. It also enabled full mouse control inside tmux, whilst the original vim did not work for me at least.
2. Use Vim-Plug over Vundle, pathogen etc. Easier to install plugins (no need extra setup like source compilation)
3. Use Coc over YouCompleteMe, Syntastic etc. Much easier plugin handling with very good default code completion and linting.

# Installing

This vimrc will install vim-plug and many plugins automatically when you first launch vim.  

```bash
mkdir ~/bin -p
mkdir ~/.local/bin -p
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

cd ~/bin
git clone https://github.com/kiyoon/vimrc4ubuntu
git clone https://github.com/kiyoon/tmux-conf
cd
ln -s bin/vimrc4ubuntu/.vimrc
ln -s bin/tmux-conf/.tmux.conf

##### Node.js (for Coc, Github Copilot)
curl -sL install-node.vercel.app/17 | bash -s -- --prefix="$HOME/.local" -y

##### Neovim (local install)
# You can just do
# sudo apt install neovim
# below is to locally install without sudo.
cd ~/bin
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
cd ~/.local/bin
ln -s ~/bin/squashfs-root/AppRun nvim
rm ~/bin/nvim.appimage
pip3 install --user pynvim    # add python support

## init.vim, alias
mkdir ~/.config/nvim -p
cd ~/.config/nvim
ln -s ~/bin/vimrc4ubuntu/init.vim .

echo "alias vi='nvim'" >> ~/.bash_aliases
echo "alias vim='nvim'" >> ~/.bash_aliases
echo "alias vimdiff='nvim -d'" >> ~/.bash_aliases
echo "export EDITOR=nvim" >> ~/.bashrc
source ~/.bashrc
```

Optionally,  

```bash
sudo apt install xclip		# neovim, tmux clipboard support

# Vim Isort
pip3 install --user isort

# Nvim lsp
npm i -g pyright

# Github Copilot
nvim +PlugInstall +qall
nvim '+Copilot setup' +q
nvim '+Copilot enable' +q
```

Check out my [full terminal setup guide](https://gist.github.com/kiyoon/fc1573ed3edf61c142d925e1712940e9).

# vimrc4ubuntu
Key features:

- Backup every save automatically to ~/.vim/backup
- You can undo whenever (even after closing the file)
- Fold indicator if fold exists in a file.
- Detect file extension, and change behaviour accordingly
  - Python - expand tabs to space
  - Comment string (#, //, ...): used to make folds

# This .vimrc adds these functionalities:

## Custom commands

- `<F3>`: Toggle paste mode
- `gp`: Select last pasted text
- `\i`: Insert import statement at the beginning of the file. (Only for Python). Use it with normal or visual mode.

## Paste to tmux
See [kiyoon/vim-tmuxpaste](https://github.com/kiyoon/vim-tmuxpaste).  

- Press \<num\>- to copy and paste lines to tmux pane \<num\>.
  - For example, `1-` will paste selection (or current line) to pane 1 on the current window.
- If number not specified, then it will paste to pane 0.
- If the number is >= 10, it will paste to the pane on another window.
  - For example, 12- will paste selection (or current line) to window 1 pane 2.
  - 123- will paste selection (or current line) to window 12 pane 3.
- Use \<leader\>- (typically `\-`) to copy using the unique pane identifier.
  - For example, `5\-` will paste selection (or current line) to the %5 pane.
  - Use `set -g pane-border-format "#D"` in the tmux.conf to see the pane identifier.
- Use _ instead of - to copy without hitting Return.
- Use \<C-\_\> to copy into the tmux buffer. You can paste using C-b \] (or commonly C-a \] depending on your setup.).

## Plugins
- Select lines and press `<C-i>` to sort the Python import lines.
- :Isort to sort the entire Python imports.
- Alt + [ or ] to see next suggestions for Github Copilot.
- [tpope/vim-commentary](https://github.com/tpope/vim-commentary)
- [tpope/vim-surround](https://github.com/tpope/vim-surround)
- `\nt`: open Nvim Tree. `g?` to open help.
- `\s`, `\w`, `\b`, `\e`, `\f`: easy motion
- `,w`, `,b`, `,e`: word motion
- vil/val to select line, vie/vae to select file, vii/vai to select indent.
- treesitter-textobjects: `vif` to select function, `vic` to select class, `\a`, `\A` to swap parameters, `]m`, `]]` etc. to move between functions/classes, `\df`, `\dF` to show popup definitions.

# Useful VIM commands

- `va(`, `va{`, `va"`, ...: select opening to closing of parentheses (do more `a(` for wider range)
- `vi(`: same as above but exclude parentheses.
- `viw` : select a word
- `qq<command>q`: record macro at @q, then quit.
- `10@q`: run macro @q 10 times.

