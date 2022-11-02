# vimrc4ubuntu
Key features:

- Backup every save automatically to ~/.vim/backup
- You can undo whenever (even after closing the file)
- Fold indicator if fold exists in a file.
- Detect file extension, and change behaviour accordingly
  - Python - expand tabs to space
  - Comment string (#, //, ...): used to make folds

# Before you use
If you want autocompletion, install YouCompleteMe.  
Otherwise, you should set `use_ycm` to 0 in `.vimrc`.

## Installing YouCompleteMe
- Install Vundle  
`git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`  
- Launch vim and run `:PluginInstall`  
To install from command line: `vim +PluginInstall +qall`  
- Compile YouCompleteMe (cmake required):  
(If you don't have camke 3.13): `pip install --user cmake`  
```bash
cd ~/.vim/bundle/YouCompleteMe
python3 install.py
```

## Installing vim-isort
This enables sorting import modules for python.  
It follows similar procedure as the YouCompleteMe.  
`pip install isort`

### Two functions
- Select lines and press `<C-i>` to sort the lines.
- :Isort to sort the entire file imports.


## Using Syntastic syntax checker (for Python)

1. Install Pathogen  
```bash
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
```  
2. Install Syntastic  
```bash
cd ~/.vim/bundle && \
git clone --depth=1 https://github.com/vim-syntastic/syntastic.git
```  
3. Install flake8  
`pip3 install --user flake8`  

Add flake8 to `$PATH`. In `~/.bashrc`,  
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

4. Set `use_pathogen=1` and `use_syntastic=1` in `.vimrc`.  

### This .vimrc adds these functionalities:

1. `<C-k>` and `<C-j>` to navigate errors up and down.
2. `<F6>` to toggle Syntastic, which will remove all the signs and highlights.
3. `\l` to toggle location list (quick fix list).


# Custom commands

- `<F3>`: Toggle paste mode
- `gp`: Select last pasted text
- `\i`: Insert import statement at the beginning of the file. (Only for Python). Use it with normal or visual mode.

## GNU Screen paste
- `[num]-`: Paste line or selection to Screen window \<num\>. If num is not specified, paste to `-console` window. Detect if Vim or iPython is running on the window, and paste accordingly.
- `\-`: For window 0, use this instead of `0-`.
- `[num]_`, `\_`: Same as `-` but does not detect program nor add newline at the end.
- `<C-_>`: Copy to Screen paste buffer. You can paste it with \<C-a\> \] anywhere.



# Useful VIM commands

- `va(`, `va{`, `va"`, ...: select opening to closing of parentheses (do more `a(` for wider range)
- `vi(`: same as above but exclude parentheses.
- `viw` : select a word


# Neovim support

## Install nvim
```bash
cd ~/bin/executables
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
ln -s squashfs-root/AppRun nvim
rm nvim.appimage
```

## Configure nvim to default vim
```bash
mkdir ~/.config/nvim -p
cd ~/.config/nvim
ln -s ~/bin/vimrc4ubuntu/init.vim .

echo "alias vi='nvim'" >> ~/.bash_aliases
echo "alias vim='nvim'" >> ~/.bash_aliases
echo "alias vimdiff='nvim -d'" >> ~/.bash_aliases
echo "export EDITOR=nvim" >> ~/.bashrc
source ~/.bashrc
```

## Install Github Copilot
```bash
git clone https://github.com/github/copilot.vim \
   ~/.config/nvim/pack/github/start/copilot.vim

nvim '+Copilot setup'
nvim '+Copilot enable'
```
