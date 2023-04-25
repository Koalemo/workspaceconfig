#!/usr/bin/env bash
#
# TODO (ng): replace all apt install commands with direct binary imports

# Set repo root variable
ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

#sudo apt install cargo # needed for LspInstall TODO: still needed?

pip3 install neovim-remote

go install github.com/daedaleanai/dbt@latest

# Update dependencies
dbt sync

# Install GNU Screen

# Directory for binary links
mkdir -p $ROOT/bin; rm -rf $ROOT/bin/*

ln -s $ROOT/DEPS/ripgrep/rg $ROOT/bin/rg
ln -s $ROOT/DEPS/fd/fd $ROOT/bin/fd
