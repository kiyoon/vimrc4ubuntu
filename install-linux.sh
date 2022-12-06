#!/usr/bin/env bash

TEMPDIR=/tmp
LOCALBIN="$HOME/.local/bin"

pip3 install --user pynvim

npm install -g neovim

# LSP
npm install -g pyright

# wilder.nvim, telescope.nvim
npm install -g fd-find

# ripgrep for telescope.nvim

if ! command -v rg &> /dev/null
then
	echo "ripgrep (rg) could not be found. Installing on $LOCALBIN"
	mkdir -p "$LOCALBIN"
	mkdir -p $tempdir/ripgrep
	curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
	| grep "browser_download_url.*-x86_64-unknown-linux-musl.tar.gz" \
	| cut -d : -f 2,3 \
	| tr -d \" \
	| wget -qi - -O - | tar -xz --strip-components=1 -C $TEMPDIR/ripgrep
	mv $TEMPDIR/ripgrep/rg "$LOCALBIN"
	rm -rf $TEMPDIR/ripgrep
fi
