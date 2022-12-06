TEMPDIR=/tmp

pip3 install --user pynvim

npm install -g neovim

# LSP
npm install -g pyright

# wilder.nvim, telescope.nvim
npm install -g fd-find

# ripgrep for telescope.nvim
mkdir -p "$HOME/.local/bin"
mkdir -p $TEMPDIR/ripgrep
curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
| grep "browser_download_url.*-x86_64-unknown-linux-musl.tar.gz" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi - -O - | tar -xz --strip-components=1 -C $TEMPDIR/ripgrep
mv $TEMPDIR/ripgrep/rg "$HOME/.local/bin"
rm -rf $TEMPDIR/ripgrep
