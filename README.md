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

4. Set `use_pathogen=1` and `use_syntastic=1` in `.vimrc`.  


# Custom commands

- `<F3>`: Toggle paste mode
- `gp`: Select last pasted text

## GNU Screen paste
- `[num]-`: Paste line or selection to Screen window \<num\>. If num is not specified, paste to `-console` window. Detect if Vim or iPython is running on the window, and paste accordingly.
- `\-`: For window 0, use this instead of `0-`.
- `[num]_`, `\_`: Same as `-` but does not detect program nor add newline at the end.
- `<C-_>`: Copy to Screen paste buffer. You can paste it with \<C-a\> \] anywhere.



# Useful VIM commands

- `va(`, `va{`, `va"`, ...: select opening to closing of parentheses (do more `a(` for wider range)
- `vi(`: same as above but exclude parentheses.
- `viw` : select a word


