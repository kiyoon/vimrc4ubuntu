#!/usr/bin/env bash

TEMPDIR=$(mktemp -d)
LOCALBIN="$HOME/.local/bin"

pip3 install --user pynvim

npm install -g neovim

# LSP
npm install -g pyright
npm install -g vim-language-server
npm install -g bash-language-server

# wilder.nvim, telescope.nvim
npm install -g fd-find

# ripgrep for telescope.nvim

if ! command -v rg &> /dev/null
then
	echo "ripgrep (rg) could not be found. Installing on $LOCALBIN"
	mkdir -p "$LOCALBIN"
	mkdir -p $TEMPDIR
	curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
	| grep "browser_download_url.*-x86_64-unknown-linux-musl.tar.gz" \
	| cut -d : -f 2,3 \
	| tr -d \" \
	| wget -qi - -O - | tar -xz --strip-components=1 -C $TEMPDIR
	mv $TEMPDIR/rg "$LOCALBIN"
	rm -rf $TEMPDIR
else
	echo "ripgrep found at $(which rg). Skipping installation."
fi
