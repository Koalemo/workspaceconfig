#!/usr/bin/env bash
#
# TODO (ng): replace all apt install commands with direct binary imports

# Set repo root variable
ROOT=`git rev-parse --show-toplevel`

# Install DBT dependency manager
# Prerequisites
sudo apt install golang-1.18 golang-go
# TODO (ng): Double check these:
sudo apt install ninja-build
sudo apt install git

go install github.com/daedaleanai/dbt@latest

# Update dependencies
dbt sync

# Install GNU Screen
sudo apt install screen

# Directory for binary links
mkdir -p $ROOT/bin; rm -rf $ROOT/bin/*

ln -s $ROOT/DEPS/ripgrep/rg $ROOT/bin/rg
ln -s $ROOT/DEPS/fd/fd $ROOT/bin/fd

