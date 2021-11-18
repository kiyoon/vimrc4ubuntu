# vimrc4ubuntu
Key features:

- Backup every save automatically to ~/.vim/backup
- You can undo whenever (even after closing the file)
- Fold indicator if fold exists in a file.
- Detect file extension, and change behaviour accordingly
  - Python - expand tabs to space
  - Comment string (#, //, ...): used to make folds

# Before you use
If you want Python autocompletion, install Pathogen and Jedi-VIM.  
Otherwise, you should turn off pathogen in `.vimrc`.


# Custom commands
- `-`: Paste line or selection to Screen window called `-console`.  
- `[num]-`: Paste line or selection to Screen window \<num\>.  
- `\-`: For window 0, use this instead of `0;`.
- `_`, `[num]_`, `\_`: same as `-` but does not paste newline at the end.
- `<C-_>`, `[num]<C-_>`, `\<C-_>`: same as `-` but use when the destination is VIM.



# Useful VIM commands

- `va(`, `va{`, `va"`, ...: select opening to closing of parentheses (do more `a(` for wider range)
- `vi(`: same as above but exclude parentheses.
- `viw` : select a word


