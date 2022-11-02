# Vim setup tips (2022)
1. Use Neovim over Vim. Faster, and better plugin support. Largely compatible with most vim scripts and plugins.
2. Use Vim-Plug over Vundle, pathogen etc. Easier to install plugins (no need extra setup like source compilation)
3. Use Coc over YouCompleteMe, Syntastic etc. Much easier plugin handling with very good default code completion and linting.

# TL; DR: Install everything 
```bash
# Requirements: git, pip3, curl, screen
# optional: xclip (neovim clipboard support)

##### Locally-installed programs go here.
mkdir ~/bin/executables -p
echo 'export PATH="$HOME/bin/executables:$HOME/bin/executables/bin:$PATH"' >> ~/.bashrc
. ~/.bashrc

##### vimrc, screenrc
cd ~/bin
git clone https://github.com/kiyoon/vimrc4ubuntu
git clone https://github.com/kiyoon/screenrc4ubuntu
cd
ln -s bin/vimrc4ubuntu/.vimrc
ln -s bin/screenrc4ubuntu/.screenrc

# Necessary for screen on WSL
if grep -qi microsoft /proc/version; then
   echo "export SCREENDIR=\"$HOME/.screen\"" >> ~/.bashrc
   . ~/.bashrc
fi

# Vim Isort
pip3 install --user isort

##### Node.js (for Coc, Github Copilot)
curl -sL install-node.vercel.app/17 | bash -s -- --prefix="$HOME/bin/executables" -y

##### Neovim
cd ~/bin/executables
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
ln -s squashfs-root/AppRun nvim
rm nvim.appimage
pip3 install pynvim		# python support, required for YCM

mkdir ~/.config/nvim -p
cd ~/.config/nvim
ln -s ~/bin/vimrc4ubuntu/init.vim .

echo "alias vi='nvim'" >> ~/.bash_aliases
echo "alias vim='nvim'" >> ~/.bash_aliases
echo "alias vimdiff='nvim -d'" >> ~/.bash_aliases
echo "export EDITOR=nvim" >> ~/.bashrc
source ~/.bashrc

##### Starship
cd
sh -c "$(curl -fsSL https://starship.rs/install.sh)" sh -b "$HOME/bin/executables" -y
echo 'eval "$(starship init bash)"' >> .bashrc
wget https://gist.githubusercontent.com/kiyoon/53dae21ecd6c35c24c88bcce88b89d27/raw/21e8e98917a08a9cb6d1ab85c0fb6fe39b4c28b5/starship.toml -P .config
. ~/.bashrc

##### Install MiniConda
cd
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
CONDADIR="$HOME/bin/miniconda3"
bash Miniconda3-latest-Linux-x86_64.sh -b -p "$CONDADIR"
$CONDADIR/bin/conda init

. ~/.bashrc
conda config --set auto_activate_base false

# alias `ca` -> `conda activate`
echo "alias ca='conda activate'" >> ~/.bash_aliases
. ~/.bashrc

##### Config git
git config --global user.email "yoonkr33@gmail.com"
git config --global user.name "Kiyoon Kim"
git config --global core.editor nvim

##### Neovim Github Copilot (I do it at the end as it's optional)
git clone https://github.com/github/copilot.vim \
   ~/.config/nvim/pack/github/start/copilot.vim

nvim '+Copilot setup' +q
nvim '+Copilot enable' +q

```

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

## GNU Screen paste
- `[num]-`: Paste line or selection to Screen window \<num\>. If num is not specified, paste to `-console` window. Detect if Vim or iPython is running on the window, and paste accordingly.
- `\-`: For window 0, use this instead of `0-`.
- `[num]_`, `\_`: Same as `-` but does not detect program nor add newline at the end.
- `<C-_>`: Copy to Screen paste buffer. You can paste it with \<C-a\> \] anywhere.

## Plugins
- Select lines and press `<C-i>` to sort the lines.
- :Isort to sort the entire file imports.
- Alt + [ or ] to see next suggestions for Github Copilot.
- [tpope/vim-commentary](https://github.com/tpope/vim-commentary)
- [tpope/vim-surround](https://github.com/tpope/vim-surround)

# Useful VIM commands

- `va(`, `va{`, `va"`, ...: select opening to closing of parentheses (do more `a(` for wider range)
- `vi(`: same as above but exclude parentheses.
- `viw` : select a word

