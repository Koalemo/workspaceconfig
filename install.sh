#!/usr/bin/env bash
#
# TODO (ng): replace all apt install commands with direct binary imports

# Set repo root variable
ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

#sudo apt install cargo # needed for LspInstall TODO: still needed?

sudp apt install python3-pip
pip3 install neovim-remote

sudo apt install golang
go install github.com/daedaleanai/dbt@latest

# Update dependencies
~/go/bin/dbt sync

# cd DEPS/xpra
# -> follow instructions in https://github.com/Xpra-org/xpra/tree/master/docs/Build
# Then:
# cd bin; ln -s /path/to/xpra-install/bin/xpra xpra
#
# cd DEPS/tmux
# -> follow instructions in https://github.com/tmux/tmux/wiki/Installing

# Directory for binary links
mkdir -p $ROOT/bin; rm -rf $ROOT/bin/*

ln -s $ROOT/DEPS/ripgrep/rg $ROOT/bin/rg

# On the first start of tmux: do C-a I to install tmux plugins.
